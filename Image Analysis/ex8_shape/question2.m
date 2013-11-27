clear all, close all;
rect=zeros(21,21); %make a 7 by 3 rectangle image
rect(8:14,10:12)=ones(7,3);
rect = rect';
figure(3);subplot(2,2,1); imshow(rect); %and display it 
[F_rect,c_rect]=mom_obj(rect); %compute moments and centre 
F_rect, %print the moments [m0,0, ?1,1, ?2,0, and ?0,2]?
c_rect, %print the centre [xm, ym]?

load char_e; %load images
load char_w; %
figure(3);subplot(2,2,3); imshow(char_e); %and display them 
figure(3);subplot(2,2,4); imshow(char_w); 
[F_e,c_e]=mom_obj(char_e); %compute moments and centre 
[F_w,c_w]=mom_obj(char_w); %
[F_e, F_w] %and print them on screen 
[c_e, c_w]