function sse = gaussianClassifierPerformance(xtrain,ytrain,xtest,ytest)
class = classify(xtest, xtrain, ~ytrain(:,1));

[tmp Y] = max(ytest, [], 2);
sse = sum(class ~= Y-1);

end