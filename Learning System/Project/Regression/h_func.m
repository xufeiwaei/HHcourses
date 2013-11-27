function [res] = h_func(inputx,theta)  
%H_FUNC Summary of this function goes here  
%   Detailed explanation goes here  
  
  
%cost function 2  
for ii=2:66
    temp=temp+theta(ii)*inputx(ii);
end
res= theta(1)+temp;  
end  

