f=double(imread('cameraman.tif'));
figure(1);
imagesc(f);truesize;colormap(gray(256));
c=fft2(f);
figure(3)
subplot(2,2,1);imagesc(f);
subplot(2,2,2);imagesc(abs(c));
% subplot(2,2,3);imagesc(log(abs(c)));
subplot(2,2,3);imagesc(log10(abs(c)));
subplot(2,2,4);imagesc(fftshift(log(abs(c))));
colormap(gray(256));
truesize;
fi=ifft2(c);
figure(4)
subplot(2,2,1);imagesc(f);
% subplot(2,2,2);imagesc(abs(fi));
% subplot(2,2,3);imagesc(log(abs(fi)));
% subplot(2,2,4);imagesc(fftshift(log(abs(fi))));
colormap(gray(256));
truesize;

