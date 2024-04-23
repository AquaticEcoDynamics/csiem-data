function import_bar_tidal_data

main_dir = '../../../../data-lake/DOT/tide/PTBAR02/';
%'D:\csiem\data-lake\DOT\tide/PTBAR02/';

outdir = '../../../../data-warehouse/csv/dot/tide/';
%'D:\csiem/data-warehouse/csv/dot/tide/';

if ~exist(outdir,'dir')
    mkdir(outdir);
end

load ../../actions/varkey.mat;
load ../../actions/agency.mat;
load ../../actions/sitekey.mat;

varnamefull = [varkey.var00180.Name,' (',varkey.var00180.Unit,')'];


dirlist = dir(main_dir);

textformat = [repmat('%s ',1,2)];

aheight = [];
adate = [];

bheight = [];
bdate = [];

for i = [3:length(dirlist)]
    
    new_dir = [main_dir,dirlist(i).name,'/'];
    
    filelist = dir(new_dir);
    
    for j = 3:length(filelist)
        
        disp(filelist(j).name);
        
        fid = fopen([new_dir,filelist(j).name],'rt');
        
        
        datacell = textscan(fid,textformat,'Headerlines',2,'Delimiter',',','EndofLine','/');
        
        height = str2double(datacell{1});
        
        
        sDate = datacell{2};
        
        switch filelist(j).name(16)
            case 'a'
                disp('Sensor A');
                
                aheight = [aheight;height(1:length(sDate),1)./ 100];
                adate = [adate;datenum(sDate,'yyyymmdd.HHMM')];
            case '.'
                disp('No Backup');
                aheight = [aheight;height(1:length(sDate),1)./ 100];
                adate = [adate;datenum(sDate,'yyyymmdd.HHMM')];
                
            otherwise
                disp('Sensor B');
                bheight = [bheight;height(1:length(sDate),1)./ 100];
                bdate = [bdate;datenum(sDate,'yyyymmdd.HHMM')];
                %remander = str2double(sDate) - floor(str2double(sDate));
                
        end
        
        
        
    end
    
end

aheight(aheight < -50) = -9999;
bheight(bheight < -50) = -9999;


sss = find(aheight < -500);

for i = 1:length(sss)
    ttt = find(bdate == adate(sss(i)));
    if ~isempty(sss)
        if bheight(ttt) > -500
            disp('filled');
            aheight(sss(i)) = bheight(ttt);
        end
    end
end

deployment = 'Fixed';
dPos = 'm from Datum';
Ref = 'm from Datum';
SMD = [];
theheader = 'Depth';

depth = [];
QC = 'n';
filename = '../../../../data-warehouse/csv/dot/tide/PTBAR02_Tidal_Height_DATA.csv';
                           %'D:\csiem/data-warehouse/csv/dot/tide/PTBAR02_Tidal_Height_DATA.csv';

fid = fopen(filename,'wt');
fprintf(fid,'Date,Height,Data,QC\n');

ggg = find(adate >= datenum(1990,01,01,00,00,00));

for i = 1:length(ggg)
    fprintf(fid,'%s,%s,%4.4f,%s\n',datestr(adate(ggg(i)),'yyyy-mm-dd HH:MM:SS'),depth,aheight(ggg(i)),QC);
end
fclose(fid);

headerfile = regexprep(filename,'_DATA','_HEADER');

fid = fopen(headerfile,'wt');
fprintf(fid,'Agency Name,Department of Transport\n');
fprintf(fid,'Agency Code,DOT\n');
fprintf(fid,'Program,Coastal Data\n');
fprintf(fid,'Project,Tide\n');
fprintf(fid,'Tag,DOT-TIDE\n');
fprintf(fid,'Data File Name,PTBAR02_Tidal_Height.csv\n');
fprintf(fid,'Location,data-warehouse/csv/dot/tide\n');

if max(adate) >= datenum(2019,01,01)
    fprintf(fid,'Station Status,Active\n');
else
    fprintf(fid,'Station Status,Inactive\n');
end
fprintf(fid,'Lat,-31.959681\n');
fprintf(fid,'Long,115.857261\n');
fprintf(fid,'Time Zone,GMT +8\n');
fprintf(fid,'Vertical Datum,LWM Fremantle which is 2.234m below Benchmark MWB 1484\n');
fprintf(fid,'National Station ID,PTBAR02\n');
fprintf(fid,'Site Description,Barrack Street 02 Tide Station\n');
                            fprintf(fid,'Deployment,%s\n',deployment);
                            fprintf(fid,'Deployment Position,%s\n',dPos);
                            fprintf(fid,'Vertical Reference,%s\n',Ref);
                            fprintf(fid,'Site Mean Depth,%s\n',SMD);
fprintf(fid,'Bad or Unavailable Data Value,-9999\n');
fprintf(fid,'Contact Email,tides@transport.wa.gov.au\n');
fprintf(fid,'Variable ID,var00180\n');
fprintf(fid,'Data Category,%s\n',varkey.var00180.Category);
SD = mean(diff(adate));

fprintf(fid,'Sampling Rate (min),%4.4f\n',SD * (60*24));

fprintf(fid,'Date,yyyy-mm-dd HH:MM:SS\n');
fprintf(fid,'Depth,Decimal\n');

%thevar = [varName{sss},' (',varUnit{sss},')'];

fprintf(fid,'Variable,%s\n',varnamefull);
fprintf(fid,'QC,String\n');

fclose(fid);
%plot_datafile(filename);

%




