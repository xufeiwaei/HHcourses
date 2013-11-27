% hermsym.m  /kn 00-02-04
% hermsym.m  /jb 10-08-16
% reconstruct the image from half the spectrum
% using Hermitian symmetry

f=imread('blood1.tif'); % read image
f=double(f(1:256,1:256));

c=fft2(f); % calculate FT

c1=c; % reconstructed FT 

%reconstruct the FT from one half
kcol=0:128;  
krow=0:255;
c1(mod(krow,256)+1,mod(-kcol,256)+1)=0; % We destroy the information in one half FT (left)
c1(mod(krow,256)+1,mod(-kcol,256)+1)=conj(c(mod(-krow,256)+1,mod(kcol,256)+1)); %Copy half of FT (right) onto the other half (right)
 
g=ifft2(c1); % image from the reconstructed FT

% error calculation
e=f-g; % original - reconstructed
error=sum(sum(e.*e)) % sum of square error

% display
colormap(gray);
subplot(2,2,1); imagesc(f); title('original image');
subplot(2,2,3);imagesc(real(g));title('reconstructed image');
