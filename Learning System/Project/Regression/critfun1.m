function sse = critfun1(xtrain,ytrain,xtest,ytest)

mdlcross=LinearModel.fit(xtrain,ytrain,'linear','robust','on');
B =double(mdlcross.Coefficients);
Y_estimate =  B(1,1)+xtest * B(2:35,1) ;
sse = sum((Y_estimate - ytest).^2);

end

