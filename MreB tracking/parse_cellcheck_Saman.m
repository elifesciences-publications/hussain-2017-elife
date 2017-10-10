clear all
Rsq_cutoff=0.9;
Disp_cut=0.2;

Life_cutL=5;
Vel_cutL=1e-9; % low cutoff for velocity
Vel_cutH=2000; %high cutoff for velocity
Afit_cut=0.6;  %alpha cut

finaltracks = [];
finalmidline_angles = [];
final_angles = [];
finalwidths = [];
for i = [18:26]%20:23 25:35]% 166 168 170 172:2:188 190 192 194 195 197]%16:27 29:31]%]%1:17 19]%20:23 25:35]%1:17 19]%%166 168 170 172:2:188 190 192 194 195 197]% 16:27 29:31]% 1:20 [1:17 19]%20:23 26:34]%]%]%%[1:8 10:17 19:24 26:35]%[166 168 170 172:2:188 190 192 194 195 197 16:27 29:31] % 29:31]% 190 192] % %[1:8]%7 10:17 19:24 26:35]%%6]%%
%         if i<20   
             load(['X_forcellcheck_doubleknockoutcontrol_' num2str(i) '_cellchecked'])
%         else
            % load(['X_forcellcheck_12mM_' num2str(i) '_cellchecked_recheck'])
%         end
%load(['X_forcellcheck_30mM_withwidth_' num2str(i) '_cellchecked'])
%%load(['X_forcellcheck_8mM_' num2str(i) '_cellchecked'])
%load(['X_forcellcheck_PBPD2_' num2str(i) '_cellchecked'])

%load(['X_forcellcheck_PBPD3_fulltracks_' num2str(i) '_cellchecked'])
[ia] = (find([X.Rsq] >=Rsq_cutoff));

[ib] = (find([X.mag]>=Disp_cut));

ab = intersect(ia, ib);

[id]=(find([X.life]>=Life_cutL));

abd = intersect(ab, id);

[ie]=(find([X.MSD_V]>=Vel_cutL));
[ieb]=(find([X.MSD_V]<=Vel_cutH));

eb=intersect(ie, ieb);

abdeb = intersect(abd, eb);

[iF]=(find([X.Rsq_log_log_MSD]>=Afit_cut));
abdebf = intersect(abdeb, iF);

if isfield(X, 'incell')
for t =1:length(X)
   
    d = X(t).incell;
    if isempty(d)
        X(t).incell = 0;
    end
end


[ig] = (find([X.incell]==1));
abdebfg = intersect(abdebf, ig);

trackangle_midline = [X(abdebfg).theta]-[X(abdebfg).midline_angle] ;
finaltracks = [finaltracks [trackangle_midline]];
finalmidline_angles = [finalmidline_angles [X(abdebfg).midline_angle] ];
final_angles = [final_angles [X(abdebfg).theta]];
finalwidths = [finalwidths [X(abdebfg).cellwidth]];
%figure
%hist([[X(abdebfg).theta]-[X(abdebfg).midline_angle]])

%end
end
end
figure
hold on
 for i = 1:length(finaltracks)
     if finaltracks(i) < 0
         finaltracks(i) = abs(finaltracks(i) + 180);
     end
%      if finaltracks(i) > 90
%          finaltracks(i) = 180 - finaltracks(i);
%      end
         
 end
hist(abs([finaltracks]))


    

