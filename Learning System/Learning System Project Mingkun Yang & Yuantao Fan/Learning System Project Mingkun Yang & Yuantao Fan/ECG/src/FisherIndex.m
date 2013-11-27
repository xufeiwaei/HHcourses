clear all
Sample = load('ECGITtrain.mat');

X=Sample.inputECGITtrain;
Y=Sample.outputECGITtrain;
XT=Sample.inputECGITtest;

indices = Y;
index1 = (indices == 1); train1 = ~index1;
index0 = (indices == 0); train0 = ~index0;

Yr0 = Y(train1,:);
Yr1 = Y(train0,:);
Xr0 = X(train1,:);
Xr1 = X(train0,:);

ux0 = mean(Xr0,1);
ux1 = mean(Xr1,1);
vx0 = var(Xr0,1);
vx1 = var(Xr1,1);

myFI = ((ux0 - ux1).^2)./(100*( vx0 + vx1 ));

NN = 312;

for kk=1:NN
    FI(kk,1) = ((ux0(1,kk) - ux1(1,kk))^2) / (100*(vx0(:,kk)+vx1(:,kk)));
end
min(min(myFI == FI'))

% [SortFI index] = sortrows(abs(FI(:,1)),1);
% SortFI(:,1)=SortFI;
% SortFI(:,2)=index;
%
% Xinp10 = Xr0(:,77);
% Xinp11 = Xr1(:,77);
% Xinp20 = Xr0(:,259);
% Xinp21 = Xr1(:,259);

[myFI index] = sort(myFI, 2, 'descend');
acc =  index;
myFI(1:5);
% for i=1:5
%     targetIndex = index(i);
%     figure(i)
%     plot(X(:,targetIndex), Y, '*')
% end
trainY = [Y == 0, Y == 1];
% warning off
N = 8;
mse = [];
combination = {};
clc
for i=1:N
    combinationTmp = nchoosek(1:N, i);
    for j=1:size(combinationTmp,1)
        clear trainX
        for k=1:i
            trainX(:, k) = X(:, index(combinationTmp(j, k)));
        end
%         sse = crossval(@logisticRegressionPerformance, trainX, trainY);
%         sse = crossval(@KNNPerformance, trainX, trainY);
         sse = crossval(@gaussianClassifierPerformance, trainX, trainY);
%          sse = crossval(@MlpPerformance, trainX, trainY);
        mse(size(mse,1)+1, 1) = sum(sse)/size(trainY, 1);
        combination(size(combination,1)+1, :) = {combinationTmp(j, :)};
    end
end
[tmp index1] = sort(mse);
for i=1:5
    disp('conclusion')
    mse(index1(i))
    combination{index1(i)}
end

ind = [310];
xtest = XT(:,ind);
xtrain = X(:,ind);

ytrain = [Y == 0, Y == 1];

c = knnclassify(xtest, xtrain, ~ytrain(:,1),10);






