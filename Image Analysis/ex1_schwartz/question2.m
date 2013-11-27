B=imread('pout.tif'); %load the image
B=double(B); %datatype float
%show the image in figure1, and in gray
figure(1); colormap(gray);
subplot(2,3,1); imagesc(B); axis image;
g=B(80:100,108:128); %left eye as the matching pattern 21 x 21
D=B;
D(80:100,108:128)=ones(21,21).*150;
subplot(2,3,3); imagesc(D); axis image;%show where the pattern is located in the image
S=exsim(B,g);%calculate the similarity map
N=(imnoise(B/255,'gaussian',0,0.05)).*255; %add gaussian noise, mean=0, var=0.001
S=exsim(N,g); %calculate the similarity map