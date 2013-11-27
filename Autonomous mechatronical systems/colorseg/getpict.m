function [rgb,r,g,b,i,rn,gn,bn] = getpict(filename);

% function [rgb,r,g,b,i,rn,gn,bn] = getpict(filename);
% 
% filename is a string e.g.   getpict('test');
%
% getpict reads an picture from file taken by the Quickcam.
% file format should be .bmp
%
% Functions returns 
%     rgb image        class uint [0..255]   (1..rows,1..cols,1..3) 
%     r   red   image  class uint [0..255]   (1..rows,1..cols)
%     g   green image  class uint [0..255]   (1..rows,1..cols)
%     b   blue  image  class uint [0..255]   (1..rows,1..cols)
%     i   gray  image  class uint [0..255]   (1..rows,1..cols)
%         i = 0.33 r + 0.33 g + 0.33 b
%     rn  normalized red class uint [0..255]  (1..rows,1..cols)
%         rn = 0.33 r / i
%     gn  normalized green class uint [0..255]  (1..rows,1..cols)
%     bn  normalized blue  class uint [0..255]  (1..rows,1..cols)
%
% Note that the size can be obtained by size(rgb);

rgb=imread(filename,'bmp'); % rgb is of class uint [0.255]

[ro,co,n]=size(rgb);      % find size of rgb image  n = 3

r=rgb(1:ro,1:co,1);       % extract red   image   class uint
g=rgb(1:ro,1:co,2);       % extract green image   class uint
b=rgb(1:ro,1:co,3);       % extract blue  image   class uint

kr = 0.333;   %  weight of color factors
kg = 0.333;   %  either this factors or more like human experience
kb = 0.333;   %  kr = 0.3 kg = 0.59 kb= 0.11    (used in NTSC TV)

i=kr*double(r) + kg*double(g) + kb*double(b);    
								% calculate gray level                      
								% class double [0..255]
rn=kr* double(r)./i;    % calculate normalized red image [0..1]
rn=uint8(round(rn*255));% convert from double to uint class [0..255]
  
gn=kg*double(g)./i;     % calculate normalized green image [0..1]
gn=uint8(round(gn*255));% convert from double to uint class [0..255]

bn=kb*double(b)./i;     % calculate normalized blue image[0..1]
bn=uint8(round(bn*255));% convert from double to uint class [0..255]

i = uint8(round(i));    % convert to class uint8 [0..255]


