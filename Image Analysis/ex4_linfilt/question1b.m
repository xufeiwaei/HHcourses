clear;
s=1.4; %standard deviation
[x,y]=meshgrid(-round(3*s):round(3*s),-round(3*s):round(3*s)); %sample grid
g=exp(-(x.*x + y.*y)/(2*s*s)); %2D smoothing filter
g=g/sum(sum(g)); % sum of weights equals one

f=double(imread('flowers.jpg')); %load the image
f=f(1:256,1:256); %crop it to 256 x 256 pixels
y=conv2(f,g,'valid'); %filter the image
figure(1),subplot(2,2,1); imshow(f/255); % original image
figure(1),subplot(2,2,2); imshow(y/255); % smoothed image

x1=-round(3*s):round(3*s); %sample grid
gx= exp(-(x1.*x1 )/(2*s*s)); %smoothing filter in the x?direction
gx=gx/sum(gx); % sum of weights equals one
gy=gx'; %smoothing filter in the y?direction (transpose of gx)
sizegx = size(gx);
sizegy = size(gy);

yy=conv2(conv2(f,gx,'valid'),gy,'valid'); %filter the image
figure(1),subplot(2,2,4);imshow(yy/255); %and display it
e=y-yy; %compute error
sum(sum(e.*e)) %print it on screen

Gx=fft(gx,32); %DFT of the filter
figure(1),subplot(2,2,3),stem(-16:15,fftshift(abs(Gx))); %display the magnitude spectrum
clear;

s=2.4; %standard deviation
[x,y]=meshgrid(-round(3*s):round(3*s),-round(3*s):round(3*s)); %sample grid
g=exp(-(x.*x + y.*y)/(2*s*s)); %2D smoothing filter
g=g/sum(sum(g)); % sum of weights equals one

f=double(imread('flowers.jpg')); %load the image
f=f(1:256,1:256); %crop it to 256 x 256 pixels
y=conv2(f,g,'valid'); %filter the image
figure(2),subplot(2,2,1); imshow(f/255); % original image
figure(2),subplot(2,2,2); imshow(y/255); % smoothed image

x1=-round(3*s):round(3*s); %sample grid
gx= exp(-(x1.*x1 )/(2*s*s)); %smoothing filter in the x?direction
gx=gx/sum(gx); % sum of weights equals one
gy=gx'; %smoothing filter in the y?direction (transpose of gx)
sizegx = size(gx);
sizegy = size(gy);

yy=conv2(conv2(f,gx,'valid'),gy,'valid'); %filter the image
figure(2),subplot(2,2,4);imshow(yy/255); %and display it
e=y-yy; %compute error
sum(sum(e.*e)) %print it on screen

Gx=fft(gx,32); %DFT of the filter
figure(2),subplot(2,2,3),stem(-16:15,fftshift(abs(Gx))); %display the magnitude spectrum