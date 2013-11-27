%showex.m
%kn 2003-11-21
%
%calculate the complex gradient image of an image
%a gaussian filter with std=1.2 is used as a filter
%
%interaction by pointing in the displayed image
%the gradient around the point (+10 to -10) is displayed by quiver
%
%10 points can be studied in one run
%output is the gradient image


function [G]=showex_gr(im)

%generate 1-D filters
%smoothing filters
std=1.2;
c=-round(3*std):round(3*std);%col dir

gc=exp(-(c.*c)/2/std/std);%gauss x-direction
gc=gc/sum(gc);
gr=gc';

%derivative filters
dc=c.*gc;
dc=dc/sum(abs(dc));

dr=dc';

%compute gradient image
dcf=filter2(gr, filter2(dc,im,'same'),'same');  %derivate inim with respect to c
drf= filter2(gc, filter2(dr,im,'same'),'same'); %derivate inim wrt r

%*******************************************************
G=dcf + j*drf;%gradient image, complex repr
%G=abs(G).*exp(-i*mod(2*angle(G),2*pi));%2*argument image
%*******************************************************

%interact for 10 points
for m=0:10
figure(21);imagesc(im);colormap(gray);truesize
disp('point in the image');
[c,r]=ginput(1);%coord

%r_coord=r
%c_coord=c
r=round(r);%must be integer
c=round(c);

r=256-r;%due to quiver

%
if r<11;r=11;end
if c<11;c=11;end
if r>246;r=246;end
if c>246;c=246;end

figure(22);
quiver(real(G(r-10:r+10,c-10:c+10)),imag(G(r-10:r+10,c-10:c+10)));
end