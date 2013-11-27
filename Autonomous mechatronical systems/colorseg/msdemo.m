function  msdemo(filename);

%  demo of the color segmentation algorithm described in
%  paper "Real-Time Color Classification"
%  see also function  colseg
%
%  filename is a string e.g  msdemo('test')
%  test should should be of bmp format
%
%   
%
%  Hint: All open figures can be closed by cmd:  close all

[rgb,r,g,b,i,rn,gn,bn] =getpict(filename);

figure;
subplot(2,2,1),[rgbpix]=impixel(rgb)

[rnpix,gnpix,bnpix,ipix]=rgbpix2nc(rgbpix(1),rgbpix(2),rgbpix(3));

dist=colseg(rn,gn,rnpix,gnpix);
bw=im2bw(dist,(240/255));

subplot(2,2,2),imshow(dist);
subplot(2,2,3),imhist(dist);
subplot(2,2,4),imshow(bw);


