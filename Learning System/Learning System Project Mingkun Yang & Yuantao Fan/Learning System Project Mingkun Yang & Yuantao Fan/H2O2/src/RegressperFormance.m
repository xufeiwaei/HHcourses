function sse = RegressperFormance(xtrain,ytrain,xtest,ytest)

B = regress(ytrain,xtrain);
Y_estimate =  xtest * B ;
sse = sum((Y_estimate - ytest).^2);

end