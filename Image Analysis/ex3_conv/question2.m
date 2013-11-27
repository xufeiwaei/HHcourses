d=circle(10); %generate a white circle on a black background
D=fft2(d); %2D DFT
figure(1),subplot(2,2,1); imshow(d); %show the circle
subplot(2,2,2); imagesc(fftshift(abs(D))); colormap(gray); axis image %and its DFT
d=circle(20); %generate a white circle on a black background
D=fft2(d); %2D DFT
figure(1),subplot(2,2,3); imshow(d); %show the circle
subplot(2,2,4); imagesc(fftshift(abs(D))); colormap(gray); axis image %and its DFT