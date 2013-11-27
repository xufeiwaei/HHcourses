function sse = critfunpls2(xtrain,ytrain,xtest,ytest)

[XLcross,YLcross,XScross,YScross,betacross,PCTVARcross,MSEcross,statscross]=plsregress(xtrain,ytrain,10,'cv',10);
Y_estimate=[ones(size(xtest(:,1)),1) xtest]*betacross;
sse = sum((Y_estimate - ytest).^2);

end

