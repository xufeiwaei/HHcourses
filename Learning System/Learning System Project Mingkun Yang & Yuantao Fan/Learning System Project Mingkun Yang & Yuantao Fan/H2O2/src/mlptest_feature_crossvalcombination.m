clear all;
Sample = load('ChemTrainNew.mat');

X=Sample.XtrainDS;
Y=Sample.YtrainDS;
XT=Sample.XtestDS;

% Yn=zeros(4466,65);
% 
% for ii=1:65,
%     Yn(:,ii)=Y(:,1);
% end

% net = newff(X',Y',20);
% net = train(net,X',Y');
% simplefitOutputs = sim(net,XT);

Rc = [3 6 16 49 50 53 65 10 9 51 52 37 8];
Ra = [3 6 16 49 50 53 65 51 52];
Rb = [4 10 19 27 28 38 42 50];
Rx = [10 9 37 65 8];

Xa = X(:,Ra);
Xb = X(:,Rb);
Xx = X(:,Rx);
xtest=XT(:,Ra);

net = newff(Xa',Y',10);
 net.trainParam.epochs = 100;
net.trainParam.goal = 0.0001;
net.divideParam.trainratio = 1;
 net.trainParam.goal = 0.0005; 
[net tr] = train(net,Xa',Y');

simplefitOutputs = sim(net,xtest');






