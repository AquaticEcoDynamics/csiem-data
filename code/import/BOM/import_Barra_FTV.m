function import_Barra_FTV
    load ../../actions/varkey.mat;
    load ../../actions/agency.mat;
    load ../../actions/sitekey.mat;
    
    addpath('Functions');

    VarListStruct = agency.bombarraftv;
    SiteListStruct = sitekey.bombarraftv;

    outdir = '../../../../data-warehouse/csv/bom/barra_ftv/';
    mkdir(outdir);



    %% Get list of data files
    dataDir = '../../../../data-lake/BOM/barra_tfv/';
    fileCell = {dir(dataDir).name}';
    fileCell = fileCell(3:end) %skips ./ and ../

    %% collecting all sites across all years (with no duplicated sites) 
    UniqueSiteFileCell = fileCell;
    ToRemove = {};
    for i = 1:length(fileCell);
        AEDID = fileCell{i}(12:end-4);
        AllYears = {dir(fullfile(dataDir,['*',AEDID,'*'])).name}';
        OtherYears = AllYears(2:end);
        ToRemove = [ToRemove;OtherYears];
    end
    ToRemove = unique(ToRemove);
    UniqueSiteFileCell = RemoveCellArrayFromCellArray(UniqueSiteFileCell,ToRemove);

    for i = 1:length(UniqueSiteFileCell);

        disp(['Site ' num2str(i) ' ' UniqueSiteFileCell{i}(12:end-4)]);
        %BARRA_2013_uwa_matilda
        AEDID = UniqueSiteFileCell{i}(12:end-4);
        SiteStruct = SearchSitelistbyAEDID(SiteListStruct,AEDID);
        AllYears = {dir(fullfile(dataDir,['*',AEDID,'*'])).name}';

        %% read in all years date and append and initialise 'Vars' vector
        DataFilesTable = cell(1,length(AllYears));
        AppendedDateVec = [];
        for Yearindex = 1:length(AllYears)
            disp([' Year ',num2str(Yearindex),': ',AllYears{Yearindex}])
            filename = [dataDir,AllYears{Yearindex}];
            DataFilesTable{1,Yearindex} = readtable(filename);
            if Yearindex == 1
                Vars = DataFilesTable{1,1}.Properties.VariableNames';
            end
            %First elemetn is Date;
            DateVec = DataFilesTable{1,Yearindex}{:,1};
            DateVecsCell{1,Yearindex} = DateVec;
            AppendedDateVec = [AppendedDateVec;DateVec];
        end
        
        [DateVecCombined,I,~] = unique(AppendedDateVec);

        for varIndex = 2:length(Vars)
            
            if Var2BeSkippedFunction(Vars(varIndex)) == true
                disp([Vars{varIndex}, 'is being skipped']);
                continue
            end

            % displays current varibale name and how big it is (uses date)
            disp(['     Processing Variable ' Vars{varIndex} ' ' num2str(length(AppendedDateVec)) 'x1']);

            %workout what variable we are dealing with
            AgencyStruct = SearchVarlist(VarListStruct,Vars,varIndex);
            VarStruct = varkey.(AgencyStruct.ID);
            [fnameData,fnameHeader] = filenamecreator(outdir,SiteStruct,VarStruct);

            AppendedDataVec = [];
            for Yearindex = 1:length(AllYears)
                DataVec = DataFilesTable{1,Yearindex}{:,varIndex};
                DataVecsCell{1,Yearindex} = DataVec;
                AppendedDataVec = [AppendedDataVec;DataVec];
            end
            DataVecCombined = AppendedDataVec(I);


            fid = fopen(fnameData,'W');
            fprintf(fid,'Date,Depth,Data,QC\n');
            DataVecCombined = DataVecCombined*AgencyStruct.Conv;
            
            for nn = 1:length(DataVec)
                DateString = datestr(DateVecCombined(nn),"yyyy-mm-dd HH:MM:SS");
                Depth = 0;
                QC = 'N';
                fprintf(fid,'%s,%4.4f,%4.4f,%s\n',DateString,Depth,DataVecCombined(nn),QC);
            end
            fclose(fid);

            
            lat = SiteStruct.Lat;
            lon = SiteStruct.Lon;
            ID = SiteStruct.ID;
            Desc = SiteStruct.Description;


            varID = AgencyStruct.ID;
            Cat = VarStruct.Category;
            varstring = VarStruct.Name;

            wdate = '';
            sitedepth = '';
            %%bad code practise by copied from
            %csiem-data-hub/git/code/import/wamsi_theme3/SEDPSD/Functions/write_header
            write_header(fnameHeader,lat,lon,ID,Desc,varID,Cat,varstring,wdate,sitedepth)

        end
    end

end

function ReducedCellArray = RemoveCellArrayFromCellArray(CellArray,SubCellArray)
    Removed = false(1,length(SubCellArray));

    ReducedCellArray = CellArray;
    for RemovedCellIndex = 1:length(SubCellArray)
        for CellIndex = 1:length(CellArray)
            if strcmp(SubCellArray{RemovedCellIndex},ReducedCellArray{CellIndex})
                Removed(RemovedCellIndex) = true; 
                %removes cell
                ReducedCellArray(CellIndex) = [];
                break
            end
        end
        if ~Removed(RemovedCellIndex)
            fprintf('There was an issue with removing:\n%s\n',SubCellArray{RemovedCellIndex});
        end

    end
end



function Skip = Var2BeSkippedFunction(HeaderName)
    SkipableVars = {''};
    % {'HFX',
    % 'LH',
    % 'SST',
    % 'RAINV'
    % };

    Skip = false;
    for i =1:length(SkipableVars)
        if strcmp(HeaderName,SkipableVars{i})
            Skip = true;
        end

    end
end


function VarStruct = SearchVarlist(VarListStruct,FileHeaders,varIndex)
    neverFound = true;
    VarlistFeilds = fields(VarListStruct);
    NumOfVariables = length(VarlistFeilds);

    FileVarHeader = FileHeaders{varIndex};

    for StructVarIndex = 1:NumOfVariables
        StructVarHeader = VarListStruct.(VarlistFeilds{StructVarIndex}).Old;
        % Check if FileVarHeader == StructVarHeader
        if strcmp(FileVarHeader,StructVarHeader)
            VarStruct = VarListStruct.(VarlistFeilds{StructVarIndex});
            neverFound = false;
            break
        end

    end
    if neverFound == true
        disp(FileHeaders{varIndex})
        for StructVarIndex = 1:NumOfVariables
            disp(VarListStruct.(VarlistFeilds{StructVarIndex}).Old)
        end
        stop
        %not a keyword, intentially stop the code because issue has happend
    end

end

function SiteStruct = SearchSitelistbyAEDID(SiteListStruct,AEDID)
    neverFound = true;
    SitelistFeilds = fields(SiteListStruct);
    NumOfVariables = length(SitelistFeilds);

    for StructSiteIndex = 1:NumOfVariables
                                                
        if strcmp(AEDID,SiteListStruct.(SitelistFeilds{StructSiteIndex}).AED)
            SiteStruct = SiteListStruct.(SitelistFeilds{StructSiteIndex});
            neverFound = false;
            break
        end

    end
    if neverFound == true
        disp('DataFile site:');
        disp(AEDID)
        disp('Sitekey list:');
        for StructSiteIndex = 1:NumOfVariables
            disp(SiteListStruct.(SitelistFeilds{StructSiteIndex}).AED);                 
        end
        stop
        %not a keyword, intentially stop the code because issue has happend
    end
end

function [data,header] = filenamecreator(outpath,SiteStruct,VarStruct)
filevar = regexprep(VarStruct.Name,' ','_');
filesite = SiteStruct.AED;

base = [outpath,filesite,'_',filevar];
data = [base,'_DATA.csv'];
header = [base,'_Header.csv'];
end



% function dY = derivitiveAlways30mins(tVec,Y)
% dY = diff(Y)/(30*60);
% dY= [Y(1);dY];
% end

% function [data,header] = PrecipName(outpath,SiteStruct,VarStruct,Month)
% MonthList = {'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'};

% filevar = regexprep(VarStruct.Name,' ','_');
% filesite = SiteStruct.AED;

% base = [outpath,filesite,'_',filevar,'_',MonthList{Month}];
% data = [base,'_DATA.csv'];
% header = [base,'_Header.csv'];
% end
