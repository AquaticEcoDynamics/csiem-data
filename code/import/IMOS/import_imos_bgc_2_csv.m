function import_imos_bgc_2_csv

addpath(genpath('../../functions/'));

thefile = '../../../../data-lake/IMOS/bgc/IMOS_-_Combined_Biogeochemical_parameters_(reference_stations)-All_biogeochemical_parameters.csv';
%'D:/csiem/data-lake/imos/bgc/IMOS_-_Combined_Biogeochemical_parameters_(reference_stations)-All_biogeochemical_parameters.csv';

load ../../actions/varkey.mat;
load ../../actions/agency.mat;
load ../../actions/sitekey.mat;

outpath = '../../../../data-warehouse/csv/imos/bgc/';
%'D:/csiem/data-warehouse/csv/imos/bgc/';

if ~exist(outpath,'dir')
    mkdir(outpath);
end


thesiteval = fieldnames(sitekey.imosbgc);
thevarval = fieldnames(varkey);
theagencyval = fieldnames(agency.imosbgc);
Test = readtable(thefile);
% Test.Properties.VariableNames'
%[~,headers] = xlsread(thefile,'A1:CE1');
headers = Test.Properties.VariableNames;

%[snum,sstr] = xlsread(thefile,'A2:CE1000');

%stations = sstr(:,3);
stations = Test{:,3};

%mdates = datenum(sstr(:,5),'dd/mm/yyyy');
mdates = datenum(Test{:,5});

%Depths = snum(:,6);
Depths = Test{:,12}; %9 or 12
Depths(isnan(Depths)) = 0;
ustations = unique(stations);

for i = 9:width(Test)
%for i = 9:length(headers)
    for j = 1:length(ustations)
        foundstation = 0 ;
        for k = 1:length(thesiteval)
            if strcmpi(sitekey.imosbgc.(thesiteval{k}).Description,ustations{j}) == 1
                foundstation = k;
            end
        end
        
        foundvar = 0;
        
        for k = 1:length(theagencyval)
            if strcmpi(agency.imosbgc.(theagencyval{k}).Old,headers{i}) == 1
                foundvar = k;
            end
        end
        
%         if strcmpi(headers{i},'Allo_mgm3') == 1
%             disp(headers{i})
%             stop
%         end
        
        if foundvar > 0
            
            thefoundvar = 0;
            for nn = 1:length(thevarval)
                if strcmpi(thevarval{nn},agency.imosbgc.(theagencyval{foundvar}).ID) == 1
                    thefoundvar = nn;
                end
            end
            
            
            
            
            sss = find(strcmpi(stations,ustations{j}) == 1);
            
            thedata_raw = Test.(headers{i})(sss) * agency.imosbgc.(theagencyval{foundvar}).Conv;
            %thedata_raw = snum(sss,i-6) * agency.imosbgc.(theagencyval{foundvar}).Conv;
            ttt = find(~isnan(thedata_raw) == 1);
            thedata = thedata_raw(ttt);
            
            if ~isempty(thedata)
            
            thedepth = Depths(sss(ttt));
            thedate = mdates(sss(ttt));
%             [thedate,timeind] = unique(thedates);
%             thedepth = thedepth(timeind);
%             thedata = thedata(timeind);
            
            QC = 'N';
            
            
            filevar = regexprep(varkey.(thevarval{thefoundvar}).Name,' ','_');
            filevar = regexprep(filevar,'+','_');
            filename = [outpath,sitekey.imosbgc.(thesiteval{foundstation}).AED,'_',filevar,'_DATA.csv']
            fid = fopen(filename,'wt');
            fprintf(fid,'Date,Depth,Data,QC\n');
            for nn = 1:length(thedata)
                fprintf(fid,'%s,%4.4f,%4.4f,%s\n',datestr(thedate(nn),'yyyy-mm-dd HH:MM:SS'),thedepth(nn),thedata(nn),QC);
            end
            fclose(fid);
            
            headerfile = regexprep(filename,'_DATA','_HEADER');
            
            fid = fopen(headerfile,'wt');
            fprintf(fid,'Agency Name,Integrated Marine Observing System\n');
            fprintf(fid,'Agency Code,IMOS\n');
            fprintf(fid,'Program,BGC\n');
            fprintf(fid,'Project,BGC\n');
            fprintf(fid,'Tag,IMOS-BGC\n');
            fprintf(fid,'Data File Name,%s\n',regexprep(filename,outpath,''));
            fprintf(fid,'Location,%s\n',['data-warehouse/csv/imos/',lower('bgc')]);
            
            
            fprintf(fid,'Station Status,Inactive\n');
            fprintf(fid,'Lat,%6.9f\n',sitekey.imosbgc.(thesiteval{foundstation}).Lat);
            fprintf(fid,'Long,%6.9f\n',sitekey.imosbgc.(thesiteval{foundstation}).Lon);
            fprintf(fid,'Time Zone,GMT +8\n');
            fprintf(fid,'Vertical Datum,mAHD\n');
            fprintf(fid,'National Station ID,%s\n',[sitekey.imosbgc.(thesiteval{foundstation}).ID,'_BGC']);
            fprintf(fid,'Site Description,%s\n',sitekey.imosbgc.(thesiteval{foundstation}).Description);
            fprintf(fid,'Deployment,%s\n','Profile');
            fprintf(fid,'Deployment Position,%s\n','m from Surface');
            fprintf(fid,'Vertical Reference,%s\n','Water Surface');
            fprintf(fid,'Site Mean Depth,%s\n','');

            fprintf(fid,'Bad or Unavailable Data Value,NaN\n');
            fprintf(fid,'Contact Email,\n');
            fprintf(fid,'Variable ID,%s\n',agency.imosbgc.(theagencyval{foundvar}).ID);
            
            fprintf(fid,'Data Category,%s\n',varkey.(thevarval{thefoundvar}).Category);
            
            
            SD = mean(diff(thedate));
            
            fprintf(fid,'Sampling Rate (min),%4.4f\n',SD * (60*24));
            
            fprintf(fid,'Date,yyyy-mm-dd HH:MM:SS\n');
            fprintf(fid,'Depth,Decimal\n');
            
            thevar = [varkey.(thevarval{thefoundvar}).Name,' (',varkey.(thevarval{thefoundvar}).Unit,')'];
            
            fprintf(fid,'Variable,%s\n',thevar);
            fprintf(fid,'QC,String\n');
            
            fclose(fid);
            %plot_datafile(filename);

            end
            
        end
    end
    
end





