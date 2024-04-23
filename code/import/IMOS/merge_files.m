function merge_files

addpath(genpath('../../functions/'));


inpath = '../../../../data-warehouse/csv_holding/imos/amnmprofile/';
%'D:/csiem/data-warehouse/csv_holding/imos/amnmprofile/';
outpath = '../../../../data-warehouse/csv/imos/amnmprofile'; mkdir(outpath);
%'D:/csiem/data-warehouse/csv/imos/amnmprofile/'; mkdir(outpath);

temp = fullfile(inpath, '**/*_DATA.csv')
filelist = dir(fullfile(inpath, '**/*_DATA.csv'));  %get list of files and folders in any subfolder
filelist = filelist(~[filelist.isdir]);  %remove folders from list

for i = 1:length(filelist)
    
    filename = filelist(i).name;
    oldheader = regexprep(filename,'DATA.csv','HEADER.csv');
    
    spt = split(filename,'_');
    
    s_temp = spt(1:end-2);
    
    new_temp = sprintf('%s_', s_temp{:});
    
    newfile = [new_temp,'DATA.csv'];
    newheader = regexprep(newfile,'DATA.csv','HEADER.csv');
    
    
    fidout = fopen([inpath,filename]);
    
    if exist([outpath,newfile],'file')
        fid = fopen([outpath,newfile],'a+');
        
        line = fgetl(fidout);
        while ~feof(fidout)
            line = fgetl(fidout);
            fprintf(fid,'%s\n',line);
        end
        fclose(fid);
        fclose(fidout);
        
        
    else
        copyfile([inpath,oldheader],[outpath,newheader]);
        fid = fopen([outpath,newfile],'wt');
        while ~feof(fidout)
            line = fgetl(fidout);
            fprintf(fid,'%s\n',line);
        end
        fclose(fid);
        fclose(fidout);
    end
    
end
filelist = dir(fullfile(outpath, '**/*_DATA.csv'));  %get list of files and folders in any subfolder
filelist = filelist(~[filelist.isdir]);  %remove folders from list

for i = 1:length(filelist)
    
    fname = [inpath,filename];
    data = import_datafile(fname);
    fid = fopen([outpath,newfile],'wt');
    fprintf(fid,'Date,Depth,Data,QC\n');
    
    [data.Date,ind] = sort(data.Date);
    data.Depth = data.Depth(ind);
    data.Data = data.Data(ind);
    data.QC = data.QC(ind);
    for k = 1:length(data.Date)
        fprintf(fid,'%s,%4.4f,%4.4f,%s\n',datestr(data.Date(k),'yyyy-mm-dd HH:MM:SS'),data.Depth(k),data.Data(k),data.QC{k});
    end
    fclose(fid);
    
    
    plot_datafile([outpath,filelist(i).name]);
end