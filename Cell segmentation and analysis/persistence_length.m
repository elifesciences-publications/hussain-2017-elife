[ contour ] = makevec( frame );
[theta] = calculatedeltatheta( contour,1);
s=size(theta);
 corrsum=zeros(s(1),s(2));
 nums=zeros(s(1),s(2)); 
 corrsum0=zeros(s(2),1);
 nums0=zeros(s(2),1);
 t=1;
 for i = 1:s(2)
   
         clear sumdtheta n sumdtheta0 n0
         [sumdtheta, n, sumdtheta0,n0]=tempcorr(theta(:,i));
         
         %if ~all(sumdtheta)
         corrsum(1:length(sumdtheta),t)=sumdtheta(:);
         nums(1:length(n),t)=n(:);
         corrsum0(t)= sumdtheta0;
         nums0(t)=n0;
         t = t + 1;
         %end
 end
 
 finalsums = [transpose(corrsum0./nums0);corrsum./nums];
 numavg = zeros(200,1);
 avg=zeros(200,1);
for j = 1:100 %can be changed depending on the cutoff we want for angular correlation
    for i = 1:s(2)
        if ~isnan(finalsums(j,i))
            avg(j)=avg(j)+finalsums(j,i);
            numavg(j) = numavg(j)+1;
        end
    end
end
disp(num2str(s(2)))
avgcos = avg./numavg;
 %lavgcos=log(avgcos);
% [thetasq theta4]=sqtheta(theta(1:40));
 %l=[0:39]*60