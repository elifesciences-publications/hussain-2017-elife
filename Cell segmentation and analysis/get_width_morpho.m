k=1;
for a = [1:length(frame)]
    
    for b = 1:length(frame(1,a).object)
        X=0;
        dist =0;
        if ~isempty(frame(1,a).object(1,b).Xcont) && ~isempty(frame(1,a).object(1,b).area)
        X = [frame(1,a).object(1,b).pill_mesh];
        if ~isempty(X) && ~all(all(X==0))
            dist = sqrt(sum(([X(:,1) X(:,2)]-[X(:,3) X(:,4)]).^2,2));
        
        meandist(k) = mean(dist);
        stmeandist(k) = std(dist);
        maxdist(k) = max(dist);
        stmaxdist(k) = std(dist);
  k=k+1;
        end
        end
  
    end

end
finalmeanwidth = mean(meandist);
finalstmeanwidth = std(meandist);

finalmaxwidth = mean(maxdist);
finalstmaxwidth = std(maxdist);

%Check calibration (converting pixels to microns)!
x = [[finalmeanwidth finalstmeanwidth finalmaxwidth finalstmaxwidth]*0.0645 length(meandist)]