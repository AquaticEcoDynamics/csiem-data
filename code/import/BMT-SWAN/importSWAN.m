function importSWAN()
    load ../../../../data-lake/BMT/SWAN/wave_export.mat

    load ../../actions/varkey.mat;
    load ../../actions/agency.mat;
    load ../../actions/sitekey.mat;

    %% creating site key 
    % To update site key uncomment this chunk, run the code, it will create a csv file
    % open that csv paste into excel this will all be in one collumn
    % go to the data tab in excel highlight the cells and use "text to columns"
    % then rerun the import_site_key in actions

        % Sites = fields(waves);
        % fid = fopen('sites.csv','W');
        % if fid
        %     for i = Sites' %1:length(Sites);
        %         j = i{1};
        %         if ~(j(1) == 'W')
        %             tmp = [j ',' j ',' j ',' ',' ',' ',' num2str(waves.(j).DIR.Y) ',' num2str(waves.(j).DIR.X)]
        %             fprintf(fid,'%s,%s,%s,,,,%f,%f\n',j,j,j,waves.(j).DIR.Y,waves.(j).DIR.X);
        %         end
        %     end
        % end
        % fclose(fid);
        % stop

    outdir = '../../../../data-warehouse/csv/bmtswan/';
    mkdir(outdir);

    VarListStruct = agency.bmtswan;
    SiteListStruct = sitekey.bmtswan;

    Sites = fields(waves);
    disp(Sites)
    fprintf('\n\nOnly processing SWAN sites\n\n');

    for i = 1:length(Sites);
        if Sites{i}(1) == 'W'
        continue
        end

        disp(['Site ' num2str(i) ' ' Sites{i}]);
        lat = waves.(Sites{i}).DIR.Y;
        lon = waves.(Sites{i}).DIR.X;
        SiteStruct = SearchSitelistbyLatLong(SiteListStruct,lat,lon);
        % it appears that the date is saved in all three variables, potentially could save read time by not reading in all 3 of the same time vecs
        
        Vars = fields(waves.(Sites{i}));
        for varIndex = 1:length(Vars)
            % displays current varibale name and how big it is (uses date)
            disp(['     Processing Variable ' Vars{varIndex} ' ' num2str(length(waves.(Sites{i}).(Vars{varIndex}).data)) 'x1']);

            %workout what variable we are dealing with
            AgencyStruct = SearchVarlist(VarListStruct,Vars,varIndex);
            VarStruct = varkey.(AgencyStruct.ID);
            [fnameData,fnameHeader] = filenamecreator(outdir,SiteStruct,VarStruct);
            

            fid = fopen(fnameData,'W');
            fprintf(fid,'Date,Depth,Data,QC\n');
            DataVec = waves.(Sites{i}).(Vars{varIndex}).data;
            DateVec = waves.(Sites{i}).(Vars{varIndex}).date;
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

