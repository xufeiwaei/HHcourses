s=1.0; %std in the spatial domain
x=-round(4*s):round(4*s); %sample grid
g1=exp(-(x.*x)/2/s/s); %smoothing filter
g1=g1/sum(g1); %gain=1
g2=2*g1; %gain=2
figure(1); subplot(2,1,1);stem(x,g1); %show filters
subplot(2,1,2);stem(x,g2);  
f=ones(1,30);
y=conv(f,g1);
figure(2),subplot(2,1,1);stem(f);
figure(2),subplot(2,1,2);stem(y);
fz=zeros(1,60); 
fz(1:2:60)= f; 
fzi=conv(fz,g2);
figure(3),subplot(2,1,1);stem(fz);
figure(3),subplot(2,1,2);stem(fzi);
