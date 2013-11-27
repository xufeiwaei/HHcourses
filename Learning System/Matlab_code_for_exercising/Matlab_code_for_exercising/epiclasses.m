
r=rand(number,2);
r=r*8-4;

k=1:361;
figure(1);clf;

% r to polar coordinates
kr=atan(r(:,2)./r(:,1))*180/pi;
l=r(:,1)<0;
kr(l)=kr(l)+180;
l=kr<0;
kr(l)=kr(l)+360;
mr=(r(:,2).^2+r(:,1).^2);

hold on;
l=[];
inclasses=[];
data=[];
target=[];
my_colour='rgbcmykrgbcmyk';
for i=1:nclasses
	d=3.5/nclasses*i;
	y=d*sin(k/180*pi);
	x=d*cos(k/180*pi);
	y2=y+y.*sin(k/180*pi*flexure)/4;
	x2=x+x.*sin(k/180*pi*flexure)/4;
%	y2=y2*d;
%	x2=x2*d;
	plot(x2,y2)

%	class assignment
	yr=d*sin(kr/180*pi);
	xr=d*cos(kr/180*pi);
	yr=yr+yr.*sin(kr/180*pi*flexure)/4;
	xr=xr+xr.*sin(kr/180*pi*flexure)/4;
	mtr=yr.^2+xr.^2;
	l=mtr>mr;
	class=r(l,:);
	plot(class(:,1),class(:,2),[my_colour(i) '.']);
	r=r(~l,:);
	mr=mr(~l);
	kr=kr(~l);

%data
	data=[data;class];
	inclasses=[inclasses;sum(l)];
	target=[target; ones(sum(l),1)*i];
	
end
axis('square')
axis('equal')
number=sum(inclasses)

% targets for network training
t=zeros(nclasses,number);
for i=1:nclasses
	l=target==i;
	t(i,l)=1;
end


clear d              1x1              8  double array
%clear data     616x2           9856  double array
clear i              1x1              8  double array
clear k              1x361         2888  double array
%clear number         1x1              8  double array
clear class        231x2           3696  double array
clear kr           384x1           3072  double array
clear l            615x1           4920  double array (logical)
%clear flexure        1x1              8  double array
clear mr           384x1           3072  double array
clear mtr          615x1           4920  double array
%clear inclasses       5x1             40  double array
%clear nclasses        1x1              8  double array
clear r            384x2           6144  double array
clear my_colour         1x14            28  char array
%clear target       616x1           4928  double array
clear x              1x361         2888  double array
clear x2             1x361         2888  double array
clear xr           615x1           4920  double array
clear y              1x361         2888  double array
clear y2             1x361         2888  double array
clear yr           615x1           4920  double array
