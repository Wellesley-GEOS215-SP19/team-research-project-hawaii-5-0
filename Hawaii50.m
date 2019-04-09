%% Grace, Nolen, and KTP
% Hawaii sea level rise

%% Step #1: load in dataset 1 --> monthly global mean sea level rise 1870-2001 from .txt file
% File info: Columns: Year, Sea Level (mm) from, Standard deva
fileID = fopen('church_white_grl_gmsl.txt','r');
rawglobalslr = fscanf(fileID,'%f %f %f',[3, Inf]);
fclose(fileID);

globalslr = rawglobalslr';

%%
%convert years from scientific notation to decimal notation
allYears = unique(fix(globalslr(:,1)))
%yearList = NaN*zeros(length(allYears),1);    
% 

k=1;
for year = allYears(1):allYears(end)              
    yearList(k,1) = year;
    indYear = find(fix(globalslr(:,1)) == year);
    yearMean = mean(globalslr(indYear,2));
    yearList(k,2) = yearMean;
    k=k+1;
end
%% Step #1a: analyze dataset 1

figure(1); clf;
%sea level (mm) by time 1860-present
plot(globalslr(:,1),globalslr(:,2));
xlabel('Years');
ylabel('Change in Sea Level (mm)');

figure(2); clf;
%sea level (mm) by time 1860-present
plot(yearList(:,1),yearList(:,2));
xlabel('Years');
ylabel('Change in Sea Level (mm)');

%% Step #2 load in dataset 2 --> local sea level rise, Hawaii cities 
% info: from 1927-present

%Var1 = year
%Var2 = month
%Var3 = day
%Var4 = sea level (units?)
% lat lon

honolulu = readtable('d057_honolulu.csv');      %21.30700	-157.86700
nawiliwili = readtable('d058_nawiliwili.csv');  %21.96700	-159.35000
kahului = readtable('d059_kahului.csv');        %20.90000	-156.46700
hilo = readtable('d060_hilo.csv');              %19.73300	-155.06700
mokuoloe = readtable('d061_mokuoloe.csv');      %21.43300	-157.80000
barberspt = readtable('d547_barberspoint.csv'); %21.32000	-158.12000
kaumalapau = readtable('d548_kaumalapau.csv');  %20.78000	-156.90000
kawaihae = readtable('d552_kawaihae.csv');      %20.03300	-155.83300

cityLat = [21.30700, 21.96700, 20.90000, 19.73300, 21.43300, 21.32000, 20.78000, 20.03300];
cityLon = [-157.86700, -159.35000, -156.46700, -155.06700, -157.80000, -158.12000, -156.90000, -155.83300]

%%
%convert years from scientific notation to decimal notation
honYears = table2array(unique(honolulu(:,1)));

k=1;
for year = honYears(1):honYears(end)              
    honList(k,1) = year;
    indYear = find(table2array(honolulu(:,1)) == year);
    yearMean = mean(table2array(honolulu(indYear,4)));
    honList(k,2) = yearMean;
    k=k+1;
end
%%
figure(3); clf;
%sea level (mm) by time 1860-present
plot(honList(:,1),honList(:,2));
xlabel('Years');
ylabel('Change in Sea Level (mm)');
%%
figure(4); clf
worldmap([18 23],[-160 -154])
geoshow('landareas.shp','FaceColor','black')
title('Tidal Gauge Locations')
scatterm(cityLat,cityLon,50,'r','filled');

%% Step #2b: For each location, average the data to yearly values

%% Step #2c: Average the 7 cities for a 'Hawaiian' Sea level data set
% maybe not do this? hard bc the cities have different time scales
% instead going to calculate rates of change, I think

%% Step #3: load in dataset 3 --> global monthly SST 1891-present from .nc file
% data from NOAA
% NBB has full global data set on her comp. It runs through SSTdata
% info: from 1891-present
%       this is only the Hawaiian subset
%       3D which goes lon X lat X time
%       time is months from 1891 January to 2019 March

ncfile = 'SST1x1Hawaii.nc' ; % nc file name
% To get information about the nc file
ncinfo(ncfile);
% to display nc file
ncdisp(ncfile);
% to read a vriable 'var' exisiting in nc file
sstHawaii = ncread(ncfile,'sst');
%% Step #3b: Average the SST for each year
% ignore the last 'page' in this file)
sstYearlyHawaii = zeros(10,6,127);

%sum all temps over each year then divide
for i = 1:10
    for j = 1:6
        for k = 1:1523
           sstYearlyHawaii(i,j,(floor(k/12)+1)) = sstYearlyHawaii(i,j,(floor(k/12)+1)) + sstHawaii(i,j,k);
        end 
    end 
end 

%removes missing values by averaging over local area
for i = 1:10
    for j = 1:6
        for k = 1:127
           if (sstYearlyHawaii(i,j,k) > 1000000)
                   sstYearlyHawaii(i,j,k) = (sstYearlyHawaii(i+1,j,k) + sstYearlyHawaii(i-1,j,k)+sstYearlyHawaii(i,j+1,k) + sstYearlyHawaii(i,j-1,k))/4;                         
           end 
        end 
    end 
end 

%take the yearly average
sstYearlyHawaii = sstYearlyHawaii/12;

%This is the average over each page so the value for all of Hawaii
sstYearly3D =  mean(sstYearlyHawaii,[1 2]);
sstYearlyMean = zeros(127,1);

for i = 1:1
    for j = 1:1
        for k = 1:127
           sstYearlyMean(k,1) = sstYearly3D(i,j,k);
        end 
    end 
end 

sstYears = zeros(127,1);
sstYears(1,1) = 1891;
for i = 2:127
    sstYears(i,1) = sstYears(i-1,1) +1;
end 

%% Step #3c Plot SST over time
plot(sstYears(2:127,:), sstYearlyMean(2:127,:));
%%
