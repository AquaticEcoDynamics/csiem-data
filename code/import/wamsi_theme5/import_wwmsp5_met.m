function import_wwmsp5_met

addpath(genpath('../../functions/'));

load ../../actions/agency.mat;
load ../../actions/varkey.mat;
load ../../actions/sitekey.mat;

run('../../actions/csiem_data_paths.m')
filename = [datapath,'data-lake/WAMSI/WWMSP5/WWMSP5_met/20220713_COL_CockburnCement_WSCR300_29784_Raw_(Prelim_Jul-Nov22)_BBEdit.csv'];


outdir = [datapath,'data-warehouse/csv/wamsi/wwmsp5/met/'];if ~exist(outdir,'dir'); mkdir(outdir); end

data = readtable(filename, 'ReadVariableNames', false, 'HeaderLines', 4);
%[~,headers] = xlsread(filename,'C2:ZZ2');
headers = readmatrix(filename,Range="C2:ZZ2",OutputType="string");

mdate = datenum(data.Var1);

agencyvars = fieldnames(agency.wwmsp5);

sitedetails = sitekey.wwmsp5.wwmsp5_CCL;

[UTMX,UTMY] = ll2utm(sitedetails.Lat,sitedetails.Lon);

for i = 1:length(headers)
    
    for k = 1:length(agencyvars)
        if strcmpi(agency.wwmsp5.(agencyvars{k}).Old,headers{i}) == 1
            foundvar = k;
        end
    end
    
    varname = varkey.(agency.wwmsp5.(agencyvars{foundvar}).ID).Name;
    varcode = agency.wwmsp5.(agencyvars{foundvar}).ID;
    varunits = varkey.(agency.wwmsp5.(agencyvars{foundvar}).ID).Unit;
    
    thedata = data.(['Var',num2str(i+2)]) * agency.wwmsp5.(agencyvars{foundvar}).Conv;
    
    [u_mdate,int] = unique(mdate);
    u_thedata = thedata(int);
    u_thedepths(1:length(u_thedata),1) = 2;
    
    hourly = [min(u_mdate):1/24:max(u_mdate)];
    
    thedata_hourly  = interp1(u_mdate,u_thedata,hourly);
    theheight_hourly(1:length(thedata_hourly),1) = 2;
    
    deployment = 'Fixed';
    dPos = '2.0m above Seabed';
    Ref = 'm above Seabed';
    SMD = [];
    theheader = 'Height';
    
    
    
    filename = [outdir,sitedetails.AED,'_',varkey.(agency.wwmsp5.(agencyvars{foundvar}).ID).Name,'_DATA.csv'];
    filename = regexprep(filename,' ','_');
    headername = regexprep(filename,'_DATA.csv','_HEADER.csv');
    
    fid = fopen(filename,'wt');
    fprintf(fid,'Date,Height,Data,QC\n');
    for nn = 1:length(u_mdate)
        fprintf(fid,'%s,%4.4f,%4.4f,N\n',datestr(u_mdate(nn),'yyyy-mm-dd HH:MM:SS'),u_thedepths(nn),u_thedata(nn));
    end
    fclose(fid);
    
    fid = fopen(headername,'wt');
    fprintf(fid,'Agency Name,Western Australian Marine Science Institution\n');
    fprintf(fid,'Agency Code,WAMSI\n');
    fprintf(fid,'Program,WWMSP5\n');
    fprintf(fid,'Project,WWMSP5_met\n');
    fprintf(fid,'Tag,WAMSI-WWMSP5-MET\n');
    fprintf(fid,'Data File Name,%s\n','20220713_COL_CockburnCement_WSCR300_29784_Raw_(Prelim_Jul-Nov22).csv');
    fprintf(fid,'Location,%s\n',outdir);
    
    
    fprintf(fid,'Station Status,Static\n');
    fprintf(fid,'Lat,%6.9f\n',sitedetails.Lat);
    fprintf(fid,'Long,%6.9f\n',sitedetails.Lon);
    fprintf(fid,'Time Zone,GMT +8\n');
    fprintf(fid,'Vertical Datum,mAHD\n');
    fprintf(fid,'National Station ID,%s\n',sitedetails.ID);
    fprintf(fid,'Site Description,%s\n',sitedetails.Description);
    fprintf(fid,'Deployment,%s\n',deployment);
    fprintf(fid,'Deployment Position,%s\n',dPos);
    fprintf(fid,'Vertical Reference,%s\n',Ref);
    fprintf(fid,'Site Mean Depth,%s\n',[]);
    
    fprintf(fid,'Bad or Unavailable Data Value,NaN\n');
    fprintf(fid,'Contact Email,%s\n','Charitha Pattiaratchi <chari.pattiaratchi@uwa.edu.au>');
    fprintf(fid,'Variable ID,%s\n',agency.wwmsp5.(agencyvars{foundvar}).ID);
    
    fprintf(fid,'Data Category,%s\n',varkey.(agency.wwmsp5.(agencyvars{foundvar}).ID).Category);
    
    
    SD = mean(diff(hourly));
    
    fprintf(fid,'Sampling Rate (min),%4.4f\n',SD * (60*24));
    
    fprintf(fid,'Date,yyyy-mm-dd HH:MM:SS\n');
    fprintf(fid,'Depth,Decimal\n');
    
    thevar = [varname,' (',varunits,')'];
    
    fprintf(fid,'Variable,%s\n',thevar);
    fprintf(fid,'QC,String\n');
    
    fclose(fid);
    
    
    %plot_datafile(filename);
end




