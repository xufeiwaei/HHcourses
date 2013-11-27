Y1=Yresult;
Y2=YresultPLS;
Y3=MLPtestY;
MSE1=msef;
MSE2=msepls1;
MSE3=tr3.best_vperf;
%combline three model result
ModelcommitteResult=((1/MSE1)/(1/MSE1+1/MSE2+1/MSE3))*Y1+((1/MSE2)/(1/MSE1+1/MSE2+1/MSE3))*Y2+((1/MSE3)/(1/MSE1+1/MSE2+1/MSE3))*Y3;
