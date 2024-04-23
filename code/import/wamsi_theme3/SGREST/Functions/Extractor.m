function AllTable = Extractor(directory,searchReq)
    filelist = dir(fullfile(directory,searchReq));
    NumOfFiles = length(filelist);
    
    %Populating Data Matrix and Variable Name Vec
    for FileIndex = 1:NumOfFiles
        FilePath = [filelist(FileIndex).folder,'/',filelist(FileIndex).name];
    
        NumericTable = readtable(FilePath,Range = "A25:B37");
    
            opts = spreadsheetImportOptions("NumVariables", 2);
            opts.Sheet = "Report";
            opts.VariableTypes = ["string", "string"];
            opts.DataRange = "A11:B12";
        StringTable = readtable(FilePath,opts);
        StringTable = [StringTable ;array2table(["FileName",filelist(FileIndex).name])];
        
        if FileIndex == 1
            VariableNamesRowVec = [StringTable.Var1' NumericTable.Var1'];
    
            NumOfNumeric = length(NumericTable.Var1');
            NumericData = nan(NumOfFiles,NumOfNumeric);
    
            NumOfString = length(StringTable.Var1');
            StringData = strings(NumOfFiles,NumOfString);
    
            NumOfVars = NumOfString + NumOfNumeric;
        end
        
        for VarIndex = 1:NumOfNumeric
            NumericData(FileIndex,:) = NumericTable.Var2';  
        end
        
        for VarIndex = 1:NumOfString
            StringData(FileIndex,:) = StringTable.Var2';  
        end
    
        StringData(FileIndex,2) = datestr(StringData(FileIndex,2),'dd/mm/yyyy');
    
    end
    
    vartypes = strings(NumOfVars,1);
    for i = 1:NumOfString
        vartypes(i) = "string";
    end
    for i = NumOfString+1:NumOfVars
        vartypes(i) = "double";
    end
    
    AllTable = table('Size',[NumOfFiles,NumOfVars],'VariableTypes',vartypes,'VariableNames',VariableNamesRowVec);
    AllTable(:,VariableNamesRowVec(1:NumOfString)) = array2table(StringData(:,1:NumOfString));
    AllTable(:,VariableNamesRowVec(NumOfString+1:NumOfVars)) = array2table(NumericData(:,1:NumOfNumeric));

    %Adding Lat and Long
    LatLong = table('Size',[NumOfFiles,2],'VariableTypes',["double","double"],'VariableNames',["Latitude","Longitude"]);
    Dict = ReadInCoordDictionary("../../../../../data-swamp/WWMSP3.1 - Sediment Quality CutDown/Study areas and site locations/3.1_coordinates_edited.csv", [2, Inf]);
    for i = 1:NumOfFiles
        Logical = table2array(AllTable(i,'Sample Name:')) == Dict.Title;
        if sum(Logical) > 0 
            Index = find(Logical);
            Index = Index(1);
            LatLong(i,'Latitude') = Dict(Index,"Latitude");
            LatLong(i,'Longitude') = Dict(Index,"Longitude");
        end
    end
    AllTable = [AllTable(:,VariableNamesRowVec(1:NumOfString)) , LatLong, AllTable(:,VariableNamesRowVec(NumOfString+1:end)) ];
    

    %% Changing Table to match the WIR variable names
        % To get the cell array of varibale names straight from AllTable
        %WIRVarNames = AllTable.Properties.VariableNames'
        load("TableNamesWIRStructered.mat");

        AllTable.Properties.VariableNames = WIRVarNames';
        
end



