function [ deltatheta ] = calculatedeltatheta( contours,n )
%Summary 
%This function calculates the angle difference between each point and the
%nth point away from it. Use n = 1 for successive points 
[m, o] = size(contours);
l=1;

for j = 1:2:o
    k=1;
    for i = 1:m-n
        
        xpos =contours(i+n,j)-contours(i,j);
        ypos=contours(i+n,j+1)-contours(i,j+1);
        
        if floor(abs(xpos))==abs(xpos) && floor(abs(ypos))==abs(ypos)
            
        elseif contours(i+n,j) == 0 && contours(i+n,j+1)==0
            
%         elseif contours(i+n,j) == 0 && contours(i+n,j+1)==0
%             deltatheta(k,l) = atand((contours(i+n,j+1)-contours(i,j+1))/(contours(i+n,j)-contours(i,j)));
            
        elseif xpos > 0 && ypos > 0
            deltatheta(k,l) = atand((contours(i+n,j+1)-contours(i,j+1))/(contours(i+n,j)-contours(i,j))); %arctan[(y2-y1)/(x2-x1)]
        elseif xpos < 0 && ypos > 0
            deltatheta(k,l) = 180 + atand((contours(i,j+1)-contours(i+n,j+1))/(contours(i,j)-contours(i+n,j)));
        elseif xpos > 0 && ypos < 0
            deltatheta(k,l) = 360 + atand((contours(i,j+1)-contours(i+n,j+1))/(contours(i,j)-contours(i+n,j)));
        elseif xpos < 0 && ypos < 0
            deltatheta(k,l) = 180 + atand((contours(i,j+1)-contours(i+n,j+1))/(contours(i,j)-contours(i+n,j)));
        end
        k = k+1;
        
        
    end
    l = l+1;
end

% 
% for j = 1:o/2
%     
%     for i = 1:m-n-1
%     check = 0;
%         for k = 1:1:m-n-1
%            if i >=j
%         deltatheta(i,j)=theta(i,j)-theta(k,j);
%         
%         if abs(deltatheta(i,j))>=90
%             check =1;
%         end
%         
%         if check
%             deltatheta(i,j)=0;
%         end
%            end
%     end
% end

end

