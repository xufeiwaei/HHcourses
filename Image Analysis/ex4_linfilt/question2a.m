clear;
s=1; %standard deviation
[x,y]=meshgrid(-round(3*s):round(3*s),-round(3*s):round(3*s)); %sample grid
g=exp(-(x.*x + y.*y)/(2*s*s)); %2D smoothing filter
g=g/sum(sum(g)); % sum of weights equals one

f=double(imread('flowers.jpg')); %load the image
f=f(1:256,1:256); %crop it to 256 x 256 pixels
y=conv2(f,g,'valid'); %filter the image

x2=-round(3*s):round(3*s); %sample grid
dx= x2/(s*s).*exp(-(x2.*x2)/(2*s*s)); %derivative in the x?direction
dy=dx'; %derivative in the y?direction
x1=-round(3*s):round(3*s); %sample grid
gx= exp(-(x1.*x1 )/(2*s*s)); %smoothing filter in the x?direction
gx=gx/sum(gx); % sum of weights equals one
gy=gx'; %smoothing filter in the y?direction (transpose of gx)
figure(1),subplot(2,1,1); stem(x1,gx); %1D smoothing filter
figure(1),subplot(2,1,2); stem(x2,dx); %1D derivative filter

fx=conv2(conv2(f,dx,'valid'),gy,'valid'); %derivative in x-direction
fy=conv2(conv2(f,dy,'valid'),gx,'valid'); %derivative in y-direction
figure(2),subplot(2,2,1); imshow(f/255); %show the original image
figure(2),subplot(2,2,2); imagesc(fx); colormap(gray); axis image; %show derivative image in the x
figure(2),subplot(2,2,4); imagesc(fy); colormap(gray); axis image; %and in the y-direction

Edge=sqrt(fx.*fx + fy.*fy); %edge filtered image (the magnitude of the gradient)
figure(2),subplot(2,2,3); imshow(Edge/255); %and display it

Dx=fft(dx,32); %DFT of the dx filter
figure(3),stem(-16:15,fftshift(abs(Dx))); %and display the magnitude spectrum