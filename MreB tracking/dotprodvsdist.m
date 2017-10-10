function dotprodvsdist(X, movie)
t=1;

% Check for at least 3 tracks in vicinity
for i = 1:length(X)
    counter = 0;
    for j = 1:length(X)
        if norm(X(i).avg - X(j).avg) <= 5
            counter = counter + 1;
        end
    end
    if counter >= 3
        X(i).incell = 1;
    else
        X(i).incell = 0;       
    end
end

for i = 1:length(X)
    for j = 1:length(X)
        if i >=j && X(i).incell && X(j).incell
            mag1= X(i).mag;
            mag2= X(j).mag;
            ang1 = (X(i).theta);
            ang2 = (X(j).theta);
            dtheta =abs(ang1-ang2);
            if dtheta>90
                dtheta = 180-dtheta;
                dot_product(i,j) = mag1*mag2*cosd(dtheta);
                norm_dp(i,j) = cosd(dtheta);
                maxDP(i,j)=mag1*mag2;
                dist(i,j) = norm([X(i).avg - X(j).avg]);
            else
                dot_product(i,j) = mag1*mag2*cosd(dtheta);
                norm_dp(i,j) = cosd(dtheta);
                maxDP(i,j)=mag1*mag2;
                dist(i,j) = norm([X(i).avg - X(j).avg]);
            end
            
                if X(i).ML_frame(1) > X(j).ML_frame(1)
                    gap =  X(i).ML_frame(1) - X(j).ML_frame(2);
                else
                    gap =  X(j).ML_frame(1) - X(i).ML_frame(2);
                end
                pair_inmovie(t).moviename = X(i).moviename; 
                pair_inmovie(t).condition = X(i).condition;
                pair_inmovie(t).i = i;
                pair_inmovie(t).posXi = X(i).pos;
                pair_inmovie(t).j = j;
                pair_inmovie(t).posXj = X(j).pos;
                
                pair_inmovie(t).RsqXi = X(i).Rsq;
                pair_inmovie(t).RsqXj = X(j).Rsq;
                
                pair_inmovie(t).MSDXi = X(i).MSD;
                pair_inmovie(t).MSDXj = X(j).MSD;
                
                pair_inmovie(t).MSDXi = X(i).ML_frame;
                pair_inmovie(t).MSDXj = X(j).ML_frame;
                
                pair_inmovie(t).distanceXi = X(i).distance;
                pair_inmovie(t).distanceXj = X(j).distance;
                
                pair_inmovie(t).thetaXi = X(i).theta;
                pair_inmovie(t).thetaXj = X(j).theta;
                
                pair_inmovie(t).lifefitXi = X(i).linefit;
                pair_inmovie(t).linefitXj = X(j).linefit;
                
                pair_inmovie(t).magXi = X(i).mag;
                pair_inmovie(t).magXj = X(j).mag;
                
                pair_inmovie(t).dot_product = dot_product(i,j);
                pair_inmovie(t).maxDP = maxDP(i,j);
                pair_inmovie(t).norm_dp = norm_dp(i,j);
                pair_inmovie(t).dtheta = dtheta;
                pair_inmovie(t).pairwisedist = dist(i,j);
                pair_inmovie(t).timediff = gap;
                t = t+1;
        end
    end
end

save(['pairs_inmovie' num2str(movie)], 'pair_inmovie', '-v7.3')

end