function [rn,gn,bn,i] = rgbpix2nc(r,g,b);

%  function [rn,gn,bn,i] = rgbpix2nc(r,g,b);
%
%  r,g,b pixel value [0..255]
%  Converts a pixel value r g b to normalized color space 
%  i = 0.33 * r + 0.33 g + 0.33 b    [0..255]
%  rn,gn,bn = [0..1]

kr=0.33;
kg=0.33;
kb=0.33;

i= kr*double(r)+kg*double(g)+kb*double(b);

rn = kr*double(r)/i;
gn = kg*double(g)/i;
bn = kb*double(b)/i;




