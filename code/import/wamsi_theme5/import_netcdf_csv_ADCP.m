function import_netcdf_csv_ADCP

addpath(genpath('../../functions/'));

filepath = '../../../../data-lake/WAMSI/wwmsp5_adcp/';
              %'D:csiem/data-lake/wamsi/wwmsp5_adcp/';

outdir = '../../../../data-warehouse/csv/wamsi/wwmsp5_awac/';
            %'D:csiem/data-warehouse/csv/wamsi/wwmsp5_awac/';

mkdir(outdir);

plotdir = 'Images/';mkdir(plotdir);

%filelist = dir(fullfile(filepath, '**\*.nc'));  %get list of files and folders in any subfolder
filelist = dir(fullfile(filepath, '**/*.nc'));  %get list of files and folders in any subfolder
filelist = filelist(~[filelist.isdir]);  %remove folders from list

% Conversion
%[snum,sstr] = xlsread('Conversions_mh.xlsx','A2:D1000');
load ../../actions/agency.mat;

agencyvars = fieldnames(agency.theme5);

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
    
    %
    %
    
    if ~dont_export
        
        for j = 1:length(vars)
            bottom_tag = 'Fixed';
            
            if strcmpi(vars{j},'SALINITY') == 0
            
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
            
            if foundvar ~=0
                if ndims(data.(vars{j})) < 3
                    
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
                    
                    deployment = 'Fixed';
                    dPos = 'm below Surface';
                    Ref = 'Water Surface';
                    SMD = thedepth;
                    theheader = 'Depth';
                    
                    
                    %
                    %                 pdepth(1:length(pdate),1) = str2num(thedepth);
                    %             end
                    %                 pQC(1:length(pdate)) = {'n'};
                    
                    if ~isempty(pdepth)
                        
                        
                        
                        
                        if length(pdata) == length(pdate)
                            
                            disp(vars{j});
                            
                            [pdate_u,int] = unique(pdate);
                            pdata_u = pdata(int);
                            pdepth_u = pdepth(int);
                            pQC_u(1:length(pdata_u)) = {'n'};
                            hourly = [min(pdate):1/24:max(pdate)];
                            
                            pdata_int  = interp1(pdate_u,pdata_u,hourly);
                            pdepth_int = interp1(pdate_u,pdepth_u,hourly);
                            pQC_int(1:length(hourly)) = {'n'};
                            
                            varname = varkey.(agency.theme5.(agencyvars{foundvar}).ID).Name;
                            varunits = varkey.(agency.theme5.(agencyvars{foundvar}).ID).Unit;
                            
                            thetxt = ['_',regexprep(varname,' ','_'),'_DATA.csv'];
                            datafile = regexprep(filelist(i).name,'.nc',thetxt);
                            fullfile_1 = [outdir,datafile];
                            headerfile = regexprep(fullfile_1,'DATA.csv','HEADER.csv');
                            
                            fid = fopen(fullfile_1,'wt');
                        fprintf(fid,'Date,%s,Data,QC\n',theheader);
                            for nn = 1:length(pdate_u)
                                fprintf(fid,'%s,%4.4f,%4.4f,%s\n',datestr(pdate_u(nn),'yyyy-mm-dd HH:MM:SS'),pdepth_u(nn),pdata_u(nn),pQC_u{nn});
                            end
                            fclose(fid);
                            
                            fid = fopen(headerfile,'wt');
                            fprintf(fid,'Agency Name,Western Australian Marine Science Institution\n');
                            fprintf(fid,'Agency Code,WAMSI\n');
                            fprintf(fid,'Program,WAMSI Westport Marine Science Program\n');
                            fprintf(fid,'Project,WWMSP5.1\n');
                            fprintf(fid,'Tag,WWMSP5.1-AWAC\n');
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
                
            end
            
            
        end
        
        
        
    else
        fprintf(fiddepth,'%s\n',filename);
        
    end
end
fclose(fiddepth);
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
