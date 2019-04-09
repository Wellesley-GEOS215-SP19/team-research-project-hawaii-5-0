%% Kalau, Nolen Belle, Grace
% loading the local Hawaii SST data
%
%% Hawaii Data
ncfile = 'SST1x1Hawaii.nc' ; % nc file name
% To get information about the nc file
ncinfo(ncfile);
% to display nc file
ncdisp(ncfile);
% to read a vriable 'var' exisiting in nc file
sstHawaii = ncread(ncfile,'sst');

%% Global Data
ncfile = 'sst.mon.mean.global.nc' ; % nc file name
% To get information about the nc file
ncinfo(ncfile);
% to display nc file
ncdisp(ncfile);
% to read a vriable 'var' exisiting in nc file
sstGlobal = ncread(ncfile,'sst');

%%  Average the SST for each year
% 
sstYearlyGlobal = zeros(360,180,127);

%sum all temps over each year then divide
for i = 1:360
    for j = 1:180
        for k = 1:1523
           sstYearlyGlobal(i,j,(floor(k/12)+1)) = sstYearlyGlobal(i,j,(floor(k/12)+1)) + sstGlobal(i,j,k);
        end 
    end 
end 

%% removes missing values by averaging over local area
%this doesn't run right now, not really sure why but since we might not
%even ever want it, I'm not gonna try and fix it at this moment -NBB

countA = 0;
countB = 0;
missingDataA = zeros(2667127,3);
missingDataB = zeros(1905,3);

for i = 1:360
    for j = 1:180
        for k = 1:127
           if (sstYearlyGlobal(i,j,k) > 1000000) %if it is missing
                  if (i>1) && (i<360) && (j>1) && (j<180) %if it isn't on edge
                      if (sstYearlyGlobal(i+1,j,k) < 10000) && (sstYearlyGlobal(i-1,j,k) < 10000) && (sstYearlyGlobal(i,j+1,k) < 10000) && (sstYearlyGlobal(i,j-1,k) < 10000)
                          %in the event that the sites around it are good
                          %and it isnt on the edge, smooth the data
                          sstYearlyGlobal(i,j,k) = (sstYearlyGlobal(i+1,j,k) + sstYearlyGlobal(i-1,j,k)+sstYearlyGlobal(i,j+1,k) + sstYearlyGlobal(i,j-1,k))/4; 
                          countB = countB + 1;
                          missingDataB(countB,:) = [i,j,k];
                      end               
                  end
                  countA = countA +1;
                  missingDataA(countA,:) = [i,j,k];
           end 
        end 
    end 
end 

%% take the yearly average
sstYearlyGlobal = sstYearlyGlobal/12;

%This is the average over each page so the value for all of Hawaii
sstYearly3D =  mean(sstYearlyGlobal,[1 2]);
sstYearlyMean = zeros(127,1);
count = 0;
for i = 1:1
    for j = 1:1
        for k = 1:127
           sstYearlyMean(k,1) = sstYearly3D(i,j,k);
           if (sstYearlyMean(k,1)>100)
               count = count +1;
           end
        end 
    end 
end 
