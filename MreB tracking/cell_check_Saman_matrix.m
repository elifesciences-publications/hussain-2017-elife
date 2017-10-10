clear all
imagenum = [1];
file = [246:254]%212:218 222:231];
pixsize = 0.0648;
t=1;
for i = [18:27]
    figure
    
% %     if file(t) < 10
     cellfile =  ['~/Documents/MATLAB/Morphometrics_11_13_2013/finalpillmesh_bEG300_15uMIPTG' num2str(file(t))];
%     
    trackfile = ['~/Documents/MATLAB/MATLAB code Saman/X_doubleknockout_control_' num2str(i) ];
%     t=t+1;
%     else
%              cellfile =  ['~/Documents/MATLAB/Morphometrics_11_13_2013/finalpillmeshrecheck_bEG300_12X20M' num2str(file(t))];
%              trackfile = ['~/Documents/MATLAB/MATLAB code Saman/X_8mM_' num2str(i)];
%              t=t+1;
%     end
% cellfile =  ['~/Documents/MATLAB/Morphometrics_11_13_2013/30mMxyl0' num2str(file(t)) 'BF_CONTOURS_pill_MESH'];
%         trackfile = ['X_forcellcheck30mM_' num2str(i)];
        t = t+1;
    
    load(trackfile);
    load(cellfile);
    %frame =y;
    getdirtracks(X,pixsize);
    
    avg = [X.avg]./pixsize;
    Xavg = avg(1:2:length(avg));
    Yavg = avg(2:2:length(avg));
    
    for cells = 1:length(frame.object)
        if ~isempty(frame.object(1,cells).pill_mesh) && ~isempty(frame.object(1,cells).Xcont) && length([frame.object(1,cells).width])>=5
            polx = frame.object(1,cells).Xcont;
            poly = frame.object(1,cells).Ycont;
            
            plot(polx, poly)
            hold on
            
            centerline = frame.object(1,cells).centerline;
            
            
            
            allin = inpolygon(Xavg, Yavg, polx, poly)
            in = find(allin==1);
            out = find(allin~=1);
            
            
            
            for incells = [in]
                X(incells).incell = 1;
                X(incells).cellid = cells;
                [d,p] = min((centerline(:,1)-Xavg(incells)).^2 + (centerline(:,2)-Yavg(incells)).^2);
                
                if p == 1
                    X(incells).midline_angle = atand([centerline(p+1,2) - centerline(p,2)]/[centerline(p+1,1) - centerline(p,1)]);
                    X(incells).midline = [centerline(p+1,:); centerline(p,:)];
                elseif p == length(centerline)
                    X(incells).midline_angle = atand([centerline(p,2) - centerline(p-1,2)]/[centerline(p,1) - centerline(p-1,1)]);
                    X(incells).midline = [centerline(p,:); centerline(p-1,:)];
                else
                    X(incells).midline_angle = atand([centerline(p+1,2) - centerline(p-1,2)]/[centerline(p+1,1) - centerline(p-1,1)]);
                    X(incells).midline = [centerline(p+1,:); centerline(p-1,:)];
                end
                
                X(incells).trackangle_midline = [X(incells).theta] - [X(incells).midline_angle];
                
                if p-5 >0 && p+5 < length([frame.object(1, cells).width])
                    X(incells).cellwidth = mean([frame.object(1, cells).width(p-5:p+5)]) %calculate the mean width of the cell using 10 nearest points to the track
                elseif p-5 >0
                    X(incells).cellwidth = mean([frame.object(1, cells).width(p-5:length([frame.object(1, cells).width]))]);
                else
                    X(incells).cellwidth = mean([frame.object(1, cells).width(1:p+5)])
                end
                
                if X(incells).Rsq > 0.9 && X(incells).mag > 0.2
                    plot(X(incells).pos(:,1)/pixsize, X(incells).pos(:,2)/pixsize,'r')
                    text(X(incells).pos(1,1)/pixsize, X(incells).pos(1,2)/pixsize, num2str(incells))
                    if abs(X(incells).trackangle_midline) < 20 || abs(X(incells).trackangle_midline) > 160
                        plot(X(incells).pos(:,1)/pixsize, X(incells).pos(:,2)/pixsize,'g')
                        plot(Xavg(incells), Yavg(incells), 'k.')
                        
                    end
                else
                    plot(X(incells).pos(:,1)/pixsize, X(incells).pos(:,2)/pixsize,'k')
                end
                
                %plot(Xavg, Yavg, 'g.')
                plot(centerline(:,1), centerline(:,2))
                plot(centerline(p,1), centerline(p,2), 'bx')
                plot(frame.object(1, cells).pill_mesh(p,1), frame.object(1, cells).pill_mesh(p,2),'x')
                plot(frame.object(1, cells).pill_mesh(p,3), frame.object(1, cells).pill_mesh(p,4),'x')
                
                
                
            end
            
%             for outcells = [out]
%                 
%                 %                       if X(outcells).Rsq > 0.9 && X(outcells).mag > 0.2
%                 %                         plot(X(outcells).pos(:,1)/pixsize, X(outcells).pos(:,2)/pixsize,'r')
%                 %
%                 %                         text(X(outcells).pos(1,1)/pixsize, X(outcells).pos(1,2)/pixsize, num2str(outcells))
%                 %                     else
%                 %                         plot(X(outcells).pos(:,1)/pixsize, X(outcells).pos(:,2)/pixsize)
%                 %                       end
%                 
%                 X(outcells).incell = 0;
%                 X(outcells).cellid = [];
%                 X(outcells).midline = [];
%                 X(outcells).midline_angle = [];
%                 X(outcells).trackangle_midline =[];
%             end

        end
        
        
    end
     save(['X_forcellcheck_doubleknockoutcontrol_' num2str(i) '_cellchecked'], 'X')
    
end


