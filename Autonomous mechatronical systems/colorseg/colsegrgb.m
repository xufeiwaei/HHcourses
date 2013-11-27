function [dist] = colsegrgb(r,g,b,rref,gref,bref);

%  function colsegrgb(r,g,b,rref,gref,bref);
%
%  functions calculates distance for each pixel in the
%  rgb-image to a reference pixel [rref,gref,bref)
%  all input parameters are of class uint8 [0..255]
%
%  distance images class uint8 [0..255];
%  255 means distance 0;    
%    0 means distance 255;


[ro,co]=size(r);   % determine image size

r=double(r)/255;   % convert all to double [0..1]
g=double(g)/255;
b=double(b)/255;
rref=rref/255;
gref=gref/255;
bref=bref/255;

for rr=1:ro,       % calculate distance
   for cc=1:co,
      difr=r(rr,cc) - rref; % [-1..1]
      difg=g(rr,cc) - gref;
      difb=b(rr,cc) - bref;
      dist(rr,cc)=sqrt(difr*difr+difg*difg+difb*difb);  % [0..sqrt(3)]
   end
end

% convert and invert distance image to uint8 [0..225]
% so that value 255 means distance 0
% and value 0 meand very far distance

factor=255/sqrt(3);
dist=uint8(round(255-(dist*factor)));
      
      


