% clear all
% clc
% 
% clear all
%for xylose = [4 8 12 15 20]
   % load(['frames' num2str(xylose) 'X0M_bEG300'])


% change to name of image
filename = 'series1_2a.tif';%['~/Documents/022915phasespace_bEG300_phase/' num2str(20) 'X10M.tif'];

info = imfinfo(filename);
frames = length(frame);

%change to name of mat file from morphometrics with contours
%load('~/Documents/022915phasespace_bEG300_phase/4X10M_10-Apr-2015_CONTOURS')

rows = info(1,1).Height;
columns = info(1,1).Width;

t = 1;

for i = 1:frames
    A = imread(filename,i);
    fig =  figure('Position', [100, 100, 1049, 895]);
    colormap(gray)
    imagesc(A)
    hold on
    for j = 1:length(frame(1,i).object)
        meshX = frame(1,i).object(1,j).Xcont
        meshY = frame(1,i).object(1,j).Ycont
        if nonzeros(meshX)
            plot(meshX,meshY,'g')
            hold on
            text(frame(1,i).object(1,j).Xcont(1),frame(1,i).object(1,j).Ycont(1),num2str(t), 'color','g')
            t=t+1;
        end
    end
    
    check = 1;
    
    while check
        [x y] = ginput(1)
        for k = 1:length(frame(1,i).object)
            clear meshX meshY
            %     mesh = 0;
            %
            
            meshX=frame(1,i).object(1,k).Xcont;
            meshY = frame(1,i).object(1,k).Ycont;
            %     mesh2(:,1) = flipud(frame(1,i).object(1,k).pill_mesh(:,3));
            %     mesh2(:,2) = flipud(frame(1,i).object(1,k).pill_mesh(:,4));
            %     mesh = cat(1,mesh1,mesh2);
            
            in = inpolygon(x,y,meshX(:),meshY(:))
            
            if in
                
                plot(meshX,meshY,'r')
                frame(1,i).object(1,k).Xcont(:) = []
                frame(1,i).object(1,k).Ycont(:) = []
                frame(1,i).object(1,k).area = []
            end
            
            
            if x< 0 || y <0
                check = 0
            end
            
        end
        if x< 0 || y <0
            check = 0
        end
    end
    close all
end

% change to name of mat file you want to save the output in
save(['frames_series1_2a_CONTOURS'],'frame')
%end

%    q =1; 
% for i = 1:frames
% 
%   
%    
%     for j = 1:length(frame(1,i).object)
%         obj=frame(1,i).object(1,j).pill_mesh;
%         if ~isempty(obj) && any(any(obj~=0))
%             w= frame(1,i).object(1,j).width; %sqrt((obj(:,4)-obj(:,2)).^2+(obj(:,3)-obj(:,1)).^2)
%           width(q) = mean(w);
%         q = q+1;
%         end
%         
%     end
%     end