clear;
L=zeros(64,64); %zero matrix 64 x 64
L(30:34,30:34)=ones(5,5); %put in a white square 5 x 5
figure(1),subplot(4,2,1); imshow(L); %show it
FL=fft2(L); %2D DFT
subplot(4,2,2); imshow(fftshift(log10(abs(FL)))); %show the centralized DFT
clear;
L=zeros(64,64); %zero matrix 64 x 64
L(29:35,29:35)=ones(7,7); %put in a white square 7 x 7
figure(1),subplot(4,2,3); imshow(L); %show it
FL=fft2(L); %2D DFT
subplot(4,2,4); imshow(fftshift(log10(abs(FL)))); %show the centralized DFT
clear;
L=zeros(64,64); %zero matrix 64 x 64
L(27:37,27:37)=ones(11,11); %put in a white square 11 x 11
figure(1),subplot(4,2,5); imshow(L); %show it
FL=fft2(L); %2D DFT
subplot(4,2,6); imshow(fftshift(log10(abs(FL)))); %show the centralized DFT
clear;
L=zeros(64,64); %zero matrix 64 x 64
L(1:7,1:7)=ones(7,7); %put in a white square 7 x 7
figure(1),subplot(4,2,7); imshow(L); %show it
FL=fft2(L); %2D DFT
subplot(4,2,8); imshow(fftshift(log10(abs(FL)))); %show the centralized DFT

