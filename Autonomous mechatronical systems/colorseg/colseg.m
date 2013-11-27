function [dist] = colseg(n1,n2,ref1,ref2);

%  function [dist] = colseg(n1,n2,ref1,ref2);
%
%   colseg performs colour segmentation
%   based on normalized colors
%   as described in Paper "Real Time Color Classification"
%   by Gunzinger, Mathis, Guggenbuhl
%
%   Input is two of the three normailzed color images
%   and the corresponding cluster center ref 1and ref 2
%   n1,n2  class uint8  [0..255]
%   ref1, ref2 normalized color coord [0..1]
%
%   distance images class uint8 [0..255];
%   255 means distance 0  (very close);    
%   0 means distance 255  (very far);


[ro,co]=size(n1);   % detetmine size

n1=double(n1)/255;  % convert to class double[0..1]
n2=double(n2)/255;

for rr=1:ro,        % calculate differences
   for cc=1:co,
      dif1=n1(rr,cc) - ref1; % [-1..1]
      dif2=n2(rr,cc) - ref2; % [-1..1]
      dist(rr,cc)=sqrt(dif1*dif1+dif2*dif2);  % [0..sqrt(2)]
   end
end

% convert distance to uint8 and invert it 
% so that distance 0 gets value 255

factor=255/sqrt(2);
dist=uint8(round(255-(dist*factor)));
      
      


