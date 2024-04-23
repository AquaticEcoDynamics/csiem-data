function import_fpa_mqmp%clear all; close all;

load ../../actions/varkey.mat;
load ../../actions/sitekey.mat;
load ../../actions/agency.mat;

xlsfilename = '../../../../data-lake/FPA/MQMP/MQMP2002-2021_WQ_20210728.xlsx';
%'                D:\csiem\data-lake\FPA\MQMP\MQMP2002-2021_WQ_20210728.xlsx';

sheetname = {'InnerHarbourWQ';...
    'RousHeadHarbour';...
    'ShippingChannelWQ';...
    'OuterHarbourWQ';...
    };


outdir = '../../../../data-warehouse/csv/fpa/mqmp/';mkdir(outdir);
%           'D:\csiem\data-warehouse\csv\fpa\mqmp\';mkdir(outdir);


rownumber = [452,93,277,265];

fpasites = fieldnames(sitekey.fpamqmp);
fpavars = fieldnames(agency.fpamqmp);

for i = 1:length(sheetname)
    
    [~,headers] = xlsread(xlsfilename,sheetname{i},'E2:AM2');
    
    
    [~,datasites] = xlsread(xlsfilename,sheetname{i},['A8:A',num2str(rownumber(i))]);
    
    [~,~,thedata] = xlsread(xlsfilename,sheetname{i},['E8:AM',num2str(rownumber(i))]);
    
    
    [themonths] = xlsread(xlsfilename,sheetname{i},['D8:D',num2str(rownumber(i))]);
    [theyears] = xlsread(xlsfilename,sheetname{i},['C8:C',num2str(rownumber(i))]);
    
    mdate = datenum(theyears,themonths,15,12,00,00);
    
    
    usites = unique(datasites);
    
    
    for j = 1:length(usites)
        
        tmp = usites{j};
        thesite = tmp(1:end-2);
        thedepth = tmp(end);
        
        
        sss = find(strcmpi(datasites,usites{j}) == 1);
        
        foundsite = [];
        for kk = 1:length(fpasites)
            if strcmpi(sitekey.fpamqmp.(fpasites{kk}).ID,thesite) == 1
                foundsite = kk;
            end
        end
        
        for k = 1:length(headers)
            %if strcmpi(headers{k},'JUNK') == 0
                foundvar = [];
                for kk = 1:length(fpavars)
                    if strcmpi(agency.fpamqmp.(fpavars{kk}).Old,headers{k}) == 1
                        foundvar = kk;
                    end
                end
                if ~isempty(foundvar)
                varID = agency.fpamqmp.(fpavars{foundvar}).ID;
                varConv = agency.fpamqmp.(fpavars{foundvar}).Conv;
                varname = varkey.(varID).Name;
                varstring = [varname,' (',varkey.(varID).Unit,')'];
                
%                 thedatacol = thedata(:,k);
                cdata = [];
                for kk = 1:length(sss)
                    if ~isnumeric(thedata{sss(kk),k})
                        cdata(kk,1) = str2double(thedata{sss(kk),k});
                    else
                        cdata(kk,1) = thedata{sss(kk),k};
                    end
                end
                cdata = cdata * varConv;
                cdate = mdate(sss);
                cdepth(1:length(sss),1) = 0.5;
                
                if sum(~isnan(cdata)) > 0
                    
                    
                    bdb = find(~isnan(cdata) == 1);
                    
                    writedata = cdata(bdb);
                    writedate = cdate(bdb);
                    writedepth = cdepth(bdb);
                    
                    
                    lat = sitekey.fpamqmp.(fpasites{foundsite}).Lat;
                    lon = sitekey.fpamqmp.(fpasites{foundsite}).Lon;
                    
                    if strcmpi(thedepth,'T')
                        filename = [outdir,sitekey.fpamqmp.(fpasites{foundsite}).AED,'_',regexprep(varname,' ','_'),'_SURFACE__DATA.csv'];
                    else
                        filename = [outdir,sitekey.fpamqmp.(fpasites{foundsite}).AED,'_',regexprep(varname,' ','_'),'_BOTTOM__DATA.csv'];
                    end
                    
                    fid = fopen(filename,'wt');
                    if strcmpi(thedepth,'T')
                        fprintf(fid,'Date,Depth,Data,QC\n');
                    else
                        fprintf(fid,'Date,Height,Data,QC\n');
                    end
                    for kk = 1:length(writedate)
                        fprintf(fid,'%s,%4.4f,%4.4f,N\n',datestr(writedate(kk),'yyyy-mm-dd HH:MM:SS'),writedepth(kk),writedata(kk));
                    end
                    fclose(fid);
                    headerfile = regexprep(filename,'_DATA','_HEADER');
                    
                    fid = fopen(headerfile,'wt');
                    fprintf(fid,'Agency Name,Fremantle Port Authorityn\n');
                    
                    fprintf(fid,'Agency Code,FPA\n');
                    fprintf(fid,'Program,Marine Quality Monitoring Program\n');
                    fprintf(fid,'Project,MQMP\n');
                    fprintf(fid,'Tag,FPA-MQMP\n');
                    fprintf(fid,'Data File Name,%s\n',filename);
                    fprintf(fid,'Location,%s\n',['data-warehouse/csv/fpa/mqmp']);
                    
                    
                    fprintf(fid,'Station Status,Static\n');
                    fprintf(fid,'Lat,%6.9f\n',lat);
                    fprintf(fid,'Long,%6.9f\n',lon);
                    fprintf(fid,'Time Zone,GMT +8\n');
                    fprintf(fid,'Vertical Datum,mAHD\n');
                    fprintf(fid,'National Station ID,%s\n',sitekey.fpamqmp.(fpasites{foundsite}).ID);
                    fprintf(fid,'Site Description,%s\n',sitekey.fpamqmp.(fpasites{foundsite}).Description);
                    fprintf(fid,'Deployment,%s\n','Fixed');
                    if strcmpi(thedepth,'T') == 1
                        fprintf(fid,'Deployment Position,%s\n','0.5m below Surface');
                        fprintf(fid,'Vertical Reference,%s\n','m below Surface');
                    else
                        fprintf(fid,'Deployment Position,%s\n','0.5m above Seabed');
                        fprintf(fid,'Vertical Reference,%s\n','m above Seabed');
                    end
                    fprintf(fid,'Site Mean Depth,%s\n','');
                    fprintf(fid,'Bad or Unavailable Data Value,NaN\n');
                    fprintf(fid,'Contact Email,%s\n','');
                    fprintf(fid,'Variable ID,%s\n',varID);
                    
                    fprintf(fid,'Data Category,%s\n',varkey.(varID).Category);
                    
                    
                    SD = mean(diff(cdate));
                    
                    fprintf(fid,'Sampling Rate (min),%4.4f\n',SD * (60*24));
                    
                    fprintf(fid,'Date,yyyy-mm-dd HH:MM:SS\n');
                    fprintf(fid,'Depth,Decimal\n');
                    
                    
                    fprintf(fid,'Variable,%s\n',varstring);
                    fprintf(fid,'QC,String\n');
                    
                    fclose(fid);
                end
            end
        end
    end
end

