function [ MSE ] = CalMSE(YfitDS,YclassDS)
SSE=0;
    for loopSse=1:size(YfitDS,1)
        SSE=SSE+(YfitDS(loopSse,1)-YclassDS(loopSse,1))^2;
    end
    MSE = SSE/size(YfitDS,1);
end

