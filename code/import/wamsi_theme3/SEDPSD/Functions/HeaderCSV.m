function HeaderCSV(InputFlatFile,VarKey)
    Table = readtable(InputFlatFile);
    ColLetter = char(width(Table)+ 64); %1->A 2->B
    Range = ['A1:', ColLetter ,'1']; 
    Headers = readcell(InputFlatFile,"Range",Range);

    [UniqueVars,VarIndex,~] = unique(table2array(Table(:,"Var6")));
    [UniqueSites,SiteIndex,~] = unique(table2array(Table(:,"Var4")));

    OutDir = '../../../../../data-warehouse/csv/wamsi/wwmsp3.1_SEDPSD/';
    mkdir(OutDir);

    %% Create Header and CSV
    for VarNum = 1:length(UniqueVars)
        VarKeyInd = VarKey{:,2} == UniqueVars(VarNum);
        for SiteNum = 1:length(UniqueSites)
            
            %  mafrl_CB_Ammonium_Int_Data.csv
            %  mafrl_CB_Ammonium_Int_Header.csv

            fileName = [OutDir,char(UniqueSites(SiteNum)),'_',char(UniqueVars(VarNum))];
                fileName = filenameGoodifier(fileName);

            
            fid = fopen([fileName,'_DATA.csv'],'wt');
    
            fprintf(fid,'Date,Height,Data,QC\n');
            fclose(fid);
                lat = Table{SiteIndex(SiteNum),'Var2'};
                lon = Table{SiteIndex(SiteNum),'Var3'};
                ID = '';%"National Station ID";
                Desc = '';%"Site description";
                varID = VarKey{VarKeyInd,1};
                Cat = '';%'Data catergory';
                varstring = VarKey{VarKeyInd,2};
                wdate = '';
                sitedepth = '';
            write_header([fileName,'_HEADER.csv'],lat,lon,ID,Desc,varID,Cat,varstring,wdate,sitedepth);
            
        end
    end



    for DataNum = 1:height(Table)
        SiteName = table2array(Table(DataNum,"Var4"));
        VarName = table2array(Table(DataNum,"Var6"));

        fileName = [OutDir,char(SiteName) ,'_',char(VarName)];
                fileName = filenameGoodifier(fileName);


            
        fid = fopen([fileName,'_DATA.csv'],'a');

    
        
        %Date = datestr(table2array(Table(DataNum,'Var1')),'yyyy-mm-dd');
        Date = datestr(table2array(Table(DataNum,'Var1')),'yyyy-mm-dd HH:MM:SS');
        Depth = 0;
        Data = table2array(Table(DataNum,'Var8')); %HardCoded to 8
        QC = 'N';
        if ~isnan(Data)
                %fprintf(fid,'%s,%4.4f,%4.4f,%i\n',Date,Depth,Data,QC);
                fprintf(fid,'%s,%4.4f,%4.4f,%c\n',Date,Depth,Data,QC);
        end
        fclose(fid);
    end



    
end

function filename = filenameGoodifier(filename)
            filename = regexprep(filename,'>','lt');
            filename = regexprep(filename,'<','gt');
            %filename = regexprep(filename,'µ','u');
            %filename = regexprep(filename,'%','percentage');
end

