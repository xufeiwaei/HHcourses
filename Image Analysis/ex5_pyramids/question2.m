close all, clear all;

s=1.0; %std in the spatial domain
x=-round(4*s):round(4*s); %sample grid
g1=exp(-(x.*x)/2/s/s); %smoothing filter
g1=g1/sum(g1); %gain=1
g2=2*g1; %gain=2

fmt=fmtest(256, [0.1*pi 0.3*pi]); %generate the image fmt
figure(1); imshow(fmt); truesize; %and display in truesize

fmt_s2=shrink(fmt,2); %shrink by 2
figure(2);imshow(fmt_s2);truesize; %and display

y=conv2(conv2(fmt,g1,'same'),g1','same'); % first 2D smoothing 
fmtsmooth_s2=shrink(y,2); %then shrink by 2
figure(3);imshow(fmtsmooth_s2);truesize; %and display

fmt_s3=expand(fmt,2); %shrink by 2
figure(4);imshow(fmt_s3);truesize; %and display
y=conv2(conv2(fmt,g1,'same'),g1','same'); % first 2D smoothing 
fmtsmooth_s3=expand(y,2); %then shrink by 2
figure(5);imshow(fmtsmooth_s3);truesize; %and display

fmt_s4=shrink(fmt,3); %shrink by 2
figure(6);imshow(fmt_s4);truesize; %and display

y=conv2(conv2(fmt,g2,'same'),g2','same'); % first 2D smoothing 
fmtsmooth_s4=shrink(y,3); %then shrink by 2
figure(7);imshow(fmtsmooth_s4);truesize; %and display