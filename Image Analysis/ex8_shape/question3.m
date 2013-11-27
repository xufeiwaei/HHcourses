load char_e; %load character E
figure(4); subplot(2,2,1); imshow(char_e); %and display it
[x y]=perim_sort(char_e); %extract and sort the boundary coordinates 
f=x+i*y; %make a complex 1D signal out of the coordinates
N=length(f); %number of boundary points (N=262)
figure(4); subplot(2,2,2); plot(imag(f),real(f)),axis equal; %plot the boundary 
F=fft(f,N); %F?descriptors of the boundary
fi=ifft(F,N); %go back to boundary points x+i*y
figure(4); subplot(2,2,3); plot(imag(fi),real(fi)),axis equal; % and plot the boundary

s=1.0; %std in the spatial domain
x=-round(131*s):round(131*s); %sample grid
g1=exp(-(x.*x)/2/s/s); %smoothing filter
g1=g1/sum(g1); %gain=1
g2=2*g1; %gain=2

CC=zeros(N,1); %start with a zero filter
% the Fd:s should be put in ?in pair?, i.e. F(k) and F(-k) is ?a pair?
% in the ?Brick-wall? Fourier domain filter
CC=zeros(N,1); %start with a zero filter 
CC(mod([0:10],N)+1)=ones(11,1); %add in ones ?in pair?; F(k) 
CC(mod([-10:-1],N)+1)=ones(10,1); %F(-k)
FC=F(1).*CC; % filter
f1=ifft(FC,N); % reconstruct the boundary from the low order Fd:s 
figure(4); subplot(2,2,4); plot(imag(f1),real(f1)); %reconstructed boundary