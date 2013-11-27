Y1=Yfit6fertures;
Y2=YfitMLPcon;
MSE1=klosskfinal;
MSE2=trf.best_vperf;
%combline two model result
Ycommittefit1=(MSE2/(MSE1+MSE2))*Y1+(MSE1/(MSE1+MSE2))*Y2;
for loopcommittefit=1:size(Ycommittefit1,1)
    if Ycommittefit1(loopcommittefit,1)<1.5 && Ycommittefit1(loopcommittefit,1)>0.8
        Ycommittefit(loopcommittefit,1)=1;
    elseif Ycommittefit1(loopcommittefit,1)<2.5 && Ycommittefit1(loopcommittefit,1)>1.5
        Ycommittefit(loopcommittefit,1)=2;
    else
        Ycommittefit(loopcommittefit,1)=3;
    end
end
col_num1 = 20;
col_num2 = 19;
figure,
for scatterloopcon=1:500
    if Ycommittefit(scatterloopcon) == 1
        plot(X(scatterloopcon,col_num1),X(scatterloopcon,col_num2),'g*'); hold on;
    elseif Ycommittefit(scatterloopcon) == 2
        plot(X(scatterloopcon,col_num1),X(scatterloopcon,col_num2),'b*'); hold on;
    else
        plot(X(scatterloopcon,col_num1),X(scatterloopcon,col_num2),'y*'); hold on;
    end
end