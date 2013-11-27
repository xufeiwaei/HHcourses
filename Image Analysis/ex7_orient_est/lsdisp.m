function [rgbim]=lsdisp(hsvim,gamma,scaling)
%        [rgbim]=lsdisp(hsvim,gamma,scaling)
%converts an hsv image to rgb and displays it. The result is put in rgbim when an output
%argument is required otherwise no rgbim is returned.
%
%There are two behaviours of hsvshow depending on whether hsvim is complex
%valued or not.
% 
%When hsvim is a complex matrix the arguments, that is angle(hsvim),  modulate the hue 
%linearly so that the range [0,2PI] corresponds, to hues defined by
%the CIE color standard, with zero representing the red color during the display. 
%Saturation is put to 1. 
%The value is modulated by the magnitudes, mag(hsvim). The parameter gamma is a positive
%real number that performs gamma correction on value. The scaling is a switch that turns off 
%the normalization performed on mag(hsvim) before the display. They default to gamma=1.5 
%and scaling='scloff' when both omitted
%
%When hsvim is a real matrix, then it is assumed that  it is a 3 dimensional matrix.
%On display the matrix corresponding to the first dimension is interpreted in the range of 
%[0,2PI], and it is let to modulate the hue linearly so that the 
%range [0,2PI] corresponds to hues defined according to the CIE color standard, 
%with zero representing the color red. Saturation is modulated by hsvim(:,:,2) whereas
%value is modulated by hsvim(:,:,3). The parameter gamma is a positive
%real number that performs gamma correction on saturation. The scaling is a switch that turns 
%off the normalization performed on mag(hsvim) before the display.
%These parameters  default to gamma=1.5 and scaling='scloff' when both omitted.


PI=4*atan(1);
gam=3.5;  %default
scl='sclon'; %default

if (1<nargin)
gam=gamma;   
end

if (2<nargin)
scl=scaling;   
end

if (isreal(hsvim))
   HH=mod(hsvim(:,:,1),2*PI);
   SS=hsvim(:,:,2);
   VV=hsvim(:,:,3);
   if (~strcmp(scl ,'scloff'))
      mxs= max(VV(:));
      VV=VV/mxs;
      SS=SS/mxs;
   end
   SS=SS.^gam;
else
   HH=mod(angle(hsvim), 2*PI);
   SS=ones(size(hsvim,1), size(hsvim,2)); 
   VV=abs(hsvim);
   if (~strcmp(scl ,'scloff'))
      VV=VV/max(VV(:));
   end
   VV=VV.^gam;
end

hsvim(:,:,1)=HH/2/PI;
hsvim(:,:,2)=SS;
hsvim(:,:,3)=VV;
rgbimage=hsv2rgb(hsvim);

image(rgbimage);
if (0<nargout)
   rgbim=rgbimage;
end

%truesize;
%imwrite(rgbim,'rgbim.tif','tif'); imshow('rgbim.tif'); truesize; 

