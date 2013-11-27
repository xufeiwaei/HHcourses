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


e128_1=expand(y128,2); %first expand 
e128_2=conv2(conv2(e128_1,g2,'same'),g2','same'); %then interpolate 
L256=fmt-e128_2; %take the difference
e64_1=expand(y64,2); %first expand 
e64_2=conv2(conv2(e64_1,g2,'same'),g2','same'); %then interpolate 
L128=y128-e64_2; %take the difference
e32_1=expand(y32,2); %first expand 
e32_2=conv2(conv2(e32_1,g2,'same'),g2','same'); %then interpolate 
L64=y64-e32_2; %take the difference
%display the Laplacian pyramid in truesize
figure(9); imagesc(L256); colormap(gray); truesize; 
figure(10); imagesc(L128); colormap(gray); truesize; 
figure(11); imagesc(L64); colormap(gray); truesize;