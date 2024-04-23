function reformat_ctd

addpath(genpath('../../functions/'));

basedir = '../../../../../data-lake/WAMSI/wwmsp3.1_ctd/CTD/';
%'D:\csiem\data-lake\WAMSI\wwmsp3.1_ctd\CTD\';

filelist = dir(fullfile(basedir, '**/*.csv'));  %get list of files and folders in any subfolder
filelist = filelist(~[filelist.isdir]);  %remove folders from list

[conv,trans] = xlsread('translation.xlsx','A2:E100');

outdir = '../../../../../data-warehouse/csv_holding/wamsi/wwmsp3.1_ctd/';mkdir(outdir);
%'D:\csiem\data-warehouse\csv_holding\wamsi\wwmsp3.1_ctd\';mkdir(outdir);

fid = fopen([outdir,'wwmsp_theme3.1_CTD_reformat_bbusch_working.csv'],'wt');

fprintf(fid,'Date,X,Y,Depth (m),Height (mAHD),Site,SampleID,Variable,Units,ReadingValue,VariableName,VariableType,VariableNameQualifier,AnalysisMethodCode,MeasurementInstrument,StandardUnits,LimitOfReporting,QualityCode,Filename,Weather Conditions,Observations\n');

for i = 1:length(filelist)
    
    filename = [filelist(i).folder,'/',filelist(i).name];
    %filename = [filelist(i).folder,'\',filelist(i).name];
    
    disp(filename);
    
    siteName = readmatrix(filename,"Range","B4:B4","OutputType","string");
    LatLon = readmatrix(filename,"Range","B5:B6","OutputType","string");
    %[snum,sstr,scell] = xlsread(filename,'B4:B6');
    
    sdates = readmatrix(filename,Range="B1:D1",OutputType="string");
    %[~,~,sdates] = xlsread(filename,'B1:D1');
    
    ID = char(siteName); %scell{1};
    X = char(LatLon(1)); %scell{2};
    Y = char(LatLon(2)); %scell{3};

    %ID = (siteName); %scell{1};
    %X = (LatLon(1)); %scell{2};
    %Y = (LatLon(2)); %scell{3};
    
    if isnumeric(ID)
        ID = num2str(ID);
    end
    
    %[~,headers,~] = xlsread(filename,'A8:R8');
    headers = readmatrix(filename,Range="A8:R8",OutputType="string");
    headers = regexprep(headers,',','');
    
    
    data = readtable(filename, 'ReadVariableNames', false, 'HeaderLines', 8);
    
    for j = 1:length(data.Var1)
        
        if ~isnan(data.Var1(j))
            
            
            if ~isnumeric(data.Var1(j))
                thetail = char(data.Var1(j));
                thedatestr = [num2str(sdates{1}),'-',sdates{2},'-',num2str(sdates{3}),' ',thetail];
                thedate = datenum(thedatestr,'dd-mmm-yyyy HH:MM:SS');
                
            else
                thedatestr = [num2str(sdates{1}),'-',sdates{2},'-',num2str(sdates{3})];
                thedate = datenum(thedatestr,'dd-mmm-yyyy') + data.Var1(j);
            end
            
            
            
            sampleID = [datestr(thedate,'ddmmyyyy'),'_',ID];
            
            thesite = ['site',ID];
            
            thedepth = data.Var2(j);
            theheight = data.Var3(j);
            theweather = ['"',data.Var17{1},'"'];
            if sum(ismember(data.Properties.VariableNames,['Var',num2str(18)])) > 0
                theobs = ['"',data.Var18{1},'"'];
            else
                theobs = [];
            end
            
            %theobs = regexprep(theobs,',',' ');
            
            for k = 4:16%length(headers)-2
                
                if sum(ismember(data.Properties.VariableNames,['Var',num2str(k)])) > 0
                    
                    thedata = data.(['Var',num2str(k)])(j);
                    
                    if isnumeric(thedata)
                        if ~isnan(thedata)
                            fprintf(fid,'%s,%s,%s,%6.6f,%6.6f,%s,%s,%s,%s,%6.6f,%s,%s,,Direct reading,Sea-Bird SBE19plus (sn01906585),%s,,Excellent,%s,%s,%s\n',...
                                datestr(thedate,'dd-mm-yyyy HH:MM:SS'),X,Y,thedepth,theheight,thesite,sampleID,[trans{k-3,2},' | (',trans{k-3,3},')'],trans{k-3,3},thedata,trans{k-3,2},trans{k-3,5},trans{k-3,3},filelist(i).name,theweather,theobs);
                            
                        end
                    else
                        
%                         newdata = thedata{1};
%                         
%                         newdata = regexprep(newdata,',', ' ');
%                         
%                         if ~isempty(newdata)
%                             fprintf(fid,'%s,%s,%6.6f,%6.6f,%s,%s,%s,%s,%s,To Be Added,,Direct reading,Sea-Bird SBE19plus (sn01906585),To Be Added,,Excellent,%s,%s,%s\n',...
%                                 X,Y,thedepth,theheight,sampleID,trans{2,k-4},trans{3,k-4},newdata,headers{k},filelist(i).name,theweather,theobs);
%                             
%                         end
                    end
                    
                end
            end
            
        end
    end
    
end










