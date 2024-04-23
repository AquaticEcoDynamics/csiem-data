function write_header(headerfile,lat,lon,ID,Desc,varID,Cat,varstring,wdate,sitedepth)
filename = regexprep(headerfile,'_HEADER','_DATA');

temp = split(filename,'\');
filename_short = temp{end};

fid = fopen(headerfile,'wt');
            fprintf(fid,'Agency Name,BMT\n');
            
            fprintf(fid,'Agency Code,BMT\n');
            fprintf(fid,'Program,SWAN\n');
            fprintf(fid,'Project,BMT-SWAN\n');
            fprintf(fid,'Tag,\n');

            %%
            fprintf(fid,'Data File Name,%s\n',filename_short);
            fprintf(fid,'Location,%s\n','N/A');
            %%
            
            fprintf(fid,'Station Status,\n');
            fprintf(fid,'Lat,%6.9f\n',lat);
            fprintf(fid,'Long,%6.9f\n',lon);
            fprintf(fid,'Time Zone,GMT +8\n');
            fprintf(fid,'Vertical Datum,mAHD\n');
            fprintf(fid,'National Station ID,%s\n',ID);

            %%
            fprintf(fid,'Site Description,%s\n',Desc);
            fprintf(fid,'Deployment,%s\n','Floating');         
            fprintf(fid,'Deployment Position,%s\n','0m below surface');% '0.0m above Seabed');
            fprintf(fid,'Vertical Reference,%s\n','m below surface');
            fprintf(fid,'Site Mean Depth,%4.4f\n',sitedepth);
            %%

            fprintf(fid,'Bad or Unavailable Data Value,NaN\n');
            fprintf(fid,'Contact Email,%s\n','Lachy Gill, uwa email:00114282@uwa.edu.au 05/04/2024');

            %%
            fprintf(fid,'Variable ID,%s\n',varID);
            %%
            
            fprintf(fid,'Data Category,%s\n',Cat);
            
            
            SD = mean(diff(wdate));
            
            fprintf(fid,'Sampling Rate (min),%4.4f\n',SD * (60*24));
            
            fprintf(fid,'Date,yyyy-mm-dd HH:MM:SS\n');
            fprintf(fid,'Depth,Decimal\n');
            
            
            fprintf(fid,'Variable,%s\n',varstring);
            fprintf(fid,'QC,String\n');
            
            fclose(fid);