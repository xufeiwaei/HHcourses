%NormSC.m
%Computes the normalized scalar product between 
%two subimages.
%
%usage: sim1=NormSC(im1,im2);
%input: im1 and im2; subimages of equal size; type double
%output: sim1; the normalized scalar product of im1 and im2.
%
%Kenneth Nilsson/22 juni 2009


function SC=NormSC(Sub1,Sub2)

%make double 
%Sub1=double(Sub1);
%Sub2=double(Sub2);

%Length of subimages
L1=sqrt(sum(sum(Sub1.*Sub1)));
L2=sqrt(sum(sum(Sub2.*Sub2)));

%Scalar product
SProd=sum(sum(Sub1.*Sub2));

%Normalized scalar product
SC=SProd/(L1*L2);
