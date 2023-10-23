clear all; close all;

addpath(genpath('../functions/'));

load varkey.mat;

outfilepath = 'F:\warehouse\';
filepath ='F:\warehouse\csv\';

filelist = dir(fullfile(filepath, '**\*HEADER.csv'));  %get list of files and folders in any subfolder
filelist = filelist(~[filelist.isdir]);  %remove folders from list

agency = [];
for i = 1:length(filelist)
    data(i).header = import_header([filelist(i).folder,'\',filelist(i).name]);
    agency = [agency;{data(i).header.Agency_Code}];
end

unique_agency = unique(agency);

inc = 1;

for ag = 3:length(unique_agency)

    find_agency = find(strcmpi(agency,unique_agency(ag)) == 1);

    % The datafile name.
    cockburn.(unique_agency{ag}) = [];

    for ff = 1:length(find_agency)

        disp(filelist(find_agency(ff)).name);

        headerfile = [filelist(find_agency(ff)).folder,'\',filelist(find_agency(ff)).name];
        datafile = regexprep(headerfile,'HEADER','DATA');

        % Import the header stuff
        header = import_header(headerfile);
        smd = import_header_smd(regexprep(headerfile,'HEADER','SMD'));
        header.calc_SMD = smd.calc_SMD;
        header.mAHD = smd.mAHD;
        sitecode = [header.Agency_Code,'_',header.Program_Code,'_',header.Station_ID];
        sitecode = regexprep(sitecode,'\.','');
        sitecode = [sitecode,'_',header.Deployment,'_',num2str(inc)];
        sitecode = regexprep(sitecode,'-','_');
        %sitecode = [agency,'_',num2str(randi(10000,1))];
        %sitecode = [agency,'_',num2str(i)];
        tfv_name = varkey.(header.Variable_ID).tfvName;
        tfv_conv = varkey.(header.Variable_ID).tfvConv;
        Deployment = header.Deployment;

        % Import the data stuff

        if strcmpi(tfv_name,'N/A') == 0

            % opts = detectImportOptions(datafile);
            % if sum(ismember(opts.VariableNames,'Height'))
            %     opts = setvartype(opts, 'Height', 'string');  %or 'char' if you prefer
            % else
            %     opts = setvartype(opts, 'Depth', 'string');  %or 'char' if you prefer
            % end

            % tab = readtable(datafile,opts);

            tt = import_datafile_raw(datafile);
            disp('Finished Import');
            tab = struct2table(tt);
            tab.Date = datetime(tab.Date,'ConvertFrom','datenum');
            % Downshift the data to hourly if required.
            dt = mean(diff(tab.Date));
            if datenum(dt) < 1/24
                tt2 = timetable2table(retime(table2timetable(tab),'hourly','nearest'));
                disp('Finished Downsample');
            else
                tt2 = tab;
            end


            [s,~,j] = unique(tt2.QC);
            QC_CODE = s{mode(j)};


            cockburn.(unique_agency{ag}).(sitecode).(tfv_name).QC = QC_CODE;

            cockburn.(unique_agency{ag}).(sitecode).(tfv_name).Date = datenum(tt2.Date);
            cockburn.(unique_agency{ag}).(sitecode).(tfv_name).Data = tt2.Data * tfv_conv;
            cockburn.(unique_agency{ag}).(sitecode).(tfv_name).Data_Raw = double(tt2.Data);
            if sum(ismember(tt2.Properties.VariableNames,'Depth'))
                cockburn.(unique_agency{ag}).(sitecode).(tfv_name).oDepth = tt2.Depth;
            else
                cockburn.(unique_agency{ag}).(sitecode).(tfv_name).Height = tt2.Height;
            end


            switch Deployment

                case 'Integrated'
                    cockburn.(unique_agency{ag}).(sitecode).(tfv_name).mDepth = tt2.Depth;
                case 'Fixed'

                    if sum(ismember(tt2.Properties.VariableNames,'Height'))



                        thedata = [];
                        for k = 1:length(tt2.Height)
                            thedata(k,1) = str2double(tt2.Height{k});
                        end
                        cockburn.(unique_agency{ag}).(sitecode).(tfv_name).mDepth = (str2double(header.calc_SMD) - thedata) .* -1;


                    else

                        for k = 1:length(tt2.Depth)
                            cockburn.(unique_agency{ag}).(sitecode).(tfv_name).mDepth(k,1) = str2double(tt2.Depth{k}) * -1;
                        end


                    end
                case 'Floating'
                    if isum(ismember(tt2.Properties.VariableNames,'Height'))
                        thedata = [];
                        for k = 1:length(tt2.Height)
                            thedata(k,1) = str2double(tt2.Height{k});
                        end



                        cockburn.(unique_agency{ag}).(sitecode).(tfv_name).mDepth = (thedata) .* -1;


                    else

                        for k = 1:length(tt2.Depth)
                            cockburn.(unique_agency{ag}).(sitecode).(tfv_name).mDepth(k,1) = str2double(tt2.Depth{k}) * -1;
                        end


                    end

                case 'Profile'
                    for k = 1:length(tt2.Depth)
                        cockburn.(unique_agency{ag}).(sitecode).(tfv_name).mDepth(k,1) = str2double(tt2.Depth{k}) * -1;
                    end
                otherwise

            end
            headerfield = fieldnames(header);

            for k = 1:length(headerfield)

                cockburn.(unique_agency{ag}).(sitecode).(tfv_name).(headerfield{k}) = header.(headerfield{k});
            end



            cockburn.(unique_agency{ag}).(sitecode).(tfv_name).X = header.Lon;
            cockburn.(unique_agency{ag}).(sitecode).(tfv_name).Y = header.Lat;
            cockburn.(unique_agency{ag}).(sitecode).(tfv_name).XUTM = header.X;
            cockburn.(unique_agency{ag}).(sitecode).(tfv_name).YUTM = header.Y;
            cockburn.(unique_agency{ag}).(sitecode).(tfv_name).Agency = header.Tag;
            cockburn.(unique_agency{ag}).(sitecode).(tfv_name).Units = varkey.(header.Variable_ID).tfvUnits;



            inc = inc + 1;
        end


    end


    

    if ~isempty(cockburn.(unique_agency{ag}))
        dt=whos('cockburn'); MB=dt.bytes*9.53674e-7;
        disp(['cockburn is: ',num2str(MB),'MB']);
        if MB > 1700
            save([outfilepath,unique_agency{ag},'.mat'],'cockburn','-mat','-v7.3');
        else
            save([outfilepath,unique_agency{ag},'.mat'],'cockburn','-mat','-v7.3');
        end
    end
    clear cockburn
end
