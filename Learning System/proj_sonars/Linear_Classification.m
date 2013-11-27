clear all; close all;
load('sonarTrainData.mat');


% downsampled data
for i=1:10,
    inputSonarTrainDS(:,i)=sum(inputSonarTrain(:,(i-1)*6+1:i*6),2);
end
for i=1:10,
    inputSonarTestDS(:,i)=sum(inputSonarTrain(:,(i-1)*6+1:i*6),2);
end


% seperate data
Class_0_index = 1;
Class_1_index = 1;
for i=1:104
    if outputSonarTrain(i) == 0
        Class_0(Class_0_index,:) = inputSonarTrainDS(i,:);
        Class_0_index = Class_0_index + 1;
    else
        Class_1(Class_1_index,:) = inputSonarTrainDS(i,:);
        Class_1_index = Class_1_index + 1;
    end
end
clear Class_0_index Class_1_index


% Histogram
variable_num = 1;
Histo_num = 30;
Max_value = max(inputSonarTrainDS);
figure;
subplot(2,2,1);hist(inputSonarTrainDS(:,variable_num),0:Max_value(variable_num)/Histo_num:Max_value(variable_num));
subplot(2,2,3);hist(Class_0(:,variable_num),0:Max_value(variable_num)/Histo_num:Max_value(variable_num));
subplot(2,2,4);hist(Class_1(:,variable_num),0:Max_value(variable_num)/Histo_num:Max_value(variable_num));


Cov_Martrix = cov(inputSonarTrainDS);
Inv_Cov = inv(Cov_Martrix);
Mean_Class0 = mean(Class_0);
Mean_Class1 = mean(Class_1);


% Logistic Regression
gamma = log(49/55) + (Mean_Class1*Inv_Cov*Mean_Class1' - Mean_Class0*Inv_Cov*Mean_Class0')/2;
betta = Inv_Cov*(Mean_Class0'-Mean_Class1');
for i=1:104
    Logistic_Classifier_Result(i,1) = 1/(1+exp(-gamma-betta'*inputSonarTrainDS(i,:)'));
    if Logistic_Classifier_Result(i,1)>0.5
        Logistic_Classifier_Output(i,1) = 0;
    else
        Logistic_Classifier_Output(i,1) = 1;
    end
end
Logistic_Error_Count = 0;
for i=1:104
    if Logistic_Classifier_Output(i,1) ~= outputSonarTrain(i,1)
        Logistic_Error_Count = Logistic_Error_Count+1;
    end
end
Logistic_Error_Rate = Logistic_Error_Count/104


% Linear Gaussian Classifier
for i=1:104
    Gaussian_Classifier_Result(i,1) = ((inputSonarTrainDS(i,:)-Mean_Class0)*Inv_Cov*(inputSonarTrainDS(i,:)-Mean_Class0)' - (inputSonarTrainDS(i,:)-Mean_Class1)*Inv_Cov*(inputSonarTrainDS(i,:)-Mean_Class1)')/2 - log(49/55);
    if Gaussian_Classifier_Result(i,1)>0
        Gaussian_Classifier_Output(i,1) = 1;
    else
        Gaussian_Classifier_Output(i,1) = 0;
    end
end
Gaussian_Error_Count = 0;
for i=1:104
    if Gaussian_Classifier_Output(i,1) ~= outputSonarTrain(i,1)
        Gaussian_Error_Count = Gaussian_Error_Count+1;
    end
end
Gaussian_Error_Rate = Gaussian_Error_Count/104


% Perceptron
net = newff(inputSonarTrainDS',outputSonarTrain');
net.divideFcn = 'divideind';
net.divideParam.trainInd = 36:104;
net.divideParam.valInd = 1:35;

[net tr] = train(net,inputSonarTrainDS',outputSonarTrain');
for i=1:104
    Perceptron_Classifier_Result(i,1) = net(inputSonarTrainDS(i,:)');
    if Perceptron_Classifier_Result(i,1)>0.5
        Perceptron_Classifier_Output(i,1) = 1;
    else
        Perceptron_Classifier_Output(i,1) = 0;
    end
end
Perceptron_Error_Count = 0;
for i=1:104
    if Perceptron_Classifier_Output(i,1) ~= outputSonarTrain(i,1)
        Perceptron_Error_Count = Perceptron_Error_Count + 1;
    end
end
Perceptron_Error_Rate = Perceptron_Error_Count/104