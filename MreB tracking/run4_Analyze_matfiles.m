Rsq_cutoff=0.9;
Disp_cut=0.2;
Timediff_cut=0;
Life_cutL=0;
Vel_cutL=1e-9; % low cutoff for velocity
Vel_cutH=2000; %high cutoff for velocity
Afit_cut=0.6;  %alpha cut

bins=0.25;
Maxdistance=3;


ALL_CONDIIONS=unique(extractfield(Allarray,'condition'));
%ALL_CONDIIONS(strncmp(ALL_CONDIIONS,'PBPhour2',7))=[];

%close all;
%figure(1)
for C=1:(length(ALL_CONDIIONS))
    CC1=ALL_CONDIIONS(C);
    CC2= CC1{1}; 
    %condmatch=structfind(Allarray,'condition',CC2);
    all_CUR_pairs=Allarray;%(condmatch);
    CC2
[ia] = (find([all_CUR_pairs.RsqXi] >=Rsq_cutoff));
[ja] = (find([all_CUR_pairs.RsqXj] >=Rsq_cutoff));
A_Rline = intersect(ia, ja);  % this is Rsq cutoff

[ib] = (find([all_CUR_pairs.magXi]>=Disp_cut));
[jb] = (find([all_CUR_pairs.magXj]>=Disp_cut));
A_Disp = intersect(ib, jb); %this is displacement cutoff

[ic] = (find(abs([all_CUR_pairs.timediff])>=Timediff_cut));
A_TDiff = ic; %this is difference between frames cutoff.

[id]=(find([all_CUR_pairs.lifeXi]>=Life_cutL));
[jd]= (find([all_CUR_pairs.lifeXj]>=Life_cutL));
A_Life = intersect(id, jd); %this is lifetime cutoff.

[ie]=(find([all_CUR_pairs.MSDi_V]>=Vel_cutL));
[je]= (find([all_CUR_pairs.MSDj_V]>=Vel_cutL));
[ieb]=(find([all_CUR_pairs.MSDi_V]<=Vel_cutH));
[jeb]= (find([all_CUR_pairs.MSDj_V]<=Vel_cutH));
A_VelL= intersect(ie,je); %this is velocity cutoff.
A_VelH= intersect(ieb,jeb); %this is velocity cutoff.
A_Vel=intersect(A_VelL,A_VelH);

[iF]=(find([all_CUR_pairs.Rsq_log_log_MSDi]>=Afit_cut));
[jF]=(find([all_CUR_pairs.Rsq_log_log_MSDj]>=Afit_cut));
A_AfitF=intersect(iF,jF);

B_RLine_Disp = intersect(A_Disp, A_Rline);
B_TDiff_Life = intersect(A_TDiff, A_Life);
B_RLine_Disp_TDiff_Life = intersect(B_RLine_Disp,B_TDiff_Life );
B_Vel_Afit = intersect(A_Vel, A_AfitF);
B_RLine_Vel_Afit=intersect(A_Rline,B_Vel_Afit);
B_RLine_Vel_Afit_Life=intersect(B_RLine_Vel_Afit,A_Life);

B_RLine_Disp_TDiff_Life_Vel_Afit = intersect(B_RLine_Disp_TDiff_Life, B_Vel_Afit);
% figure
%         for k = [B_RLine_Disp_TDiff_Life_Vel_Afit]
%             set(gca, 'YDir', 'reverse')
%             plot(Allarray(k).posXi(:,1),Allarray(k).posXi(:,2),'color', [rand rand rand])            
%             plot(Allarray(k).posXj(:,1),Allarray(k).posXj(:,2),'color', [rand rand rand])
%             text(Allarray(k).posXj(1,1),Allarray(k).posXj(1,2), num2str(Allarray(k).MSDj_V))
%             text(Allarray(k).posXi(1,1),Allarray(k).posXi(1,2), num2str(Allarray(k).MSDi_V))
%             hold on
%             axis equal
%           
%         end

%close all;
dist_dtheta = zeros(100000, 8);
dist_dp = zeros(100000, 8);
histout=[];
counter=1;
hold on
for dist = 0:bins:Maxdistance
    d1 = find([all_CUR_pairs.pairwisedist]>dist);
    d2 = find([all_CUR_pairs.pairwisedist]<=dist+bins);
    DIST = intersect(d1, d2);
    [dir] = intersect(B_RLine_Disp_TDiff_Life_Vel_Afit, DIST);
    dir_dot=mean([all_CUR_pairs(dir).dot_product]);
    dir_ndot = mean([all_CUR_pairs(dir).norm_dp])
    dir_maxDP=mean([all_CUR_pairs(dir).maxDP]);
    stdev_dp = std([all_CUR_pairs(dir).dot_product]./[all_CUR_pairs(dir).maxDP]);
    dir_mean=dir_dot/dir_maxDP;
    dir_num=length(dir);
    histout(counter,:)=[dist, dir_mean, stdev_dp, dir_ndot, dir_num];
 %    figure
%     hist([all_CUR_pairs(dir).dtheta]);
%     alldtheta = [all_CUR_pairs(dir).dtheta];
%     alldtheta = alldtheta(:);
%     save([CC2 '_alldtheta_' num2str(counter)  '_bin' num2str(bins*1000) 'nm'], 'alldtheta', '-v7.3');
%     
%     dist_dp = [all_CUR_pairs(dir).norm_dp];
%     dist_dp = dist_dp(:);
%     save([CC2 '_alldp_' num2str(counter) '_bin' num2str(bins*1000) 'nm'],  'dist_dp', '-v7.3');
    
    counter=counter+1;
%      if dist == 2.5
%          figure
%         for k = [dir]
%             if Allarray(k).dtheta < 45
%             plot(Allarray(k).posXi(:,1),Allarray(k).posXi(:,2),'color', [rand rand rand])
%             text(Allarray(k).posXi(1,1),Allarray(k).posXi(1,2), num2str(Allarray(k).thetaXi))
%             hold on
%             plot(Allarray(k).posXj(:,1),Allarray(k).posXj(:,2),'color', [rand rand rand])
%             text(Allarray(k).posXj(1,1),Allarray(k).posXj(1,2), num2str(Allarray(k).thetaXj))
%             axis equal
%             end
%         end
%      end
 %figure
 

end

end

% s1 = find([Allarray.pairwisedist]<=3);
% s2 = find([Allarray.intersect]==1);
% S = intersect(s1, s2);
% 
% allintersecting_directional = intersect(S, B_RLine_Disp_TDiff_Life_Vel_Afit);
% 
% a1 = unique([Allarray.i]);
% A = intersect(a1, B_RLine_Disp_TDiff_Life_Vel_Afit);
% 
% figure
% for i = allintersecting_directional
% hold on
% plot(Allarray(i).linefitXi(:,1)/0.11, Allarray(i).linefitXi(:,2)/0.11,'r*')
% plot(Allarray(i).linefitXj(:,1)/0.11, Allarray(i).linefitXj(:,2)/0.11, 'g*')
% end
% 
% for i = A
% hold on
% plot(Allarray(i).linefitXi(:,1)/0.11, Allarray(i).linefitXi(:,2)/0.11)
% plot(Allarray(i).linefitXj(:,1)/0.11, Allarray(i).linefitXj(:,2)/0.11)
% end
% totaltracks = length(A)
% totalintersections = length(allintersecting_directional)
% 
% titlestr=strcat('Rsq cut=', num2str(Rsq_cutoff), ' Disp cut=',num2str(Disp_cut), ' Life cut=',num2str(Life_cutL), ' Afit cut=', num2str(Afit_cut), ' Bins=', num2str(bins));
% plot(histout(:,1),histout(:,2))
% figure(1)
% legend(ALL_CONDIIONS);
% title(titlestr);
% 
% figure(2)
% plot(histout(:,1),histout(:,4))
% legend(ALL_CONDIIONS);
% title(titlestr);
% 
% hold off

