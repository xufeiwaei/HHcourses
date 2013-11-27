f = double(imread('blood1.tif'));
g = double(imread('enamel.tif'));
f = f(1:256,1:256);
g = g(1:256,1:256);
figure(1);
imagesc(f);truesize;colormap(gray(256));
figure(2);
imagesc(g);truesize;colormap(gray(256));
fscalg = sum(sum(f.*g)) % <f,g>
fscalf = sum(sum(f.*f)) % <f,f>
c = fft2(f);
d = fft2(g);
cscald = sum(sum(conj(c).*d))/256/256 %<c,d>, c=DFT{f} and d=DFT{g}
cscalc = sum(sum(conj(c).*c))/256/256
