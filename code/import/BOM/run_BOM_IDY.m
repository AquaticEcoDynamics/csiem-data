function run_BOM_IDY()
    run('../../actions/csiem_data_paths.m')
lakedir = [datapath,'data-lake/BOM/IDY/idy/'];

addpath(genpath('Functions'));

header_file = 'cockburn_header.m';

% % % 
metdata = getBoMmetdata(lakedir,header_file);

export_metdata_2_csv(metdata);

% if exist(rdir,'dir')
%     rmdir(rdir, 's');
% end

