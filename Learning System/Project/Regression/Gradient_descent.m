function [optTheta,functionVal,exitFlag]=Gradient_descent( )  
%GRADIENT_DESCENT Summary of this function goes here  
%   Detailed explanation goes here  
  
  options = optimset('GradObj','on','MaxIter',100);  
  initialTheta = zeros(66,1);  
  [optTheta,functionVal,exitFlag] = fminunc(@costFunction2,initialTheta,options);  
  
end  

