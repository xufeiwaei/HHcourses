close all,clear all;
b3=zeros(32,32); 
b3(6:26,12:20)=ones(21,9); 
subplot(2,2,1); imshow(b3); axis on;
se=ones(5,5); % 3 x 3 structuring element 
se %print it on screen
b3e=imerode(b3,se);
subplot(2,2,3); imshow(b3e); axis on
ib=b3 & ~b3e; % equal to b3/b3e
b3f=imdilate(b3,se);
ib2=~b3 & b3f;
subplot(2,2,4); imshow(ib2); axis on;
% extract the ?inner boundary?, can be interpreted as the difference b3-b3e 
subplot(2,2,2); imshow(ib); axis on;