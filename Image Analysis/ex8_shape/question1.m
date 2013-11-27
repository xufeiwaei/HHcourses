close all, clear all;

load imbact; %load the image imbact
figure(1); subplot(2,2,1); imshow(imbact); %and display it 
%manually find a threshold value T from the histogram of the image 
[hist_bact,xx]=imhist(imbact); %compute the histogram 
figure(1); subplot(2,2,2); stem(xx,hist_bact); %and display it 
%make a binary image by thresholding
T=101; %put in the value for the threshold T here 
bin_bact=imbact<T; %make a binary image
figure(1); subplot(2,2,3); imshow(bin_bact); %and display it
[lab_bact,num]=bwlabel(bin_bact); %segment (label) the binary image
figure(2); subplot(2,2,1); imagesc(lab_bact);colormap(jet); axis image %display it 
num,%print on screen the number of objects

A_vect=area_obj(lab_bact,num); %compute the area of each object
A_vect, %print the area values on the screen
figure(2); subplot(2,1,2); hist(A_vect,20); %and the area distribution