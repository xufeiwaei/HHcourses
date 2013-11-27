f=double(imread('cameraman.tif'));
figure(1);
imagesc(f);truesize;colormap(gray(256));
E1=base(256,5,-10); %generate the base image E of size 256x256, krow=5 and kcol=?10
proj = sum(sum(conj(E1).*f)) %compute the projection
c=fft2(f); %the DFT of the image f of size 256x256
c(mod(5,256)+1,mod(-10,256)+1) %compare with the DFT value for krow=5 and kcol=?10
proj;
Etest1=base(256,5,-5);
Etest2=base(256,5,5);
figure(2);
subplot(1,2,1), imagesc(real(Etest1)),subplot(1,2,2), imagesc(real(Etest2));
truesize;colormap(gray(256));