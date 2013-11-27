clear all; close all;
load('sonarTrainData.mat');

N = 5;

% Get PCA result
PCA_Result = ex4_1_PCA(22,1);

InputData = PCA_Result;


for Cross_Validation_Mum = 1:10
    switch Cross_Validation_Mum
        case 1 
            ValSetInd =   [1:10];
            TrainSetInd = [11:104];
        case 2
            ValSetInd =   [11:20];
            TrainSetInd = [1:10 21:104];
        case 3
            ValSetInd  =  [21:30];
            TrainSetInd = [1:20 31:104];
        case 4
            ValSetInd  =  [31:40];
            TrainSetInd = [1:30 41:104];
        case 5
            ValSetInd  =  [41:50];
            TrainSetInd = [1:40 51:104];
        case 6
            ValSetInd  =  [51:60];
            TrainSetInd = [1:50 61:104];
        case 7
            ValSetInd  =  [61:70];
            TrainSetInd = [1:60 71:104];
        case 8
            ValSetInd  =  [71:80];
            TrainSetInd = [1:70 81:104];
        case 9
            ValSetInd  =  [81:90];
            TrainSetInd = [1:80 91:104];
        case 10
            ValSetInd  =  [91:100];
            TrainSetInd = [1:90 101:104];
    end
    
    
    for i=1:size(TrainSetInd,2)
        TrainSet(i,:) = InputData(TrainSetInd(i),:);
    end
    for i=1:size(TrainSetInd,2)
        TrainSetOutput(i,:) = outputSonarTrain(TrainSetInd(i),:);
    end
    for i=1:size(ValSetInd,2)
        ValSet(i,:) = InputData(ValSetInd(i),:);
    end
    for i=1:size(ValSetInd,2)
        ValOutput(i,:) = outputSonarTrain(ValSetInd(i),:);
    end
    
    % KNN Classifier
    for i=1:size(ValSetInd,2)
        KNN_Result(i,1) = ex5_KNN(N,TrainSet,TrainSetOutput,ValSet(i,:));
        if KNN_Result(i,1)>0.5
            KNN_Output(i,1) = 1;
        else
            KNN_Output(i,1) = 0;
        end
    end
    
    % Error Calculation
    KNN_Error_Count = 0;
    for i=1:size(ValSetInd,2)
        if KNN_Output(i,1) ~= outputSonarTrain(ValSetInd(i),1)
            KNN_Error_Count = KNN_Error_Count+1;
        end
    end
    Logistic_Error_Rate = KNN_Error_Count/size(ValSetInd,2);
    
    Error(Cross_Validation_Mum,1) = Logistic_Error_Rate;
    
    
    clear TrainSet TrainSetOutput ValSet ValOutput KNN_Result KNN_Output
end

Gen_Error = mean(Error)
Gen_Err_Var = var(Error)