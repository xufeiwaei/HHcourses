Y1=MLPYfit1;
Y2=MLPYfit2;
Y3=MLPYfit;
MSE1=MLPfMSE1;
MSE2=MLPfMSE2;
MSE3=MLPfMSE;
%combline two model result
Ycommittefit=((1/MSE1)/(1/MSE1+1/MSE2+1/MSE3))*Y1+((1/MSE2)/(1/MSE1+1/MSE2+1/MSE3))*Y2+((1/MSE3)/(1/MSE1+1/MSE2+1/MSE3))*Y3;
NewMSE=CalMSE(Ycommittefit,Y);
figure,plot(1:size(Y(:,1)),Y,'o',1:size(Y(:,1)),Ycommittefit,'r.');