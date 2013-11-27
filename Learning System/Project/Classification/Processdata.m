load thyroidTrain.mat;
X=trainThyroidInput;
Y=trainThyroidOutput;

class1=Y(:,1);
class2=Y(:,2);
class3=Y(:,3);
    
% seperate data
Class1Tcount = 1;
Class1Fcount = 1;
Class2Tcount = 1;
Class2Fcount = 1;
Class3Tcount = 1;
Class3Fcount = 1;
for loopi=1:size(X,1)
    if (class1(loopi) == 1)
        Class1T(Class1Tcount,:) = X(loopi,:);
        Class1Tcount = Class1Tcount + 1;
    else 
        Class1F(Class1Fcount,:) = X(loopi,:);
        Class1Fcount = Class1Fcount + 1;
    end
end
for loopj=1:size(X,1)
    if (class2(loopj) == 1)
        Class2T(Class2Tcount,:) = X(loopj,:);
        Class2Tcount = Class2Tcount + 1;
    else 
        Class2F(Class2Fcount,:) = X(loopj,:);
        Class2Fcount = Class2Fcount + 1;
    end
end
for loopk=1:size(X,1)
    if (class3(loopk) == 1)
        Class3T(Class3Tcount,:) = X(loopk,:);
        Class3Tcount = Class3Tcount + 1;
    else 
        Class3F(Class3Fcount,:) = X(loopk,:);
        Class3Fcount = Class3Fcount + 1;
    end
end
classcount=Class1Tcount+Class2Tcount+Class3Tcount-3;
    
    
    % Fisher Index
for i=1:21
    mean1T = mean(Class1T(:,i));
    mean1F = mean(Class1F(:,i));
    var1T  =  var(Class1T(:,i));
    var1F  =  var(Class1F(:,i));
    FI1(i,2) = (mean1T - mean1F)^2/((size(Class1T,1)-1)*var1T + (size(Class1F,1)-1)*var1F);
    FI1(i,1) = i;
end
    %output1 = sortrows(FI1,-2);
for j=1:21
    mean2T = mean(Class2T(:,j));
    mean2F = mean(Class2F(:,j));
    var2T  =  var(Class2T(:,j));
    var2F  =  var(Class2F(:,j));
    FI2(j,2) = (mean2T - mean2F)^2/((size(Class2T,1)-1)*var2T + (size(Class2F,1)-1)*var2F);
    FI2(j,1) = j;
end
    %output2 = sortrows(FI2,-2);
for k=1:21
    mean3T = mean(Class3T(:,k));
    mean3F = mean(Class3F(:,k));
    var3T  =  var(Class3T(:,k));
    var3F  =  var(Class3F(:,k));
    FI3(k,2) = (mean3T - mean3F)^2/((size(Class3T,1)-1)*var3T + (size(Class3F,1)-1)*var3F);
    FI3(k,1) = k;
end
    %output3 = sortrows(FI3,-2);
    FI(:,1)=FI1(:,1);
    FI(:,2)=(FI1(:,2)+FI2(:,2)+FI3(:,2))/3;
    outputFI = sortrows(FI,-2);
    
  
 