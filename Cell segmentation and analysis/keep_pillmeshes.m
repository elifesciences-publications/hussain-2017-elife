% clear all
% % clc
% % Image name
% filename = 'bEG300_15uMIPTG';
% m='231';
% % mat file containing pillmesh
% %load([filename '_CONTOURS_pill_MESH'])
% load([filename m '_CONTOURS_pill_MESH'])
% 
% if ~exist('frame')
%     frame = y;
% end
% 
% n = m;
% info = imfinfo(['bEG300_15uMIPTG' n '.tif']);
% frames = length(frame);

clear all
clc
% Image name
filename = '20X20M-2.tif';

% mat file containing pillmesh
load('finalpillmesh_12X20M')

info = imfinfo(filename);
frames = length(frame);
rows = info(1,1).Height;
columns = info(1,1).Width;

t = 1;

for i = [1:frames]
    A = imread([filename], i);
    fig =  figure('Position', [100, 100, 1049, 895]);
    colormap(gray)
%     subplot(1,2,1)
    imagesc(A)
%     subplot(1,2,2)
%     imagesc(A)
    hold on
    for j = 1:length(frame(1,i).object)
        
            if  nonzeros(frame(1,i).object(1,j).pill_mesh)
                meshX = [frame(1,i).object(1,j).pill_mesh(:,1) frame(1,i).object(1,j).pill_mesh(:,2)];
                meshY = [frame(1,i).object(1,j).pill_mesh(:,3) frame(1,i).object(1,j).pill_mesh(:,4)];
                cell_length(t) = [frame(1,i).object(1,j).length];
                cell_width(t) = max([frame(1,i).object(1,j).width]);
                plot(meshX(:,1),meshX(:,2),'r')
                plot(meshY(:,1),meshY(:,2),'r')
                text(meshX(1,1),meshX(1,2),num2str(t), 'color','r')
                t=t+1;
                disp([ num2str(frame(1,i).object(1,j).length) ' ' num2str(max([frame(1,i).object(1,j).width]))])
                
            end
     
    end
    
    check = 1;
    
    while check
        [x y] = ginput(1);
        for k = 1:length(frame(1,i).object)
            clear mesh1 mesh2 mesh
            
            if nonzeros(frame(1,i).object(1,k).pill_mesh)
                mesh1(:,1)=frame(1,i).object(1,k).pill_mesh(:,1);
                mesh1(:,2) = frame(1,i).object(1,k).pill_mesh(:,2);
                mesh2(:,1) = flipud(frame(1,i).object(1,k).pill_mesh(:,3));
                mesh2(:,2) = flipud(frame(1,i).object(1,k).pill_mesh(:,4));
                mesh = cat(1,mesh1,mesh2);
                
                in = inpolygon(x,y,mesh(:,1),mesh(:,2));
                
                if in
                    plot(mesh(:,1),mesh(:,2),'g')
                    newframe(1,i).object(1,k)=frame(1,i).object(1,k);
                end
                
                
            end
            if x< 0 || y <0
                check = 0;
            end
            
        end
        if x< 0 || y <0
            check = 0;
        end
    end
    close all
end

%new file with deleted pill meshes
save(['finalpillmesh_xyz'], 'newframe')