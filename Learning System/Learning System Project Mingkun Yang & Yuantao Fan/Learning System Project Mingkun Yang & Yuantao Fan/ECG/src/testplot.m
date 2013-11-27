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

xtrain(:,1) = X(:,310);
% xtrain(:,2) = X(:,274);
% xtrain(:,3) = X(:,202);
% xtrain(:,4) = X(:,203);

Ytrain = Y(1:100,1);
Ytest = Y(101:200,1);
xtrain1 = xtrain(1:100,:);
xtest = xtrain(101:200,:);

% Ytrain = [Ytrain22 == 0, Ytrain22 == 1];

c = knnclassify(xtest, xtrain1, Ytrain,10);
% B = mnrfit(xtrain1,Ytrain);
% class = mnrval(B, xtest);
% [tmp class] = max(class, [], 2);
% [tmp YY] = max(Ytest, [], 2);


indices1 = c(:,1);
index11 = (indices1 == 1); train1 = ~index11;
index00 = (indices1 == 0); train0 = ~index00;

Xt0(:,1) = xtest(train0,1);
Xt1(:,1) = xtest(train1,1);
% Xt00(:,1) = xtest(train0,2);
% //Xt11(:,1) = xtest(train1,2);

% 
% indices2 = Y(101:200,1);
% index11 = (indices2 == 1); train1 = ~index11;
% index00 = (indices2 == 0); train0 = ~index00;

Yt0(:,1) = c(train0,1);
Yt1(:,1) = c(train1,1);

% Yt0(:,1) = xtest(train0,1);
% Yt1(:,1) = xtest(train1,1);
% Yt00(:,1) = xtest(train0,2);
% Yt11(:,1) = xtest(train1,2);


figure, scatter(Xt0,Yt0,40,[1 0 0],'+');
hold on,scatter(Xt1,Yt1(:,1),40,[1 0 0],'o');
scatter(Yt0,Yt0,40,[0 0 1],'+');
scatter(Yt1,Yt1(:,1),40,[0 0 1],'o');
title('ScatterTest');
xlabel('Xd1');
ylabel('Xd2');
hold off;











