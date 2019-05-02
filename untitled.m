%% Single Variable Sea Level Predictor
%
%
%Author: Nolen Belle Bryant

%% read in the files

historicSeaLevel = readtable('globalSeaLevelMean1870_2001.csv');
historicSST = readtable('globalSSTmean1891_2017.csv');
futureSST = readtable('rcp45&85_2010-59_Global.csv');
%% Model Input
%must go through at the end and change all the SST columbs to be names SST
futureSST45_Global(:,1) = futureSST(:,1);
futureSST45_Global(:,2) = futureSST(:,2);
futureSST85_Global(:,1) = futureSST(:,1);
futureSST85_Global(:,2) = futureSST(:,3);

%% Model Training

training(:,1) = historicSeaLevel(22:132,2);%1891-2001
training(:,2) = historicSST(1:111,2);%1891-2001
