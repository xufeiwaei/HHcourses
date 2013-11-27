function [imex] = imexpand(im);

%  function [imex] = imexpand(im);
%
%  Expands an image of class uint to full range [0..255]
%
%  bases on imadjust.m in IP toolbox
%
  


ma=max(max(double(im)))/255;
mi=min(min(double(im)))/255;

imex=imadjust(im,[mi ma],[0 1]);


