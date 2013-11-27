%resample_periodic.m
%input s=signal to be resample
%      P=number of points after resample
%output c= resampled signal of P points
%usage: xr=resample_periodic(x,128);

function c=resample_periodic(s,P)

se=[s' s' s']';%make signal "periodic"
ser=resample(se,3*P,3*length(s),2);

c=ser(P+1:P+128);
