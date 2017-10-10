function [X] = readtracks(tracksFinal, myImageFile, pixSize, file, xylose, count)

%get size of Cell list
tracks = tracksFinal;
mX=length(tracks);

for i=1:mX,

    %name GET FROM ABOVE
    X(i).moviename = myImageFile;
    X(i).condition = xylose;
    %Particle id number
    X(i).id=i;
    t = 1;
    % Getting x and y co-ordinates from the tracking output
    X(i).ML_frame=tracksFinal(i,1).seqOfEvents(:,1);
    for j = 1:8:length(tracksFinal(i,1).tracksCoordAmpCG)
     if ~isnan(tracksFinal(i,1).tracksCoordAmpCG(j))
    X(i).pos(t,1)=tracksFinal(i,1).tracksCoordAmpCG(j) * pixSize;
    X(i).pos(t,2)=tracksFinal(i,1).tracksCoordAmpCG(j+1) * pixSize;
    t= t+1;
     end
    end

    %get life of particles
    X(i).life=length(X(i).pos);

    %get out position; %ALL COMPUATION DONE ON THIS.
%     X(i).pos(:,1)=X(i).ML_x;
%     X(i).pos(:,2)=X(i).ML_y;

    %get average point (for midpoint analysis)
    X(i).avg(:,1)=mean(X(i).pos(:,1));
    X(i).avg(:,2)=mean(X(i).pos(:,2));
    
    for point1 = 1:length(X(i).pos)-1
        for point2 = 1:length(X(i).pos)-1
            if point1>point2
                dist(point1, point2) = point1-point2;
                msd(point1, point2) = sqrt(sum([X(i).pos(point1,:) - X(i).pos(point2,:)].^2));
            end
        end
    end
    
    for time = 1:length(X(i).pos)-1
        [r c] = find(dist == time);
        MSD(time) = mean(mean(msd(r,c)));
        distance(time) = sqrt(sum([X(i).pos(time+1,:) - X(i).pos(time,:)].^2));
    end
        
    X(i).distance = distance;
    X(i).MSD = MSD;
    clear dist
    clear msd
%line fitting using pca 
  
    positionmat =[X(i).pos(:,1),X(i).pos(:,2)];           
    [coeff score roots] = pca(positionmat);
    
    basis = coeff(:,1);
    normal = coeff(:,2);
    pctExplained = roots' ./ sum(roots);
    X(i).Rsq = pctExplained(1);
    meanpos = mean(positionmat,1);
    [row col] = size(positionmat);
    Xfit = repmat(meanpos,row,1) + score(:,1)*coeff(:,1)';

%store slope and angle.
    theta = atand((Xfit(1,2)-Xfit(2,2))/(Xfit(1,1)-Xfit(2,1)));
    X(i).theta=theta;
    X(i).linefit = Xfit(:,:);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %displacement / velocity section.

  %get overall displacement (start to finish)
    n = length(Xfit);
    X(i).mag=norm([X(i).linefit(n,:)]  - [X(i).linefit(1,:)]);
    
    X(i).dispdistratio = X(i).mag./sum(X(i).distance);

end
save(['X_movie_30mM' num2str(count)], 'X')