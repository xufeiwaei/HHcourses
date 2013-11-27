clear all; close all;
[magn, argument]=fmtest(256,[0.1,0.33]*pi, 1); %generate testimage 
figure(1); imagesc(magn); colormap(gray); truesize; %display 
figure(2); imagesc(argument); colormap(gray); truesize;
magnone=ones(256,256); %constant image=1 
%display a three component real valued image im_r 
im_r(:,:,1)=argument; %steers H, 
im_r(:,:,3)=magnone; %steers V, 
im_r(:,:,2)=ones(256,256); %steers S (is put to 1) 
figure(3); lsdisp(im_r); truesize;
%display a complex image im_c
%angle(im_c) steers H, abs(im_c) steers V,
%and S is put to 1 in the lsdip function 
im_c=magnone.*exp(i*argument); %make a complex image; 
figure(4); lsdisp(im_c); truesize; %and display it
Im2Arg1=magnone.*exp(i*2*argument); %generate ?2*argument? image
figure(17); lsdisp(Im2Arg1); truesize; 
Im2Arg=magn.*exp(i*2*argument); %generate 2*argument? image 
figure(5); lsdisp(Im2Arg) ;truesize;