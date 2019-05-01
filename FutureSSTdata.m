%% FutureSSTdata
% each ensemble_tos file contains a 720 x 340 -> lon x lat grid 
% lon 0:360 and lat -85:85 by 1/2 degrees
% predited sst in K

% each enseble file is also one month of one year
% the variables in the file are:
%         mean_mean_tos   ->  mean predicted sst (tos -> temp of surface)
%         minimum         ->  min predicted sst
%         maximum         ->  max predicted sst
%
% missing value =  1.000000020040877e+20

% desired lon [198.5  to 207.5]
% desired lat [23.5 to 18.5]
% this is the area that the historical SST covers
% this corresponds to [397:415,207:217]
%% Global Data
ncfile = 'ensemble_tos_rcp45_201001.nc' ; % nc file name
% To get information about the nc file
ncinfo(ncfile);
% to display nc file
ncdisp(ncfile);
% to read a vriable 'var' exisiting in nc file
sstGlobal = ncread(ncfile,'mean_mean_tos');
%this is just over hawaii and in Celcius, I hope
hawaii = sstGlobal(397:415,207:217)-273.15;
%mean(hawaii('all'))

%% how to Run Prediction Model
% steps: 
    % Load training data into Regression Learner App
    % Run all models, pick best fit
    % Export model with trained data 
    % call method: yfit = demoModelSST.predictFcn(demoFuture)
    % return: yfit, is a table with predicted values

predictedSST = zeros(50,2);
%% condencing sst 4.5 and 8.1 RCP values
%this works for one rcp
%to change the rcp, change the ncfile variable string and the column number
%that it will be read into predictedSST

%rows: year 2010-2059
%columns: rcp 2.5, rcp8.1

year = 10;
month = 0;
row = 1;
for i= 1:600
    month = month + 1;
    if (month < 10)
        ncfile = strcat('ensemble_tos_rcp45_20',num2str(year),'0',num2str(month),'.nc');
    end 
    if (month > 9)
        ncfile = strcat('ensemble_tos_rcp45_20', num2str(year),num2str(month),'.nc');
    end 

    sstGlobal = ncread(ncfile,'mean_mean_tos');
    hawaii = sstGlobal(397:415,207:217)-273.15;
     
    predictedSST(row,1) = predictedSST(row,1) + mean(hawaii('all'));
    
    if (floor(month/12) == 1) %after 12 iterations/months
        row = row + 1; %begin averaging in a new year
        year = year + 1;
        month = 0;
    end   
end 


%%
predictedSST = predictedSST/12;

%% file
% the complete predictedSST is saved as 'rcp45&85_2010-59.csv'
% which is in the FutureSSTdata file
