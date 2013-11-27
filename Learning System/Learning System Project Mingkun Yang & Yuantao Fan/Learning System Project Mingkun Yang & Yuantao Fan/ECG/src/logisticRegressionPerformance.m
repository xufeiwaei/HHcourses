function sse = logisticRegressionPerformance(xtrain,ytrain,xtest,ytest)

B = mnrfit(xtrain,ytrain);
Y_estimate = mnrval(B, xtest);
[tmp Y_estimate] = max(Y_estimate, [], 2);
[tmp Y] = max(ytest, [], 2);
sse = sum(Y_estimate ~= Y);

end