function import_wc_digitised_dataset
addpath(genpath('../../functions/'));

load ../../actions/sitekey.mat
load ../../actions/varkey.mat

xlsname = '../../../../data-lake/WCWA/WC-BMT/Digitised_DO.xlsx';
%            'D:\csiem\data-lake\WCWA\WC-BMT\Digitised_DO.xlsx';


outdir = '../../../../data-warehouse/csv/wcwa/psdp-1.2/';mkdir(outdir);
%'           D:\csiem\data-warehouse\csv\wcwa\psdp-1.2\';mkdir(outdir);

%____________________________________________________________
mdata = [];ddata = [];data = [];

[snum,~] = xlsread(xlsname,'Southbuoy_surf','A2:B100');

mdata = calc_dates(snum(:,1));
ddata(1:length(mdata),1) = 0;
data = snum(:,2);
Lat = sitekey.wc.wc_southbuoy.Lat;
Lon = sitekey.wc.wc_southbuoy.Lon;
filename = 'WC_Digitised_SB_Oxygen_2013';
AgencyName = 'Water Corporation';
AgencyCode = 'WCWA';
Program =  'PSDP-1.2';
ProgramCode = 'PSDP-1.2';
SiteID = sitekey.wc.wc_southbuoy.ID;
SiteDesc = sitekey.wc.wc_southbuoy.Description;

write_files(mdata,ddata,data,...
    filename,AgencyName,AgencyCode,...
    Program,ProgramCode,outdir,Lat,Lon,...
    SiteID,SiteDesc);

%____________________________________________________________

mdata = [];ddata = [];data = [];

[snum,~] = xlsread(xlsname,'Southbuoy_bed','A2:B100');

mdata = calc_dates(snum(:,1));
ddata(1:length(mdata),1) = 20;
data = snum(:,2);
Lat = sitekey.wc.wc_southbuoy.Lat;
Lon = sitekey.wc.wc_southbuoy.Lon;
filename = 'WC_Digitised_SB_Oxygen_2013_Bottom';
AgencyName = 'Water Corporation';
AgencyCode = 'WCWA';
Program =  'PSDP-1.2';
ProgramCode = 'PSDP-1.2';
SiteID = sitekey.wc.wc_southbuoy.ID;
SiteDesc = sitekey.wc.wc_southbuoy.Description;

write_files(mdata,ddata,data,...
    filename,AgencyName,AgencyCode,...
    Program,ProgramCode,outdir,Lat,Lon,...
    SiteID,SiteDesc);



%____________________________________________________________
mdata = [];ddata = [];data = [];

[snum,~] = xlsread(xlsname,'Centralbuoy_surf','A2:B100');

mdata = calc_dates(snum(:,1));
ddata(1:length(mdata),1) = 0;
data = snum(:,2);
Lat = sitekey.wc.wc_centralbuoy.Lat;
Lon = sitekey.wc.wc_centralbuoy.Lon;
filename = 'WC_Digitised_CB_Oxygen_2013';
AgencyName = 'Water Corporation';
AgencyCode = 'WCWA';
Program =  'PSDP-1.2';
ProgramCode = 'PSDP-1.2';
SiteID = sitekey.wc.wc_centralbuoy.ID;
SiteDesc = sitekey.wc.wc_centralbuoy.Description;

write_files(mdata,ddata,data,...
    filename,AgencyName,AgencyCode,...
    Program,ProgramCode,outdir,Lat,Lon,...
    SiteID,SiteDesc);

%____________________________________________________________

mdata = [];ddata = [];data = [];

[snum,~] = xlsread(xlsname,'Centralbuoy_bed','A2:B100');

mdata = calc_dates(snum(:,1));
ddata(1:length(mdata),1) = 20;
data = snum(:,2);
Lat = sitekey.wc.wc_centralbuoy.Lat;
Lon = sitekey.wc.wc_centralbuoy.Lon;
filename = 'WC_Digitised_CB_Oxygen_2013_Bottom';
AgencyName = 'Water Corporation';
AgencyCode = 'WCWA';
Program =  'PSDP-1.2';
ProgramCode = 'PSDP-1.2';
SiteID = sitekey.wc.wc_centralbuoy.ID;
SiteDesc = sitekey.wc.wc_centralbuoy.Description;

write_files(mdata,ddata,data,...
    filename,AgencyName,AgencyCode,...
    Program,ProgramCode,outdir,Lat,Lon,...
    SiteID,SiteDesc);

%____________________________________________________________
mdata = [];ddata = [];data = [];

[snum,~] = xlsread(xlsname,'Northbuoy_surf','A2:B100');

mdata = calc_dates(snum(:,1));
ddata(1:length(mdata),1) = 0;
data = snum(:,2);
Lat = sitekey.wc.wc_northbuoy.Lat;
Lon = sitekey.wc.wc_northbuoy.Lon;
filename = 'WC_Digitised_NB_Oxygen_2013';
AgencyName = 'Water Corporation';
AgencyCode = 'WCWA';
Program =  'PSDP-1.2';
ProgramCode = 'PSDP-1.2';
SiteID = sitekey.wc.wc_northbuoy.ID;
SiteDesc = sitekey.wc.wc_northbuoy.Description;

write_files(mdata,ddata,data,...
    filename,AgencyName,AgencyCode,...
    Program,ProgramCode,outdir,Lat,Lon,...
    SiteID,SiteDesc);

%____________________________________________________________

mdata = [];ddata = [];data = [];

[snum,~] = xlsread(xlsname,'Northbuoy_bed','A2:B100');

mdata = calc_dates(snum(:,1));
ddata(1:length(mdata),1) = 20;
data = snum(:,2);
Lat = sitekey.wc.wc_northbuoy.Lat;
Lon = sitekey.wc.wc_northbuoy.Lon;
filename = 'WC_Digitised_NB_Oxygen_2013_Bottom';
AgencyName = 'Water Corporation';
AgencyCode = 'WCWA';
Program =  'PSDP-1.2';
ProgramCode = 'PSDP-1.2';
SiteID = sitekey.wc.wc_northbuoy.ID;
SiteDesc = sitekey.wc.wc_northbuoy.Description;

write_files(mdata,ddata,data,...
    filename,AgencyName,AgencyCode,...
    Program,ProgramCode,outdir,Lat,Lon,...
    SiteID,SiteDesc);
