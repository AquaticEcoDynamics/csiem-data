st = table2struct(Sediment);

outfile = 'crappy_export.csv';
fid = fopen(outfile,'wt');
fprintf(fid,'Date,X,Y,Varname,Val\n');

vars = fieldnames(st);

for i = 6:length(vars)

    thedata = {st.(vars{i})}

    for j = 1:length(thedata)
        fprintf(fid,'%s,%s,%s,',st(j).SamplingDate_,st(j).Longitude,st(j).Latitude);
        fprintf(fid,'%s,',vars{i});
        fprintf(fid,'%4.4f\n',thedata{j});
    end
end
fclose(fid);


