
% Set up global vars
globals.MsdFitOptions = fitoptions('Method','NonlinearLeastSquares','Lower',[0 0],'Upper',[Inf Inf],'Startpoint',[0 0]);
globals.MsdFitOptions_NB = fitoptions('Method','NonlinearLeastSquares','Startpoint',[0 0]);
globals.debugtrace=0;
empt=double.empty(0,100);
fMsd = fittype('4*A*x+(B*x)^2','options', globals.MsdFitOptions);

% %get dir got batch processing.
folder_name = uigetdir('~','directory full of data'); 
binfiles = dir(fullfile(folder_name,'*.mat'));

incval=50000;


[totfiles,blah]=size(binfiles);

for filecount=1:totfiles
filename_bin = binfiles(filecount,1).name;
filepath_bin = folder_name;

tmp.str1=['opening ' num2str(filecount), ' of ' num2str(totfiles) ' files  ' filename_bin];
disp(tmp.str1);  
 
clearvars all_pairs allsize;
clearvars all_pairs_MSD reassign_error;
load(fullfile(filepath_bin,filename_bin));
all_pairs = pair_inmovie;
clear pair_inmovie
tmp.str2=['Analyzing ' num2str(filecount), ' of ' num2str(totfiles) ' files  ' filename_bin];
disp(tmp.str2);  

tstruct=struct('MSDi_D',0, 'MSDi_V',0, 'MSDi_alpha',0,'Rsq_log_log_MSDi',0,'MSDj_D',0,'MSDj_V',0,'MSDj_alpha',0,'Rsq_log_log_MSDj',0,'MSD_timestep_i',empt,'MSD_timestep_j',empt );
fMsd = fittype('4*A*x+(B*x)^2','options', globals.MsdFitOptions);

allsize=length(all_pairs); 
all_pairs_MSD=repmat(tstruct, 1, allsize);

matlabpool(2)
parfor d= 1:1:allsize
    ACmeanrsquare_i=[];
    ACmeanrsquare_j=[];
    Xvalsi=all_pairs(d).posXi(:,1);
    Yvalsi=all_pairs(d).posXi(:,2);
    XvalsTranspi=transpose(Xvalsi);
    YvalsTranspi=transpose(Yvalsi);
    
    Xvalsj=all_pairs(d).posXj(:,1);
    Yvalsj=all_pairs(d).posXj(:,2);
    XvalsTranspj=transpose(Xvalsj);
    YvalsTranspj=transpose(Yvalsj);

    lifeXi=(all_pairs(d).lifeXi);
    lifeXj=(all_pairs(d).lifeXj);
    
    end_mi=lifeXi*(0.8); 
    end_mj=lifeXj*(0.8); 

    roundcheck=end_mi-round(end_mi);
    if (roundcheck < 0.5 )
        end_mi=round(end_mi);
    else
        end_mi=round(end_mi)-1;
    end
    
    roundcheck=end_mj-round(end_mj);
    if (roundcheck < 0.5 )
        end_mj=round(end_mj);
    else
        end_mj=round(end_mj)-1;
    end
    
    ACmeanrsquare_i=[];
    checkdt=1;
    for dt = 1:(end_mi-1)
        ar1_end=end_mi-dt;
        diffxA = XvalsTranspi(1:ar1_end) - XvalsTranspi((1+dt):(end_mi));
        diffyA = YvalsTranspi(1:ar1_end) - YvalsTranspi((1+dt):(end_mi));
        ACrsquare = diffxA.*diffxA + diffyA.*diffyA;
        ACmeanrsquare_i(dt) = mean(ACrsquare);
        checkdt=dt;
    end

    
    ACmeanrsquare_j=[];
    checkdt=1;
    for dt = 1:(end_mj-1)
        ar1_end=end_mj-dt;
        diffxA = XvalsTranspj(1:ar1_end) - XvalsTranspj((1+dt):(end_mj));
        diffyA = YvalsTranspj(1:ar1_end) - YvalsTranspj((1+dt):(end_mj));
        ACrsquare = diffxA.*diffxA + diffyA.*diffyA;
        ACmeanrsquare_j(dt) = mean(ACrsquare);
        checkdt=dt;
    end
        all_pairs_MSD(d).MSD_timestep_i =ACmeanrsquare_i;
        all_pairs_MSD(d).MSD_timestep_j =ACmeanrsquare_j;
    

   
    x2i=transpose(1:end_mi-1);
    y2i=transpose(ACmeanrsquare_i(1:end_mi-1));
    x2i(isnan(x2i)) = [];
    y2i(isnan(y2i)) = [];
    y2i=double(y2i);

    %Fit MSD to a curve.
    
    OMsd = fit(x2i,y2i,fMsd);
    yOfit = 4*OMsd.A*x2i+(OMsd.B*x2i).^2;
    
    
    all_pairs_MSD(d).MSDi_D =OMsd.A;                    %diffusion componglobals.MsdFitOptionsent of fit (bounded at 0).
    all_pairs_MSD(d).MSDi_V =OMsd.B;                    %Velocity component of fit  (bounded at 0).

    X_MSD=log10(1:(end_mi-1));
    Y_MSD=log10(ACmeanrsquare_i(1:(end_mi-1)));
    X_MSD(isnan(X_MSD)) = [];
    Y_MSD(isnan(Y_MSD)) = [];

p2Msd = polyfit(X_MSD,Y_MSD,1);
    sMsd=p2Msd(1);
    all_pairs_MSD(d).MSDi_alpha = sMsd;
    
    %get Rsquared of line.
    ypredM = polyval(p2Msd,X_MSD);          % predictions
    RdevM = Y_MSD - mean(Y_MSD);            % deviations - measure of spread
    SSTM = sum(RdevM.^2);                   % total variation to be accounted for
    residM = (Y_MSD) - ypredM;              % residuals - measure of mismatch
    SSEM = sum(residM.^2);                  % variation NOT accounted for
    Rsq_log_log_MSD = 1 - SSEM/SSTM;        % percent of error explained
    all_pairs_MSD(d).Rsq_log_log_MSDi=Rsq_log_log_MSD;
      
    x2i=transpose(1:end_mj-1);
    y2i=transpose(ACmeanrsquare_j(1:end_mj-1));
    x2i(isnan(x2i)) = [];
    y2i(isnan(y2i)) = [];
    y2i=double(y2i);

    %Fit MSD to a curve.
    
    OMsd = fit(x2i,y2i,fMsd);
    yOfit = 4*OMsd.A*x2i+(OMsd.B*x2i).^2;
    
    
    all_pairs_MSD(d).MSDj_D =OMsd.A;                    %diffusion component of fit (bounded at 0).
    all_pairs_MSD(d).MSDj_V =OMsd.B;                    %Velocity component of fit  (bounded at 0).
    
%     if (globals.debugtrace == 1)
%         figure(4);
%         clf;
%         hold on;
%         plot(x2i,yOfit,'g');
%         plot(x2i,y2i,'r');
%         title(['Quadratic fit D ',num2str(OMsd.A),' V ' num2str(OMsd.B)])
%     end
    
  
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %here we get the log log alpha value out of the system, and a scatter,
    %which is a good indication of our fit.
    %this is the scatter of the of the MSD DATA
    
    %%%%%%%%%
    %NOTE I HAD THIS AT 3:end_m-1 for a while. unsure why. This is to perhaps
    %imporove the fit of the beginning few points.
    %TEST THIS?
    X_MSD=log10(1:(end_mj-1));
    Y_MSD=log10(ACmeanrsquare_j(1:(end_mj-1)));
    X_MSD(isnan(X_MSD)) = [];
    Y_MSD(isnan(Y_MSD)) = [];
%     pMsd=scatter(X_MSD,Y_MSD);
%     set(pMsd,'Visible','off');
%     %get slope of line
%     hMsd=lsline;
    p2Msd = polyfit(X_MSD,Y_MSD,1);
    sMsd=p2Msd(1);
    all_pairs_MSD(d).MSDj_alpha = sMsd;
    
    %get Rsquared of line.
    ypredM = polyval(p2Msd,X_MSD);          % predictions
    RdevM = Y_MSD - mean(Y_MSD);            % deviations - measure of spread
    SSTM = sum(RdevM.^2);                   % total variation to be accounted for
    residM = (Y_MSD) - ypredM;              % residuals - measure of mismatch
    SSEM = sum(residM.^2);                  % variation NOT accounted for
    Rsq_log_log_MSD = 1 - SSEM/SSTM;        % percent of error explained
    all_pairs_MSD(d).Rsq_log_log_MSDj=Rsq_log_log_MSD;

    if rem(d,incval) == 0 || d==1
        str2=[num2str(incval) ' on ' filename_bin];
        disp(str2);
    end 

end
[all_pairs(1:numel(all_pairs_MSD)).MSDi_D] = all_pairs_MSD.MSDi_D;
[all_pairs(1:numel(all_pairs_MSD)).MSDi_V] = all_pairs_MSD.MSDi_V;
[all_pairs(1:numel(all_pairs_MSD)).MSDi_alpha] = all_pairs_MSD.MSDi_alpha;
[all_pairs(1:numel(all_pairs_MSD)).Rsq_log_log_MSDi] = all_pairs_MSD.Rsq_log_log_MSDi;

[all_pairs(1:numel(all_pairs_MSD)).MSDj_D] = all_pairs_MSD.MSDj_D;
[all_pairs(1:numel(all_pairs_MSD)).MSDj_V] = all_pairs_MSD.MSDj_V;
[all_pairs(1:numel(all_pairs_MSD)).MSDj_alpha] = all_pairs_MSD.MSDj_alpha;
[all_pairs(1:numel(all_pairs_MSD)).Rsq_log_log_MSDj] = all_pairs_MSD.Rsq_log_log_MSDj;

[all_pairs(1:numel(all_pairs_MSD)).MSD_timestep_i] = all_pairs_MSD.MSD_timestep_i;
[all_pairs(1:numel(all_pairs_MSD)).MSD_timestep_j] = all_pairs_MSD.MSD_timestep_j;

tot=0;
tot=tot+sum([all_pairs().MSDi_D] - [all_pairs_MSD().MSDi_D]);
tot=tot+sum([all_pairs().MSDi_V] - [all_pairs_MSD().MSDi_V]);
tot=tot+sum([all_pairs().MSDi_D] - [all_pairs_MSD().MSDi_D]);
tot=tot+sum([all_pairs().MSDi_V] - [all_pairs_MSD().MSDi_V]);

tot=tot+sum([all_pairs().MSDi_alpha] - [all_pairs_MSD().MSDi_alpha]);
tot=tot+sum([all_pairs().Rsq_log_log_MSDi] - [all_pairs_MSD().Rsq_log_log_MSDi]);
tot=tot+sum([all_pairs().MSDj_alpha] - [all_pairs_MSD().MSDj_alpha]);
tot=tot+sum([all_pairs().Rsq_log_log_MSDj] - [all_pairs_MSD().Rsq_log_log_MSDj]);

if tot==0
disp('no reassigment errors found');  
reassign_error='none';
else
disp('ERROR IN ASSIGNMENT');
reassign_error='ERROR';
end

str1=['saving ' num2str(filecount), ' of ' num2str(totfiles) ' files ' filename_bin];
disp(str1); 

%setup outfile
filename_mat = strrep(filename_bin, '.mat', '');
filename_mat = strcat(filename_mat, '_MSDANAL.mat');
spacer='/';
filename_out=strcat(filepath_bin,spacer,filename_mat);
save(filename_out, 'reassign_error', 'filename_out','filename_mat','all_pairs', '-v7.3');
disp(' ');
disp(' ');
end