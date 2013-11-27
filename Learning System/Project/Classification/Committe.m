Y1=Yresult;
Y2=YresultMLPcon;
MSE1=klosskfinal;
MSE2=trf.best_vperf;
%combline two model result
YcommitteResult1=(MSE2/(MSE1+MSE2))*Y1+(MSE1/(MSE1+MSE2))*Y2;
YcommitteResult=zeros(2200,3);
for loopcommittefit=1:size(YcommitteResult1,1)
    if YcommitteResult1(loopcommittefit,1)<1.5 && YcommitteResult1(loopcommittefit,1)>0.8
        YcommitteResult(loopcommittefit,1)=1;
    elseif YcommitteResult1(loopcommittefit,1)<2.5 && YcommitteResult1(loopcommittefit,1)>1.5
        YcommitteResult(loopcommittefit,2)=1;
    else
        YcommitteResult(loopcommittefit,3)=1;
    end
end
