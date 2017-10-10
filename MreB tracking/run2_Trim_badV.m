
% %get dir got batch processing.
folder_name = uigetdir('~','directory full of data'); 
binfiles = dir(fullfile(folder_name,'*.mat'));
Vel_cut=1e-9;

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

[Vie]=(find([all_pairs.MSDi_V]>=Vel_cut));
[Vje]= (find([all_pairs.MSDj_V]>=Vel_cut));
[Vieb]=(find([all_pairs.MSDi_V]<=Vel_cut));
[Vjeb]= (find([all_pairs.MSDj_V]<=Vel_cut));
A_Vel= intersect(Vie,Vje); %this is velocity cutoff.

all_pairsV=all_pairs(A_Vel);

filename_mat = strrep(filename_bin, '.mat', '');
filename_mat = strcat(filename_mat, '_MSD_VCUT.mat');
spacer='/';
filename_out=strcat(filepath_bin,spacer,filename_mat);
save(filename_out, 'filenameIN', 'filename_out','filename_mat','all_pairsV', '-v7.3');
end
