close all, clear all;

%Create the image b4
b4=zeros(32,32);
b4(6:26,12:20)=ones(21,9); %object 
b4(18,15:16)=zeros(1,2); %small holes (noise) 
b4(7:9,18)=zeros(3,1);
b4(27,27)=ones(1,1); %small objects (noise)
b4( 10:12,3)=ones(3,1);
subplot(2,2,1); imshow(b4); axis on; %display image
se1=ones(1,1);
se2=ones(1,3);
brode1=imdilate(b4,se2);
bdilate1=imerode(brode1,se2);
subplot(2,2,2); imshow(bdilate1); axis on; 
brode2=imerode(bdilate1,se2);
bdilate2=imdilate(brode2,se2);
subplot(2,2,4); imshow(bdilate2); axis on; 
brode3=imerode(b4,se2);
bdilate3=imdilate(brode3,se2);
subplot(2,2,3); imshow(bdilate3); axis on; 
