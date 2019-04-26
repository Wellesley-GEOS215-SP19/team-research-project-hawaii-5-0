%% Kalau, Nolen Belle, Grace
% This data set contains sst for 127 years from 1891 to near present
% data smoothed for missing values

% sstYearlyGlobal is the yearly averages for each 1x1 square
% sstYearlyMean is the yearly average of the global sea surface

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

sstYearlyGlobal = sstYearlyGlobal/12;
%% removes missing values by averaging over local area

countA = 0;
%countB = 0;
countC = 0;
missingDataA = zeros(2667127,3);
%missingDataB = zeros(44577,3);
missingDataC = zeros(2606167,12);

for i = 1:360
    for j = 1:180
        for k = 1:127
           if (sstYearlyGlobal(i,j,k) > 100) %if it is missing
                  if (i>1) && (i<360) && (j>1) && (j<180) %if it isn't on edge
                    countC = countC+1; 
                    missingDataC(countC,1:3) = [i,j,k];
                    tempValue = 0;
                    tempCount = 0;
                    if (sstYearlyGlobal(i+1,j,k) < 100)
                      tempValue = tempValue + sstYearlyGlobal(i+1,j,k);
                      tempCount = tempCount + 1;
                      missingDataC(countC,4) = sstYearlyGlobal(i+1,j,k);
                    end
                    if (sstYearlyGlobal(i-1,j,k) < 100)
                      tempValue = tempValue + sstYearlyGlobal(i-1,j,k);
                      tempCount = tempCount + 1;
                      missingDataC(countC,5) = sstYearlyGlobal(i-1,j,k);
                    end
                    if (sstYearlyGlobal(i,j+1,k) < 100)
                      tempValue = tempValue + sstYearlyGlobal(i,j+1,k);
                      tempCount = tempCount + 1;
                      missingDataC(countC,6) = sstYearlyGlobal(i,j+1,k);
                    end
                    if (sstYearlyGlobal(i,j-1,k) < 100)
                      tempValue = tempValue + sstYearlyGlobal(i,j-1,k);
                      tempCount = tempCount + 1;
                      missingDataC(countC,7) = sstYearlyGlobal(i,j-1,k);
                    end
                    if (sstYearlyGlobal(i+1,j+1,k) < 100)
                      tempValue = tempValue + sstYearlyGlobal(i+1,j+1,k);
                      tempCount = tempCount + 1;
                      missingDataC(countC,8) = sstYearlyGlobal(i+1,j+1,k);
                    end
                    if (sstYearlyGlobal(i-1,j-1,k) < 100)
                      tempValue = tempValue + sstYearlyGlobal(i-1,j-1,k);
                      tempCount = tempCount + 1;
                      missingDataC(countC,9) = sstYearlyGlobal(i-1,j-1,k);
                    end
                    if (sstYearlyGlobal(i+1,j-1,k) < 100)
                      tempValue = tempValue + sstYearlyGlobal(i+1,j-1,k);
                      tempCount = tempCount + 1;
                      missingDataC(countC,10) = sstYearlyGlobal(i+1,j-1,k);
                    end
                    if (sstYearlyGlobal(i-1,j+1,k) < 100)
                      tempValue = tempValue + sstYearlyGlobal(i-1,j+1,k);
                      tempCount = tempCount + 1;
                      missingDataC(countC,11) = sstYearlyGlobal(i-1,j+1,k);
                    end
                    missingDataC(countC,12) = tempCount;
                    sstYearlyGlobal(i,j,k) = tempValue/tempCount; %average of good neighbors
                  end
                  %Now to smooth the missing data at the edge
                  countA = countA +1;
                  missingDataA(countA,:) = [i,j,k];
                  if (i==1) && (j>1) && (j<180)
                    tempValue = 0;
                    tempCount = 0;
                    if (sstYearlyGlobal(i+1,j,k) < 10000)
                      tempValue = tempValue + sstYearlyGlobal(i+1,j,k);
                      tempCount = tempCount + 1;
                    end
                    if (sstYearlyGlobal(360,j,k) < 10000)
                      tempValue = tempValue + sstYearlyGlobal(360,j,k);
                      tempCount = tempCount + 1;
                    end
                    if (sstYearlyGlobal(i,j+1,k) < 10000)
                      tempValue = tempValue + sstYearlyGlobal(i,j+1,k);
                      tempCount = tempCount + 1;
                    end
                    if (sstYearlyGlobal(i,j-1,k) < 10000)
                      tempValue = tempValue + sstYearlyGlobal(i,j-1,k);
                      tempCount = tempCount + 1;
                    end
                    if (sstYearlyGlobal(360,j-1,k) < 10000)
                      tempValue = tempValue + sstYearlyGlobal(360,j-1,k);
                      tempCount = tempCount + 1;
                    end
                    if (sstYearlyGlobal(360,j+1,k) < 10000)
                      tempValue = tempValue + sstYearlyGlobal(360,j+1,k);
                      tempCount = tempCount + 1;
                    end
                    if (sstYearlyGlobal(i+1,j-1,k) < 10000)
                      tempValue = tempValue + sstYearlyGlobal(i+1,j-1,k);
                      tempCount = tempCount + 1;
                    end
                    if (sstYearlyGlobal(i+1,j+1,k) < 10000)
                      tempValue = tempValue + sstYearlyGlobal(i+1,j+1,k);
                      tempCount = tempCount + 1;
                    end
                    sstYearlyGlobal(i,j,k) = tempValue/tempCount;
                  end 
                  if (i==360) && (j>1) && (j<180)
                    tempValue = 0;
                    tempCount = 0;
                    if (sstYearlyGlobal(i-1,j,k) < 10000)
                      tempValue = tempValue + sstYearlyGlobal(i-1,j,k);
                      tempCount = tempCount + 1;
                    end
                    if (sstYearlyGlobal(1,j,k) < 10000)
                      tempValue = tempValue + sstYearlyGlobal(1,j,k);
                      tempCount = tempCount + 1;
                    end
                    if (sstYearlyGlobal(i,j+1,k) < 10000)
                      tempValue = tempValue + sstYearlyGlobal(i,j+1,k);
                      tempCount = tempCount + 1;
                    end
                    if (sstYearlyGlobal(i,j-1,k) < 10000)
                      tempValue = tempValue + sstYearlyGlobal(i,j-1,k);
                      tempCount = tempCount + 1;
                    end
                    if (sstYearlyGlobal(1,j-1,k) < 10000)
                      tempValue = tempValue + sstYearlyGlobal(1,j-1,k);
                      tempCount = tempCount + 1;
                    end
                    if (sstYearlyGlobal(1,j+1,k) < 10000)
                      tempValue = tempValue + sstYearlyGlobal(1,j+1,k);
                      tempCount = tempCount + 1;
                    end
                    if (sstYearlyGlobal(i-1,j-1,k) < 10000)
                      tempValue = tempValue + sstYearlyGlobal(i-1,j-1,k);
                      tempCount = tempCount + 1;
                    end
                    if (sstYearlyGlobal(i-1,j+1,k) < 10000)
                      tempValue = tempValue + sstYearlyGlobal(i-1,j+1,k);
                      tempCount = tempCount + 1;
                    end
                    sstYearlyGlobal(i,j,k) = tempValue/tempCount; 
                  end 
                  if (j==1)&& (i>1) && (i<360)
                    tempValue = 0;
                    tempCount = 0;
                    if (sstYearlyGlobal(i+1,j,k) < 10000)
                      tempValue = tempValue + sstYearlyGlobal(i+1,j,k);
                      tempCount = tempCount + 1;
                    end
                    if (sstYearlyGlobal(i-1,j,k) < 10000)
                      tempValue = tempValue + sstYearlyGlobal(i-1,j,k);
                      tempCount = tempCount + 1;
                    end
                    if (sstYearlyGlobal(i,j+1,k) < 10000)
                      tempValue = tempValue + sstYearlyGlobal(i,j+1,k);
                      tempCount = tempCount + 1;
                    end
                    if (sstYearlyGlobal(i-1,j+1,k) < 10000)
                      tempValue = tempValue + sstYearlyGlobal(i-1,j+1,k);
                      tempCount = tempCount + 1;
                    end
                    if (sstYearlyGlobal(i+1,j+1,k) < 10000)
                      tempValue = tempValue + sstYearlyGlobal(i+1,j+1,k);
                      tempCount = tempCount + 1;
                    end
                    sstYearlyGlobal(i,j,k) = tempValue/tempCount;
                  end 
                  if (j==180) && (i>1) && (i<360)
                    tempValue = 0;
                    tempCount = 0;
                    if (sstYearlyGlobal(i+1,j,k) < 10000)
                      tempValue = tempValue + sstYearlyGlobal(i+1,j,k);
                      tempCount = tempCount + 1;
                    end
                    if (sstYearlyGlobal(i-1,j,k) < 10000)
                      tempValue = tempValue + sstYearlyGlobal(i-1,j,k);
                      tempCount = tempCount + 1;
                    end
                    if (sstYearlyGlobal(i,j-1,k) < 10000)
                      tempValue = tempValue + sstYearlyGlobal(i,j-1,k);
                      tempCount = tempCount + 1;
                    end
                    if (sstYearlyGlobal(i-1,j-1,k) < 10000)
                      tempValue = tempValue + sstYearlyGlobal(i-1,j-1,k);
                      tempCount = tempCount + 1;
                    end
                    if (sstYearlyGlobal(i+1,j-1,k) < 10000)
                      tempValue = tempValue + sstYearlyGlobal(i+1,j-1,k);
                      tempCount = tempCount + 1;
                    end
                    sstYearlyGlobal(i,j,k) = tempValue/tempCount;
                  end 
                  if (j==180) && (i==360)
                    tempValue = 0;
                    tempCount = 0;
                    if (sstYearlyGlobal(1,j,k) < 10000)
                      tempValue = tempValue + sstYearlyGlobal(1,j,k);
                      tempCount = tempCount + 1;
                    end
                    if (sstYearlyGlobal(i-1,j,k) < 10000)
                      tempValue = tempValue + sstYearlyGlobal(i-1,j,k);
                      tempCount = tempCount + 1;
                    end
                    if (sstYearlyGlobal(i,j-1,k) < 10000)
                      tempValue = tempValue + sstYearlyGlobal(i,j-1,k);
                      tempCount = tempCount + 1;
                    end
                    if (sstYearlyGlobal(i-1,j-1,k) < 10000)
                      tempValue = tempValue + sstYearlyGlobal(i-1,j-1,k);
                      tempCount = tempCount + 1;
                    end
                    if (sstYearlyGlobal(1,j-1,k) < 10000)
                      tempValue = tempValue + sstYearlyGlobal(1,j-1,k);
                      tempCount = tempCount + 1;
                    end
                    sstYearlyGlobal(i,j,k) = tempValue/tempCount;
                  end
                  if (j==180) && (i==1)
                    tempValue = 0;
                    tempCount = 0;
                    if (sstYearlyGlobal(i+1,j,k) < 10000)
                      tempValue = tempValue + sstYearlyGlobal(i+1,j,k);
                      tempCount = tempCount + 1;
                    end
                    if (sstYearlyGlobal(360,j,k) < 10000)
                      tempValue = tempValue + sstYearlyGlobal(360,j,k);
                      tempCount = tempCount + 1;
                    end
                    if (sstYearlyGlobal(i,j-1,k) < 10000)
                      tempValue = tempValue + sstYearlyGlobal(i,j-1,k);
                      tempCount = tempCount + 1;
                    end
                    if (sstYearlyGlobal(360,j-1,k) < 10000)
                      tempValue = tempValue + sstYearlyGlobal(360,j-1,k);
                      tempCount = tempCount + 1;
                    end
                    if (sstYearlyGlobal(i+1,j-1,k) < 10000)
                      tempValue = tempValue + sstYearlyGlobal(i+1,j-1,k);
                      tempCount = tempCount + 1;
                    end
                    sstYearlyGlobal(i,j,k) = tempValue/tempCount;
                  end
           end 
        end 
    end 
end 
%% Check 
countB = 0;
missingDataB = zeros(127,3);
for i = 1:360
    for j = 1:180
        for k = 1:127
           if (sstYearlyGlobal(i,j,k) > 100) %if it is missing
               countB = countB+1;
               missingDataB(k,1:3) = [i,j,k];
           end 
        end 
    end 
end 
%% take the yearly average

%This is the average over each page so the value for all of Hawaii
sstYearly3D =  mean(sstYearlyGlobal,[1 2]);
sstYearlyMean = zeros(127,1);
count = 0;
for i = 1:1
    for j = 1:1
        for k = 1:127
           sstYearlyMean(k,1) = sstYearly3D(i,j,k);
           if (sstYearlyMean(k,1)>40)
               count = count +1;
           end
        end 
    end 
end 
