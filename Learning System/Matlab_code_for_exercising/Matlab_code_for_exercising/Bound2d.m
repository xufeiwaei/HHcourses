
[x,y]=meshdom(0.0:.01:1.0,1.0:-.01:0);
load misdot.dat;
load ww.w;

w1=ww(1,:);
w2=ww(2,:);


clear ww

z1=w1(1)+w1(2).*x+w1(3).*y;
z2=w2(1)+w2(2).*x+w2(3).*y;


plot(misdot(:,1),misdot(:,2),'wo');
axis([0 1 0 0.5]);
hold on;
contour (z1,[0,0],[0.0:.01: 1.0],[0:.01:1.0],'w');
contour (z2,[0,0],[0.0:.01: 1.0],[0:.01:1.0],'g.');
hold off;
 