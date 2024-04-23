function importWAVES()
    main_dir = '../../../../../data-lake/WAMSI/wwmsp5.2_waves/';
    outdir = '../../../../../data-warehouse/csv/wamsi/wwmsp5.2_waves/';
    if ~exist(outdir,'dir')
        mkdir(outdir);
    end
    load ../../../actions/varkey.mat;
    load ../../../actions/agency.mat;
    load ../../../actions/sitekey.mat;
    VarListStruct = agency.theme5waves;
    SiteListStruct = sitekey.wwmsp5waves;

                % currentDir = pwd;
                % cd(main_dir);
                % !ls */*.csv > files.txt
                % fid = fopen('files.txt');
                % files = {};
                % for i = 1:31
                %     files{i,1} = fscanf(fid,"%s/n")
                % end
                % fclose(fid);
                % !rm files.txt
                % cd(currentDir);

    filelist = dir(fullfile(main_dir, '**/*.csv'));  %get list of files and folders in any subfolder
    filelist = filelist(~[filelist.isdir]);  %remove folders from list

    %% Date,X,Y,WVHT,WVDIR,WVPER for JPPL
    %  Date,X,Y,HS,DM,TPP for all others

    for i =1:length({filelist(:).name})
        file = [filelist(i).folder,'/',filelist(i).name];
        disp(['File ' num2str(i) ' ' filelist(i).name]);
        FileContentsTable = readtable(file);
        fileHeaders = FileContentsTable.Properties.VariableNames;

        SiteStruct = SearchSitelistbyLatLong(SiteListStruct,FileContentsTable{1,3},FileContentsTable{1,2});
        DateVec = FileContentsTable{:,1};

        for varIndex = 4:6
            disp(['     Processing Variable ' fileHeaders{varIndex} ' ' num2str(height(FileContentsTable)) 'x1']);
            %workout what variable we are dealing with
            AgencyStruct = SearchVarlist(VarListStruct,fileHeaders,varIndex);
            VarStruct = varkey.(AgencyStruct.ID);
            [fnameData,fnameHeader] = filenamecreator(outdir,SiteStruct,VarStruct);
            


            fid = fopen(fnameData,'W');
            fprintf(fid,'Date,Depth,Data,QC\n');
            for nn = 1:length(FileContentsTable{:,varIndex})
                DateString = datestr(DateVec(nn),"yyyy-mm-dd HH:MM:SS");
                Depth = 0;
                QC = 'N';
                fprintf(fid,'%s,%4.4f,%4.4f,%s\n',DateString,Depth,FileContentsTable{nn,varIndex},QC);
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

function SiteStruct = SearchSitelistbyLatLong(SiteListStruct,fileLat,fileLon)
    neverFound = true;
    SitelistFeilds = fields(SiteListStruct);
    NumOfVariables = length(SitelistFeilds);
    fileSiteLatLonPair = [fileLat fileLon];
    %disp(fileSiteLatLonPair)

    for StructSiteIndex = 1:NumOfVariables
        StructSiteLatLonPair = [SiteListStruct.(SitelistFeilds{StructSiteIndex}).Lat ...
                                SiteListStruct.(SitelistFeilds{StructSiteIndex}).Lon];
                                
        %disp(StructSiteLatLonPair)                 
        if fileSiteLatLonPair == StructSiteLatLonPair
            SiteStruct = SiteListStruct.(SitelistFeilds{StructSiteIndex});
            neverFound = false;
            break
        end

    end
    if neverFound == true
        disp(fileSiteLatLonPair)
        disp('Onto sites now')
        for StructSiteIndex = 1:NumOfVariables
            disp(SiteListStruct.(SitelistFeilds{StructSiteIndex}).ID)
            disp([SiteListStruct.(SitelistFeilds{StructSiteIndex}).Lat ...
                                  SiteListStruct.(SitelistFeilds{StructSiteIndex}).Lon]);
                                  
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