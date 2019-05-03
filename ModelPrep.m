%% Single Variable Sea Level Predictor
% Author: Nolen Belle Bryant

%% read in the files
historicSeaLevelGlobal = readtable('globalSeaLevelMean1870_2001.csv');
historicSSTGlobal = readtable('globalSSTmean1891_2017.csv');
futureSSTGlobal = readtable('rcp45&85_2010-59_Global.csv');

historicSeaLevelHawaii = readtable('hawaiiSeaLevelMean1905_2019.csv');
historicSSTHawaii = readtable('hawaiiSSTmean1891_2017.csv');
futureSSTHawaii = readtable('rcp45&85_2010-59.csv');
%% Model Input
%Global
futureSST45_Global(:,1) = futureSSTGlobal(:,1);
futureSST45_Global(:,2) = futureSSTGlobal(:,2);
futureSST85_Global(:,1) = futureSSTGlobal(:,1);
futureSST85_Global(:,2) = futureSSTGlobal(:,3);

futureSST85_Global.Properties.VariableNames{2} = 'SST';

%% Hawaii
futureSST45_Hawaii(:,1) = futureSSTHawaii(:,1);
futureSST45_Hawaii(:,2) = futureSSTHawaii(:,2);
futureSST85_Hawaii(:,1) = futureSSTHawaii(:,1);
futureSST85_Hawaii(:,2) = futureSSTHawaii(:,3);

futureSST85_Hawaii.Properties.VariableNames{2} = 'SST';

%% Sort out the werid rcp45 data

%the origional data is weird. I think it is a mistake
futureSST45_Global=table2array(futureSST45_Global);
futureSST45_Global(32:50,2) = futureSST45_Global(32:50,2)-6.6302;
futureSST45_Global(27:50,2) = futureSST45_Global(27:50,2) +0.2998;

futureSST45_Hawaii = table2array(futureSST45_Hawaii);
futureSST45_Hawaii(32:50,2) = futureSST45_Hawaii(32:50,2)-2.4006;

%convert back to array and rename
futureSST45_Global=array2table(futureSST45_Global);
futureSST45_Hawaii=array2table(futureSST45_Hawaii);

futureSST45_Global.Properties.VariableNames{2} = 'SST';
futureSST45_Hawaii.Properties.VariableNames{2} = 'SST';
%% Prep Model Training

%Global
globalTraining(:,1) = historicSeaLevelGlobal(22:132,2);%1891-2001
globalTraining(:,2) = historicSSTGlobal(1:111,2);%1891-2001

globalTraining.Properties.VariableNames{2} = 'SST';
globalTraining.Properties.VariableNames{1} = 'SeaLevel';

%Hawaii
hawaiiTraining(:,1) = historicSeaLevelHawaii(1:113,2);%1905-2017
hawaiiTraining(:,2) = historicSSTHawaii(15:127,2);%1905-2017

hawaiiTraining.Properties.VariableNames{2} = 'SST';
hawaiiTraining.Properties.VariableNames{1} = 'SeaLevel';

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

futureSeaLevel45_Hawaii = HawaiiModel.predictFcn(futureSST45_Hawaii(:,2));
futureSeaLevel85_Hawaii = HawaiiModel.predictFcn(futureSST85_Hawaii(:,2));

%% plot
%calculate the delta from 2019
deltaSL85_Hawaii =  futureSeaLevel85_Hawaii-futureSeaLevel85_Hawaii(10);
deltaSL45_Hawaii =  futureSeaLevel45_Hawaii-futureSeaLevel45_Hawaii(10);
deltaSL85_Global =  futureSeaLevel85_Global-futureSeaLevel85_Global(10);
deltaSL45_Global =  futureSeaLevel45_Global-futureSeaLevel45_Global(10);

years = table2array(futureSST45_Global(:,1));
%% plot
rcp85 = [250,450];
rcp45 = [200,350];
%%
figure(1); clf;
hold on;

plot(years,deltaSL85_Hawaii);
plot(years,deltaSL45_Hawaii);
plot(years,deltaSL85_Global);
plot(years,deltaSL45_Global);
plot(2059, rcp85,'LineWidth',2 );
plot(2059, rcp45);
hold off;