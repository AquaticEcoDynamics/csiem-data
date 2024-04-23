clear all; close all;

addpath(genpath('../../functions/'));

thefile = '../../../../data-lake/imos/amnmmooring/IMOS_ANMN-NRS_BOSTZ_20081120_NRSROT_FV02_hourly-timeseries_END-20201207_C-20210427.nc';

load ../../actions/varkey.mat;
load ../../actions/agency.mat;
load ../../actions/sitekey.mat;

outpath = '../../../../data-warehouse/csv/imos/amnmmooring/';

stime = ncread(thefile,'TIME');

mtime = datenum(1950,01,01,00,00,00) + stime;

depth = ncread(thefile,'DEPTH');

thevars = {...
    'TEMP',...
    'PSAL',...
    'PRES_REL',...
    'DOX2',...
    'CPHL',...
    };


% lat = ncread(thefile,'LATITUDE');
% lon = ncread(thefile,'LONGITUDE');
% 
% for i = 1:length(lat)
%     S(i).Lat = lat(i);
%     S(i).Lon = lon(i);
%     S(i).ID = i;
%     S(i).Geometry = 'point';
% end
% shapewrite(S,'Mooring.shp');
