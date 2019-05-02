%% Single Variable Sea Level Predictor
% Author: Nolen Belle Bryant

%% read in the files
historicSeaLevelGlobal = readtable('globalSeaLevelMean1870_2001.csv');
historicSSTGlobal = readtable('globalSSTmean1891_2017.csv');
futureSSTGlobal = readtable('rcp45&85_2010-59_Global.csv');

%historicSeaLevelHawaii = readtable('x');
historicSSTHawaii = readtable('hawaiiSSTmean1891_2017.csv');
futureSSTHawaii = readtable('rcp45&85_2010-59.csv');
%% Model Input
%Global
futureSST45_Global(:,1) = futureSSTGlobal(:,1);
futureSST45_Global(:,2) = futureSSTGlobal(:,2);
futureSST85_Global(:,1) = futureSSTGlobal(:,1);
futureSST85_Global(:,2) = futureSSTGlobal(:,3);

futureSST45_Global.Properties.VariableNames{2} = 'SST';
futureSST85_Global.Properties.VariableNames{2} = 'SST';

%Hawaii
futureSST45_Hawaii(:,1) = futureSSTHawaii(:,1);
futureSST45_Hawaii(:,2) = futureSSTHawaii(:,2);
futureSST85_Hawaii(:,1) = futureSSTHawaii(:,1);
futureSST85_Hawaii(:,2) = futureSSTHawaii(:,3);

futureSST45_Hawaii.Properties.VariableNames{2} = 'SST';
futureSST85_Hawaii.Properties.VariableNames{2} = 'SST';

%% Prep Model Training

%Global
globalTraining(:,1) = historicSeaLevelGlobal(22:132,2);%1891-2001
globalTraining(:,2) = historicSSTGlobal(1:111,2);%1891-2001

globalTraining.Properties.VariableNames{2} = 'SST';
globalTraining.Properties.VariableNames{1} = 'SeaLevel';

%Hawaii
%hawaiiTraining(:,1) = historicSeaLevelHawaii(x,y);%1891-2001
%hawaiiTraining(:,2) = historicSSTHawaii(1:111,2);%1891-2001

%hawaiiTraining.Properties.VariableNames{2} = 'SST';
%hawaiiTraining.Properties.VariableNames{1} = 'SeaLevel';

clear futureSSTGlobal;
clear historicSeaLevelGlobal;
clear historicSSTGlobal;
clear SST;
clear historicSSTHawaii;
clear historicSeaLevelHawaii;
clear futureSSTHawaii;
%% how to Run Prediction Model
% steps: 
    % Load training data into Regression Learner App
    % Run all models, pick best fit
    % Export model with trained data 
    % call method: yfit = demoModelSST.predictFcn(demoFuture)
    % return: yfit, is a table with predicted values
%% Run the Model

futureSeaLevel45_Global = GlobalModel.predictFcn(futureSST45_Global(:,2));
futureSeaLevel85_Global = GlobalModel.predictFcn(futureSST85_Global(:,2));

%futureSeaLevel45_Hawaii = HawaiiModel.predictFcn(futureSST45_Hawaii(:,2));
%futureSeaLevel85_Hawaii = HawaiiModel.predictFcn(futureSST85_Hawaii(:,2));

%% plot
years = table2array(futureSST45_Global(:,1));

%calculate the delta from 2019
deltaSL85_Global =  futureSeaLevel85_Global-futureSeaLevel85_Global(10);

%%
figure(1); clf;
hold on;
plot(years,deltaSL85_Global);
%plot(years,futureSeaLevel45_Global);
hold off;