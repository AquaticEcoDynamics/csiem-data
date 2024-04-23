clear all; close all;
addpath(genpath('../functions'));
tic

import_var_key_info;
import_site_key;


import_dwer = 0;
import_dot = 0;
import_bom = 0;
import_mafrl = 0;
import_imos = 0;
import_imos_srs = 0;

import_dpird = 0;
import_moorings = 0;
import_theme2 = 0;

import_theme3 = 0;
import_theme5 = 0;
import_wc = 0;
import_fpa = 0;

create_smd = 1;

create_matfiles = 0;
create_parquet = 0;

create_dataplots = 0;
plotnew_dataplots = 0;

create_shapefiles = 0;


run_marvl = 1;


%___________________________________________________________________________

% Import Scripts.....

%___________________________________________________________________________



if import_fpa
    cd ../import/FPA;
    import_fpa_mqmp;
    cd ../../actions;
end


if import_dwer
    % DWER Export
    cd ../import/DWER;
    
    %run_WIR_import_v2;
    export_wir_v2_stage1;
    import_and_reformat_flatfile;
    
    % export_wir;clear all; close all;
    cd ../../actions
end
% DOT Export

if import_dot
    cd ../import/DOT;
    
    
    import_bar_tidal_data;
    %
    import_freo_tidal_data;
    %
    import_hil_tidal_data;
    %
    import_mgb_tidal_data;
    
    cd ../../actions
end

if import_bom
    %BOM Export
    cd ../import/BOM;
    run_bom_import;
    cd ../../actions
end
%MAFRL
if import_mafrl
    cd ../import/MAFRL/
    
    import_mafrl_2_csv;
    merge_files;
    
    
    cd ../../actions
end


%IMOS
if import_imos
    cd ../import/imos
    
    import_imos_bgc_2_csv;
    %
    import_imos_profile_2_csv;
    %
    import_imos_profile_2_2010_csv;
    
    merge_files;

    import_imos_temp_sal;
    
    % Needs updating
    % import_imos_profile_2_csv_BURST;
    %
    % import_imos_profile_2_csv_BURST2;
    
    
    cd ../../actions
end

if import_imos_srs
    cd ../import/IMOS_SRS/
    import_IMOS_SRS_L3S_netcdf_data;
    import_IMOS_SRS_MODIS_netcdf_data;
    import_IMOS_SRS_MODIS_OC3_netcdf_data;
    cd ../../actions/
end

if import_dpird
    % DPIRD
    cd ../import/dpird
    
    import_dpird_crab_data;
    
    cd ../../actions/
end

if import_moorings
    % DWER Mooring
    cd ../import/DWER_Mooring
    
    import_mooring_data_v2;
    
    cd ../../actions/
end

if import_theme2
    % wamsi_theme2
    cd ../import/wamsi_theme2
    
    import_theme2_light;
    import_theme2_seagrass;
    cd ../../actions/
end

if import_theme3
    % wamsi_theme3
    cd ../import/wamsi_theme3/CTD
    reformat_ctd;
    import_theme3ctd_data;
    
    cd ../../../actions/

    %Sediment
    cd ../import/wamsi_theme3/SEDPSD
    run ImportSEDPSDMain
    cd ../../../actions

    cd ../import/wamsi_theme3/SGREST
    run ImportSGRESTMain
    cd ../../../actions

    
end

if import_wc
    % WC_Digitised
    cd ../import/WCWA
    import_wc_digitised_dataset;
    import_wc_digitised_dataset_b;

    import_PhyWQ_1334_09;
    
    cd ../../actions/
end
%WAMSI
if import_theme5
    cd ../import/wamsi_theme5
    
    import_netcdf_csv;
    import_netcdf_csv_ADCP;
    import_met_csv;
    cd ../../actions/
end

if create_smd
    calculate_SMD_for_headers
end

if create_matfiles
    csv_2_matfile_tfv_by_agency;
end
if create_parquet
    csv_2_parquet_by_agency;
    csv_2_parquet_by_category;
end

if create_dataplots
    plot_datawarehouse_csv_all(plotnew_dataplots);
end

if run_marvl
    addpath(genpath('/GIS_DATA/csiem-data-hub/marvl'));
    create_marvl_config_information;
    run_AEDmarvl marvl_pipeline_images;
    rmpath(genpath('/GIS_DATA/csiem-data-hub/marvl'));
end

if create_shapefiles
    header_to_shapefile;
end

B = toc;

disp(['Total Runtime: ',num2str(B/(60*60)),' Hours']);





