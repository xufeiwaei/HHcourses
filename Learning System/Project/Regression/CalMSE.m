function [ MSE ] = CalMSE(YfitDS,YclassDS)
SSE=0;
    for loopSse=1:size(YfitDS,1)
        SSE=(YfitDS(loopSse,1)-YclassDS(loopSse,1))^2+SSE;
    end
    MSE = SSE/size(YfitDS,1);
end

