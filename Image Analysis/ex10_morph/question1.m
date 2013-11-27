clear all, close all;

% create the binary image b1
b1=zeros(16,16); %white object on a black background 
b1(7:9,4:12)=ones(3,9);
subplot(2,2,1); imshow(b1); axis on %display
% create the structuring elements
se1=ones(1,4); % 1 x 3
se2=ones(2,1); % 3 x 1
se1 %print them on screen
se2 %
% erode the image b1
e1b1=imerode(b1,se1); %by se1 
e2b1=imerode(b1,se2); %by se2
subplot(2,2,2); imshow(e1b1); axis on; 
subplot(2,2,4); imshow(e2b1); axis on;

se = ones(3,3);
e3b1 = imerode(b1,se); 
subplot(2,2,3); imshow(e3b1); axis on;
