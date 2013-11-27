clear all, close all;

load char_e; %load character E
img = char_e; %assign it to a new image matrix, img
[Re]=FD_contour(img,1); %compute ref vector and display contour images in Fig. 1 
Re, %print the reference vector on screen
load char_w; %load character W
[Rw]=FD_contour(char_w,2); %compute ref vector and contour images , and display 
Rw, %print the reference vector on screen

img=imresize(img,1.6,'bicubic'); %Enlarge E 1.6 times 
[Se]=FD_contour(img,3); %compute ref vector and contour points, and display 
Se %print the feature vector on screen

dist_e=norm(Se-Re); %distance between scaled character E and reference E 
dist_w=norm(Se-Rw); %distance between scaled character E and reference W 
L=dist_w/dist_e %Likelihood of img being E compared to being W

img2=imrotate(img,60,'bicubic'); %rotate img (scaled E) with 60 degrees 
[SRe]=FD_contour(img2,4); %compute ref vector and contour points, and display 
Se %print the feature vector on screen