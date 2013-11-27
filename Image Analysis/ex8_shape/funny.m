clear all; close all;
load char_e; %load character E
load char_w;

while 1
for k = 1:300
k
smoothing_level = k;

img = double(char_e);

%figure(4); subplot(2,2,1); imagesc(img); colormap gray; axis image%and display it
[x y]=perim_sort(img); %extract and sort the boundary coordinates
f=x+i*y; %make a complex 1D signal out of the coordinates
N=length(f); %number of boundary points (N=262)
%figure(4); subplot(2,2,2); plot(imag(f),real(f)); axis equal %plot the boundary
F=fft(f,N); %Fdescriptors of the boundary
fi=ifft(F,N); %go back to boundary points x+i*y
%figure(4); subplot(2,2,3); plot(imag(fi),real(fi));axis equal % and plot the boundary

s = k;
NN = 1:N;
G = exp(-(NN-N/2).*(NN-N/2)/2/s/s);
% figure(5);plot(G);
% CC=zeros(N,1); %start with a zero filter
% % the Fd:s should be put in in pair, i.e. F(k) and F(-k) is a pair
% % in the Brick-wall Fourier domain filter
% CC=zeros(N,1); %start with a zero filter
% CC(mod([0:smoothing_level],N)+1)=ones(smoothing_level+1,1); %add in ones in pair; F(k)
% CC(mod([-smoothing_level:-1],N)+1)=ones(smoothing_level,1); %F(-k)
% FC=F.*CC; % filter
% FC = fftshift(F).*G';
% FC = ifftshift(FC);
  FC = F .* G';
f1=ifft(FC,N); % reconstruct the boundary from the low order Fd:s
figure(5); plot(imag(f1),real(f1));axis ([0 50 0 50]); %reconstructed boundary

pause(0.001);
end

% for k = 130:-1:1
% 
% smoothing_level = k;
% 
% img = double(char_w);
% 
% figure(4); subplot(2,2,1); imagesc(img); colormap gray; axis image%and display it
% [x y]=perim_sort(img); %extract and sort the boundary coordinates
% f=x+i*y; %make a complex 1D signal out of the coordinates
% N=length(f); %number of boundary points (N=262)
% figure(4); subplot(2,2,2); plot(imag(f),real(f)); axis equal %plot the boundary
% F=fft(f,N); %Fdescriptors of the boundary
% fi=ifft(F,N); %go back to boundary points x+i*y
% figure(4); subplot(2,2,3); plot(imag(fi),real(fi));axis equal % and plot the boundary
% 
% 
% CC=zeros(N,1); %start with a zero filter
% % the Fd:s should be put in in pair, i.e. F(k) and F(-k) is a pair
% % in the Brick-wall Fourier domain filter
% CC=zeros(N,1); %start with a zero filter
% CC(mod([0:smoothing_level],N)+1)=ones(smoothing_level+1,1); %add in ones in pair; F(k)
% CC(mod([-smoothing_level:-1],N)+1)=ones(smoothing_level,1); %F(-k)
% FC=F.*CC; % filter
% f1=ifft(FC,N); % reconstruct the boundary from the low order Fd:s
% figure(4); subplot(2,2,4); plot(imag(f1),real(f1));axis equal %reconstructed boundary
% 
% pause(0.0001);
% end

end