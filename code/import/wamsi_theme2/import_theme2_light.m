function import_theme2_light

addpath(genpath('../../functions/'));


load ../../../code/actions/sitekey.mat;
load ../../../code/actions/varkey.mat;
load ../../../code/actions/agency.mat;


filename = '../../../../data-lake/WAMSI/wwmsp2.2_light/Light Data/Light data Mastersheet_July2023-2.xlsx';
             %'D:\csiem\data-lake\WAMSI\wwmsp2.2_light\Light Data\Light data Mastersheet_July2023-2.xlsx';

outdir = '../../../../data-warehouse/csv/wamsi/wwmsp2.2_light/';mkdir(outdir);
%'D:\csiem\data-warehouse\csv\wamsi\wwmsp2.2_light\';


data = readtable(filename,'sheet','all data');

mdate = datenum(data.Date) + data.Time;

mdepth = data.Depth_m_;

msites = data.Treatment;
msites = regexprep(msites,'Ambient','wwmsp2_KwinanaShelf');
msites = regexprep(msites,'Shading','wwmsp2_KwinanaShelf_shade');
usites = unique(msites);

[~,headers] = xlsread(filename,'all data','M1:AJ1');
[adata,~] = xlsread(filename,'all data','M2:AJ1000000');

tag = 'WWMSP-2.2';

for i = 1:length(headers)
    
    for j = 1:length(usites)
        
        sss = find(strcmpi(msites,usites{j}) == 1);
        
        
        varnum = [];
        thevars = fieldnames(agency.theme2light);
        for m = 1:length(thevars)
            if strcmpi(agency.theme2light.(thevars{m}).Old,headers{i}) == 1
                varnum = m;
            end
        end
        
        
        
        varID = agency.theme2light.(thevars{varnum}).ID;
        
        if strcmpi(varID,'Ignore') == 0
            
            varname = varkey.(varID).Name;
            varstring = [varname,' (',varkey.(varID).Unit,')'];
            
            sitenum = [];
            thesites = fieldnames(sitekey.wwmsp2);
            for m = 1:length(thesites)
                if strcmpi(sitekey.wwmsp2.(thesites{m}).AED,usites{j}) == 1
                    sitenum = m;
                end
            end
            lat = sitekey.wwmsp2.(thesites{sitenum}).Lat;
            lon = sitekey.wwmsp2.(thesites{sitenum}).Lon;
            wdata = adata(sss,i);
            wdate = mdate(sss,1);
            wdepth = mdepth(sss,1);
            

            fvarname = regexprep(varname,'µ','u');
            fvarname = regexprep(fvarname,'/','\');    

            fvarname
            
            
            filename = [outdir,sitekey.wwmsp2.(thesites{sitenum}).AED,'_',regexprep(fvarname,' ','_'),'_DATA.csv'];
            
            
            fid = fopen(filename,'wt');
            fprintf(fid,'Date,Depth,Data,QC\n');
            for kk = 1:length(wdate)
                fprintf(fid,'%s,%4.4f,%4.4f,N\n',datestr(wdate(kk),'yyyy-mm-dd HH:MM:SS'),wdepth(kk),wdata(kk));
            end
            fclose(fid);
            headerfile = regexprep(filename,'_DATA','_HEADER');
            
            fid = fopen(headerfile,'wt');
            fprintf(fid,'Agency Name,Western Australian Marine Science Institution\n');
            
            fprintf(fid,'Agency Code,WAMSI\n');
            fprintf(fid,'Program,WAMSI Westport Marine Science Program\n');
            fprintf(fid,'Project,WWMSP2.2\n');
            fprintf(fid,'Tag,WWMSP2.2-Light\n');
            fprintf(fid,'Data File Name,%s\n',filename);
            fprintf(fid,'Location,%s\n',['data-warehouse/csv/wamsi/wwmsp2.2_light']);
            
            
            fprintf(fid,'Station Status,Static\n');
            fprintf(fid,'Lat,%6.9f\n',lat);
            fprintf(fid,'Long,%6.9f\n',lon);
            fprintf(fid,'Time Zone,GMT +8\n');
            fprintf(fid,'Vertical Datum,mAHD\n');
            fprintf(fid,'National Station ID,%s\n',sitekey.wwmsp2.(thesites{sitenum}).ID);
            fprintf(fid,'Site Description,%s\n',sitekey.wwmsp2.(thesites{sitenum}).Description);
            fprintf(fid,'Deployment,%s\n','Fixed');
            fprintf(fid,'Deployment Position,%s\n','0m above Seabed');
            fprintf(fid,'Vertical Reference,%s\n','m above Seabed');
            fprintf(fid,'Site Mean Depth,%s\n','4.5');
            fprintf(fid,'Bad or Unavailable Data Value,NaN\n');
            fprintf(fid,'Contact Email,%s\n','');
            fprintf(fid,'Variable ID,%s\n',varID);
            
            fprintf(fid,'Data Category,%s\n',varkey.(varID).Category);
            
            
            SD = mean(diff(wdate));
            
            fprintf(fid,'Sampling Rate (min),%4.4f\n',SD * (60*24));
            
            fprintf(fid,'Date,yyyy-mm-dd HH:MM:SS\n');
            fprintf(fid,'Depth,Decimal\n');
            
            
            fprintf(fid,'Variable,%s\n',varstring);
            fprintf(fid,'QC,String\n');
            
            fclose(fid);
            %plot_datafile(filename);
        end
    end
end

