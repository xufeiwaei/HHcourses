function result = Logistic_Regression(TrainSetInput,TrainSetOutput,Input)
    
    % Seperate Training data
    Class_0_index = 1;
    Class_1_index = 1;
    for i=1:size(TrainSetInput,1)
        if TrainSetOutput(i) == 0
            Class_0(Class_0_index,:) = TrainSetInput(i,:);
            Class_0_index = Class_0_index + 1;
        else
            Class_1(Class_1_index,:) = TrainSetInput(i,:);
            Class_1_index = Class_1_index + 1;
        end
    end
    clear Class_0_index Class_1_index
    
    
    Cov_Martrix = cov(TrainSetInput);
    Inv_Cov = inv(Cov_Martrix);
    Mean_Class0 = mean(Class_0);
    Mean_Class1 = mean(Class_1);
    
    
    gamma = log(size(Class_0,1)/size(Class_1,1)) + (Mean_Class1*Inv_Cov*Mean_Class1' - Mean_Class0*Inv_Cov*Mean_Class0')/2;
    betta = Inv_Cov*(Mean_Class0'-Mean_Class1');
    
    result = 1/(1+exp(-gamma-betta'*Input'));
end