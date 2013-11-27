function [ jVal,gradient ] = costFunction2( theta )  
%COSTFUNCTION2 Summary of this function goes here  
%   linear regression -> y=theta0 + theta1*x  
%   parameter: x:m*n  theta:n*1   y:m*1   (m=4,n=1)  
%     
  
%Data  
load ChemTrainNew.mat;
X=XtrainDS;
Y=YtrainDS;
m=size(X,1); 
  
hypothesis = h_func(X,theta);  
delta = hypothesis - Y;  
jVal=sum(delta.^2);  
  
gradient(1)=sum(delta)/m;  
gradient(2)=sum(delta.*X)/m;  

end

