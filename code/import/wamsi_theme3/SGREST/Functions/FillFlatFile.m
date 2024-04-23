function FillFlatFile(FFName,Table,OriginStr)
    fid = fopen(FFName,'at');
    DisplayVarNames = Table.Properties.VariableNames;
    for SampleInd = 1:height(Table)
        for VariableInd = 6:18
            TableVarName = Table.Properties.VariableNames{VariableInd};
            

            %Current Format
            %["Date","X","Y","Site","SampleID","Variable","Units","ReadingValue","VariableName","VariableType","Origins","Filename"];
            fprintf(fid,'%s,',table2array(Table(SampleInd,"Sampling Date")));
            fprintf(fid,'%4.7f,',table2array(Table(SampleInd,"Latitude")));
            fprintf(fid,'%4.7f,',table2array(Table(SampleInd,"Longitude")));
            fprintf(fid,'%s,',table2array(Table(SampleInd,"Sample Name")));
            fprintf(fid,'%s,',' ');                        %Sample ID
            fprintf(fid,'%s,',TableVarName);                      %Var Name
            fprintf(fid,'%s,',' ');                          %Units
            fprintf(fid,'%4.4f,',table2array(Table(SampleInd,TableVarName)));
            fprintf(fid,'%s,',TableVarName);                      %Var Name
            fprintf(fid,'%s,','Sediment');                      %Var type
            fprintf(fid,'%s,',OriginStr);                        %Origin
            fprintf(fid,'%s,',table2array(Table(SampleInd,"FileName"))); 
            fprintf(fid,'\n');
        end

    end
    fclose(fid);


    
end
