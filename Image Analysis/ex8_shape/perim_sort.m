% function [x y]=perim_sort(B)
% input B is a binary image with one object
% output x and y are the sorted coordinates of the perimeter pixels
% x and y are vectors

function [x,y]=perim_sort(B)

per=bwperim(B,8); % binary perimeter image

[r c]=find(per); % coordinate perimeter pixels
[k l]=size(r);
x=zeros(k,1);y=zeros(k,1); %sorted coord

x(1)=r(1); y(1)=c(1); %start coordinate
r(1)=1000; c(1)=1000; %mark point as used

diffr=r-x(1); %difference betw  all points and start pixel
diffc=c-y(1);

for n=2:k,

%diff=abs(diffr)+abs(diffc); %manhattan distance
diff=sqrt((diffr.^2) + (diffc.^2));
[a,ind]=sort(diff); %sorting minimum first

if diff(ind(1))> 4, % not connected
   x(n)=x(n-1); y(n)=y(n-1);
   r(ind(1))=1000; c(ind(1))=1000; %used
   else
   x(n)=r(ind(1)); y(n)=c(ind(1)); %add in sorting vector
   r(ind(1))=1000; c(ind(1))=1000; %used
end

diffr=r-x(n);
diffc=c-y(n);

end
%x=[x' x(1)]';%close the boundary
%y=[y' y(1)]';