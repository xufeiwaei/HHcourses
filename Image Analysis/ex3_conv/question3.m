f = ones(5,5); 
g = ones(3,3);
y=conv2(f,g);
%do convolution by DFT, multiplication, and IDFT
F=fft2(f,5,5); % DFT in 5 x 5 points (N=5)
G=fft2(g,5,5); % both DFT must be of equal size (later on multiplication!)
Y=F.*G; % point multiplication
yy=real(ifft2(Y)); % convolved image
y,yy,