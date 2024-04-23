clear all; close all;

addpath(genpath('Functions'));
% This uses the latest version of the code, which requries

% Watch for the Version flag for files downloaded after Nov. 2017.

% Haven't checked if level flat file is also affected

%______________________________________________________________________________

% There is a zipped folder in Raw Zipped. Unzip that folder and add it to the Raw directory. It's too big for Github unzipped.

holding = '/Projects2/csiem-data-hub/data-warehouse/csv_holding/dwer/matfiles';
%'D:\csiem\data-warehouse\csv_holding\dwer\matfiles\';

swanestPath = '/Projects2/csiem-data-hub/data-lake/DWER/swanest/';
dirlist = dir(swanestPath);
%'D:\csiem/data-lake/dwer/swanest/'

for i = 71:length(dirlist)%3
    
    filelist = dir([swanestPath,dirlist(i).name,'/*.xlsx']);
    
    if strcmpi(filelist(1).name,'WaterQualityDiscreteForSiteCrossTab.xlsx')
        filename = [swanestPath,dirlist(i).name,'/WaterQualityDiscreteForSiteCrossTab.xlsx'];
        type = 'WQ';
%         if i ~= 9
            filename
         [rows,cols] = calculate_xls_size(filename);
%         end
    else
        filename = [swanestPath,dirlist(i).name,'/WaterLevelsContinuousForSiteCrossTab.xlsx'];
        type = 'Level';
        [rows,cols] = calculate_xls_size_l(filename);
    end
    
    savename = [holding,'swan_',dirlist(i).name,'.mat'];
    %savename = 'swan.mat';
    
     import_wir_dataset_v3(filename,type,'Create',savename,'Row',rows,'Column',cols,...
            'Remove_NaN',1,'Summerise',0,'Version',2);
        
%     if i == 3
%         import_wir_dataset_v2(filename,type,'Create','swan.mat','Row',rows,'Column',cols,...
%             'Remove_NaN',1,'Summerise',0,'Version',2);
%     else
%         if i == length(dirlist)
%             import_wir_dataset_v2(filename,type,'Append','swan.mat','Row',rows,'Column',cols,...
%                 'Remove_NaN',1,'Summerise',1,'Version',2);
%         else
%             import_wir_dataset_v2(filename,type,'Append','swan.mat','Row',rows,'Column',cols,...
%                 'Remove_NaN',1,'Summerise',0,'Version',2);
%         end
%     end
    clear functions
end


swan = append_matfiles(holding);

%load swan.mat;
%
swan = sort_WIR_data(swan);


sites = fieldnames(swan)
for i = 1:length(sites)
    vars = fieldnames(swan.(sites{i}));
    for j = 1:length(vars)
        [swan.(sites{i}).(vars{j}).Lat,swan.(sites{i}).(vars{j}).Lon] = utm2ll(swan.(sites{i}).(vars{j}).X,swan.(sites{i}).(vars{j}).Y,-50);
    end
end


%
save /Projects2/csiem-data-hub/data-warehouse/csv_holding/dwer/swan.mat swam -mat -v7.3;
%D:\csiem\data-warehouse\csv_holding\dwer\swan.mat swan -mat -v7.3;

% import_drainage_data;
% save('../modeltools/matfiles/swan.mat','swan','-mat');
%load swan.mat;



%export_site_information
%




















%______________________________________________________________





