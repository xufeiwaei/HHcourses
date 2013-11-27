function [Fv, xe,ye]=FD_contour(char_e, fn)
%load char_e; %load the character E
b_cell=bwboundaries(char_e); % extract the contour points. see help bwboundaries for output.
xe= b_cell{1}(:,2);
ye= -b_cell{1}(:,1); % ... Pick col 1 for y coords and change sign

xer=resample_periodic(xe,128); %and resample to 128 points %%%Question: Why resample?
yer=resample_periodic(ye,128);
figure(fn); subplot(2,2,1); imshow(char_e); axis on; %display E
figure(fn); subplot(2,2,2); plot(xe,ye); %and its contour images
figure(fn); subplot(2,2,4); plot(xer,yer);
fe=xer+i*yer; %make a 1D complex signal out of the contour points
Fe=fft(fe,128); %and compute its FDs
% compute the reference feature vector
Fv=normFD(Fe,[-4, -3, -2, -1, 2, 3, 4]); % use only the lower values of k
Fv; %print the reference vector on screen
return
