function ImportSGRESTMain()
    addpath('Functions')
    directory = "../../../../../data-swamp/WWMSP3.1 - Seagrass CutDown/WAMS23-6 WCP3.1  PSD/";
    searchReq = '*.xlsx' ;
    Seagrass = Extractor(directory,searchReq);
    Seagrass = SeagrassLatFixer(Seagrass);

    load ../../../actions/varkey.mat;
    load ../../../actions/agency.mat;
    %load ../../../actions/sitekey.mat;

    variableStruct = agency.theme3sgrest;
    VarKey = agencyMat2LachyVarkKey(variableStruct);

    %% this has been updated with agency.mat stuff
    % VarkeyAddress = "../../../../../git/data-governance/variable_key.xlsx";
    %             opts = spreadsheetImportOptions("NumVariables", 2);
    %             opts.Sheet = "MASTER KEY";
    %             opts.VariableTypes = ["string", "string"];
    %             opts.DataRange = "A345:B357";
    % VarKey = readtable(VarkeyAddress,opts);

    FFName = "../../../../../data-lake/WAMSI/wwmsp3.1_SGREST/FlatFile.csv";
    FFHeadings = ["Date","X","Y","Site","SampleID","Variable","Units","ReadingValue","VariableName","VariableType","Origin","Filename"];
    writematrix(FFHeadings,FFName)
    FillFlatFile(FFName,Seagrass,"Seagrass");


    HeaderCSV(FFName,VarKey);
end


function VarKey = agencyMat2LachyVarkKey(CurrentAgencyStruct)
    feildList = fields(CurrentAgencyStruct);

    VarKey = table();
    for i = 1:length(feildList)
        header = string(CurrentAgencyStruct.(feildList{i}).Old);
        id = string(CurrentAgencyStruct.(feildList{i}).ID);
        VarKey = [VarKey;table(id,header)];
    end
end
