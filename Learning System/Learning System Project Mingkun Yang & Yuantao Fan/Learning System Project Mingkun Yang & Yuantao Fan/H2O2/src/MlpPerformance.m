function sse = MlpPerformance(xtrain,ytrain,xtest,ytest)

net = newff(xtrain',ytrain',10, {}, 'trainbr');
% net = newff(trainX',trainY',38);
% net = newff(simplefitInputs,simplefitTargets,20)
net.trainParam.goal = 0.0001;
net.divideParam.trainratio = 1;
net.divideParam.valratio = 0;
net.divideParam.testratio = 0;
% net.performFcn='msereg';
% net.performParam.ratio=0.8;
[net tr]= train(net,xtrain',ytrain');
Y_estimate = sim(net,xtest');
sse = sum((Y_estimate' - ytest).^2);


end