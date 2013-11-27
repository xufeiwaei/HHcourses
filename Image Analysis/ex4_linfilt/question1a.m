s=1.4; %standard deviation
[x,y]=meshgrid(-round(3*s):round(3*s),-round(3*s):round(3*s)); %sample grid
g=exp(-(x.*x + y.*y)/(2*s*s)); %2D smoothing filter
g=g/sum(sum(g)); % sum of weights equals one
figure(1); subplot(3,1,1);mesh(x,y,g); %show the filter
sizeg = size(g);

x1=-round(3*s):round(3*s); %sample grid
gx= exp(-(x1.*x1 )/(2*s*s)); %smoothing filter in the x?direction
gx=gx/sum(gx); % sum of weights equals one
gy=gx'; %smoothing filter in the y?direction (transpose of gx)
figure(1); subplot(3,1,2); stem(x1,gx); %show the 1D smoothing filter
sizegx = size(gx);
sizegy = size(gy);

gg=conv2(gx,gy);%computing g=gx? gy
gg=gg/sum(sum(gg));% sum of weights equals one
figure(1); subplot(3,1,3);mesh(x,y,gg); %show the filter
sizegg = size(gg);


