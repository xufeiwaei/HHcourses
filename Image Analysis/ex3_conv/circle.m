% circle.m  06-01-23/kn
% generate a white circle of radius r pixels
% on a 256 x 256 image of black background
% input: radius in pixels
% output: the 256 x 256 image C

function C=circle(r)

[x,y]=meshgrid(-128:127,-128:127);%coordinates 256x256
radius=sqrt(x.*x + y.*y); %r^2=x^2+y^2

C=radius<r;

