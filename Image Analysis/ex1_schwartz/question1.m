A=ones(128,128).*40; %dark background, size 128 x 128
A(50:70,50:70)=ones(21,21).*200; %light square, size 21 x 21
%show the image in figure 1, and in gray
figure(1); subplot(2,2,1); imagesc(A); colormap(gray); axis image;
g=ones(21,21).*40; %pattern g
g(1:10,1:21)=ones(10,21).*200;
g=g';
S=exsim(A,g); %calculate the similarity map
