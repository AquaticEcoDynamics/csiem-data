clear all; close all;

addpath(genpath('../../functions/'));

thefile = 'D:/csiem/data-lake/imos/amnmprofile/IMOS_-_Australian_National_Mooring_Network_(ANMN)_Facility_-_WQM_and_CTD_burst_averaged_data_products.csv';

load ../../actions/varkey.mat;
load ../../actions/agency.mat;
load ../../actions/sitekey.mat;

outpath = 'D:/csiem/data-warehouse/csv/imos/amnmprofile/';

if ~exist(outpath,'dir')
    mkdir(outpath);
end


thesiteval = fieldnames(sitekey.imosbgc);
thevarval = fieldnames(varkey);
theagencyval = fieldnames(agency.imosprofile);

Table = readtable(thefile);
headers = Table.Properties.VariableNames;
%[~,headers] = xlsread(thefile,'A29:CA29');

%[snum,sstr] = xlsread(thefile,'A30:CA689555');

%stations = sstr(:,4);
stations = Table{:,4};

sdate = Table{:,8};
%sdate = sstr(:,8);
sdate = regexprep(sdate,'T',' ');
sdate = regexprep(sdate,'Z','');


mdates = datenum(sdate,'yyyy-mm-dd HH:MM:SS');


Depths = snum(:,10);
Depths(isnan(Depths)) = 0;


ustations = unique(stations);

for i = 12:length(headers)
    for j = 1:length(ustations)
        foundstation = 0 ;
        for k = 1:length(thesiteval)
            if strcmpi(sitekey.imosbgc.(thesiteval{k}).ID,ustations{j}) == 1
                foundstation = k;
            end
        end
        
        foundvar = 0;
        
        for k = 1:length(theagencyval)
            if strcmpi(agency.imosprofile.(theagencyval{k}).Old,headers{i}) == 1
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
                if strcmpi(thevarval{nn},agency.imosprofile.(theagencyval{foundvar}).ID) == 1
                    thefoundvar = nn;
                end
            end
            
            
            
            
            sss = find(strcmpi(stations,ustations{j}) == 1);
            
            thedata_raw = snum(sss,i-1) * agency.imosprofile.(theagencyval{foundvar}).Conv;
            ttt = find(~isnan(thedata_raw) == 1);
            thedata = thedata_raw(ttt);
            
            if ~isempty(thedata)
            
            thedepth = Depths(sss(ttt));
            thedate = mdates(sss(ttt));
            QC = 'N';
            
            
            
            
            filevar = regexprep(varkey.(thevarval{thefoundvar}).Name,' ','_');
            filevar = regexprep(filevar,'+','_');
            filename = [outpath,sitekey.imosbgc.(thesiteval{foundstation}).AED,'_','BURST_',filevar,'_DATA.csv'];
            fid = fopen(filename,'wt');
            fprintf(fid,'Date,Depth,Data,QC\n');
            for nn = 1:length(thedata)
                fprintf(fid,'%s,%4.4f,%4.4f,%s\n',datestr(thedate(nn),'dd-mm-yyyy HH:MM:SS'),thedepth(nn),thedata(nn),QC);
            end
            fclose(fid);
            
            headerfile = regexprep(filename,'_DATA','_HEADER');
            
            fid = fopen(headerfile,'wt');
            fprintf(fid,'Agency Name,Integrated Marine Observing System\n');
            fprintf(fid,'Agency Code,IMOS\n');
            fprintf(fid,'Program,amnmprofile\n');
            fprintf(fid,'Project,amnmprofile\n');
            fprintf(fid,'Tag,IMOS-ANMN-CTD\n');
            fprintf(fid,'Data File Name,%s\n',regexprep(filename,outpath,''));
            fprintf(fid,'Location,%s\n',['data-warehouse/csv/imos/',lower('bgc')]);
            
            
            fprintf(fid,'Station Status,Inactive\n');
            fprintf(fid,'Lat,%6.9f\n',sitekey.imosbgc.(thesiteval{foundstation}).Lat);
            fprintf(fid,'Long,%6.9f\n',sitekey.imosbgc.(thesiteval{foundstation}).Lon);
            fprintf(fid,'Time Zone,GMT +8\n');
            fprintf(fid,'Vertical Datum,mAHD\n');
            fprintf(fid,'National Station ID,%s\n',[sitekey.imosbgc.(thesiteval{foundstation}).ID,'_PROFILE']);
            fprintf(fid,'Site Description,%s\n',sitekey.imosbgc.(thesiteval{foundstation}).Description);
                            fprintf(fid,'Mount Description,%s\n','Profile');

            fprintf(fid,'Bad or Unavailable Data Value,NaN\n');
            fprintf(fid,'Contact Email,\n');
            fprintf(fid,'Variable ID,%s\n',agency.imosprofile.(theagencyval{foundvar}).ID);
            
            fprintf(fid,'Data Classification,WQ Grab\n');
            
            
            SD = mean(diff(thedate));
            
            fprintf(fid,'Sampling Rate (min),%4.4f\n',SD * (60*24));
            
            fprintf(fid,'Date,dd-mm-yyyy HH:MM:SS\n');
            fprintf(fid,'Depth,Decimal\n');
            
            thevar = [varkey.(thevarval{thefoundvar}).Name,' (',varkey.(thevarval{thefoundvar}).Unit,')'];
            
            fprintf(fid,'Variable,%s\n',thevar);
            fprintf(fid,'QC,String\n');
            
            fclose(fid);
            plot_datafile(filename);

            
            end
        end
    end
    
end





