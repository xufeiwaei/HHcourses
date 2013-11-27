function sse = KNNPerformance(xtrain,ytrain,xtest,ytest)

c = knnclassify(xtest, xtrain, ~ytrain(:,1),7);
sse = sum(c ~= ~ytest(:,1));

end