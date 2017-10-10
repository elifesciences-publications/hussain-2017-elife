dist = [];
clear cell
figure
t = 1;

for i = 1:length(frame)
    for j = 1:length(frame(i).object)
        if ~isempty(frame(i).object(1,j).Xcont)
            dist = [dist; [frame(i).object(1,j).kappa_smooth]];
            cell(t,:) = [mean(abs(frame(i).object(1,j).kappa_smooth)) std(frame(i).object(1,j).kappa_smooth)];
            t = t+1;
        end
    end
end
dist=abs(dist);
hist(dist,50);
mean(dist);
std(dist);