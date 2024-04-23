function import_theme2_seagrass%   clear all; close all;

addpath(genpath('../../functions/'));


load ../../../code/actions/sitekey.mat;
load ../../../code/actions/varkey.mat;
load ../../../code/actions/agency.mat;

sgsites = fieldnames(sitekey.wwmsp2_seagrass);


filename = '../../../../data-lake/WAMSI/wwmsp2.2_seagrass/Driver of Seagrass Condition_Regional for Hipsey_4lake.csv';
             %'D:\csiem\data-lake\WAMSI\wwmsp2.2_seagrass\Driver of Seagrass Condition_Regional for Hipsey_4lake.csv';

outdir = '../../../../data-warehouse/csv/wamsi/wwmsp2.2_seagrass/';mkdir(outdir);
           %'D:\csiem\data-warehouse\csv\wamsi\wwmsp2.2_seagrass\';mkdir(outdir);


data = readtable(filename);

counts = data.rawcounts;


% var00324	Posidonia Sinuosa Count
% var00325	Posidonia Sinuosa Density
% var00326	Posidonia Sinuosa Above Ground Biomass
% var00327	Posidonia Sinuosa Below Ground Biomass
% var00351	Posidonia Sinuosa Total Biomass




sites = data.Site;

[usites,ind]  = unique(sites);
sitedepths = data.depth(ind);

mdate = datenum(data.DateSeagrassSampling);

for i = 1:length(usites)
    
    sss = find(strcmpi(sites,usites{i}) == 1);
    
    foundsite = [];
    for kk = 1:length(sgsites)
        if strcmpi(sitekey.wwmsp2_seagrass.(sgsites{kk}).Description,usites{i}) == 1
            foundsite = kk;
        end
    end
    
    AEDSite = sitekey.wwmsp2_seagrass.(sgsites{foundsite}).AED;
    Lat = sitekey.wwmsp2_seagrass.(sgsites{foundsite}).Lat;
    Lon = sitekey.wwmsp2_seagrass.(sgsites{foundsite}).Lon;
    ID = sitekey.wwmsp2_seagrass.(sgsites{foundsite}).ID;
    Desc = sitekey.wwmsp2_seagrass.(sgsites{foundsite}).Description;
    
    
    alldate = mdate(sss);
    alldata = data.rawcounts(sss);
    udates = unique(alldate);
    
    
    counts = [];
    for l = 1:length(udates)
        tt = find(alldate == udates(l));
        
        counts(l) = sum(alldata(tt)) / length(tt);

    end
        counts = counts;
        density = counts * 25;
        DW = 10.^(0.885.*log10(density));  % converting shoot density to dry weight, g DW/m2;

        MAC_A = DW.*0.5 .* 1000/12;  % converting dry weight to above ground biomass, mmol C/m2;
        MAC_B = 0.8339 .* MAC_A;     % calculating below ground biomass from above ground biomass, mmol C/m2;

        MAC_total = MAC_A + MAC_B;   % calculating total biomass
        
        
    
    
    outdate = udates;
    outdepth = [];
    outdepth(1:length(udates),1) = 0.0;
    
    
    
    
    firstfile = [outdir,AEDSite,'_Posidonia_Sinuosa_Count','_DATA.csv'];
    headerfile = regexprep(firstfile,'_DATA','_HEADER');
    outdata = counts;
    varID = 'var00324';
    Cat = varkey.(varID).Category;
    varstring  =[varkey.(varID).Name,' (',varkey.(varID).Unit,')'];
    
    fid = fopen(firstfile,'wt');
    fprintf(fid,'Date,Height,Data,QC\n');
    for k = 1:length(outdata)
        fprintf(fid,'%s,%4.4f,%4.2f,N\n',datestr(outdate(k),'yyyy-mm-dd HH:MM:SS'),outdepth(k),outdata(k));
    end
    fclose(fid);
    write_header(headerfile,Lat,Lon,ID,Desc,varID,Cat,varstring,outdate,sitedepths(i));
    
    
    %____________________________________________________________________________
    
    firstfile = [outdir,AEDSite,'_Posidonia_Sinuosa_Density','_DATA.csv'];
    headerfile = regexprep(firstfile,'_DATA','_HEADER');
    outdata = density;
    varID = 'var00325';
    Cat = varkey.(varID).Category;
    varstring  =[varkey.(varID).Name,' (',varkey.(varID).Unit,')'];
    
    fid = fopen(firstfile,'wt');
    fprintf(fid,'Date,Height,Data,QC\n');
    for k = 1:length(outdata)
        fprintf(fid,'%s,%4.4f,%4.2f,N\n',datestr(outdate(k),'yyyy-mm-dd HH:MM:SS'),outdepth(k),outdata(k));
    end
    fclose(fid);
    write_header(headerfile,Lat,Lon,ID,Desc,varID,Cat,varstring,outdate,sitedepths(i));  
    
    %____________________________________________________________________________
    
    firstfile = [outdir,AEDSite,'_Posidonia_Sinuosa_Density','_DATA.csv'];
    headerfile = regexprep(firstfile,'_DATA','_HEADER');
    outdata = DW;
    varID = 'var00352';
    Cat = varkey.(varID).Category;
    varstring  =[varkey.(varID).Name,' (',varkey.(varID).Unit,')'];
    
    fid = fopen(firstfile,'wt');
    fprintf(fid,'Date,Height,Data,QC\n');
    for k = 1:length(outdata)
        fprintf(fid,'%s,%4.4f,%4.2f,N\n',datestr(outdate(k),'yyyy-mm-dd HH:MM:SS'),outdepth(k),outdata(k));
    end
    fclose(fid);
    write_header(headerfile,Lat,Lon,ID,Desc,varID,Cat,varstring,outdate,sitedepths(i));  
    
    
    
    %____________________________________________________________________________
    
    firstfile = [outdir,AEDSite,'_Posidonia_Sinuosa_Above_Ground_Biomass','_DATA.csv'];
    headerfile = regexprep(firstfile,'_DATA','_HEADER');
    outdata = MAC_A;
    varID = 'var00326';
    Cat = varkey.(varID).Category;
    varstring  =[varkey.(varID).Name,' (',varkey.(varID).Unit,')'];
    
    fid = fopen(firstfile,'wt');
    fprintf(fid,'Date,Height,Data,QC\n');
    for k = 1:length(outdata)
        fprintf(fid,'%s,%4.4f,%4.2f,N\n',datestr(outdate(k),'yyyy-mm-dd HH:MM:SS'),outdepth(k),outdata(k));
    end
    fclose(fid);
    write_header(headerfile,Lat,Lon,ID,Desc,varID,Cat,varstring,outdate,sitedepths(i)); 
    
    %____________________________________________________________________________
    
    firstfile = [outdir,AEDSite,'_Posidonia_Sinuosa_Below_Ground_Biomass','_DATA.csv'];
    headerfile = regexprep(firstfile,'_DATA','_HEADER');
    outdata = MAC_B;
    varID = 'var00327';
    Cat = varkey.(varID).Category;
    varstring  =[varkey.(varID).Name,' (',varkey.(varID).Unit,')'];
    
    fid = fopen(firstfile,'wt');
    fprintf(fid,'Date,Height,Data,QC\n');
    for k = 1:length(outdata)
        fprintf(fid,'%s,%4.4f,%4.2f,N\n',datestr(outdate(k),'yyyy-mm-dd HH:MM:SS'),outdepth(k),outdata(k));
    end
    fclose(fid);
    write_header(headerfile,Lat,Lon,ID,Desc,varID,Cat,varstring,outdate,sitedepths(i));

        %____________________________________________________________________________
    
    firstfile = [outdir,AEDSite,'_Posidonia_Sinuosa_Total_Biomass','_DATA.csv'];
    headerfile = regexprep(firstfile,'_DATA','_HEADER');
    outdata = MAC_total;
    varID = 'var00351';
    Cat = varkey.(varID).Category;
    varstring  =[varkey.(varID).Name,' (',varkey.(varID).Unit,')'];
    
    fid = fopen(firstfile,'wt');
    fprintf(fid,'Date,Height,Data,QC\n');
    for k = 1:length(outdata)
        fprintf(fid,'%s,%4.4f,%4.2f,N\n',datestr(outdate(k),'yyyy-mm-dd HH:MM:SS'),outdepth(k),outdata(k));
    end
    fclose(fid);
    write_header(headerfile,Lat,Lon,ID,Desc,varID,Cat,varstring,outdate,sitedepths(i));
    
end
    
