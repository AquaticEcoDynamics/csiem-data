function export_wir_v2_stage1% clear all; close all;
load ../../../../data-warehouse/csv_holding/dwer/swan.mat;

addpath(genpath('../../functions'));

plotdir = 'Images/';mkdir(plotdir);


sites = fieldnames(swan);
pt = [];



tic

[snum,sstr] = xlsread('../../functions/Projects.xlsx','A2:D10000');

for k = 1:length(snum(:,1))
    thesites{k} = num2str(snum(k,1));
end
theproject = sstr(:,1);


[snum,sstr] = xlsread('../../../data-governance/variable_key.xlsx','MASTER KEY','A2:D10000');

varID = sstr(:,1);
varName = sstr(:,2);
varUnit = sstr(:,3);
varSymbol = sstr(:,4);

for i = 1:length(varSymbol)
    if isempty(varSymbol{i})
        varSymbol(i) = varName(i);
    end
end

load ../../actions/varkey.mat;


outputdir = 'D:\csiem/data-warehouse/csv_holding/dwer/swanest/';mkdir(outputdir);

sites = fieldnames(swan);

fid = fopen([outputdir,'WIR_FLATFILE_ALL_DATA.csv'],'wt');

fprintf(fid,'Site,Lat,Lon,Var ID,Varname,VarFull,Date,Depth,Data,Deployment,Deployment Position,Vertical Ref,Site Mean Depth,Data Classification,Agency,Agency Code,Project,Program Code,Tag,Data Category\n');


for i = 1:length(sites)
    %outdir = [outputdir,sites{i},'/'];
    
    schx = regexprep(sites{i},'s','');
    
    sss = find(strcmpi(thesites,schx)==1);
    
    
    if ~isempty(sss)
        
        proj = theproject{sss};
        oldproj = 'swanest';
        %header.Project = proj;
        %newfile = regexprep(newfile,lower(oldproj),lower(proj));
        outdir = regexprep(outputdir,lower(oldproj),lower(proj));
        %         if ~exist(outdir,'dir')
        %             mkdir(outdir);
        %         end
    else
        stop
        proj = 'swanest';
        outdir = [outputdir];
        %         if ~exist(outdir,'dir')
        %             mkdir(outdir);
        %         end
    end
    
    
    
    
    
    vars = fieldnames(swan.(sites{i}));
    
    for j = 1:length(vars)
        
        varspt = split(vars{j},'_');
        ID = varspt{2};
        
        sss = find(strcmpi(varID,ID) == 1);
        
        thevar = varName{sss};
        theID = varID{sss};
        
        %disp([sites{i},': ',thevar]);
        
        thevar_filename = regexprep(thevar,'(','');
        thevar_filename = regexprep(thevar_filename,')','');
        thevar_filename = regexprep(thevar_filename,' ','_');
        thevar_filename = regexprep(thevar_filename,'-','_');
        
        filename = [outdir,regexprep(sites{i},'s',''),'_',thevar_filename,'_DATA.csv'];
        
        %fid = fopen(filename,'wt');
        
        var_full = [thevar,' (',varUnit{sss},')'];
        
        %fprintf(fid,'Date,Depth,%s,QC\n','Data');
        
        for k = 1:length(swan.(sites{i}).(vars{j}).Date)
            
            bfg = swan.(sites{i}).(vars{j}).Depth_Chx{k};
            if isnan(bfg)
                %stop
                switch swan.(sites{i}).(vars{j}).Sample_Type{k}
                    
                    case 'Standard sample (Bottom)'
                        disp('bottom');
                        swan.(sites{i}).(vars{j}).Depth_Chx(k) = {'0.5'};
                        deploy = 'Fixed';
                        deppos = '0.5m above Seabed';
                        vertref = 'm above Seabed';
                        SMD = [];
                    case 'Standard sample (Surface)'
                        disp('surface');
                        swan.(sites{i}).(vars{j}).Depth_Chx(k) = {'0.5'};
                        deploy = 'Floating';
                        deppos = '0.5m from Surface';
                        vertref = 'm from Surface';
                        SMD = [];
                    otherwise
                        if strcmpi(proj,'CSMWQ') == 1
                            swan.(sites{i}).(vars{j}).Depth_Chx(k) = {''};
                            deploy = 'Integrated';
                            deppos = 'Water Column';
                            vertref = 'Water Surface';
                            SMD = [];
                        else
                            deploy = 'Profile';
                            deppos = 'm from Surface';
                            vertref = 'Water Surface';
                            SMD = [];
                            
                        end
                end
            else
                deploy = 'Profile';
                deppos = 'm from Surface';
                vertref = 'Water Surface';
                SMD = [];
                
            end
            
            
            
            switch thevar
                
                case 'Max Discharge'
                    %fprintf(fid,'Data Classification,HYDRO Flow\n');
                    data_class = 'HYDRO Flow';
                    
                    deploy = 'Fixed';
                    deppos = 'm from Datum';
                    vertref = 'm above Datum';
                    SMD = [];
                    
                case 'Mean Discharge'
                    %fprintf(fid,'Data Classification,HYDRO Flow\n');
                    deploy = 'Fixed';
                    deppos = 'm from Datum';
                    vertref = 'm above Datum';
                    SMD = [];
                    data_class = 'HYDRO Flow';
                case 'Min Discharge'
                    deploy = 'Fixed';
                    deppos = 'm from Datum';
                    vertref = 'm above Datum';
                    SMD = [];
                    %fprintf(fid,'Data Classification,HYDRO Flow\n');
                    data_class = 'HYDRO Flow';
                case 'Discharge'
                    deploy = 'Fixed';
                    deppos = 'm from Datum';
                    vertref = 'm above Datum';
                    SMD = [];
                    %fprintf(fid,'Data Classification,HYDRO Flow\n');
                    data_class = 'HYDRO Flow';
                case 'Max Stage Height CTF'
                    deploy = 'Fixed';
                    deppos = 'm from Datum';
                    vertref = 'm above Datum';
                    SMD = [];
                    %fprintf(fid,'Data Classification,HYDRO Level\n');
                    data_class = 'HYDRO Level';
                case 'Mean Stage Height CTF'
                    deploy = 'Fixed';
                    deppos = 'm from Datum';
                    vertref = 'm above Datum';
                    SMD = [];
                    %fprintf(fid,'Data Classification,HYDRO Level\n');
                    data_class = 'HYDRO Level';
                case 'Min Stage Height CTF'
                    deploy = 'Fixed';
                    deppos = 'm from Datum';
                    vertref = 'm above Datum';
                    SMD = [];
                    %fprintf(fid,'Data Classification,HYDRO Level\n');
                    data_class = 'HYDRO Level';
                case 'Max Stage Height'
                    deploy = 'Fixed';
                    deppos = 'm from Datum';
                    vertref = 'm above Datum';
                    SMD = [];
                    %fprintf(fid,'Data Classification,HYDRO Level\n');
                    data_class = 'HYDRO Level';
                case 'Mean Stage Height'
                    deploy = 'Fixed';
                    deppos = 'm from Datum';
                    vertref = 'm above Datum';
                    SMD = [];
                    %fprintf(fid,'Data Classification,HYDRO Level\n');
                    data_class = 'HYDRO Level';
                case 'Min Stage Height'
                    deploy = 'Fixed';
                    deppos = 'm from Datum';
                    vertref = 'm above Datum';
                    SMD = [];
                    %fprintf(fid,'Data Classification,HYDRO Level\n');
                    data_class = 'HYDRO Level';
                otherwise
                    %fprintf(fid,'Data Classification,WQ Grab\n');
                    data_class = 'WQ Grab';
            end
            %
            %
            %
            %
            if ~isnumeric(swan.(sites{i}).(vars{j}).Depth_Chx{k})
                Index = find(contains(swan.(sites{i}).(vars{j}).Depth_Chx{k},'-'));
                if ~isempty(Index)
                    if strcmpi(proj,'CSMWQ') == 1
                        switch deploy
                            case 'Profile'
                                deploy = 'Integrated';
                                deppos = 'Water Column';
                                vertref = 'Water Surface';
                            case 'Fixed'
                                deploy = 'Integrated';
                                deppos = 'Water Column';
                                vertref = 'Water Surface';
                            case 'Floating'
                                deploy = 'Integrated';
                                deppos = 'Water Column';
                                vertref = 'Water Surface';
                            otherwise
                        end
                        
                    else
                        
                        
                        
                        
                        switch deploy
                            case 'Profile'
                                deploy = 'Integrated';
                                deppos = 'Depth Range';
                                vertref = 'Water Surface';
                            case 'Fixed'
                                deploy = 'Integrated';
                                deppos = 'Depth Range';
                                vertref = 'Water Surface';
                            case 'Floating'
                                deploy = 'Integrated';
                                deppos = 'Depth Range';
                                vertref = 'Water Surface';
                            otherwise
                        end
                        
                    end
                end
            end
            
            
            
            fprintf(fid,'%s,%6.6f,%6.6f,%s,%s,%s,%s,%s,%4.4f,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n',...
                sites{i},swan.(sites{i}).(vars{j}).Lat,swan.(sites{i}).(vars{j}).Lon,ID,thevar,var_full,datestr(swan.(sites{i}).(vars{j}).Date(k),'dd-mm-yyyy HH:MM:SS'),...
                swan.(sites{i}).(vars{j}).Depth_Chx{k},swan.(sites{i}).(vars{j}).Data(k),...
                deploy,deppos,vertref,SMD,data_class,...
                'Department of Water and Environmental Regulation',...
                'DWER','Estuary',proj,['DWER-',upper(proj)],varkey.(theID).Category);
        end
    end
end
fclose(fid);
toc


