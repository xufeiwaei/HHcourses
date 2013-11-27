close all, clear all;
fim=double(imread('wood+chain.tif'));
figure(11);
subplot(2,2,1);imagesc(fim); colormap(gray); axis image; 
subplot(2,2,2); lsdisp(linsymexer(fim,[0.4 4]),0.2); axis image; 
subplot(2,2,3); lsdisp(linsymexer(fim,[3 8.3]),0.5); axis image