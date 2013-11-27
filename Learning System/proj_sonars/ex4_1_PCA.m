function PCA_Result = ex4_1_PCA(Quantity1,Quantity2)

    load('sonarTrainData.mat');


    % Combine training data and test data
    DATA = [inputSonarTrain;inputSonarTest];

    % Fisher Index
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
    for i=1:Quantity1
        UsefulData(:,i) = DATA(:,FI_result(i,2));
        inputSonarTrainUseful(:,i) = inputSonarTrain(:,FI_result(i,2));
    end

    % Standardization
    for i=1:Quantity1
        Mean_value(i) = mean(UsefulData(:,i));
        Var_value(i)  = var(UsefulData(:,i));
    end
    for i=1:Quantity1
        Standardization_Reult(:,i) = (UsefulData(:,i)-Mean_value(i))/sqrt(Var_value(i));
    end


    % PCA
    Cov_Matrix = cov(Standardization_Reult);
    [V D]=eig(Cov_Matrix);

    for i=1:Quantity1
        PCA_Result(:,i) = inputSonarTrainUseful*V(:,i);
    end

%     figure;
%     for i=1:104
%         if outputSonarTrain(i) == 0
%             plot(PCA_Result(i,Quantity1),PCA_Result(i,Quantity1-1),'g*'); hold on;
%         else
%             plot(PCA_Result(i,Quantity1),PCA_Result(i,Quantity1-1),'r*'); hold on;
%         end
%     end
    
    PCA_Result = PCA_Result(:,Quantity1-Quantity2:Quantity1);
end