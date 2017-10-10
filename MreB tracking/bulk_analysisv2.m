figure
gapcheck = [];
count = 7;
xylose = 'knockout';
for file = [1:20 22:23]

    if file <10
        s1 = '~/Documents/bEG202_tagOknockout/bEG202_0.75mMxyl00';
    else
        s1 = '~/Documents/bEG202_tagOknockout/bEG202_0.75mMxyl0';
    end
    myImageFile = strcat(s1,num2str(file),'/TrackingPackage/tracks/Channel_1_tracking_result.mat');
    load(myImageFile)
    pixSize = 0.0648;
    [X] = readtracks(tracksFinal, myImageFile, pixSize, file, xylose, count);
%     [dir_tracks] = getdirtracks(X);
%     %CHANGE
%     if ~isempty(dir_tracks)
%         gapvsdp= dotprodvsdist(dir_tracks, ['xyz.txt'])
%     end
%     gapcheck = [gapcheck; gapvsdp];
% %     axis equal
% %     saveas(1,['distcheck' num2str(file) '.fig'])
% %     close all
   count = count +1; 
end

    
    