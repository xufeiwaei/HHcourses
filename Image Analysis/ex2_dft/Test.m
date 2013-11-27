f=double(imread('cameraman.tif'));
figure(1);
imagesc(f);truesize;colormap(gray(256));
c=fft2(f);
figure(3)
subplot(2,2,1);imagesc(f);
subplot(2,2,2);imagesc(abs(c));
subplot(2,2,3);imagesc(log(abs(c)));
% subplot(2,2,3);imagesc(log10(abs(c)));
subplot(2,2,4);imagesc(fftshift(log(abs(c))));
colormap(gray(256));
truesize;

psi=base(256,50,50);
figure(5);
imagesc(real(psi));
colormap(gray(256));
truesize;

