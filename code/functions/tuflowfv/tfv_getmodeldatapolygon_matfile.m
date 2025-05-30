function [data,c_units,isConv] = tfv_getmodeldatapolygon_matfile(rawData,filename,X,Y,sX,sY,varname,D,depth_range)
%--% Function to load the tuflowFV model output at a specified location
% (X,Y).
% Usage: H = H = getmodeldatalocation(filename,X,Y,varname)

%rawGeo = tfv_readnetcdf(filename,'timestep',1);
%clear functions
inpol = inpolygon(X,Y,sX,sY);
sss = find(inpol == 1);
pred_lims = [0.05,0.25,0.5,0.75,0.95];
num_lims = length(pred_lims);
nn = (num_lims+1)/2;
for iii = 1:length(sss)
    pt_id = sss(iii);

    
    
    if strcmp(varname{1},'H') == 0 & strcmp(varname{1},'cell_A') == 0 & strcmp(varname{1},'cell_Zb') == 0
        if isfield(rawData.savedata.(varname{1}),'Top')
        
        [data.surface(iii,:),c_units,isConv] = tfv_Unit_Conversion(rawData.savedata.(varname{1}).Top(pt_id,:),varname{1});
        else
         [data.surface(iii,:),c_units,isConv] = tfv_Unit_Conversion(rawData.savedata.(varname{1}).Bot(pt_id,:),varname{1}); 
        end
        [data.bottom(iii,:),c_units,isConv]  = tfv_Unit_Conversion(rawData.savedata.(varname{1}).Bot(pt_id,:),varname{1});
        %data.profile = rawData.(varname{1})(Cell_3D_IDs,:);
        
    else
        [data.surface(iii,:),c_units,isConv] = tfv_Unit_Conversion(rawData.savedata.(varname{1})(pt_id,:),varname{1});
        
        [data.bottom(iii,:),c_units,isConv]  = tfv_Unit_Conversion(rawData.savedata.(varname{1})(pt_id,:),varname{1});
        
    end
    
        point_D = D(pt_id,:);
        %Get curtain series of predictive limits for variable varname
    
        %ddd = find(point_D <= 0.042);
        ddd = find(point_D <= depth_range(1) | point_D >= depth_range(2));

        
        data.surface(iii,ddd) = NaN;
        data.bottom(iii,ddd) = NaN;

        
end
[~,iy] = size(data.surface);

%dat = tfv_readnetcdf(filename,'time',1);
tdate = rawData.savedata.Time;%dat.Time;

%if strcmp(varname{1},'H') == 0
    
    inc = 1;
    for i = 1:iy
        xd = data.surface(:,i);
        if sum(isnan(xd)) < length(xd)
            xd(isnan(xd)) = mean(xd(~isnan(xd)));
            data.pred_lim_ts(:,inc) = plims(xd,pred_lims);
            data.date(inc,1) = tdate(i);
            inc = inc + 1;
        end
    end
    
        inc = 1;
    for i = 1:iy
        xd = data.bottom(:,i);
        if sum(isnan(xd)) < length(xd)
            xd(isnan(xd)) = mean(xd(~isnan(xd)));
            data.pred_lim_ts_b(:,inc) = plims(xd,pred_lims);
            data.date_b(inc,1) = tdate(i);
            inc = inc + 1;
        end
    end
    
    
    
% else
%     data.date = tdate;
% end




%Set limits for predictive plot as 2.5%, 50.0% and 97.5%
%pred_lims = [0.025,0.5,0.975];

