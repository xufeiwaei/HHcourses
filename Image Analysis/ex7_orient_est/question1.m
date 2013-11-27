close all, clear all;
[magn, argument]=fmtest(256,[0.1,0.33]*pi, 1); %give A a value! 
figure(1),imagesc(magn); colormap(gray); truesize; %display the magnitude image
figure(4),imagesc(argument); colormap(gray); truesize;

[magn, argument]=fmtest(256,[0.1,0.33]*pi, 0.75); %give A a value! 
figure(2),imagesc(magn); colormap(gray); truesize; %display the magnitude image
figure(5),imagesc(argument); colormap(gray); truesize;


[magn, argument]=fmtest(256,[0.1,0.33]*pi, 0.5); %give A a value! 
figure(3),imagesc(magn); colormap(gray); truesize; %display the magnitude image
figure(6),imagesc(argument); colormap(gray); truesize;

magnone=ones(256,256); %1-magnitude image 
im1_c=magnone.*exp(i*2*argument); %complex image
figure(17); lsdisp(im1_c); truesize; %color code for local orientations
