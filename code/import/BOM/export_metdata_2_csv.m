function export_metdata_2_csv(metdata)
addpath(genpath('../../functions/'));

%load '../../../../data-warehouse/csv_holding/bom/idy/metdata.mat'
%D:\csiem/data-warehouse/csv_holding/bom/idy/metdata.mat;

load ../../actions/varkey.mat;
load ../../actions/agency.mat;
load ../../actions/sitekey.mat;

thesites = fieldnames(sitekey.bom);
thevars = fieldnames(agency.bom);


%[snum,sstr] = xlsread('V:/data-lake/variable_key.xlsx','Key','A2:D10000');

% varID = sstr(:,1);
% varName = sstr(:,2);
% varUnit = sstr(:,3);
% varSymbol = sstr(:,4);
% 
% for i = 1:length(varSymbol)
%     if isempty(varSymbol{i})
%         varSymbol(i) = varName(i);
%     end
% end

% [snum,sstr] = xlsread('V:/data-lake/variable_key.xlsx','BOM','B2:D10000');
% 
% conv = snum(:,1);
% avarID = sstr(:,1);
% 
% 
% [snum,sstr] = xlsread('V:/data-lake/site_key.xlsx','BOM','A2:H10000');
% 

writepath = 'data-warehouse/csv/bom/idy';
outdir = ['../../../../', writepath,'/'];
%'D:/csiem/data-warehouse/csv/bom/idy/';



if ~exist(outdir,'dir')
    mkdir(outdir);
end

sites = fieldnames(metdata);
failedVals = {};
for i = 1:length(sites)
    foundsite = 0;
    for j = 1:length(thesites)
        if strcmpi(sitekey.bom.(thesites{j}).Shortname,sites{i}) == 1
            foundsite = j;
        end
    end
    
%     aSite = sitename{sss};
%     aLat = Lat(sss);
%     aLon = Lon(sss);
%     ID = siteid(sss);
    
    
    headers = metdata.(sites{i}).headers;
    vars = fieldnames(metdata.(sites{i}));
    mtime = metdata.(sites{i}).Date;
    % mtime = datenum(metdata.(sites{i}).Year,...
    %     metdata.(sites{i}).Month,...
    %     metdata.(sites{i}).Day,...
    %     metdata.(sites{i}).Hour,...
    %     metdata.(sites{i}).MI_Format,...
    %     00);
    
    format compact
    for j = 1:length(headers)
        display(headers{j})
    end
    fprintf('\n\n\n\n')
    for j = 1:length(thevars)
        disp(agency.bom.(thevars{j}).Old)
    end

    fprintf('\n\n')

    for j = 1:length(headers)
        foundvar = [];
        for k = 1:length(thevars)
            if strcmpi(agency.bom.(thevars{k}).Old,headers{j}) == 1
                foundvar = k;
            end
        end
        
        if ~isempty(foundvar)
            
            disp('valid data');
            dataint = find(~isnan(metdata.(sites{i}).(vars{j})) == 1);
            
            mdate = mtime(dataint);
            mdata = metdata.(sites{i}).(vars{j})(dataint);
            QC(1:length(dataint)) = {'N'};%metdata.(sites{i}).(vars{j+1})(dataint); This needs fixing
            
            if ~isempty(mdata)
                
                conv = agency.bom.(thevars{foundvar}).Conv;
                
                disp([agency.bom.(thevars{foundvar}).Old,' ',num2str(agency.bom.(thevars{foundvar}).Conv)]);
                
                if strcmpi(agency.bom.(thevars{foundvar}).ID,'var00152') == 0
                    
                    mdata = mdata * conv;
                    
                    filename = [outdir,num2str(sitekey.bom.(thesites{foundsite}).ID),'_',regexprep(varkey.(agency.bom.(thevars{foundvar}).ID).Name,' ','_'),'_DATA.csv'];
                    
                    writefile = [num2str(sitekey.bom.(thesites{foundsite}).ID),'_',regexprep(varkey.(agency.bom.(thevars{foundvar}).ID).Name,' ','_'),'_DATA.csv'];
                    
                    fid = fopen(filename,'wt');
                    
                    fprintf(fid,'Date,Height,Data,QC\n');
                    
                    for k = 1:length(mdate)
                        fprintf(fid,'%s,%s,%8.5f,%s\n',datestr(mdate(k),'yyyy-mm-dd HH:MM:SS'),'2',mdata(k),QC{k});
                    end
                    fclose(fid);
                    
                    headerfile = regexprep(filename,'_DATA','_HEADER');
                    
                    fid = fopen(headerfile,'wt');
                    fprintf(fid,'Agency Name,Bureau of Meteorology\n');
                    fprintf(fid,'Agency Code,BOM\n');
                    fprintf(fid,'Program,Weather\n');
                    fprintf(fid,'Project,IDY\n');
                    fprintf(fid,'Tag,BOM-IDY\n');
                    fprintf(fid,'Data File Name,%s\n',writefile);
                    fprintf(fid,'Location,%s\n',writepath);
                    
                    if max(mdate) >= datenum(2019,01,01)
                        fprintf(fid,'Station Status,Active\n');
                    else
                        fprintf(fid,'Station Status,Inactive\n');
                    end
                    fprintf(fid,'Lat,%8.8f\n',sitekey.bom.(thesites{foundsite}).Lat);
                    fprintf(fid,'Long,%8.8f\n',sitekey.bom.(thesites{foundsite}).Lon);
                    fprintf(fid,'Time Zone,GMT +8\n');
                    fprintf(fid,'Vertical Datum, \n');
                    fprintf(fid,'National Station ID,%s\n',num2str(sitekey.bom.(thesites{foundsite}).ID));
                    fprintf(fid,'Site Description,%s\n',sitekey.bom.(thesites{foundsite}).Description);
                    fprintf(fid,'Deployment,%s\n','Fixed');
                    fprintf(fid,'Deployment Position,%s\n','2m from Ground');
                    fprintf(fid,'Vertical Reference,%s\n','m from Ground');
                    fprintf(fid,'Site Mean Depth,%s\n','');
                    
                    
                    %fprintf(fid,'Mount Description,%s\n','Fixed +2m Above Ground');
                    fprintf(fid,'Bad or Unavailable Data Value,-9999\n');
                    fprintf(fid,'Contact Email,climatedata@bom.gov.au\n');
                    fprintf(fid,'Variable ID,%s\n',agency.bom.(thevars{foundvar}).ID);
                    fprintf(fid,'Data Category,%s\n',varkey.(agency.bom.(thevars{foundvar}).ID).Category);
                    
                    SD = mean(diff(mdate));
                    
                    fprintf(fid,'Sampling Rate (min),%4.4f\n',SD * (60*24));
                    
                    fprintf(fid,'Date,yyyy-mm-dd HH:MM:SS\n');
                    fprintf(fid,'Depth,Decimal\n');
                    
                    %thevar = [varName{sss},' (',varUnit{sss},')'];
                    
                    fprintf(fid,'Variable,%s\n',[varkey.(agency.bom.(thevars{foundvar}).ID).Name,' (',varkey.(agency.bom.(thevars{foundvar}).ID).Unit,')']);
                    fprintf(fid,'QC,String\n');
                    
                    fclose(fid);
                    %plot_datafile(filename);
                end
            else
                fprintf('Empty valid data\n');
            end
        else
            failedVal = ['site ' num2str(i) ,'; variable index ',num2str(j) , ' failed; header: ', headers{j} '; struct field name: ' vars{j}];
            failedVals = [failedVals;failedVal];
        end
        
    end
    
    
    
end
failedVals





