number=1000; sNumber=number; %The number of data will be less than this number
flexure=3;	    %Function complexity
nclasses=3;		%Number of classes

epiclasses; % Data generation
	% input vectors                         	number x 2   
	% number        Number of data points		1 x 1
	% inclasses     data number in classes		nclasses x 1
	% target        target vectors  			number x 1
	% t             target vectors  			nclasses x number 

pause

%training
%figure(2)
%net=newff([-4 4;-4 4],[15 nclasses]); %Initialization
net=newff(data',t,15);
net.trainParam.epochs = 100; %Number of iterations
net.trainParam.goal = 0.01;
[net,tr] = train(net,data',t); %Training

%Simulation
%figure(1);clf;hold on

%network outputs for the training set data
resim=sim(net,data'); 
[i jm]=max(resim); % finding the maximum output (jm)
lm=jm~=target'; %
em=sum(lm)/number*100; % errors for the training set


%network outputs for the test set data
number=sNumber;
epiclasses % new data
resim=sim(net,data'); 
[i jt]=max(resim); % finding the maximum output (jt)
lt=jt~=target';
et=sum(lt)/number*100; % errors for the test set

color='rgbcmykrgbcmyk';
for i=1:nclasses  %visualizing classification result
	l=jt==i;
	plot(data(l,1),data(l,2),[color(i) '.'],'markersize' ,10);
end

%visualizing errors
fprintf(1,'\nTraining set error   %5.2f%% \nTest set error %5.2f%%\n',em,et)
%errors are shown in blue circles
plot(data(lt,1),data(lt,2),'bo','markersize' ,12);

% To study:
% The classification accuracy:
%       when the number of classes is changed
%       when the number of data is changed 
%       when network size (complexity) is changed
%       when the number of training iterations is changed
%            	a) for a small data set
%           	b) for a large data set
%       when function complexity is changed
%           	a) for a small network (low complexity)
%           	b) for a large network 
