clear all; close all;
load('sonarTrainData.mat');


% seperate data
Class_0_index = 1;
Class_1_index = 1;
for i=1:104
    if outputSonarTrain(i) == 0
        Class_0(Class_0_index,:) = inputSonarTrain(i,:);
        Class_0_index = Class_0_index + 1;
    else
        Class_1(Class_1_index,:) = inputSonarTrain(i,:);
        Class_1_index = Class_1_index + 1;
    end
end
clear Class_0_index Class_1_index



% downsampled data
for i=1:10,
inputSonarTrainDS(:,i)=sum(inputSonarTrain(:,(i-1)*6+1:i*6),2);
end


% PCA
for i=1:60
    Mean_value(i) = mean(inputSonarTrain(:,i));
    Var_value(i)  = var(inputSonarTrain(:,i));
end
for i=1:60
    Standardization(:,i) = (inputSonarTrain(:,i)-Mean_value(i))/sqrt(Var_value(i));
end
Cov_Matrix = cov(Standardization);
[V D]=eig(Cov_Matrix);
PCA_Vector_1 = V(:,60);
PCA_Vector_2 = V(:,59);
PCA_Vector_3 = V(:,58);
PCA_1 = inputSonarTrain * PCA_Vector_1;
PCA_2 = inputSonarTrain * PCA_Vector_2;
PCA_3 = inputSonarTrain * PCA_Vector_3;
% for i=1:104
%     if outputSonarTrain(i) == 0
%         plot(PCA_1(i),PCA_2(i),'g*'); hold on;
%     else
%         plot(PCA_1(i),PCA_2(i),'r*'); hold on;
%     end
% end




% Histogram
variable_num = 1;
Histo_num = 80;
Max_value = max(inputSonarTrain);
figure;
subplot(2,2,1);hist(inputSonarTrain(:,variable_num),0:Max_value(variable_num)/Histo_num:Max_value(variable_num));
subplot(2,2,3);hist(Class_0(:,variable_num),0:Max_value(variable_num)/Histo_num:Max_value(variable_num));
subplot(2,2,4);hist(Class_1(:,variable_num),0:Max_value(variable_num)/Histo_num:Max_value(variable_num));


% Fisher Index
for i=1:60
   mean_0 = mean(Class_0(:,i));
   mean_1 = mean(Class_1(:,i));
   var_0  =  var(Class_0(:,i));
   var_1  =  var(Class_1(:,i));
   FI(i,1) = (mean_0 - mean_1)^2/((size(Class_0,1)-1)*var_0 + (size(Class_1,1)-1)*var_1);
   FI(i,2) = i;
end
FI_result = sortrows(FI,-1);


% extract useful data
for i=1:10
    UsefulData(:,i) = inputSonarTrain(:,FI_result(i,2));
end


% figure;
% for i=1:104
%     if outputSonarTrain(i) == 0
%         plot(inputSonarTrain(i,FI_result(1,2)),inputSonarTrain(i,FI_result(2,2)),'g*'); hold on;
%     else
%         plot(inputSonarTrain(i,FI_result(1,2)),inputSonarTrain(i,FI_result(2,2)),'r*'); hold on;
%     end
% end



