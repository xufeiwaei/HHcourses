clear all, close all;
% create the binary image b2 
b2=zeros(16,16); %black background 
b2(4:12, 6:10)=ones(9,5); %object 
b2(6:10, 7:9)=zeros(5,3); %hole 
% create the structuring elements
se1=ones(1,3); % 1 x 3
se2=ones(3,1); % 3 x 1
se1 %print them on screen
se2 %
se = ones(3,3);
subplot(2,2,1); imshow(b2); axis on; % dilate the image b2 
d1b2=imdilate(b2,se1); %by se1 
d2b2=imdilate(b2,se2); %by se2 
d3b2=imdilate(b2,se);
subplot(2,2,2); imshow(d1b2); axis on; 
subplot(2,2,3); imshow(d3b2); axis on;
subplot(2,2,4); imshow(d2b2); axis on;