
% %get dir got batch processing.
folder_name = uigetdir('~/Desktop','directory full of data'); 
binfiles = dir(fullfile(folder_name,'*.mat'));

Allarray=[];
[totfiles,blah]=size(binfiles);

for filecount=1:totfiles
filename_bin = binfiles(filecount,1).name;
filepath_bin = folder_name;
filenameIN = filename_bin;
all_pairs=[];
all_pairsV=[];

str1=['opening ' num2str(filecount), ' of ' num2str(totfiles) ' files  ' filename_bin];
disp(str1);  

load(fullfile(filepath_bin,filename_bin));
all_pairsV = all_pairs;
if isfield(all_pairsV, 'ML_frameXi')
all_pairsV=rmfield(all_pairsV, {'ML_frameXi' , 'ML_frameXj' });
end

if isfield(all_pairsV, 'Rqs_log_log_MSD_Xi')
all_pairsV=rmfield(all_pairsV, {'Rqs_log_log_MSD_Xi' , 'Rqs_log_log_MSD_Xj' , 'Rqs_MSD_alpha_Xi' , 'Rqs_MSD_alpha_Xj' , 'Rqs_MSD_D_Xi' , 'Rqs_MSD_D_Xj' , 'Rqs_MSD_V_Xi' , 'Rqs_MSD_V_Xj' , 'Rqs_MSD_timestep_Xi' , 'Rqs_MSD_timestep_Xj'});
end

Allarray = [Allarray, all_pairsV];
end

filename_mat = strrep(filename_bin, '.mat', '');
filename_mat = strcat(filename_mat,'_',num2str(totfiles),'_','files_combined.mat');
spacer='/';
filename_out=strcat(filepath_bin,spacer,filename_mat);
save(filename_out, 'Allarray', '-v7.3');
