function [dir_tracks] = getdirtracks(X)

[c] = (find([X.Rsq] >=0.9));
[d] = (find([X.life]>=5));
[e] = (find([X.mag]>0.3));
[f] = (find([X.dispdistratio]>0.8));
[g] = intersect(c,d);
[h] = intersect(e,f);
[dir] = intersect(g,h);
t = 1;
for i = 1:length(dir)
    counter = 0;
    clear ang
    for j = 1:length(dir)
        if norm(X(dir(i)).avg - X(dir(j)).avg) <= 5
            counter = counter + 1;
            ang(counter) = X(dir(j)).theta;
        end
    end
    stdev(i) = std(ang);
    count(i) = counter;
    numang(i) = length(ang);
    if counter >= 3
        directional(t) = dir(i);
        t = t+1;
    end
end

if exist('directional')

num_dir=size(directional);
t=1;




for i = 1:length(directional)
    dir_tracks(i).pos = X(directional(i)).pos;
    dir_tracks(i).ML = X(directional(i)).ML_frame;
    dir_tracks(i).life = X(directional(i)).life;
    dir_tracks(i).theta = X(directional(i)).theta;
    dir_tracks(i).avg = X(directional(i)).avg;
    dir_tracks(i).linefit = X(directional(i)).linefit;
    dir_tracks(i).Rsq =  X(directional(i)).Rsq;
    n = length(X(directional(i)).pos);
    dir_tracks(i).mag = norm([X(directional(i)).linefit(1,1) X(directional(i)).linefit(1,2)]-[X(directional(i)).linefit(n,1) X(directional(i)).linefit(n,2)]);
    dir_tracks(i).distance =  X(directional(i)).distance;
    dir_tracks(i).dispdistratio = X(directional(i)).dispdistratio;
    dir_tracks(i).MSD = X(directional(i)).MSD
end

figure
hold on
% 
% for i = 1:length(X)
%     plot(X(i).pos(:,1),X(i).pos(:,2),'.','color',[rand rand rand])
%     plot(X(i).linefit(:,1),X(i).linefit(:,2),'color','k');
%     %text(X(i).avg(1),X(i).avg(2),[num2str(X(i).mag)],'color','b')
% 
% end


for i =1:length(dir_tracks);
    theta = abs(dir_tracks(i).theta);
    col = (90 - theta)/90;
    c=[1-col 0 col];
    plot(dir_tracks(i).pos(:,1),dir_tracks(i).pos(:,2),'color',c)
    plot(dir_tracks(i).linefit(:,1), dir_tracks(i).linefit(:,2),'color','k');
    plot(dir_tracks(i).avg(1),dir_tracks(i).avg(2),'b*')
    %text(dir_tracks(i).avg(1),dir_tracks(i).avg(2),[num2str(dir_tracks(i).dispdistratio) ' ' num2str(i)],'color','k', 'FontSize',10)
    hold on
end
set(gca,'YDir','reverse');

else
    disp('No tracks!')
    dir_tracks=[];
end
end
