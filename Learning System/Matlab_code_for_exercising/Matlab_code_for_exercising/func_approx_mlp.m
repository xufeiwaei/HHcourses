n=100; %Number of data
d=0.05; %Noise level
hidden=15; %Number of hidden nodes

x=rand(1,n)*2-1; % random data points
xs=-1:0.01:1; % data over the whole range (for plotting)

truez=sin(x*3).*sin(cos(x*4)*3.7); % targets
truey=sin(xs*3).*sin(cos(xs*4)*3.7); % function
randz=randn(1,n)*d; % noise
z=randz+truez; % targets + noise

%figure(2)
% net=newff([-1 1],[hidden 1]);  %Initialization
% net.trainParam.epochs = 250; % Number of iterations
net = newff(x,z,hidden);
net = train(net,x,z); % training
y=sim(net,xs);        % Simulation

%Results
figure(1)
clf
plot(xs,truey,'g--')
hold on
plot(x,z,'+')
hold on
plot(xs,y(:),'r')


%To study
    %Error rate as a function of 
    %1 noise level;
    %2 number of data points;
    %3 network size;
        %	a) for a small data set;
        %	b) for a large data set;
    %4 training time, when the learning data set is small