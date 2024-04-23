function import_netcdf_csv

addpath(genpath('../../functions'));

basedir = '../../../../data-lake/WAMSI/wwmsp5_wq/';
             %'D:csiem/data-lake/wamsi/wwmsp5_wq/';
%filelist = dir(fullfile(basedir, '**\*.nc'));
filelist = dir(fullfile(basedir, '**/*.nc'));  %get list of files and folders in any subfolder
filelist = filelist(~[filelist.isdir]);  %remove folders from list

adcpfilepath = '../../../../data-lake/WAMSI/wwmsp5_adcp/ADCP/';
                 %'D:\csiem\data-lake\WAMSI\wwmsp5_adcp\ADCP\';

outdir = '../../../../data-warehouse/csv/wamsi/wwmsp5_wq/';
%            'D:csiem/data-warehouse/csv/wamsi/wwmsp5_wq/';

mkdir(outdir);

plotdir = 'images/';mkdir(plotdir);



% Conversion
%[snum,sstr] = xlsread('Conversions_mh.xlsx','A2:D1000');
load ../../actions/agency.mat;

agencyvars = fieldnames(agency.theme5);


[~,adcp] = xlsread('missing_depths.xlsx','B2:C1000');

% oldheader = sstr(:,1);
% newheader = sstr(:,3);
% conv = snum(:,1);

theme5 = [];

load ../../actions/varkey.mat;
allvars = fieldnames(varkey);

fiddepth = fopen('No Depth.txt','wt');

for i = 1:length(filelist)
    
    disp(filelist(i).name);
    
    filename = [filelist(i).folder,'/',filelist(i).name];
    
    headerfile = regexprep(filename,'.nc','.txt');
    
    
    
    thedepth = ncreadatt(filename,'/','Site_depth_at_deployment');
    
    disp(thedepth);
    
    tt = split(filelist(i).name,'_');
    
    site = tt{2};
    
    data = tfv_readnetcdf(filename);
    
    dont_export = 1;
    
    if isfield(data,'Depth')
        dont_export = 0;
    end
    if isfield(data,'PRESSURE')
        dont_export = 0;
    end
    if isfield(data,'PRESSURE_SENSOR_DEPTH')
        dont_export = 0;
    end
    
    mtime = datenum(1950,01,01,00,00,00) + data.TIME;
    
    [X,Y] = ll2utm(data.LATITUDE,data.LONGITUDE);
    
    vars = fieldnames(data);
    
    bottom_tag = '';
    
    if dont_export
        
        ss = find(strcmpi(adcp(:,1),filelist(i).name) == 1);
        
        if ~isempty(ss)
            dataadcp = tfv_readnetcdf([adcpfilepath,adcp{ss,2}]);
            
            mtimeadcp = datenum(1950,01,01,00,00,00) + dataadcp.TIME;
            
            if isfield(dataadcp,'PRESSURE_SENSOR_DEPTH');
                %data.DEPTH = interp1(mtimeadcp,dataadcp.PRESSURE_SENSOR_DEPTH,mtime);
                
                depthmean = mean(dataadcp.PRESSURE_SENSOR_DEPTH);
                
                depthmean = thedepth;
                
            else
                %data.DEPTH = interp1(mtimeadcp,dataadcp.PRESSURE,mtime);
                depthmean = mean(dataadcp.PRESSURE);
                depthmean = thedepth;
            end
            data.DEPTH(1:length(mtime),1) = 0.3;%str2double(thedepth);
            dont_export = 0;
        else
            disp(['Broken ADCP: ' ,filelist(i).name]);
            
            dont_export = 1;
        end
        
        deployment = 'Fixed';
        dPos = '0.3m above Seabed';
        Ref = 'm above Seabed';
        SMD = thedepth;
        theheader = 'Height';
        %bottom_tag = 'Fixed +0.3m Above Seabed';
    else
        %bottom_tag = 'Floating';
        
        deployment = 'Fixed';
        dPos = 'm below Surface';
        Ref = 'Water Surface';
        SMD = thedepth;
        theheader = 'Depth';
        
    end
    
    if ~dont_export
        
        for j = 1:length(vars)
            pdate = [];
            pdata = [];
            pdepth = [];
            pQC = {};
            foundvar = 0;
            for k = 1:length(agencyvars)
                if strcmpi(agency.theme5.(agencyvars{k}).Old,vars{j}) == 1
                    foundvar = k;
                end
            end
            switch vars{j}
                case 'CELL'
                    foundvar = 0 ;
                case 'UCUR'
                    foundvar = 0 ;
                case 'VCUR'
                    foundvar = 0 ;
                otherwise
            end
            
            
            if foundvar ~=0
                pdepth = [];
                pdate = mtime;
                pdata = data.(vars{j}) * agency.theme5.(agencyvars{foundvar}).Conv;
                if isfield(data,'DEPTH')
                    pdepth = data.DEPTH;
                end
                if isfield(data,'PRESSURE')
                    pdepth = data.PRESSURE;
                end
                if isfield(data,'PRESSURE_SENSOR_DEPTH')
                    pdepth = data.PRESSURE_SENSOR_DEPTH;
                end
                
                
                
                
                %
                %                 pdepth(1:length(pdate),1) = str2num(thedepth);
                %             end
                %                 pQC(1:length(pdate)) = {'n'};
                
                if ~isempty(pdepth)
                    
                    [pdate_u,int] = unique(pdate);
                    pdata_u = pdata(int);
                    pdepth_u = pdepth(int);
                    
                    
                    if length(pdata) == length(pdate)
                        
                        hourly = [min(pdate):15/(24*60):max(pdate)];
                        
                        pdata_int  = interp1(pdate_u,pdata_u,hourly);
                        pdepth_int = interp1(pdate_u,pdepth_u,hourly);
                        pQC_int(1:length(hourly)) = {'n'};
                        
                        varname = varkey.(agency.theme5.(agencyvars{foundvar}).ID).Name;
                        varunits = varkey.(agency.theme5.(agencyvars{foundvar}).ID).Unit;
                        
                        thetxt = ['_',regexprep(varname,' ','_'),'_DATA.csv'];
                        datafile = regexprep(filelist(i).name,'.nc',thetxt);
                        fullfile_1 = [outdir,datafile];
                        headerfile = regexprep(fullfile_1,'DATA.csv','HEADER.csv');
                        tic
                        tab.Date = datestr(pdate_u,'yyyy-mm-dd HH:MM:SS');
                        tab.Data = pdata_u;
                        tab.(theheader) = pdepth_u;
                        tab.QC(1:length(pdate_u),1) = 'n';
                        
                        tableout = struct2table(tab);
                        writetable(tableout,fullfile_1);clear tab tableout;
                        toc
                        %                         tic
                        %                         fid = fopen(fullfile,'wt');
                        %                         fprintf(fid,'Date,%s,Data,QC\n',theheader);
                        %                         for nn = 1:length(pdate_u)
                        %                             fprintf(fid,'%s,%4.4f,%4.4f,n\n',datestr(pdate_u(nn),'yyyy-mm-dd HH:MM:SS'),pdepth_u(nn),pdata_u(nn));
                        %                         end
                        %                         fclose(fid);
                        %                         toc
                        %                         stop
                        fid = fopen(headerfile,'wt');
                        fprintf(fid,'Agency Name,Western Australian Marine Science Institution\n');
                        fprintf(fid,'Agency Code,WAMSI\n');
                        fprintf(fid,'Program,WAMSI Westport Marine Science Program\n');
                        fprintf(fid,'Project,WWMSP5.1\n');
                        fprintf(fid,'Tag,WWMSP5.1-WQ\n');
                        fprintf(fid,'Data File Name,%s\n',datafile);
                        fprintf(fid,'Location,%s\n',['data-warehouse/csv/wamsi/wwmsp5']);
                        
                        
                        fprintf(fid,'Station Status,Static\n');
                        fprintf(fid,'Lat,%6.9f\n',data.LATITUDE);
                        fprintf(fid,'Long,%6.9f\n',data.LONGITUDE);
                        fprintf(fid,'Time Zone,GMT +8\n');
                        fprintf(fid,'Vertical Datum,mAHD\n');
                        fprintf(fid,'National Station ID,%s\n',site);
                        fprintf(fid,'Site Description,%s\n',site);
                        fprintf(fid,'Deployment,%s\n',deployment);
                        fprintf(fid,'Deployment Position,%s\n',dPos);
                        fprintf(fid,'Vertical Reference,%s\n',Ref);
                        fprintf(fid,'Site Mean Depth,%s\n',SMD);
                        fprintf(fid,'Bad or Unavailable Data Value,NaN\n');
                        fprintf(fid,'Contact Email,%s\n','Charitha Pattiaratchi <chari.pattiaratchi@uwa.edu.au>');
                        fprintf(fid,'Variable ID,%s\n',agency.theme5.(agencyvars{foundvar}).ID);
                        
                        fprintf(fid,'Data Category,%s\n',varkey.(agency.theme5.(agencyvars{foundvar}).ID).Category);
                        
                        
                        SD = mean(diff(pdate));
                        
                        fprintf(fid,'Sampling Rate (min),%4.4f\n',SD * (60*24));
                        
                        fprintf(fid,'Date,yyyy-mm-dd HH:MM:SS\n');
                        fprintf(fid,'Depth,Decimal\n');
                        
                        thevar = [varname,' (',varunits,')'];
                        
                        fprintf(fid,'Variable,%s\n',thevar);
                        fprintf(fid,'QC,String\n');
                        
                        fclose(fid);
                        %plot_datafile(fullfile);
                    end
                    
                end
                
            end
            
            
            
            
        end
        
        
        
        
        
    else
        fprintf(fiddepth,'%s\n',filename);
        
    end
end
fclose(fiddepth);

%end
%             if ~isfield(theme5,site)
%                 theme5.(site).(newheader{sss}).Date(:,1) = mtime;
%                 theme5.(site).(newheader{sss}).Data(:,1) = data.(vars{j}) * conv(sss);
%                 if isfield(data,'DEPTH')
%
%                     theme5.(site).(newheader{sss}).Depth(:,1) = data.DEPTH * -1;
%                 else
%                     theme5.(site).(newheader{sss}).Depth(1:length(mtime),1) = 0;
%                 end
%
%                 theme5.(site).(newheader{sss}).X = X;
%                 theme5.(site).(newheader{sss}).Y = Y;
%                 theme5.(site).(newheader{sss}).Title = site;
%                 theme5.(site).(newheader{sss}).Variable_Name = vars{j};
%                 theme5.(site).(newheader{sss}).Units = '';
%
%             else
%                 if isfield(theme5.(site),newheader{sss})
%                     theme5.(site).(newheader{sss}).Date = [theme5.(site).(newheader{sss}).Date;mtime];
%                     theme5.(site).(newheader{sss}).Data = [theme5.(site).(newheader{sss}).Data;data.(vars{j}) * conv(sss)];
%
%                     if isfield(data,'DEPTH')
%
%                         theme5.(site).(newheader{sss}).Depth = [theme5.(site).(newheader{sss}).Depth;data.DEPTH * -1];
%                     else
%                         dd(1:length(mtime),1) = 0;
%                         theme5.(site).(newheader{sss}).Depth = [theme5.(site).(newheader{sss}).Depth;dd];clear dd;
%                     end
%                 else
%                     theme5.(site).(newheader{sss}).Date(:,1) = mtime;
%                     theme5.(site).(newheader{sss}).Data(:,1) = data.(vars{j}) * conv(sss);
%                     if isfield(data,'DEPTH')
%
%                         theme5.(site).(newheader{sss}).Depth(:,1) = data.DEPTH * -1;
%                     else
%                         theme5.(site).(newheader{sss}).Depth(1:length(mtime),1) = 0;
%                     end
%
%                     theme5.(site).(newheader{sss}).X = X;
%                     theme5.(site).(newheader{sss}).Y = Y;
%                     theme5.(site).(newheader{sss}).Title = site;
%                     theme5.(site).(newheader{sss}).Variable_Name = vars{j};
%                     theme5.(site).(newheader{sss}).Units = '';
%                 end
%             end









%         end
%
%     end


% sites = fieldnames(theme5);
%
% for i = 1:length(sites)
%     vars = fieldnames(theme5.(sites{i}));
%     for j = 1:length(vars)
%         [theme5.(sites{i}).(vars{j}).Date,int] = sort(theme5.(sites{i}).(vars{j}).Date);
%         theme5.(sites{i}).(vars{j}).Data = theme5.(sites{i}).(vars{j}).Data(int);
%         theme5.(sites{i}).(vars{j}).Depth = theme5.(sites{i}).(vars{j}).Depth(int);
%     end
% end




% save theme5.mat theme5 -mat -v7.3;
%
%
% load swan_new.mat;
%
% for i = 1:length(sites)
%
%         swan.(sites{i}) = theme5.(sites{i});
%
% end
% save swan_new_2.mat swan -mat -v7.3;
