function merge_files

addpath(genpath('../../functions/'));

run('../../actions/csiem_data_paths.m')
inpath = [datapath,'data-warehouse/csv_holding/csmc/csmcwq/'];
outpath = [datapath,'data-warehouse/csv/csmc/csmcwq/']; mkdir(outpath);


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
    %plot_datafile([outpath,filelist(i).name]);
end