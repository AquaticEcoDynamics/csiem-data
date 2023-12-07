clear all; close all;

addpath(genpath('../functions'));

outdir = '../../data-mapping/Warehouse/';mkdir(outdir);

filepath ='D:/csiem/data-warehouse/csv/';
filelist = dir(fullfile(filepath, '**\*HEADER.csv'));  %get list of files and folders in any subfolder
filelist = filelist(~[filelist.isdir]);  %remove folders from list

for i = 1:length(filelist)
    
    headerfile = [filelist(i).folder,'/',filelist(i).name];
    
    header = import_header(headerfile);
    smd = import_header_smd(regexprep(headerfile,'HEADER','SMD'));
    header.calc_SMD = smd.calc_SMD;
    header.mAHD = smd.mAHD;
    
    if i == 1
        vars = fieldnames(header);
        for k = 1:length(vars)
            tab.(vars{k}) = {header.(vars{k})};
        end
    else
        vars = fieldnames(header);
        
        
        
        for k = 1:length(vars)
            
            if strcmpi(vars{k},'Mount') == 1
                stop;
            end
            
            tab.(vars{k}) = [tab.(vars{k});{header.(vars{k})}];
        end
    end
end

thedata = struct2table(tab);

type = unique(thedata.DataCategory);
sites = unique(thedata.Station_ID);
proj = unique(thedata.Tag);

allvars = thedata.Properties.VariableNames;


for i = 1:length(type)

    for ii = 1:length(allvars)
        newtab.(allvars{ii}) = [];
    end

     sss = find(strcmpi(thedata.DataCategory,type{i}) == 1);
    for j = 1:length(sites)
        ttt = find(strcmpi(thedata.Station_ID(sss),sites{j}) == 1);


        if ~isempty(ttt)
            for k = 1:length(allvars)

                newtab.(allvars{k}) = [newtab.(allvars{k});thedata.(allvars{k})(sss(ttt(1)))];
            end
        end

    end

    outtab = struct2table(newtab);    
    
    writetable(outtab,[outdir,type{i},'.csv']);
end


outdir = '../../data-mapping/Warehouse/tag/';mkdir(outdir);

for i = 1:length(proj)

    for ii = 1:length(allvars)
        newtab.(allvars{ii}) = [];
    end
     sss = find(strcmpi(thedata.Tag,proj{i}) == 1);
     for j = 1:length(sites)
        ttt = find(strcmpi(thedata.Station_ID(sss),sites{j}) == 1);


        if ~isempty(ttt)
            for k = 1:length(allvars)

                newtab.(allvars{k}) = [newtab.(allvars{k});thedata.(allvars{k})(sss(ttt(1)))];
            end
        end

    end
      outtab = struct2table(newtab);    
    
    writetable(outtab,[outdir,proj{i},'.csv']);
end

%newtab = struct2table(newtab);

% int = 1;
% for i = 1:length(sites)
%     sss = find(strcmpi(thedata.Station_ID,sites{i}) == 1);
%     for j = 1:length(type)
%         ttt = find(strcmpi(thedata.DataCategory(sss),type{j}) == 1);
% 
%         if ~isempty(ttt)
%             for k = 1:length(allvars)
% 
%                 newtab.(allvars{k}) = [newtab.(allvars{k});thedata.(allvars{k})(sss(ttt(1)))];
%             end
%         end
%     end
% end
% 
% outtab = struct2table(newtab);    
% 
% writetable(outtab,[outdir,'warehouse_sites.csv']);
    
%     for k = 1:length(allvars)
%         if strcmpi(allvars{k},'X') == 0 & strcmpi(allvars{k},'Y') == 0
%             
%             tmp = thedata.(allvars{k}){sss(1)};
%             
%             S(int).(allvars{k}) = tmp;
%         end
%         
%     end
%     S(int).Geometry = 'Point';
%     
%     int = int + 1;
% end
% SS = makedbfspec(S);
% 
% vars = fieldnames(SS);
% 
% for ii = 1:length(vars)
%     SS.(vars{ii}).FieldLength = 100;
% end
% 
% shapewrite(S,[outdir,'warehouse_sites.shp'],'DbfSpec', SS);






