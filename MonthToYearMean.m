function [yearMeanArray] = MonthToYearMean(monthMeans)

% MonthToYearMean Converts monthly means to yearly means by condensing data
% by year
%===================================================================
%
% USAGE:  [yearMean] = MonthToYearMean(monthMeans)
%
% DESCRIPTION:
%       Use the function MonthToYearMean to loop over all months and
%       extract the means to condense to yearly means
%
% INPUT:
%    monthMeans: a table with dates (month and year) and data (numerical
%    values)
%
% OUTPUT:
%    yearMean: an array with two columns for year and data
%               col 1 = year, col 2 = data
%
% AUTHOR:   KDLTP 12 April 2019
%
% REFERENCE:
%    Written for GEOS 215: Earth System Data Science, Wellesley College
%    Data from University of Hawaii Manoa
%==================================================================

%% Read and extract the data from your station from the csv file
%convert years from scientific notation to decimal notation and put in a
%unique list; had to use table2array because of how the data was formatted
years = table2array(unique(monthMeans(:,1)));

k=1; 
for year = years(1):years(end)              
    yearMeanArray(k,1) = year; %set col 1 to the year
    indYear = table2array(monthMeans(:,1)) == year; %find all months with same year
    yearMean = mean(table2array(monthMeans(indYear,4))); %average all values
    yearMeanArray(k,2) = yearMean; %set col 2 to the average
    k=k+1;
end

end