% load two_bend.dat
% data=two_bend;
% clear two_bend;

% load apple.dat
% data=apple;
% clear apple;

load two_nonlinear.dat
data=two_nonlinear;
clear two_nonlinear;

l=data(:,3)==0;
d1=data(l,1:2)';
d2=data(~l,1:2)';
n1=sum(l);
n2=sum(~l);

%figure(1);clf;hold on
%plot(d1(1,:),d1(2,:),'r+');
%plot(d2(1,:),d2(2,:),'g+');
%axis('equal');

Euclid_pseudoinverse_perceptron;



%------------------------------------------
% 8888888888888888888888888888888888
%------------------------------------------
% MLP

S1=6; % Number of hidden neurons
d=[d1';d2'];	% data
%tar=[[zeros(n1,1);ones(n2,1)] [ones(n1,1);zeros(n2,1)] ];	% targets
tar=[zeros(n1,1);ones(n2,1)];	% targets

fprintf(1,'\nTraining MLP ....\n\n')
net = newff(d',tar',S1);
net = train(net,d',tar');
z(:)= sim(net,[x(:) y(:)]');   % discriminant function
contour (x,y,z,[0.5,0.5],'k');		% contour where z=0.5

%%------------------------------------------
% Legend
legend('Class 1',...
	'Class 2',...
	'Class 1 center ',...
	'Class 2 center',...
	'Line connecting class centers',... 
	'Euclidean',...
	'Pseudoinverse',...
	'Perceptron',...
	'Multilayer perceptron',...
	0)

h=get(figure(1),'children');
set(h(1),'Position',[0.02 0.05 0.3 0.16 ])
