function import_mafrl_2_csv
%clear all; close all;


addpath(genpath('../../functions/'));

thefile = '../../../../data-lake/CSMC/mafrl/MAFRL - WQ data - 1982 to 2020_BBEdit.xlsx';
% /'D:/csiem/data-lake/csmc/mafrl/MAFRL - WQ data - 1982 to 2020_BBEdit.xlsx';

theyears = [1983 1985 1986 1987 1990:1:1993 1997:1:2020];
%theyears = [2013];
load ../../actions/varkey.mat;
load ../../actions/agency.mat;
load ../../actions/sitekey.mat;

plotdir = 'Images/';mkdir(plotdir);



thesiteval = fieldnames(sitekey.mafrl);
thevarval = fieldnames(varkey);
theagencyval = fieldnames(agency.mafrl);


outpath = '../../../../data-warehouse/csv_holding/csmc/csmcwq/LachTest/';
%'D:/csiem/data-warehouse/csv_holding/csmc/csmcwq/';
%outpath = 'csmcwq-mafrl/';
fiderr = fopen('errorfile.csv','wt');
fprintf(fiderr,'Year,Site,Var,Foundsite,Foundvar\n');

if ~exist(outpath,'dir');mkdir(outpath);end

for i = 1:length(theyears)
    [~,sites] = xlsread(thefile,num2str(theyears(i)),'A3:A10000');
    TESTAdate = readtable(thefile,"Sheet",num2str(theyears(i)));
    sdate = TESTAdate{:,2};
    %[~,sdate] = xlsread(thefile,num2str(theyears(i)),'B3:B10000');
    [~,headers] = xlsread(thefile,num2str(theyears(i)),'C1:ZZ1');
    %[data,~] = xlsread(thefile,num2str(theyears(i)),'C3:ZZ10000');
    [sdata,~,sraw] = xlsread(thefile,num2str(theyears(i)),'C3:ZZ10000');
    data = fix_text_as_num(sdata,sraw);
    
    
    
    headers = regexprep(headers,'''','');
    
    usites = unique(sites);
    
    for j = 1:length(usites)
        
        if ~isempty(usites{j})
            
            for k = 1:length(headers)
                
                sss = find(strcmpi(sites,usites{j}) == 1);
                
                
                foundsite = 0;
                foundagency = 0;
                for mm = 1:length(thesiteval)
                    if strcmpi(sitekey.mafrl.(thesiteval{mm}).ID,usites{j}) == 1
                        disp('Found the site');
                        foundsite = mm;
                    end
                end
                
                
                    
                    for mm = 1:length(theagencyval)
                        if strcmpi(agency.mafrl.(theagencyval{mm}).Old,headers{k}) == 1
                            disp('Found the headers');
                            foundagency = mm;
                        end
                    end
                    
                    if foundsite > 0 & foundagency > 0
                    
                    thedata = [];
                    thedate = [];
                    
                    thedata = data(sss,k) * agency.mafrl.(theagencyval{foundagency}).Conv;
                    thedate = datenum(sdate(sss));
                    %thedate = datenum(sdate(sss),'dd/mm/yyyy');
                    
                    ggg = find(thedate < datenum(1832,01,01));
                    if ~isempty(ggg)
                        stop;
                    end
                    
                    
                    thedepth = {};
                    QC = {};
                    
                    for nn = 1:length(thedata)
                        switch agency.mafrl.(theagencyval{foundagency}).Depth
                            
                            case 'Int'
                                thedepth(nn,1) = {[]};%{['0 - ',num2str(sitekey.mafrl.(thesiteval{foundsite}).Depth)]};
                                
                                deployment = ['Integrated'];
                                pos = 'Water Column';
                                ref = 'Water Surface';
                                meandepth = num2str(sitekey.mafrl.(thesiteval{foundsite}).Depth);
                                
                                type = 'Depth';
                            case 'Surface'
                                thedepth(nn,1) = {'0.5'};
                                
                                deployment = ['Fixed'];
                                
                                 pos = '0.5m below Surface';
                                 ref = 'm below Surface';
                                 meandepth = num2str(sitekey.mafrl.(thesiteval{foundsite}).Depth);
                                 
                                 type = 'Depth';
                            case 'Bottom'
                                
                                deployment = ['Fixed'];
                                thedepth(nn,1) = {'0.5'};
                                %thedepth(nn,1) = {num2str(sitekey.mafrl.(thesiteval{foundsite}).Depth)};
                                pos = '0.5m above Seabed';
                                ref = 'm above Seabed';
                                meandepth = num2str(sitekey.mafrl.(thesiteval{foundsite}).Depth);
                                
                                type = 'Height';
                            otherwise
                        end
                        QC(nn,1) = {'N'};
                    end
                    
                    thefoundvar = 0;
                    for nn = 1:length(thevarval)
                        if strcmpi(thevarval{nn},agency.mafrl.(theagencyval{foundagency}).ID) == 1
                            thefoundvar = nn;
                        end
                    end
                    
                    
                    
                    
                    [lat,lon] = utm2ll(sitekey.mafrl.(thesiteval{foundsite}).X,sitekey.mafrl.(thesiteval{foundsite}).Y,-50);
                    
                    filevar = regexprep(varkey.(thevarval{thefoundvar}).Name,' ','_');
                    
                    filename = [outpath,sitekey.mafrl.(thesiteval{foundsite}).AED,'_',filevar,'_',agency.mafrl.(theagencyval{foundagency}).Depth,'_',num2str(theyears(i)),'_DATA.csv'];
                    filename
                    fid = fopen(filename,'wt');
                    fprintf(fid,'Date,%s,Data,QC\n',type);
                    for nn = 1:length(thedata)
                        if(~isnan(thedate(nn))) %% ie if it is not nan do this else ignoroe date
                            fprintf(fid,'%s,%s,%4.4f,%s\n',datestr(thedate(nn),'yyyy-mm-dd HH:MM:SS'),thedepth{nn},thedata(nn),QC{nn});
                        else
                            %fprintf(fid,'%s,%s,%4.4f,%s\n',datestr(thedate(nn),'yyyy-mm-dd HH:MM:SS'),thedepth{nn},thedata(nn),QC{nn});
                            fprintf(fid,'%s,%s,%4.4f,%s\n','yyyy-mm-dd HH:MM:SS',thedepth{nn},thedata(nn),QC{nn});
                        end

                    end
                    fclose(fid);
                    
                    headerfile = regexprep(filename,'_DATA','_HEADER');
                    headerfile
                    fid = fopen(headerfile,'wt');
                    fprintf(fid,'Agency Name,Cockburn Sound Management Council\n');
                    fprintf(fid,'Agency Code,CSMC\n');
                    fprintf(fid,'Program,Cockburn Sound Marine Water Quality Monitoring\n');
                    fprintf(fid,'Project,CSMC-WQ\n');
                    fprintf(fid,'Tag,CSMC-WQ\n');
                    fprintf(fid,'Data File Name,%s\n',regexprep(filename,outpath,''));
                    fprintf(fid,'Location,%s\n',['data-warehouse/csv/csmc/',lower('CSMWQ-WQ')]);
                    
                    
                    fprintf(fid,'Station Status,Inactive\n');
                    fprintf(fid,'Lat,%6.9f\n',lat);
                    fprintf(fid,'Long,%6.9f\n',lon);
                    fprintf(fid,'Time Zone,GMT +8\n');
                    fprintf(fid,'Vertical Datum,mAHD\n');
                    fprintf(fid,'National Station ID,%s\n',sitekey.mafrl.(thesiteval{foundsite}).ID);
                    fprintf(fid,'Site Description,%s\n',sitekey.mafrl.(thesiteval{foundsite}).Description);
                    
                    fprintf(fid,'Deployment,%s\n',deployment);
                        fprintf(fid,'Deployment Position,%s\n',pos);
                        fprintf(fid,'Vertical Reference,%s\n',ref);
                        fprintf(fid,'Site Mean Depth,%s\n',meandepth);
                    
                    
                    
                    
                    fprintf(fid,'Bad or Unavailable Data Value,NaN\n');
                    fprintf(fid,'Contact Email,\n');
                    fprintf(fid,'Variable ID,%s\n',agency.mafrl.(theagencyval{foundagency}).ID);
                    
                    fprintf(fid,'Data Category,%s\n',varkey.(thevarval{thefoundvar}).Category);
                    
                    
                    SD = mean(diff(thedate));
                    
                    fprintf(fid,'Sampling Rate (min),%4.4f\n',SD * (60*24));
                    
                    fprintf(fid,'Date,yyyy-mm-dd HH:MM:SS\n');
                    fprintf(fid,'Depth,Decimal\n');
                    
                    thevar = [varkey.(thevarval{thefoundvar}).Name,' (',varkey.(thevarval{thefoundvar}).Unit,')'];
                    
                    fprintf(fid,'Variable,%s\n',thevar);
                    fprintf(fid,'QC,String\n');
                    
                    fclose(fid);
                    %plot_datafile(filename);
                    
                    
                    
                    
                    else
                        fprintf(fiderr,'%d,%s,%s,%i,%i\n',theyears(i),usites{j},headers{k},foundsite,foundagency);
                
                    end
                
                
                
            end
            
        end
    end
end

fclose(fiderr);
fclose all;