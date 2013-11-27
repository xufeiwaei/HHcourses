clear all; close all;
load('sonarTrainData.mat');


% downsampled data
for i=1:10,
    inputSonarTrainDS(:,i)=sum(inputSonarTrain(:,(i-1)*6+1:i*6),2);
end
for i=1:10,
    inputSonarTestDS(:,i)=sum(inputSonarTrain(:,(i-1)*6+1:i*6),2);
end



InputData = inputSonarTrainDS;



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
        TrainOutput(i,:) = outputSonarTrain(TrainSetInd(i),:);
    end
    for i=1:size(ValSetInd,2)
        ValSet(i,:) = InputData(ValSetInd(i),:);
    end
    for i=1:size(ValSetInd,2)
        ValOutput(i,:) = outputSonarTrain(ValSetInd(i),:);
    end


    % Linear Gaussian Classifier
    for i=1:size(ValSetInd,2)
        Gaussian_Classifier_Result(i,1) = Linear_Gaussian_Classifier(TrainSet,TrainOutput,ValSet(i,:));
        if Gaussian_Classifier_Result(i,1)>0
            Gaussian_Classifier_Output(i,1) = 1;
        else
            Gaussian_Classifier_Output(i,1) = 0;
        end
    end
    
    
    Gaussian_Error_Count = 0;
    for i=1:size(ValSetInd,2)
        if Gaussian_Classifier_Output(i,1) ~= outputSonarTrain(ValSetInd(i),1)
            Gaussian_Error_Count = Gaussian_Error_Count+1;
        end
    end
    Gaussian_Error_Rate = Gaussian_Error_Count/size(ValSetInd,2);

    Error(Cross_Validation_Mum,1) = Gaussian_Error_Rate;

    clear TrainSet TrainOutput ValSet ValOutput Gaussian_Classifier_Result Gaussian_Classifier_Output
end

Gen_Error = mean(Error)
Gen_Err_Var = var(Error)