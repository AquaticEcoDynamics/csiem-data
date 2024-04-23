function calculate_SMD_for_headers;

addpath(genpath('../functions/'));

filepath = '../../../data-warehouse/csv/';
%          'D:\csiem\data-warehouse\csv\';

%filelist = dir(fullfile(filepath, '**\*HEADER.csv'));  %get list of files and folders in any subfolder
filelist = dir(fullfile(filepath, '**/*HEADER.csv'));  %get list of files and folders in any subfolder
filelist = filelist(~[filelist.isdir]);  %remove folders from list

shp = shaperead('Summary/GIS/Boundary.shp');
external = readtable('Summary/GIS/external.csv');
internal = readtable('Summary/GIS/mesh_nodes.csv');

dtri_inside = DelaunayTri(internal.Var3,internal.Var4);
dtri_external = DelaunayTri(external.Var1,external.Var2);


for i = 1:length(filelist)
    filename = [filelist(i).folder,'/',filelist(i).name];
    
    newfile = regexprep(filename,'_HEADER.csv','_SMD.csv');
    filename
    data = import_header(filename);
    
    query_points(:,1) = data.Lon;
    query_points(:,2) = data.Lat;
    
    if inpolygon(data.Lon,data.Lat,shp(1).X,shp(1).Y)
        disp('Inside');
        pt_id = nearestNeighbor(dtri_inside,query_points);
        mahd = internal.Var5(pt_id);
    else
        disp('Outside');
        pt_id = nearestNeighbor(dtri_external,query_points);
        mahd = external.Var3(pt_id);
    end
    disp(num2str(mahd));
    nSMD = 0-mahd;
    fid = fopen(newfile,'wt');
    fprintf(fid,'Calculated mAHD,%4.4f\n',mahd);
    fprintf(fid,'Calculated SMD,%4.4f\n',nSMD);
    fclose(fid);
    query_points = [];
end