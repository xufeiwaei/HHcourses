clear all, close all;
[magn, argument]=fmtest(256,[0.1,0.33]*pi, 1); %generate testimage 
figure(1); imagesc(magn); colormap(gray); truesize; %display 
figure(2); imagesc(argument); colormap(gray); truesize;
magnone=ones(256,256); %constant image=1 


gradient=showex_gr(magn); %shows gradient in image magn
%design 1D gaussian filters
std=2.5;
x=-round(3*std):round(3*std);
gx=exp(-(x.*x)/2/std/std); gx=gx/sum(gx); %in the x direction 
gy=gx'; %and in the y direction
%do the local averaging on the gradient image
avg_grad=filter2(gy,filter2(gx,gradient));
%display the avg_grad image by using lsdisp and option complex input
figure(21);lsdisp(avg_grad,3.5,'sclof'); truesize;

orientation=showex_gr(magn); %shows orientations in image magn
avg_or=filter2(gy,filter2(gx,orientation)); %do local averaging 
figure(22); lsdisp(avg_or); truesize; %and display