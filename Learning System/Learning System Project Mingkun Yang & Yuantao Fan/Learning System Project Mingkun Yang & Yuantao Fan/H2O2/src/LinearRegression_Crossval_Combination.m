clear all;
Sample = load('ChemTrainNew.mat');
Sampleindex = load('id.mat');

index = flipdim(Sampleindex.id,1);

X=Sample.XtrainDS;
Y=Sample.YtrainDS;
XT=Sample.XtestDS;

Index = log(Y)>1;

Y_ext = Y(Index);
X_ext = X(Index,:);
trainY = Y_ext;

X = log(X_ext);

% warning off
N = 5;
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
        sse = crossval(@RegressperFormance,trainX,trainY);
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

xtest(:,1) = XT(:,9);
xtest(:,2) = XT(:,65);
xtest(:,3) = XT(:,37);
xtest(:,4) = XT(:,10);
xtest(:,5) = XT(:,8);


xtrain(:,1) = X(:,9);
xtrain(:,2) = X(:,65);
xtrain(:,3) = X(:,37);
xtrain(:,4) = X(:,10);
xtrain(:,5) = X(:,8);

ytrain = trainY;
B = regress(ytrain,xtrain);
Y_estimate = xtest * B ;
% Y_estimate =  xtest * B ;
% sse = sum((Y_estimate - ytest).^2);



