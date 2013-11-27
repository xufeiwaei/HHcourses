% Given:
%		Two data clusters d1 ir d2
% 		Number of data in the clusters n1 ir n2
nntwarn off

	% Visualization of clusters
figure(1);clf;hold on
plot(d1(1,:),d1(2,:),'r+');
plot(d2(1,:),d2(2,:),'g+');
axis('equal');

% matrices to draw decision boundaries
[x,y]=meshgrid(min(min(d1)):.1:max(max(d1)),min(min(d2)):.1:max(max(d2))); % x ir y matrices 
z=x;	% z matrix



%%------------------------------------------
% 1111111111111111111111111111111111
%%------------------------------------------
% Euclidean distance classifier
x1=mean(d1');
x2=mean(d2');
plot(x1(1),x1(2),'k+','MarkerSize',12,'LineWidth',4)
plot(x2(1),x2(2),'ko','MarkerSize',12,'LineWidth',4)
plot([x1(1),x2(1)],[x1(2) x2(2)],'k:')

	% weights
w=x1-x2;

middle = (x1+x2)/2;
z(:) = [x(:)-middle(1) y(:)-middle(2)]*w';
contour (x,y,z,[0,0],'b');		% contour where z=0


%%------------------------------------------
% 2222222222222222222222222222222222
%%------------------------------------------
% Pseudoinverse
d=[[ones(n1,1);ones(n2,1)] [d1';d2']];
tar=[zeros(n1,1);ones(n2,1)];

w = pinv(d)*tar;

z(:)=w(1)+x(:)*w(2)+ y(:)*w(3);		% discriminant function

contour (x,y,z,[0.5,0.5],'r');		% contour where z=0


%%------------------------------------------
% 3333333333333333333333333333333333
%%------------------------------------------
% Perceptron

   % parameters
df = 100;   % visualization frequency
me = 200;   % Maximum number of epochs to train.
eg=.00000000001;	% error to stop training
lr=0.5;		% learning rate
tp = [df me eg lr];

d=[d1';d2'];	% data
net = newff(d',tar');
net = train(net,d',tar');
z(:)= sim(net,[x(:) y(:)]');   % discriminant function

contour (x,y,z,[0.5,0.5],'g');		% contour where z=0



%%------------------------------------------
% Legend 
legend('Class 1',...
	'Class 2',...
	'Class 1 center',...
	'Class 2 center',...
	'Line connecting class centers',... 
	'Euclidean',...
	'Pseudoinverse',...
	'Perceptron',...
	0)

h=get(figure(1),'children');
set(h(1),'Position',[0.02 0.05 0.3 0.16 ])

