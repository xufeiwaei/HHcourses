close all, clear all;

[magn, argument]=fmtest(256,[0.1,0.33]*pi, 1); %give A a value! 
magnone=ones(256,256); %1-magnitude image 
im1_c=magnone.*exp(i*2*argument); %complex image
figure(17); lsdisp(im1_c); truesize; %color code for local orientations


fim=double(imread('fingerp.tif','tif')); %read the image 
figure(1),imagesc(fim);colormap(gray);axis image; %and display it 
LS2=linsymexer(fim,[1.5,2]); %estimate LS 
figure(2),lsdisp(LS2,0.5); truesize; %and display

mnt=LS2(:,:,3)-LS2(:,:,2);
%Display the result by imagesc and by modulating your response mnt with 
%the original image via lsdisp:
figure(3),lsdisp(fim.*exp(i*7*mnt)); truesize;