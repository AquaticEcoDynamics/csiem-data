function ImportWRF()
    load ../../actions/varkey.mat;
    load ../../actions/agency.mat;
     load ../../actions/sitekey.mat;

    VarListStruct = agency.wwmsp1wrf;
    SiteListStruct = sitekey.wwmsp1wrf;

    outdir = '../../../../data-warehouse/csv/wamsi/wwmsp1.1_wrf/';
    mkdir(outdir);


    
    %% Get list of data files
    dataDir = '../../../../data-lake/WAMSI/WWMSP1.1 - WRF/';
    fileCell = {dir(dataDir).name}';
    fileCell = fileCell(3:end) %skips ./ and ../

    for i = 1:length(fileCell);

        disp(['Site ' num2str(i) ' ' fileCell{i}]);
        %WRF_2022_AEID.csv
        AEDID = fileCell{i}(10:end-4);


        SiteStruct = SearchSitelistbyAEDID(SiteListStruct,AEDID);
        % it appears that the date is saved in all three variables, potentially could save read time by not reading in all 3 of the same time vecs

        DataFilesTable = readtable([dataDir,fileCell{i}]);
           
        Vars = DataFilesTable.Properties.VariableNames';
        % First elemetn is Date;
        DateVec = DataFilesTable{:,1};
        for varIndex = 2:length(Vars)
            
            if Var2BeSkippedFunction(Vars(varIndex)) == true
                disp([Vars{varIndex}, 'is being skipped']);
                continue
            end

            % displays current varibale name and how big it is (uses date)
            disp(['     Processing Variable ' Vars{varIndex} ' ' num2str(length(DateVec)) 'x1']);

            %workout what variable we are dealing with
            AgencyStruct = SearchVarlist(VarListStruct,Vars,varIndex);
            VarStruct = varkey.(AgencyStruct.ID);
            [fnameData,fnameHeader] = filenamecreator(outdir,SiteStruct,VarStruct);

            if strcmp(AgencyStruct.ID,'var00152')
                
                DataVec = DataFilesTable{:,varIndex}*AgencyStruct.Conv;
                for MonthNumber = 1:12
                    IndexesOfThisMonth = month(DateVec)==MonthNumber;
                    if MonthNumber == 1 
                        %removing the january from 2023 in the 2022 data
                        IndexesOfThisMonth = IndexesOfThisMonth(1:end-1);
                    end
                
                    %Shifting to include the midnight of the next month
                    IndexesOfThisMonth = [false;IndexesOfThisMonth(1:end-1)];
                
                    MonthDateVec = DateVec(IndexesOfThisMonth);
                    MonthDataVec = DataVec(IndexesOfThisMonth); 
                
                    dMonthDataVec = derivitiveAlways30mins(MonthDateVec,MonthDataVec);
                
                    [fnameDataAcc,fnameHeaderAcc] = PrecipName(outdir,SiteStruct,VarStruct,MonthNumber);
                    RateId = 'var00383';
                    RateVarStruct = varkey.(RateId);
                    if ~strcmp(RateVarStruct.Name,'Precipitation Rate')
                        fprintf('Something in the varkey has changed and my hardcoded variable id is broken\n\n');
                        stop
                    end

                    [fnameDataRate,fnameHeaderRate] = PrecipName(outdir,SiteStruct,RateVarStruct,MonthNumber);
                    
                    fid = fopen(fnameDataAcc,'W');
                    fprintf(fid,'Date,Depth,Data,QC\n');

                    fid2 = fopen(fnameDataRate,'W');
                    fprintf(fid,'Date,Depth,Data,QC\n');
                    % MonthDateVec,MonthDataVec,dMonthDataVec

                    for nn = 1:length(MonthDateVec)
                        DateString = datestr(MonthDateVec(nn),"yyyy-mm-dd HH:MM:SS");
                        Depth = 0;
                        QC = 'N';

                        %Acculamtive
                        fprintf(fid,'%s,%4.4f,%4.4f,%s\n',DateString,Depth,MonthDataVec(nn),QC);

                        %Rate
                        fprintf(fid2,'%s,%4.4f,%4.4f,%s\n',DateString,Depth,dMonthDataVec(nn),QC);
                    end
                    fclose(fid);
                    fclose(fid2);

                    lat = SiteStruct.Lat;
                    lon = SiteStruct.Lon;
                    ID = SiteStruct.ID;
                    Desc = SiteStruct.Description;
                    wdate = '';
                    sitedepth = '';
        
                    %Acumulative
                    varID = AgencyStruct.ID;
                    Cat = VarStruct.Category;
                    varstring = VarStruct.Name;
                    write_header(fnameHeaderAcc,lat,lon,ID,Desc,varID,Cat,varstring,wdate,sitedepth)

                    %Rate
                    varID = RateId;
                    Cat = RateVarStruct.Category;
                    varstring = RateVarStruct.Name;
                    write_header(fnameHeaderRate,lat,lon,ID,Desc,varID,Cat,varstring,wdate,sitedepth)

                end
                continue
            end

            

            fid = fopen(fnameData,'W');
            fprintf(fid,'Date,Depth,Data,QC\n');
            DataVec = DataFilesTable{:,varIndex}*AgencyStruct.Conv;
            



            for nn = 1:length(DataVec)
                DateString = datestr(DateVec(nn),"yyyy-mm-dd HH:MM:SS");
                Depth = 0;
                QC = 'N';
                fprintf(fid,'%s,%4.4f,%4.4f,%s\n',DateString,Depth,DataVec(nn),QC);
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

function Skip = Var2BeSkippedFunction(HeaderName)
    SkipableVars = {'HFX',
    'LH',
    'SST',
    'RAINV'
    };
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

function dY = derivitiveAlways30mins(tVec,Y)
    dY = diff(Y)/(30*60);
    dY= [Y(1);dY];
end

function [data,header] = PrecipName(outpath,SiteStruct,VarStruct,Month)
    MonthList = {'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'};

    filevar = regexprep(VarStruct.Name,' ','_');
    filesite = SiteStruct.AED;

    base = [outpath,filesite,'_',filevar,'_',MonthList{Month}];
    data = [base,'_DATA.csv'];
    header = [base,'_Header.csv'];
end
