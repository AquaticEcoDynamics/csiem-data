function plot_datawarehouse_csv_all(plotnew_dataplots)%   clear all; close all;

filepath = '../../../data-warehouse/csv/';
%          'D:\csiem\data-warehouse\csv\';

outdir = '../../../data-warehouse/data-images/';
%        'D:\csiem\data-warehouse\data-images\';

filelist = dir(fullfile(filepath, '**/*DATA.csv'));  %get list of files and folders in any subfolder
%filelist = dir(fullfile(filepath, '**\*DATA.csv'));  %get list of files and folders in any subfolder

filelist = filelist(~[filelist.isdir]);  %remove folders from list

for i = 1:length(filelist)
    
    filename = [filelist(i).folder,'/',filelist(i).name];
%    filename = [filelist(i).folder,'\',filelist(i).name];

    
    spt = split(filelist(i).folder,'/');
%    spt = split(filelist(i).folder,'\');

    
    savedir = [outdir,spt{end-1},'/',spt{end},'/'];
%    savedir = [outdir,spt{end-1},'\',spt{end},'\'];

    
    mkdir(savedir);
    
    savename = [savedir,regexprep(filelist(i).name,'.csv','.png')];
    
    if plotnew_dataplots
        if ~exist(savename,'file')
            disp(savename);
            plot_datafile_all(filename,savename);   
        end
    else
        plot_datafile_all(filename,savename);
    end
    
end