%% FutureSSTdata
% information about the data set:
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

% information about this script:
% predictedSSTHawaii -> holds the predicted sst yearly average for Hawaii
% predictedSSTGlobal -> holds the predicted sst yearly average for world
%     these outputs are saved as:
%     rcp45&85_2010-59.csv
%     rcp45&85_2010-59_Global.csv

% Author: Nolen Belle Bryant
    
%% file
% the complete predictedSSTHawaii is saved as 'rcp45&85_2010-59.csv'
% which is in the FutureSSTdata file


% ^this could also be run for a global average but missing values would
% have to be taken out first.
%% condencing sst 4.5 and 8.1 RCP values
%rows: year 2010-2059
%columns: rcp 2.5, rcp8.1

predictedSSTHawaii = zeros(50,2);
predictedSSTGlobal = zeros(50,2);

year = 10;
month = 0;
row = 1;
column = 1;
rcp = '45';

for i= 1:1200
    month = month + 1;
    %iterate through and open all the data files
    if (month < 10)
        ncfile = strcat('ensemble_tos_rcp',rcp,'_20',num2str(year),'0',num2str(month),'.nc');
    end 
    
    if (month > 9)
        ncfile = strcat('ensemble_tos_rcp',rcp,'_20', num2str(year),num2str(month),'.nc');
    end 
    
    sstGlobal = ncread(ncfile,'mean_mean_tos')-273.15; %open the sst values
    hawaii = sstGlobal(397:415,207:217); %take just the Hawaiian values
    
    mask = (sstGlobal > 1000); %find all of the missing values
    sstGlobal(mask) = NaN; %set those values to NaN so that we can take the mean without them
    
    %add the mean values to the correct places in the arrays
    predictedSSTHawaii(row,column) = predictedSSTHawaii(row,column) + mean(hawaii('all'));
    predictedSSTGlobal(row,column) = predictedSSTGlobal(row,column) + nanmean(sstGlobal,'all');
    
    %track when all the months of one year have been read
    if (floor(month/12) == 1) %after 12 iterations/months
        row = row + 1; %begin averaging in a new year
        year = year + 1;
        month = 0;
    end   
    
    %track when all the rcp45 values have been opened
    if (i==600)
            rcp = '85';
            column = 2;
            year = 10;
            row = 1;
    end
end 

%% Average the monthly total
predictedSSTHawaii = predictedSSTHawaii/12;
predictedSSTGlobal = predictedSSTGlobal/12;

%% Testing/Debugging code

%ncfile = 'ensemble_tos_rcp45_201011.nc';
%sstGlobal = ncread(ncfile,'mean_mean_tos');
%mask = (sstGlobal > 1000); %find all of the missing values
%sstGlobal(mask) = NaN; %set those values to NaN so that we can take the mean without them

