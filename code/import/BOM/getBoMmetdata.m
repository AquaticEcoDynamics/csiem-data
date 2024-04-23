function metdata = getBoMmetdata(sMetDir,header_file)
% Function to import the swan met data and save to a structured type
% swanmet.mat
% sMetDir is the file path in which the BoM data files are stored. Remember
% to add "\" at the end of the path!!!
% Add or remove headers under cHeader based on your data. Import of Date in
% the right format should be checked!

    addpath(genpath('Headers'));
    addpath(genpath('Functions'));


    indir = '../../../../data-warehouse/csv_holding/bom/idy/';mkdir(indir);

    run(header_file);

    dirlist = dir(sMetDir);


    for iMet = 3:length(dirlist)
        
        disp(['Processing File ',num2str(iMet - 2)]);
        disp(dirlist(iMet).name)
        filename = [sMetDir,dirlist(iMet).name];
        
        %fid = fopen(filename,'rt');
        
        
        
    
        x  = length(cHeader);
        %textformat = [repmat('%s ',1,x)];
        %datacell = textscan(fid,textformat,...
        %    'Headerlines',1,...
        %    'Delimiter',',');
        %fclose(fid);
        warning('OFF', 'MATLAB:table:ModifiedAndSavedVarnames')
        TableVar = readtable(filename,VariableNamingRule='modify');
        warning('ON', 'MATLAB:table:ModifiedAndSavedVarnames')

            
        

        % for iHeader = 1:length(cHeader)
        %     sCompStrFull = cHeader{iHeader};
        %     sCompStr = sCompStrFull(end-2:end);
            
        %     %if strcmp(sCompStr,'_QC') == 0
        %         if strcmp(cHeader{iHeader},'Date') == 1
        %             met.(cHeader{iHeader}) = datenum(datacell{iHeader},'dd/mm/yyyy HH:MM');
        %         else
        %             met.(cHeader{iHeader}) = str2double(datacell{iHeader});
        %         end
        %     %end
            
        % end
        
        
        % nSiteID = met.StationID(1);
        
        
        % met.Date = datenum(met.Year,met.Month,met.Day,met.Hour,met.MI_Format,00);
        
        % vars = fieldnames(met);
        
        % [~,uind] = unique(met.Date);
        
        % for kgk = 1:length(vars)
        %     met.(vars{kgk}) = met.(vars{kgk})(uind);
        % end
        
        
        % [mdata,name]  = bom_sites(nSiteID,met);
        
        % metdata.(name) = mdata.(name);
        
        
        nSiteID = TableVar{1,2};%All entries in a file have same the site id
        year = TableVar{:,3};
        month = TableVar{:,4};
        day = TableVar{:,5};
        hour = TableVar{:,6};
        mins = TableVar{:,7};


        Dates = datenum(year,month,day,hour,mins,00);
        [uDates,uind] = unique(Dates);

        NoDoubleUps = TableVar(uind,:);
            
        met = table2struct(NoDoubleUps(:,13:end),"ToScalar",true);
        met.Date = uDates;
        met.headers = TableVar.Properties.VariableDescriptions(13:end);


            
        [mdata,name]  = bom_sites(nSiteID,met);
            
        metdata.(name) = mdata.(name);
        end

    %save([indir,'metdata.mat'],'metdata','-v7.3');
end

