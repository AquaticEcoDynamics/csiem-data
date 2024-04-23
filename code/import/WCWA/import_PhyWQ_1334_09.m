function import_PhyWQ_1334_09

addpath(genpath('../../functions/'));


load ../../../code/actions/sitekey.mat;
load ../../../code/actions/varkey.mat;

outdir = '/Projects2/csiem-data-hub/data-warehouse/csv/wcwa/wcwa-psdp-bmt349/';mkdir(outdir);
%                         'D:\csiem\data-warehouse\csv\wcwa\wcwa-psdp-bmt349\';mkdir(outdir);

datafile = '../../../../data-lake/WCWA/Working/Working/2018/BMT 349 Cockburn Sound Metocean Summary Report/Water Quality/1334_09_PhysicalWQ.xlsx';
%'             D:\csiem\data-lake\WCWA\Working\Working\2018\BMT 349 Cockburn Sound Metocean Summary Report\Water Quality\1334_09_PhysicalWQ.xlsx';


siteA = sitekey.wc.wc_metocean_A;
siteB = sitekey.wc.wc_metocean_B;
siteC = sitekey.wc.wc_metocean_C;
siteD = sitekey.wc.wc_metocean_D;

siteA.Depth = 10;
siteB.Depth = 18;
siteC.Depth = 18;
siteD.Depth = 20;
%__________________________________________________________
% Temperature Data

tempdata = readtable(datafile,'Range','A1:L12313','Sheet','Temperature ');
mdate = datenum(tempdata.DateTime);
varID = 'var00007';

%__________________________________________________________
filecode = 'siteA_surface_temp';

sss = find(~isnan(tempdata.SiteASurface) == 1);
wdate = mdate(sss);
wdata = tempdata.SiteASurface(sss);
wdepth(1:length(sss),1) = siteA.Depth - 1.3;
write_psdp_data(outdir,siteA,varID,varkey,wdate,wdata,wdepth,filecode);clear wdepth;

%__________________________________________________________
filecode = 'siteA_bot_temp';

sss = find(~isnan(tempdata.SiteASeabed) == 1);
wdate = mdate(sss);
wdata = tempdata.SiteASeabed(sss);
wdepth(1:length(sss),1) = 0.5;%siteA.Depth - 1.3;
write_psdp_data(outdir,siteA,varID,varkey,wdate,wdata,wdepth,filecode);clear wdepth;

%__________________________________________________________
filecode = 'siteB_surface_temp';

sss = find(~isnan(tempdata.SiteBSurface) == 1);
wdate = mdate(sss);
wdata = tempdata.SiteBSurface(sss);
wdepth(1:length(sss),1) = siteB.Depth - 1.3;
write_psdp_data(outdir,siteB,varID,varkey,wdate,wdata,wdepth,filecode);clear wdepth;

%__________________________________________________________
filecode = 'siteB_mid_temp';

sss = find(~isnan(tempdata.SiteBMidWater__9_2M_) == 1);
wdate = mdate(sss);
wdata = tempdata.SiteBMidWater__9_2M_(sss);
wdepth(1:length(sss),1) = siteB.Depth / 2;
write_psdp_data(outdir,siteB,varID,varkey,wdate,wdata,wdepth,filecode);clear wdepth;

%__________________________________________________________
filecode = 'siteB_bot_temp';

sss = find(~isnan(tempdata.SiteBSeabed) == 1);
wdate = mdate(sss);
wdata = tempdata.SiteBSeabed(sss);
wdepth(1:length(sss),1) = 0.5;
write_psdp_data(outdir,siteB,varID,varkey,wdate,wdata,wdepth,filecode);clear wdepth;

%__________________________________________________________
filecode = 'siteC_surface_temp';

sss = find(~isnan(tempdata.SiteCSurface) == 1);
wdate = mdate(sss);
wdata = tempdata.SiteCSurface(sss);
wdepth(1:length(sss),1) = siteC.Depth - 1.3;
write_psdp_data(outdir,siteC,varID,varkey,wdate,wdata,wdepth,filecode);clear wdepth;

%__________________________________________________________
filecode = 'siteC_mid_temp';

sss = find(~isnan(tempdata.SiteCSurface) == 1);
wdate = mdate(sss);
wdata = tempdata.SiteCSurface(sss);
wdepth(1:length(sss),1) = siteC.Depth / 2;
write_psdp_data(outdir,siteC,varID,varkey,wdate,wdata,wdepth,filecode);clear wdepth;

%__________________________________________________________
filecode = 'siteC_bot_temp';

sss = find(~isnan(tempdata.SiteCSeabed) == 1);
wdate = mdate(sss);
wdata = tempdata.SiteCSeabed(sss);
wdepth(1:length(sss),1) = 0.5;
write_psdp_data(outdir,siteC,varID,varkey,wdate,wdata,wdepth,filecode);clear wdepth;
%__________________________________________________________
filecode = 'siteD_surface_temp';

sss = find(~isnan(tempdata.SiteDSurface) == 1);
wdate = mdate(sss);
wdata = tempdata.SiteDSurface(sss);
wdepth(1:length(sss),1) = siteD.Depth - 1.3;
write_psdp_data(outdir,siteD,varID,varkey,wdate,wdata,wdepth,filecode);clear wdepth;

%__________________________________________________________
filecode = 'siteD_mid_temp';

sss = find(~isnan(tempdata.SiteDMidWater) == 1);
wdate = mdate(sss);
wdata = tempdata.SiteDMidWater(sss);
wdepth(1:length(sss),1) = siteD.Depth / 2;
write_psdp_data(outdir,siteD,varID,varkey,wdate,wdata,wdepth,filecode);clear wdepth;

%__________________________________________________________
filecode = 'siteD_bot_temp';

sss = find(~isnan(tempdata.SiteDSeabed) == 1);
wdate = mdate(sss);
wdata = tempdata.SiteDSeabed(sss);
wdepth(1:length(sss),1) = 0.5;
write_psdp_data(outdir,siteD,varID,varkey,wdate,wdata,wdepth,filecode);clear wdepth;
%__________________________________________________________


%__________________________________________________________
% Salinity Data

tempdata = readtable(datafile,'Range','A1:L12312','Sheet','Salinity');
mdate = datenum(tempdata.DateTime);
varID = 'var00006';

%__________________________________________________________
filecode = 'siteA_surface_sal';

sss = find(~isnan(tempdata.SiteASeabed) == 1);
wdate = mdate(sss);
wdata = tempdata.SiteASurface(sss);
wdepth(1:length(sss),1) = siteA.Depth - 1.3;
write_psdp_data(outdir,siteA,varID,varkey,wdate,wdata,wdepth,filecode);clear wdepth;

%__________________________________________________________
filecode = 'siteA_bot_sal';

sss = find(~isnan(tempdata.SiteASeabed) == 1);
wdate = mdate(sss);
wdata = tempdata.SiteASeabed(sss);
wdepth(1:length(sss),1) = 0.5;%siteA.Depth - 1.3;
write_psdp_data(outdir,siteA,varID,varkey,wdate,wdata,wdepth,filecode);clear wdepth;

%__________________________________________________________
filecode = 'siteB_surface_sal';

sss = find(~isnan(tempdata.SiteBSurface) == 1);
wdate = mdate(sss);
wdata = tempdata.SiteBSurface(sss);
wdepth(1:length(sss),1) = siteB.Depth - 1.3;
write_psdp_data(outdir,siteB,varID,varkey,wdate,wdata,wdepth,filecode);clear wdepth;

%__________________________________________________________
filecode = 'siteB_mid_sal';

sss = find(~isnan(tempdata.SiteBMidWater) == 1);
wdate = mdate(sss);
wdata = tempdata.SiteBMidWater(sss);
wdepth(1:length(sss),1) = siteB.Depth / 2;
write_psdp_data(outdir,siteB,varID,varkey,wdate,wdata,wdepth,filecode);clear wdepth;

%__________________________________________________________
filecode = 'siteB_bot_sal';

sss = find(~isnan(tempdata.SiteBSeabed) == 1);
wdate = mdate(sss);
wdata = tempdata.SiteBSeabed(sss);
wdepth(1:length(sss),1) = 0.5;
write_psdp_data(outdir,siteB,varID,varkey,wdate,wdata,wdepth,filecode);clear wdepth;

%__________________________________________________________
filecode = 'siteC_surface_sal';

sss = find(~isnan(tempdata.SiteCSurface) == 1);
wdate = mdate(sss);
wdata = tempdata.SiteCSurface(sss);
wdepth(1:length(sss),1) = siteC.Depth - 1.3;
write_psdp_data(outdir,siteC,varID,varkey,wdate,wdata,wdepth,filecode);clear wdepth;

%__________________________________________________________
filecode = 'siteC_mid_sal';

sss = find(~isnan(tempdata.SiteCSurface) == 1);
wdate = mdate(sss);
wdata = tempdata.SiteCSurface(sss);
wdepth(1:length(sss),1) = siteC.Depth / 2;
write_psdp_data(outdir,siteC,varID,varkey,wdate,wdata,wdepth,filecode);clear wdepth;

%__________________________________________________________
filecode = 'siteC_bot_sal';

sss = find(~isnan(tempdata.SiteCSeabed) == 1);
wdate = mdate(sss);
wdata = tempdata.SiteCSeabed(sss);
wdepth(1:length(sss),1) = 0.5;
write_psdp_data(outdir,siteC,varID,varkey,wdate,wdata,wdepth,filecode);clear wdepth;
%__________________________________________________________
filecode = 'siteD_surface_sal';

sss = find(~isnan(tempdata.SiteDSurface) == 1);
wdate = mdate(sss);
wdata = tempdata.SiteDSurface(sss);
wdepth(1:length(sss),1) = siteD.Depth - 1.3;
write_psdp_data(outdir,siteD,varID,varkey,wdate,wdata,wdepth,filecode);clear wdepth;

%__________________________________________________________
filecode = 'siteD_mid_sal';

sss = find(~isnan(tempdata.SiteDMidWater) == 1);
wdate = mdate(sss);
wdata = tempdata.SiteDMidWater(sss);
wdepth(1:length(sss),1) = siteD.Depth / 2;
write_psdp_data(outdir,siteD,varID,varkey,wdate,wdata,wdepth,filecode);clear wdepth;

%__________________________________________________________
filecode = 'siteD_bot_sal';

sss = find(~isnan(tempdata.SiteDSeabed) == 1);
wdate = mdate(sss);
wdata = tempdata.SiteDSeabed(sss);
wdepth(1:length(sss),1) = 0.5;
write_psdp_data(outdir,siteD,varID,varkey,wdate,wdata,wdepth,filecode);clear wdepth;
%__________________________________________________________

%__________________________________________________________
% DO Data Import 1

tempdata = readtable(datafile,'Range','A1:E37630','Sheet','DO');
mdate = datenum(tempdata.DateTime);
varID = 'var00085';


%__________________________________________________________
filecode = 'siteA_bot_do';

sss = find(~isnan(tempdata.SiteASeabedPostCal) == 1);
wdate = mdate(sss);
wdata = tempdata.SiteASeabedPostCal(sss);
wdepth(1:length(sss),1) = 0.5;%siteA.Depth - 1.3;
write_psdp_data(outdir,siteA,varID,varkey,wdate,wdata,wdepth,filecode);clear wdepth;



%__________________________________________________________
filecode = 'siteB_bot_do';

sss = find(~isnan(tempdata.SiteBSeabed2) == 1);
wdate = mdate(sss);
wdata = tempdata.SiteBSeabed2(sss);
wdepth(1:length(sss),1) = 0.5;
write_psdp_data(outdir,siteB,varID,varkey,wdate,wdata,wdepth,filecode);clear wdepth;


%__________________________________________________________
filecode = 'siteC_bot_do';

sss = find(~isnan(tempdata.SiteCSeabedPostcal) == 1);
wdate = mdate(sss);
wdata = tempdata.SiteCSeabedPostcal(sss);
wdepth(1:length(sss),1) = 0.5;
write_psdp_data(outdir,siteC,varID,varkey,wdate,wdata,wdepth,filecode);clear wdepth;

%__________________________________________________________
filecode = 'siteD_bot_do';

sss = find(~isnan(tempdata.SiteDSeabed2PostCal) == 1);
wdate = mdate(sss);
wdata = tempdata.SiteDSeabed2PostCal(sss);
wdepth(1:length(sss),1) = 0.5;
write_psdp_data(outdir,siteD,varID,varkey,wdate,wdata,wdepth,filecode);clear wdepth;
%__________________________________________________________

%__________________________________________________________
% DO Data Import 2

tempdata = readtable(datafile,'Range','H1:J6157','Sheet','DO');
mdate = datenum(tempdata.DateTime);
varID = 'var00085';


%__________________________________________________________
filecode = 'siteA_surface_do';

sss = find(~isnan(tempdata.SiteASurface) == 1);
wdate = mdate(sss);
wdata = tempdata.SiteASurface(sss);
wdepth(1:length(sss),1) = siteA.Depth - 1.3;
write_psdp_data(outdir,siteA,varID,varkey,wdate,wdata,wdepth,filecode);clear wdepth;


