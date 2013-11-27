n=1000;
d=8;
d2=5;
dy=.35;
dx=.45;

x1=abs(randn(n,1))+abs(randn(n,1).*pi/4);
l=x1<3;
x1=x1(l);
n1=size(x1,1);
x2=randn(n1,1)/d;

y1=(x1+x2).*cos(x1)+randn(n1,1)/d2+dx;
y2=(x1+x2).*sin(x1)+randn(n1,1)/d2-dy;
data=[y1 y2 zeros(n1,1)];

figure(1)
clf
hold on
plot(y1,y2,'r*')


y1=randn(n,1)/d2-.5;
y2=randn(n,1)/d2+.25;
data=[data;y1 y2 ones(n,1)];

plot(y1,y2,'g*')

axis('equal');
grid