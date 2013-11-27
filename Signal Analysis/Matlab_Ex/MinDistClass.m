%Biometric identification 2009
%First exampel on minimum distance classification.
%Classification of an area as a perfect black, white or border area
%in an image.
%Feature used is the mean value of pixels in the area.
%
%usage: C=MinDistClass(B,r,c)
%input: B the image, (r,c) the left corner of the selected 10x10 area (r,c)
%output: classification image C shown in figure(27)
%example: C=MinDistClass(SvartVit,45,100)
%
%Kennneth Nilsson/15 Juni 2009

function C=MinDistClass(B,r,c)
%mean pixel value of reference area (=feature)
m1=0;%perfect black
m2=127.5;%perfect border
m3=255;%perfect white

%compute mean of selected area
O=B(r:r+9,c:c+9);
m=mean(mean(O));

%compute distances to reference area
d1=abs(m-m1);%black
d2=abs(m-m2);%border
d3=abs(m-m3);%white

%select minimum distance
[V,I]=sort([d1 d2 d3],'ascend');

%label=1 if closest to m1 (black)
%label=2 if closest to m2 (border)
%label=3 if closest to m3 (white)
label =I(1);

%mark area 
%with 50 if closest to black
%with 200 if closest to white
%with 128 if closest to border
C=B;%output image
switch label
    case {1}
        Mark=ones(10,10)*50;
        classtext='black';
    case{2}
        Mark=ones(10,10)*128;
        classtext='border';
    case{3}
        Mark=ones(10,10)*200;
        classtext='white';
    otherwise
        classtext='error';
end
    
C(r:r+9,c:c+9)=Mark;

%show result
figure(27);imagesc(C);
colormap(gray); truesize;
title(['classification result= ' classtext])

