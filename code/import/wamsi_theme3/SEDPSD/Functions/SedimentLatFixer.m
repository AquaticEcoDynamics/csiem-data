function Sediment = SedimentLatFixer(Sediment)
    rawInputTable = readtable("../../../../../data-swamp/WWMSP3.1 - Sediment Quality CutDown/Baseline_sediment_site_location LATLON.xlsx");
    
    %% AJ 1
    Sediment{9,4:5} = rawInputTable{5,5:6};
    %% 2
    Sediment{10,4:5} = rawInputTable{5,5:6};
    %% 3
    Sediment{11,4:5} = rawInputTable{5,5:6};

    %% G3
    Sediment{13,4:5} = rawInputTable{20,5:6};

    %% JBH
    Sediment{14,4:5} = rawInputTable{9,5:6};

     %% KJB
    Sediment{15,4:5} = rawInputTable{15,5:6};

end
