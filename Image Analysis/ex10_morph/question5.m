close all,clear all;
%Create the image b5.
b5=zeros(32,32);
b5(10:24,18:24)=ones(15,7); %the big object 
b5(8:9,18)=ones(2,1); %that should 
b5(24,16:17)=ones(1,2); %be extracted
b5(4:5,5)=ones(2,1); %small object 
b5(28,16:17)=ones(1,2); % small object
subplot(3,3,1); imshow(b5); axis on; %display image
%delete small objects < se
se=ones(3,3);
eb5=imerode(b5,se);
subplot(3,3,2); imshow(eb5); axis on; %recover the big object iteratively\

k1=imdilate(eb5,se) & b5; 
subplot(3,3,4); imshow(k1); axis on;

k2=imdilate(k1,se) & b5; 
subplot(3,3,5); imshow(k2); axis on;