%% Kalau, Nolen Belle, Grace
% loading the local Hawaii SST data
%
%%
ncfile = 'SST1x1Hawaii.nc' ; % nc file name
% To get information about the nc file
ncinfo(ncfile);
% to display nc file
ncdisp(ncfile);
% to read a vriable 'var' exisiting in nc file
sstHawaii = ncread(ncfile,'sst');

%%
%ncfile = 'sst.mon.mean.global.nc' ; % nc file name
% To get information about the nc file
%ncinfo(ncfile);
% to display nc file
%ncdisp(ncfile);
% to read a vriable 'var' exisiting in nc file
%sstGlobal = ncread(ncfile,'sst');