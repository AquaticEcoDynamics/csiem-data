function Seagrass = SeagrassLatFixer(Seagrass)
    rawInputTable = readtable("/Projects2/csiem-data-hub/data-swamp/WWMSP3.1 - Seagrass CutDown/SeagrassSediment_Sample_Locations LATLON.xlsx");
    
    %% CS_R14A
    Seagrass{1,4:5} = rawInputTable{6,2:3};

    %% Kwinana 1
    Seagrass{2,4:5} = rawInputTable{11,2:3};

    %% 2
    Seagrass{3,4:5} = rawInputTable{12,2:3};

     %% 3
    Seagrass{4,4:5} = rawInputTable{13,2:3};

    %% S4S7 2022
    Seagrass{10,4:5} = rawInputTable{7,2:3};

end
