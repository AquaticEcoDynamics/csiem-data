function import_wc_digitised_dataset_b
addpath(genpath('../../functions/'));

load ../../actions/sitekey.mat

xlsname = '../../../../data-lake/WCWA/WC-BMT/Digitised_DO.xlsx';
%'            D:\csiem\data-lake\WCWA\WC-BMT\Digitised_DO.xlsx';

outdir = '../../../../data-warehouse/csv/wcwa/psdp-1.2/';mkdir(outdir);
%'           D:\csiem\data-warehouse\csv\wcwa\psdp-1.2\';mkdir(outdir);


[snum,~] = xlsread(xlsname,'PSDPsites','A2:A100');
mdata = calc_dates(snum(:,1));
mdata = [mdata;mdata];
%____________________________________________________________
ddata = [];data = [];

[snum,~] = xlsread(xlsname,'PSDPsites','B2:C100');

thesite = 'wc_psdp_S2';

filename = 'WC_Digitised_S2_Oxygen_2013';


ddata(1:length(snum(:,1)),1) = 0;ddata = [ddata;ddata+20];
data = [snum(:,1);snum(:,2)];

Lat = sitekey.wc.(thesite).Lat;
Lon = sitekey.wc.(thesite).Lon;
AgencyName = 'Water Corporation';
AgencyCode = 'WCWA';
Program =  'PSDP-1.2';
ProgramCode = 'PSDP-1.2';
SiteID = sitekey.wc.(thesite).ID;
SiteDesc = sitekey.wc.(thesite).Description;

write_files(mdata,ddata,data,...
    filename,AgencyName,AgencyCode,...
    Program,ProgramCode,outdir,Lat,Lon,...
    SiteID,SiteDesc);

%____________________________________________________________
ddata = [];data = [];

[snum,~] = xlsread(xlsname,'PSDPsites','D2:E100');

thesite = 'wc_psdp_S3';

filename = 'WC_Digitised_S3_Oxygen_2013';


ddata(1:length(snum(:,1)),1) = 0;ddata = [ddata;ddata+20];
data = [snum(:,1);snum(:,2)];

Lat = sitekey.wc.(thesite).Lat;
Lon = sitekey.wc.(thesite).Lon;
AgencyName = 'Water Corporation';
AgencyCode = 'WCWA';
Program =  'PSDP-1.2';
ProgramCode = 'PSDP-1.2';
SiteID = sitekey.wc.(thesite).ID;
SiteDesc = sitekey.wc.(thesite).Description;

write_files(mdata,ddata,data,...
    filename,AgencyName,AgencyCode,...
    Program,ProgramCode,outdir,Lat,Lon,...
    SiteID,SiteDesc);

%____________________________________________________________
ddata = [];data = [];

[snum,~] = xlsread(xlsname,'PSDPsites','F2:G100');

thesite = 'wc_psdp_R2';

filename = 'WC_Digitised_R2_Oxygen_2013';


ddata(1:length(snum(:,1)),1) = 0;ddata = [ddata;ddata+20];
data = [snum(:,1);snum(:,2)];

Lat = sitekey.wc.(thesite).Lat;
Lon = sitekey.wc.(thesite).Lon;
AgencyName = 'Water Corporation';
AgencyCode = 'WCWA';
Program =  'PSDP-1.2';
ProgramCode = 'PSDP-1.2';
SiteID = sitekey.wc.(thesite).ID;
SiteDesc = sitekey.wc.(thesite).Description;

write_files(mdata,ddata,data,...
    filename,AgencyName,AgencyCode,...
    Program,ProgramCode,outdir,Lat,Lon,...
    SiteID,SiteDesc);

%____________________________________________________________
ddata = [];data = [];

[snum,~] = xlsread(xlsname,'PSDPsites','H2:I100');

thesite = 'wc_psdp_A4';

filename = 'WC_Digitised_A4_Oxygen_2013';


ddata(1:length(snum(:,1)),1) = 0;ddata = [ddata;ddata+20];
data = [snum(:,1);snum(:,2)];

Lat = sitekey.wc.(thesite).Lat;
Lon = sitekey.wc.(thesite).Lon;
AgencyName = 'Water Corporation';
AgencyCode = 'WCWA';
Program =  'PSDP-1.2';
ProgramCode = 'PSDP-1.2';
SiteID = sitekey.wc.(thesite).ID;
SiteDesc = sitekey.wc.(thesite).Description;

write_files(mdata,ddata,data,...
    filename,AgencyName,AgencyCode,...
    Program,ProgramCode,outdir,Lat,Lon,...
    SiteID,SiteDesc);

%____________________________________________________________
ddata = [];data = [];

[snum,~] = xlsread(xlsname,'PSDPsites','J2:K100');

thesite = 'wc_psdp_A7';

filename = 'WC_Digitised_A7_Oxygen_2013';


ddata(1:length(snum(:,1)),1) = 0;ddata = [ddata;ddata+20];
data = [snum(:,1);snum(:,2)];

Lat = sitekey.wc.(thesite).Lat;
Lon = sitekey.wc.(thesite).Lon;
AgencyName = 'Water Corporation';
AgencyCode = 'WCWA';
Program =  'PSDP-1.2';
ProgramCode = 'PSDP-1.2';
SiteID = sitekey.wc.(thesite).ID;
SiteDesc = sitekey.wc.(thesite).Description;

write_files(mdata,ddata,data,...
    filename,AgencyName,AgencyCode,...
    Program,ProgramCode,outdir,Lat,Lon,...
    SiteID,SiteDesc);

%____________________________________________________________
ddata = [];data = [];

[snum,~] = xlsread(xlsname,'PSDPsites','L2:M100');

thesite = 'wc_psdp_A10';

filename = 'WC_Digitised_A10_Oxygen_2013';


ddata(1:length(snum(:,1)),1) = 0;ddata = [ddata;ddata+20];
data = [snum(:,1);snum(:,2)];

Lat = sitekey.wc.(thesite).Lat;
Lon = sitekey.wc.(thesite).Lon;
AgencyName = 'Water Corporation';
AgencyCode = 'WCWA';
Program =  'PSDP-1.2';
ProgramCode = 'PSDP-1.2';
SiteID = sitekey.wc.(thesite).ID;
SiteDesc = sitekey.wc.(thesite).Description;

write_files(mdata,ddata,data,...
    filename,AgencyName,AgencyCode,...
    Program,ProgramCode,outdir,Lat,Lon,...
    SiteID,SiteDesc);

%____________________________________________________________
ddata = [];data = [];

[snum,~] = xlsread(xlsname,'PSDPsites','N2:O100');

thesite = 'wc_psdp_A13';

filename = 'WC_Digitised_A13_Oxygen_2013';


ddata(1:length(snum(:,1)),1) = 0;ddata = [ddata;ddata+20];
data = [snum(:,1);snum(:,2)];

Lat = sitekey.wc.(thesite).Lat;
Lon = sitekey.wc.(thesite).Lon;
AgencyName = 'Water Corporation';
AgencyCode = 'WCWA';
Program =  'PSDP-1.2';
ProgramCode = 'PSDP-1.2';
SiteID = sitekey.wc.(thesite).ID;
SiteDesc = sitekey.wc.(thesite).Description;

write_files(mdata,ddata,data,...
    filename,AgencyName,AgencyCode,...
    Program,ProgramCode,outdir,Lat,Lon,...
    SiteID,SiteDesc);

%____________________________________________________________
ddata = [];data = [];

[snum,~] = xlsread(xlsname,'PSDPsites','P2:Q100');

thesite = 'wc_psdp_B4';

filename = 'WC_Digitised_B4_Oxygen_2013';


ddata(1:length(snum(:,1)),1) = 0;ddata = [ddata;ddata+20];
data = [snum(:,1);snum(:,2)];

Lat = sitekey.wc.(thesite).Lat;
Lon = sitekey.wc.(thesite).Lon;
AgencyName = 'Water Corporation';
AgencyCode = 'WCWA';
Program =  'PSDP-1.2';
ProgramCode = 'PSDP-1.2';
SiteID = sitekey.wc.(thesite).ID;
SiteDesc = sitekey.wc.(thesite).Description;

write_files(mdata,ddata,data,...
    filename,AgencyName,AgencyCode,...
    Program,ProgramCode,outdir,Lat,Lon,...
    SiteID,SiteDesc);

%____________________________________________________________
ddata = [];data = [];

[snum,~] = xlsread(xlsname,'PSDPsites','R2:S100');

thesite = 'wc_psdp_B6';

filename = 'WC_Digitised_B6_Oxygen_2013';


ddata(1:length(snum(:,1)),1) = 0;ddata = [ddata;ddata+20];
data = [snum(:,1);snum(:,2)];

Lat = sitekey.wc.(thesite).Lat;
Lon = sitekey.wc.(thesite).Lon;
AgencyName = 'Water Corporation';
AgencyCode = 'WCWA';
Program =  'PSDP-1.2';
ProgramCode = 'PSDP-1.2';
SiteID = sitekey.wc.(thesite).ID;
SiteDesc = sitekey.wc.(thesite).Description;

write_files(mdata,ddata,data,...
    filename,AgencyName,AgencyCode,...
    Program,ProgramCode,outdir,Lat,Lon,...
    SiteID,SiteDesc);

%____________________________________________________________
ddata = [];data = [];

[snum,~] = xlsread(xlsname,'PSDPsites','T2:U100');

thesite = 'wc_psdp_B8';

filename = 'WC_Digitised_B8_Oxygen_2013';


ddata(1:length(snum(:,1)),1) = 0;ddata = [ddata;ddata+20];
data = [snum(:,1);snum(:,2)];

Lat = sitekey.wc.(thesite).Lat;
Lon = sitekey.wc.(thesite).Lon;
AgencyName = 'Water Corporation';
AgencyCode = 'WCWA';
Program =  'PSDP-1.2';
ProgramCode = 'PSDP-1.2';
SiteID = sitekey.wc.(thesite).ID;
SiteDesc = sitekey.wc.(thesite).Description;

write_files(mdata,ddata,data,...
    filename,AgencyName,AgencyCode,...
    Program,ProgramCode,outdir,Lat,Lon,...
    SiteID,SiteDesc);

%____________________________________________________________
ddata = [];data = [];

[snum,~] = xlsread(xlsname,'PSDPsites','V2:W100');

thesite = 'wc_psdp_B10';

filename = 'WC_Digitised_B10_Oxygen_2013';


ddata(1:length(snum(:,1)),1) = 0;ddata = [ddata;ddata+20];
data = [snum(:,1);snum(:,2)];

Lat = sitekey.wc.(thesite).Lat;
Lon = sitekey.wc.(thesite).Lon;
AgencyName = 'Water Corporation';
AgencyCode = 'WCWA';
Program =  'PSDP-1.2';
ProgramCode = 'PSDP-1.2';
SiteID = sitekey.wc.(thesite).ID;
SiteDesc = sitekey.wc.(thesite).Description;

write_files(mdata,ddata,data,...
    filename,AgencyName,AgencyCode,...
    Program,ProgramCode,outdir,Lat,Lon,...
    SiteID,SiteDesc);


%____________________________________________________________
ddata = [];data = [];

[snum,~] = xlsread(xlsname,'PSDPsites','X2:Y100');

thesite = 'wc_psdp_C4';

filename = 'WC_Digitised_C4_Oxygen_2013';


ddata(1:length(snum(:,1)),1) = 0;ddata = [ddata;ddata+20];
data = [snum(:,1);snum(:,2)];

Lat = sitekey.wc.(thesite).Lat;
Lon = sitekey.wc.(thesite).Lon;
AgencyName = 'Water Corporation';
AgencyCode = 'WCWA';
Program =  'PSDP-1.2';
ProgramCode = 'PSDP-1.2';
SiteID = sitekey.wc.(thesite).ID;
SiteDesc = sitekey.wc.(thesite).Description;

write_files(mdata,ddata,data,...
    filename,AgencyName,AgencyCode,...
    Program,ProgramCode,outdir,Lat,Lon,...
    SiteID,SiteDesc);

%____________________________________________________________
ddata = [];data = [];

[snum,~] = xlsread(xlsname,'PSDPsites','Z2:AA100');

thesite = 'wc_psdp_C6';

filename = 'WC_Digitised_C6_Oxygen_2013';


ddata(1:length(snum(:,1)),1) = 0;ddata = [ddata;ddata+20];
data = [snum(:,1);snum(:,2)];

Lat = sitekey.wc.(thesite).Lat;
Lon = sitekey.wc.(thesite).Lon;
AgencyName = 'Water Corporation';
AgencyCode = 'WCWA';
Program =  'PSDP-1.2';
ProgramCode = 'PSDP-1.2';
SiteID = sitekey.wc.(thesite).ID;
SiteDesc = sitekey.wc.(thesite).Description;

write_files(mdata,ddata,data,...
    filename,AgencyName,AgencyCode,...
    Program,ProgramCode,outdir,Lat,Lon,...
    SiteID,SiteDesc);

%____________________________________________________________
ddata = [];data = [];

[snum,~] = xlsread(xlsname,'PSDPsites','AB2:AC100');

thesite = 'wc_psdp_C8';

filename = 'WC_Digitised_C8_Oxygen_2013';


ddata(1:length(snum(:,1)),1) = 0;ddata = [ddata;ddata+20];
data = [snum(:,1);snum(:,2)];

Lat = sitekey.wc.(thesite).Lat;
Lon = sitekey.wc.(thesite).Lon;
AgencyName = 'Water Corporation';
AgencyCode = 'WCWA';
Program =  'PSDP-1.2';
ProgramCode = 'PSDP-1.2';
SiteID = sitekey.wc.(thesite).ID;
SiteDesc = sitekey.wc.(thesite).Description;

write_files(mdata,ddata,data,...
    filename,AgencyName,AgencyCode,...
    Program,ProgramCode,outdir,Lat,Lon,...
    SiteID,SiteDesc);

%____________________________________________________________
ddata = [];data = [];

[snum,~] = xlsread(xlsname,'PSDPsites','AD2:AE100');

thesite = 'wc_psdp_C10';

filename = 'WC_Digitised_C10_Oxygen_2013';


ddata(1:length(snum(:,1)),1) = 0;ddata = [ddata;ddata+20];
data = [snum(:,1);snum(:,2)];

Lat = sitekey.wc.(thesite).Lat;
Lon = sitekey.wc.(thesite).Lon;
AgencyName = 'Water Corporation';
AgencyCode = 'WCWA';
Program =  'PSDP-1.2';
ProgramCode = 'PSDP-1.2';
SiteID = sitekey.wc.(thesite).ID;
SiteDesc = sitekey.wc.(thesite).Description;

write_files(mdata,ddata,data,...
    filename,AgencyName,AgencyCode,...
    Program,ProgramCode,outdir,Lat,Lon,...
    SiteID,SiteDesc);

%____________________________________________________________
ddata = [];data = [];

[snum,~] = xlsread(xlsname,'PSDPsites','AF2:AG100');

thesite = 'wc_psdp_D6';

filename = 'WC_Digitised_D6_Oxygen_2013';


ddata(1:length(snum(:,1)),1) = 0;ddata = [ddata;ddata+20];
data = [snum(:,1);snum(:,2)];

Lat = sitekey.wc.(thesite).Lat;
Lon = sitekey.wc.(thesite).Lon;
AgencyName = 'Water Corporation';
AgencyCode = 'WCWA';
Program =  'PSDP-1.2';
ProgramCode = 'PSDP-1.2';
SiteID = sitekey.wc.(thesite).ID;
SiteDesc = sitekey.wc.(thesite).Description;

write_files(mdata,ddata,data,...
    filename,AgencyName,AgencyCode,...
    Program,ProgramCode,outdir,Lat,Lon,...
    SiteID,SiteDesc);

%____________________________________________________________
ddata = [];data = [];

[snum,~] = xlsread(xlsname,'PSDPsites','AH2:AI100');

thesite = 'wc_psdp_D8';

filename = 'WC_Digitised_D8_Oxygen_2013';


ddata(1:length(snum(:,1)),1) = 0;ddata = [ddata;ddata+20];
data = [snum(:,1);snum(:,2)];

Lat = sitekey.wc.(thesite).Lat;
Lon = sitekey.wc.(thesite).Lon;
AgencyName = 'Water Corporation';
AgencyCode = 'WCWA';
Program =  'PSDP-1.2';
ProgramCode = 'PSDP-1.2';
SiteID = sitekey.wc.(thesite).ID;
SiteDesc = sitekey.wc.(thesite).Description;

write_files(mdata,ddata,data,...
    filename,AgencyName,AgencyCode,...
    Program,ProgramCode,outdir,Lat,Lon,...
    SiteID,SiteDesc);

%____________________________________________________________
ddata = [];data = [];

[snum,~] = xlsread(xlsname,'PSDPsites','AJ2:AK100');

thesite = 'wc_psdp_D10';

filename = 'WC_Digitised_D10_Oxygen_2013';


ddata(1:length(snum(:,1)),1) = 0;ddata = [ddata;ddata+20];
data = [snum(:,1);snum(:,2)];

Lat = sitekey.wc.(thesite).Lat;
Lon = sitekey.wc.(thesite).Lon;
AgencyName = 'Water Corporation';
AgencyCode = 'WCWA';
Program =  'PSDP-1.2';
ProgramCode = 'PSDP-1.2';
SiteID = sitekey.wc.(thesite).ID;
SiteDesc = sitekey.wc.(thesite).Description;

write_files(mdata,ddata,data,...
    filename,AgencyName,AgencyCode,...
    Program,ProgramCode,outdir,Lat,Lon,...
    SiteID,SiteDesc);

%____________________________________________________________
ddata = [];data = [];

[snum,~] = xlsread(xlsname,'PSDPsites','AL2:AM100');

thesite = 'wc_psdp_D12';

filename = 'WC_Digitised_D12_Oxygen_2013';


ddata(1:length(snum(:,1)),1) = 0;ddata = [ddata;ddata+20];
data = [snum(:,1);snum(:,2)];

Lat = sitekey.wc.(thesite).Lat;
Lon = sitekey.wc.(thesite).Lon;
AgencyName = 'Water Corporation';
AgencyCode = 'WCWA';
Program =  'PSDP-1.2';
ProgramCode = 'PSDP-1.2';
SiteID = sitekey.wc.(thesite).ID;
SiteDesc = sitekey.wc.(thesite).Description;

write_files(mdata,ddata,data,...
    filename,AgencyName,AgencyCode,...
    Program,ProgramCode,outdir,Lat,Lon,...
    SiteID,SiteDesc);

%____________________________________________________________
ddata = [];data = [];

[snum,~] = xlsread(xlsname,'PSDPsites','AN2:AO100');

thesite = 'wc_psdp_CT7';

filename = 'WC_Digitised_CT7_Oxygen_2013';


ddata(1:length(snum(:,1)),1) = 0;ddata = [ddata;ddata+20];
data = [snum(:,1);snum(:,2)];

Lat = sitekey.wc.(thesite).Lat;
Lon = sitekey.wc.(thesite).Lon;
AgencyName = 'Water Corporation';
AgencyCode = 'WCWA';
Program =  'PSDP-1.2';
ProgramCode = 'PSDP-1.2';
SiteID = sitekey.wc.(thesite).ID;
SiteDesc = sitekey.wc.(thesite).Description;

write_files(mdata,ddata,data,...
    filename,AgencyName,AgencyCode,...
    Program,ProgramCode,outdir,Lat,Lon,...
    SiteID,SiteDesc);

%____________________________________________________________
ddata = [];data = [];

[snum,~] = xlsread(xlsname,'PSDPsites','AP2:AQ100');

thesite = 'wc_psdp_CT3';

filename = 'WC_Digitised_CT3_Oxygen_2013';


ddata(1:length(snum(:,1)),1) = 0;ddata = [ddata;ddata+20];
data = [snum(:,1);snum(:,2)];

Lat = sitekey.wc.(thesite).Lat;
Lon = sitekey.wc.(thesite).Lon;
AgencyName = 'Water Corporation';
AgencyCode = 'WCWA';
Program =  'PSDP-1.2';
ProgramCode = 'PSDP-1.2';
SiteID = sitekey.wc.(thesite).ID;
SiteDesc = sitekey.wc.(thesite).Description;

write_files(mdata,ddata,data,...
    filename,AgencyName,AgencyCode,...
    Program,ProgramCode,outdir,Lat,Lon,...
    SiteID,SiteDesc);