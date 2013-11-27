clear;
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

Ra = [3 6 16 49 50 51 52 53 65];
Rb = [4 10 19 27 28 38 42 50];

Xa = X(:,Ra);
Xb = X(:,Rb);
MLP_p = zeros(80,2);

for i=1:30

net = newff(Xa',Y',i);
 net.trainParam.epochs = 100;
% net.trainParam.show = 50; %系统每50步显示一次训练误差的变化曲线  
%  net.trainParam.lr = 0.001; %学习速率  
% net.trainParam.lr_inc = 1.08; %Ratio to increase learning rate  
% net.trainParam.lr_dec = 0.6;   %Ratio to decrease learning rate  
 net.trainParam.goal = 0.0005; 
[net tr] = train(net,Xa',Y');

MLP_p(i,1) = tr.vperf(tr.best_epoch)
MLP_p(i,2) = i;

%simplefitOutputs = sim(net,XT);

end

plot(MLP_p(:,2),MLP_p(:,1));
% for Xa no.38 err=9.4432;
% for Xb no.56 err=11.3031;







