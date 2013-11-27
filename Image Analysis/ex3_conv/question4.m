f=imread('flowers.jpg');
f=double(f(1:256,1:256));
g=ones(5,5)/(5*5);
y=conv2(f,g);
figure(1),subplot(2,2,1); imshow(f/255);
subplot(2,2,2); imshow(y/255);
F=fft2(f,256,256); % DFT in 256 x 256 points (N=256)
G=fft2(g,256,256); % both DFT must be of equal size (later on multiplication!)
Y=F.*G; % point multiplication
yy1=real(ifft2(Y)); % convolved image
figure(1),subplot(2,2,3); imshow(yy1/255);
F1=fft2(f,261,261); % DFT in 256 x 256 points (N=256)
G1=fft2(g,261,261); % both DFT must be of equal size (later on multiplication!)
Y1=F1.*G1; % point multiplication
yy2=real(ifft2(Y1)); % convolved image
figure(1),subplot(2,2,4); imshow(yy2/255);