function import_dpird_crab_data

addpath(genpath('../../functions/'));

load ../../../code/actions/varkey.mat;

load ../../../code/actions/sitekey.mat;

filePath = '../../../../data-lake/DPIRD/crab/Temperature/CS temp loggers_2007_to_2015 (1).xlsx';
%'D:\csiem\data-lake\DPIRD\crab\Temperature\CS temp loggers_2007_to_2015 (1).xlsx'
data = readtable(filePath);

mdate = datenum(data.date_local) + data.time_local;

sites = unique(data.site_code);

outdir = '../../../../data-warehouse/csv/dpird/crp/';mkdir(outdir);
%'D:\csiem\data-warehouse\csv\dpird\crp\';
catsites = fieldnames(sitekey.dpird);

for i = 1:length(sites)
    
    for j = 1:length(catsites)
        
        if strcmpi(sitekey.dpird.(catsites{j}).ID,sites{i}) == 1
            
            filename = [outdir,'DPIRD_',sitekey.dpird.(catsites{j}).ID,'_TEMPERATURE_Fixed_DATA.csv'];
            
            sss = find(strcmpi(data.site_code,sites{i}) == 1);
            
            thedata = data.temp_deg_C(sss);
            thedates = mdate(sss);
            
            fid = fopen(filename,'wt');
            fprintf(fid,'Date,Depth,Data,QC\n');
            for k = 1:length(thedates)
                fprintf(fid,'%s,1,%4.4f,N\n',datestr(thedates(k),'yyyy-mm-dd HH:MM:SS'),thedata(k));
            end
            fclose(fid);
            headerfile = regexprep(filename,'_DATA','_HEADER');
            
            fid = fopen(headerfile,'wt');
        fprintf(fid,'Agency Name,Department of Primary Industry and Regional Development\n');
        fprintf(fid,'Agency Code,DPIRD\n');
        fprintf(fid,'Program,Crab Research Program\n');
        fprintf(fid,'Project,CRP\n');
        fprintf(fid,'Tag,DPIRD-CRP\n');
        fprintf(fid,'Data File Name,%s\n',regexprep(filename,outdir,''));
        fprintf(fid,'Location,%s\n',['data-warehouse/csv/dpird/crp']);


        fprintf(fid,'Station Status,Inactive\n');
        fprintf(fid,'Lat,%6.9f\n',sitekey.dpird.(catsites{j}).Lat);
        fprintf(fid,'Long,%6.9f\n',sitekey.dpird.(catsites{j}).Lon);
        fprintf(fid,'Time Zone,GMT +8\n');
        fprintf(fid,'Vertical Datum,mAHD\n');
        fprintf(fid,'National Station ID,%s\n',sitekey.dpird.(catsites{j}).ID);
        fprintf(fid,'Site Description,%s\n',sitekey.dpird.(catsites{j}).Description);
        fprintf(fid,'Deployment,%s\n','Fixed');
        fprintf(fid,'Deployment Position,%s\n','1m from Surface');
        fprintf(fid,'Vertical Reference,%s\n','m from Surface');
        fprintf(fid,'Site Mean Depth,%s\n',[]);
        fprintf(fid,'Bad or Unavailable Data Value,NaN\n');
        fprintf(fid,'Contact Email,\n');
        fprintf(fid,'Variable ID,%s\n','var00007');

        fprintf(fid,'Data Category,%s\n',varkey.var00007.Category);


        SD = mean(diff(thedates));

        fprintf(fid,'Sampling Rate (min),%4.4f\n',SD * (60*24));

        fprintf(fid,'Date,yyyy-mm-dd HH:MM:SS\n');
        fprintf(fid,'Depth,Decimal\n');

        %thevar = [varkey.(varID).Name,' (',varkey.(varID).Unit,')'];

        fprintf(fid,'Variable,%s\n','Temperature (C)');
        fprintf(fid,'QC,String\n');

        fclose(fid);

        %plot_datafile(filename);
            
        end
    end
end

    
    
    

