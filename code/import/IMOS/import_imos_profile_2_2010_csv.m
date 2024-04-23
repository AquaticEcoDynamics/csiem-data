function import_imos_profile_2_2010_csv

addpath(genpath('../../functions/'));

thefile = '../../../../data-lake/IMOS/amnmprofile/IMOS_-_Australian_National_Mooring_Network_(ANMN)_Facility_-_WQM_and_CTD_burst_averaged_data_products.csv';
%            'D:/csiem/data-lake/imos/amnmprofile/IMOS_-_Australian_National_Mooring_Network_(ANMN)_Facility_-_WQM_and_CTD_burst_averaged_data_products.csv';

load ../../actions/varkey.mat;
load ../../actions/agency.mat;
load ../../actions/sitekey.mat;

outpath = '../../../../data-warehouse/csv_holding/imos/amnmprofile/';
%            'D:/csiem/data-warehouse/csv_holding/imos/amnmprofile/';

if ~exist(outpath,'dir')
    mkdir(outpath);
end


thesiteval = fieldnames(sitekey.imosamnm);
thevarval = fieldnames(varkey);
theagencyval = fieldnames(agency.imosprofile);

% [~,headers] = xlsread(thefile,'A1:AO1');

% [snum,sstr] = xlsread(thefile,'A2:AO700000');


thedata = readtable(thefile);

stations = thedata.site_code;

sdate = thedata.TIME;
sdate = regexprep(sdate,'T',' ');
sdate = regexprep(sdate,'Z','');


mdates = datenum(sdate,'yyyy-mm-dd HH:MM:SS');


Depths = thedata.DEPTH;
Depths(isnan(Depths)) = 0;


ustations = unique(stations);

for i = 1:length(theagencyval)
    
    thevar = agency.imosprofile.(theagencyval{i}).Old;
    
    
    if ismember(thevar, thedata.Properties.VariableNames)
    

        for j = 1:length(ustations)
            foundstation = 0 ;
            for k = 1:length(thesiteval)
                if strcmpi(sitekey.imosamnm.(thesiteval{k}).ID,ustations{j}) == 1
                    foundstation = k;
                end
            end


                varID = agency.imosprofile.(theagencyval{i}).ID;
                varname = varkey.(varID).Name;
                fullvar = [varname,' (',varkey.(varID).Unit,')'];

                sss = find(strcmpi(stations,ustations{j}) == 1);

                thedata_raw = thedata.(thevar)(sss,1) * agency.imosprofile.(theagencyval{i}).Conv;
                ttt = find(~isnan(thedata_raw) == 1);
                thedataout = thedata_raw(ttt);

                if ~isempty(thedataout)

                thedepth = Depths(sss(ttt));
                thedate = mdates(sss(ttt));
                QC = 'N';




                filevar = regexprep(varkey.(varID).Name,' ','_');
                filevar = regexprep(filevar,'+','_');
                filename = [outpath,sitekey.imosamnm.(thesiteval{foundstation}).AED,'_',filevar,'_2010_DATA.csv'];
                fid = fopen(filename,'wt');
                fprintf(fid,'Date,Depth,Data,QC\n');
                for nn = 1:length(thedataout)
                    fprintf(fid,'%s,%4.4f,%4.4f,%s\n',datestr(thedate(nn),'yyyy-mm-dd HH:MM:SS'),thedepth(nn),thedataout(nn),QC);
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
                fprintf(fid,'Location,%s\n',['data-warehouse/csv/imos/',lower('amnmprofile')]);


                fprintf(fid,'Station Status,Inactive\n');
                fprintf(fid,'Lat,%6.9f\n',sitekey.imosamnm.(thesiteval{foundstation}).Lat);
                fprintf(fid,'Long,%6.9f\n',sitekey.imosamnm.(thesiteval{foundstation}).Lon);
                fprintf(fid,'Time Zone,GMT +8\n');
                fprintf(fid,'Vertical Datum,mAHD\n');
                fprintf(fid,'National Station ID,%s\n',[sitekey.imosamnm.(thesiteval{foundstation}).ID,'_PROFILE']);
                fprintf(fid,'Site Description,%s\n',sitekey.imosamnm.(thesiteval{foundstation}).Description);
                fprintf(fid,'Deployment,%s\n','Profile');
                fprintf(fid,'Deployment Position,%s\n','m from Surface');
                fprintf(fid,'Vertical Reference,%s\n','Water Surface');
                fprintf(fid,'Site Mean Depth,%s\n','');

                fprintf(fid,'Bad or Unavailable Data Value,NaN\n');
                fprintf(fid,'Contact Email,\n');
                fprintf(fid,'Variable ID,%s\n',agency.imosprofile.(theagencyval{i}).ID);

                fprintf(fid,'Data Category,%s\n', varkey.(varID).Category);


                SD = mean(diff(thedate));

                fprintf(fid,'Sampling Rate (min),%4.4f\n',SD * (60*24));

                fprintf(fid,'Date,yyyy-mm-dd HH:MM:SS\n');
                fprintf(fid,'Depth,Decimal\n');

                %thevar = [varkey.(thevarval{thefoundvar}).Name,' (',varkey.(thevarval{thefoundvar}).Unit,')'];

                fprintf(fid,'Variable,%s\n',fullvar);
                fprintf(fid,'QC,String\n');

                fclose(fid);
                %plot_datafile(filename);

                end

            end
        
    end
    
end





