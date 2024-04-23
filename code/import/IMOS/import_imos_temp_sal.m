function import_imos_temp_sal
%clear all; close all;

thefile = '../../../../data-lake/IMOS/amnmprofile/IMOS_-_Australian_National_Mooring_Network_(ANMN)_Facility_-_Temperature_and_salinity_time-series.csv';
%            'D:/csiem/data-lake/imos/amnmprofile/IMOS_-_Australian_National_Mooring_Network_(ANMN)_Facility_-_Temperature_and_salinity_time-series.csv';

load ../../actions/varkey.mat;
load ../../actions/agency.mat;
load ../../actions/sitekey.mat;

outpath = '../../../../data-warehouse/csv/imos/amnmadcp/';
%'D:/csiem/data-warehouse/csv/imos/amnmadcp/';

if ~exist(outpath,'dir')
    mkdir(outpath);
end


thetable = readtable(thefile,"NumHeaderLines",22);

thesiteval = fieldnames(sitekey.imosamnm);
thevarval = fieldnames(varkey);
theagencyval = fieldnames(agency.imosprofile);

stations = thetable.site_code;
ustations = unique(stations);
sdate = thetable.TIME;
sdate = regexprep(sdate,'T',' ');
sdate = regexprep(sdate,'Z','');

mdates = datenum(sdate,'yyyy-mm-dd HH:MM:SS');

procvars = {...
    'TEMP';...
    'PSAL';...
    'PRES_REL'};


Depths = thetable.DEPTH;
Depths(isnan(Depths)) = 0;

for i = 1:length(procvars)

    for j = 1:length(ustations)

        foundstation = 0 ;
        for k = 1:length(thesiteval)
            if strcmpi(sitekey.imosamnm.(thesiteval{k}).ID,ustations{j}) == 1
                foundstation = k;
            end
        end
        
        foundvar = 0;
        
        for k = 1:length(theagencyval)
            if strcmpi(agency.imosprofile.(theagencyval{k}).Old,procvars{i}) == 1
                foundvar = k;
            end
        end

        if foundvar > 0
            
            
            
            
            thefoundvar = 0;
            for nn = 1:length(thevarval)
                if strcmpi(thevarval{nn},agency.imosprofile.(theagencyval{foundvar}).ID) == 1
                    thefoundvar = nn;
                end
            end


            
            sss = find(strcmpi(stations,ustations{j}) == 1);
            
            thedata_raw = thetable.(procvars{i})(sss) * agency.imosprofile.(theagencyval{foundvar}).Conv;
            ttt = find(~isnan(thedata_raw) == 1);
            thedata = thedata_raw(ttt);
            
            if ~isempty(thedata)
            
            thedepth = Depths(sss(ttt));
            thedate = mdates(sss(ttt));
            QC = 'N';
            
            
            
            
            filevar = regexprep(varkey.(thevarval{thefoundvar}).Name,' ','_');
            filevar = regexprep(filevar,'+','_');
            filename = [outpath,sitekey.imosamnm.(thesiteval{foundstation}).AED,'_',filevar,'_2020_DATA.csv'];
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
            fprintf(fid,'Program,amnmadcp\n');
            fprintf(fid,'Project,amnmadcp\n');
            fprintf(fid,'Tag,IMOS-ANMN-ADCP\n');
            fprintf(fid,'Data File Name,%s\n',regexprep(filename,outpath,''));
            fprintf(fid,'Location,%s\n',['data-warehouse/csv/imos/',lower('amnmadcp')]);
            
            
            fprintf(fid,'Station Status,Inactive\n');
            fprintf(fid,'Lat,%6.9f\n',sitekey.imosamnm.(thesiteval{foundstation}).Lat);
            fprintf(fid,'Long,%6.9f\n',sitekey.imosamnm.(thesiteval{foundstation}).Lon);
            fprintf(fid,'Time Zone,GMT +8\n');
            fprintf(fid,'Vertical Datum,mAHD\n');
            fprintf(fid,'National Station ID,%s\n',[sitekey.imosamnm.(thesiteval{foundstation}).ID,'_PROFILE']);
            fprintf(fid,'Site Description,%s\n',sitekey.imosamnm.(thesiteval{foundstation}).Description);
            fprintf(fid,'Deployment,%s\n','Fixed');
            fprintf(fid,'Deployment Position,%s\n','m from Surface');
            fprintf(fid,'Vertical Reference,%s\n','Water Surface');
            fprintf(fid,'Site Mean Depth,%s\n','');

            fprintf(fid,'Bad or Unavailable Data Value,NaN\n');
            fprintf(fid,'Contact Email,\n');
            fprintf(fid,'Variable ID,%s\n',agency.imosprofile.(theagencyval{foundvar}).ID);
            
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

