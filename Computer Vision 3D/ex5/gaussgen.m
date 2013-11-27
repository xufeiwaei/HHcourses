function [h]=gaussgen(sma,type,size)
% $Id: gaussgen.m,v 1.1 2000/03/16 17:12:39 josef Exp josef $
% (C) Josef Bigun
% This function generates a 2-D gaussian kernel with standard deviation of sma if type ='gauss'.
% it generates a 2-D  gaussian derivative kernel with standard deviation of sma
% if type='dxg'.  The argument size is a vector telling the size of the filter [height,width].
% By using height=1 or widht=1, 1-D gaussian or derivative of gaussians can be generated.
%
% The function can be called with 0, 1, 2, and 3 arguments as:
%   gaussgen, gaussgen(sma), gausssgen(sma,type), and gaussgen(sma,type,size)
% The default values of the omitted variables  are 
% std =1;
% typ='gauss';
% siz =[1,round(6*std)];


std =1;
typ='gau';

if nargin>0, 
    std=sma;
end

if nargin>1,
    typ=type; 
end

siz = round(5*std);
siz =[1,;siz + mod(siz-1,2)]; %make 2D vec, make sure odd sized
% if (typ == 'gau')
%     siz =[1,round(5*std)];
% end

if nargin>2,
    siz=size; 
end

[x,y]=meshgrid(-(siz(2)-1)/2:(siz(2)-1)/2,-(siz(1)-1)/2:(siz(1)-1)/2);

if (typ == 'gau')
  h = exp(-(x.*x + y.*y)/(2*std*std));
  h = h/sum(sum(h));
end

if (typ == 'dxg')
  h = x.*exp(-(x.*x + y.*y)/(2*std*std));
  h = h/sum(sum(abs(h)));

end

% plot(x,h)
% 