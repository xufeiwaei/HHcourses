Y1=MLPtestY1;
Y2=MLPtestY2;
Y3=MLPtestY;
MSE1=MLPfMSE1;
MSE2=MLPfMSE2;
MSE3=MLPfMSE;
%combline two model result
NNcommitteResult=((1/MSE1)/(1/MSE1+1/MSE2+1/MSE3))*Y1+((1/MSE2)/(1/MSE1+1/MSE2+1/MSE3))*Y2+((1/MSE3)/(1/MSE1+1/MSE2+1/MSE3))*Y3;
