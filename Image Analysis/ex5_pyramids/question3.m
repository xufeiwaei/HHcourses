s=1.0; %std in the spatial domain
x=-round(4*s):round(4*s); %sample grid
g1=exp(-(x.*x)/2/s/s); %smoothing filter
g1=g1/sum(g1); %gain=1
g2=2*g1; %gain=2

fmt=fmtest(256,[0.1*pi 0.3*pi]); %generate the image fmt
%generate the Gaussian pyramid 
y256_s=conv2(conv2(fmt,g1,'same'),g1','same'); %first 2D smoothing 
y128=shrink(y256_s,2); %then shrink by 2
y128_s=conv2(conv2(y128,g1,'same'),g1','same'); %first 2D smoothing 
y64=shrink(y128_s,2); %then shrink by 2
y64_s=conv2(conv2(y64,g1,'same'),g1','same'); %first 2D smoothing 
y32=shrink(y64_s,2); %then shrink by 2
%display the Gaussian pyramid in truesize
figure(5); imshow(fmt);  truesize; 
figure(6); imshow(y128); truesize; 
figure(7); imshow(y64);  truesize; 
figure(8); imshow(y32);  truesize;