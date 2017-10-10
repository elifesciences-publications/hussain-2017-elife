% clear all 
% 
% 
 %filename = '~/Documents/Manuscript_Figures_Aug2015/Figure1/C/0mM_Mg/12X0M.tif';
% 
%info = imfinfo(filename);
%frames = numel(info);
%load('frames15X20M_bEG300')
%columns = info(1,1).Width;

t=1;
for i = 1:length(frame)
 %   A = imread(filename,i);
    figure 
  %  colormap(gray)
   % imagesc(A)
    hold on 
    for j = 1:length(frame(1,i).object)
        if ~isempty(frame(1,i).object(1,j).Xcont)
X = frame(1,i).object(1,j).Xcont;
Y = frame(1,i).object(1,j).Ycont;

plot(X,Y,'r.')
text(frame(1,i).object(1,j).Xcont(1),frame(1,i).object(1,j).Ycont(1),num2str(t), 'color','g')

t = t+1;
axis equal
        end
    end
    pause
   % close all
    
end

