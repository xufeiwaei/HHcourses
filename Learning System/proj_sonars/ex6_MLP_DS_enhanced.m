clear all; close all;
load('sonarTrainData.mat');

% for x = 1:50
Hiden_Nodes_Num = 34;

% downsampled data
for i=1:10,
    inputSonarTrainDS(:,i)=sum(inputSonarTrain(:,(i-1)*6+1:i*6),2);
end
for i=1:10,
    inputSonarTestDS(:,i)=sum(inputSonarTrain(:,(i-1)*6+1:i*6),2);
end

InputData = inputSonarTestDS(:,[1:2 4:5 7:10]);

% Cross Validation for Logistic Regression
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



    % Perceptron 1
    net_comp_1 = newff(TrainSet',TrainOutput',Hiden_Nodes_Num);
%     net.divideFcn = 'divideind';
%     net.divideParam.trainInd = TrainSetInd;
%     net.divideParam.valInd = ValSetInd;
    net_comp_1.divideParam.trainRatio = 0.8;
    net_comp_1.divideParam.valRatio   = 0.2;
    net_comp_1.divideParam.testRatio   = 0;
    
    [net_comp_1 tr] = train(net_comp_1,TrainSet',TrainOutput');

    for i=1:size(ValSetInd,2)
        Perceptron_Classifier_Result(i,1) = net_comp_1(ValSet(i,:)');
        if Perceptron_Classifier_Result(i,1)>0.5
            Perceptron_Classifier_Output(i,1) = 1;
        else
            Perceptron_Classifier_Output(i,1) = 0;
        end
    end


    Perceptron_Error_Count = 0;
    for i=1:size(ValSetInd,2)
        if Perceptron_Classifier_Output(i,1) ~= outputSonarTrain(ValSetInd(i),1)
            Perceptron_Error_Count = Perceptron_Error_Count + 1;
        end
    end
    
    Error_Count(1) = Perceptron_Error_Count;
    
    
    
    
    % Perceptron 2
    net_comp_2 = newff(TrainSet',TrainOutput',Hiden_Nodes_Num);
%     net.divideFcn = 'divideind';
%     net.divideParam.trainInd = TrainSetInd;
%     net.divideParam.valInd = ValSetInd;
    net_comp_2.divideParam.trainRatio = 0.8;
    net_comp_2.divideParam.valRatio   = 0.2;
    net_comp_2.divideParam.testRatio   = 0;
    
    [net_comp_2 tr] = train(net_comp_2,TrainSet',TrainOutput');

    for i=1:size(ValSetInd,2)
        Perceptron_Classifier_Result(i,1) = net_comp_2(ValSet(i,:)');
        if Perceptron_Classifier_Result(i,1)>0.5
            Perceptron_Classifier_Output(i,1) = 1;
        else
            Perceptron_Classifier_Output(i,1) = 0;
        end
    end


    Perceptron_Error_Count = 0;
    for i=1:size(ValSetInd,2)
        if Perceptron_Classifier_Output(i,1) ~= outputSonarTrain(ValSetInd(i),1)
            Perceptron_Error_Count = Perceptron_Error_Count + 1;
        end
    end
    
    Error_Count(2) = Perceptron_Error_Count;
    
    
    
    % Perceptron 3
    net_comp_3 = newff(TrainSet',TrainOutput',Hiden_Nodes_Num);
%     net.divideFcn = 'divideind';
%     net.divideParam.trainInd = TrainSetInd;
%     net.divideParam.valInd = ValSetInd;
    net_comp_3.divideParam.trainRatio = 0.8;
    net_comp_3.divideParam.valRatio   = 0.2;
    net_comp_3.divideParam.testRatio   = 0;
    
    [net_comp_3 tr] = train(net_comp_3,TrainSet',TrainOutput');

    for i=1:size(ValSetInd,2)
        Perceptron_Classifier_Result(i,1) = net_comp_3(ValSet(i,:)');
        if Perceptron_Classifier_Result(i,1)>0.5
            Perceptron_Classifier_Output(i,1) = 1;
        else
            Perceptron_Classifier_Output(i,1) = 0;
        end
    end


    Perceptron_Error_Count = 0;
    for i=1:size(ValSetInd,2)
        if Perceptron_Classifier_Output(i,1) ~= outputSonarTrain(ValSetInd(i),1)
            Perceptron_Error_Count = Perceptron_Error_Count + 1;
        end
    end
    
    Error_Count(3) = Perceptron_Error_Count;
    
    
    
    % Perceptron 4
    net_comp_4 = newff(TrainSet',TrainOutput',Hiden_Nodes_Num);
%     net.divideFcn = 'divideind';
%     net.divideParam.trainInd = TrainSetInd;
%     net.divideParam.valInd = ValSetInd;
    net_comp_4.divideParam.trainRatio = 0.8;
    net_comp_4.divideParam.valRatio   = 0.2;
    net_comp_4.divideParam.testRatio   = 0;
    
    [net_comp_4 tr] = train(net_comp_4,TrainSet',TrainOutput');

    for i=1:size(ValSetInd,2)
        Perceptron_Classifier_Result(i,1) = net_comp_4(ValSet(i,:)');
        if Perceptron_Classifier_Result(i,1)>0.5
            Perceptron_Classifier_Output(i,1) = 1;
        else
            Perceptron_Classifier_Output(i,1) = 0;
        end
    end

    Perceptron_Error_Count = 0;
    for i=1:size(ValSetInd,2)
        if Perceptron_Classifier_Output(i,1) ~= outputSonarTrain(ValSetInd(i),1)
            Perceptron_Error_Count = Perceptron_Error_Count + 1;
        end
    end
    
    Error_Count(4) = Perceptron_Error_Count;
    
    
    
    
    
    % Perceptron 5
    net_comp_5 = newff(TrainSet',TrainOutput',Hiden_Nodes_Num);
%     net.divideFcn = 'divideind';
%     net.divideParam.trainInd = TrainSetInd;
%     net.divideParam.valInd = ValSetInd;
    net_comp_5.divideParam.trainRatio = 0.8;
    net_comp_5.divideParam.valRatio   = 0.2;
    net_comp_5.divideParam.testRatio   = 0;
    
    [net_comp_5 tr] = train(net_comp_5,TrainSet',TrainOutput');

    for i=1:size(ValSetInd,2)
        Perceptron_Classifier_Result(i,1) = net_comp_5(ValSet(i,:)');
        if Perceptron_Classifier_Result(i,1)>0.5
            Perceptron_Classifier_Output(i,1) = 1;
        else
            Perceptron_Classifier_Output(i,1) = 0;
        end
    end


    Perceptron_Error_Count = 0;
    for i=1:size(ValSetInd,2)
        if Perceptron_Classifier_Output(i,1) ~= outputSonarTrain(ValSetInd(i),1)
            Perceptron_Error_Count = Perceptron_Error_Count + 1;
        end
    end
    
    Error_Count(5) = Perceptron_Error_Count;
    
    
    
    
    % Perceptron 6
    net_comp_6 = newff(TrainSet',TrainOutput',Hiden_Nodes_Num);
%     net.divideFcn = 'divideind';
%     net.divideParam.trainInd = TrainSetInd;
%     net.divideParam.valInd = ValSetInd;
    net_comp_6.divideParam.trainRatio = 0.8;
    net_comp_6.divideParam.valRatio   = 0.2;
    net_comp_6.divideParam.testRatio   = 0;
    
    [net_comp_6 tr] = train(net_comp_6,TrainSet',TrainOutput');

    for i=1:size(ValSetInd,2)
        Perceptron_Classifier_Result(i,1) = net_comp_6(ValSet(i,:)');
        if Perceptron_Classifier_Result(i,1)>0.5
            Perceptron_Classifier_Output(i,1) = 1;
        else
            Perceptron_Classifier_Output(i,1) = 0;
        end
    end


    Perceptron_Error_Count = 0;
    for i=1:size(ValSetInd,2)
        if Perceptron_Classifier_Output(i,1) ~= outputSonarTrain(ValSetInd(i),1)
            Perceptron_Error_Count = Perceptron_Error_Count + 1;
        end
    end
    
    Error_Count(6) = Perceptron_Error_Count;
    
    
    
    
    
    % Perceptron 7
    net_comp_7 = newff(TrainSet',TrainOutput',Hiden_Nodes_Num);
%     net.divideFcn = 'divideind';
%     net.divideParam.trainInd = TrainSetInd;
%     net.divideParam.valInd = ValSetInd;
    net_comp_7.divideParam.trainRatio = 0.8;
    net_comp_7.divideParam.valRatio   = 0.2;
    net_comp_7.divideParam.testRatio   = 0;
    
    [net_comp_7 tr] = train(net_comp_7,TrainSet',TrainOutput');

    for i=1:size(ValSetInd,2)
        Perceptron_Classifier_Result(i,1) = net_comp_7(ValSet(i,:)');
        if Perceptron_Classifier_Result(i,1)>0.5
            Perceptron_Classifier_Output(i,1) = 1;
        else
            Perceptron_Classifier_Output(i,1) = 0;
        end
    end


    Perceptron_Error_Count = 0;
    for i=1:size(ValSetInd,2)
        if Perceptron_Classifier_Output(i,1) ~= outputSonarTrain(ValSetInd(i),1)
            Perceptron_Error_Count = Perceptron_Error_Count + 1;
        end
    end
    
    Error_Count(7) = Perceptron_Error_Count;
    
    
    
    
    
    
    % Perceptron 1
    net_comp_8 = newff(TrainSet',TrainOutput',Hiden_Nodes_Num);
%     net.divideFcn = 'divideind';
%     net.divideParam.trainInd = TrainSetInd;
%     net.divideParam.valInd = ValSetInd;
    net_comp_8.divideParam.trainRatio = 0.8;
    net_comp_8.divideParam.valRatio   = 0.2;
    net_comp_8.divideParam.testRatio   = 0;
    
    [net_comp_8 tr] = train(net_comp_8,TrainSet',TrainOutput');

    for i=1:size(ValSetInd,2)
        Perceptron_Classifier_Result(i,1) = net_comp_8(ValSet(i,:)');
        if Perceptron_Classifier_Result(i,1)>0.5
            Perceptron_Classifier_Output(i,1) = 1;
        else
            Perceptron_Classifier_Output(i,1) = 0;
        end
    end


    Perceptron_Error_Count = 0;
    for i=1:size(ValSetInd,2)
        if Perceptron_Classifier_Output(i,1) ~= outputSonarTrain(ValSetInd(i),1)
            Perceptron_Error_Count = Perceptron_Error_Count + 1;
        end
    end
    
    Error_Count(8) = Perceptron_Error_Count;
    
    
    
    
    % Perceptron 9
    net_comp_9 = newff(TrainSet',TrainOutput',Hiden_Nodes_Num);
%     net.divideFcn = 'divideind';
%     net.divideParam.trainInd = TrainSetInd;
%     net.divideParam.valInd = ValSetInd;
    net_comp_9.divideParam.trainRatio = 0.8;
    net_comp_9.divideParam.valRatio   = 0.2;
    net_comp_9.divideParam.testRatio   = 0;
    
    [net_comp_9 tr] = train(net_comp_9,TrainSet',TrainOutput');

    for i=1:size(ValSetInd,2)
        Perceptron_Classifier_Result(i,1) = net_comp_9(ValSet(i,:)');
        if Perceptron_Classifier_Result(i,1)>0.5
            Perceptron_Classifier_Output(i,1) = 1;
        else
            Perceptron_Classifier_Output(i,1) = 0;
        end
    end


    Perceptron_Error_Count = 0;
    for i=1:size(ValSetInd,2)
        if Perceptron_Classifier_Output(i,1) ~= outputSonarTrain(ValSetInd(i),1)
            Perceptron_Error_Count = Perceptron_Error_Count + 1;
        end
    end
    
    Error_Count(9) = Perceptron_Error_Count;
    
    
    
    
    
    % Perceptron 10
    net_comp_10 = newff(TrainSet',TrainOutput',Hiden_Nodes_Num);
%     net.divideFcn = 'divideind';
%     net.divideParam.trainInd = TrainSetInd;
%     net.divideParam.valInd = ValSetInd;
    net_comp_10.divideParam.trainRatio = 0.8;
    net_comp_10.divideParam.valRatio   = 0.2;
    net_comp_10.divideParam.testRatio   = 0;
    
    [net_comp_10 tr] = train(net_comp_10,TrainSet',TrainOutput');

    for i=1:size(ValSetInd,2)
        Perceptron_Classifier_Result(i,1) = net_comp_10(ValSet(i,:)');
        if Perceptron_Classifier_Result(i,1)>0.5
            Perceptron_Classifier_Output(i,1) = 1;
        else
            Perceptron_Classifier_Output(i,1) = 0;
        end
    end


    Perceptron_Error_Count = 0;
    for i=1:size(ValSetInd,2)
        if Perceptron_Classifier_Output(i,1) ~= outputSonarTrain(ValSetInd(i),1)
            Perceptron_Error_Count = Perceptron_Error_Count + 1;
        end
    end
    
    Error_Count(10) = Perceptron_Error_Count;
    
    
    
    
    [Sorted_Error Sorted_Ind] = sort(Error_Count);
    
    switch Cross_Validation_Mum
        case 1
            switch Sorted_Ind(1)
                case 1
                    network1 = net_comp_1;
                case 2
                    network1 = net_comp_2;
                case 3
                    network1 = net_comp_3;
                case 4
                    network1 = net_comp_4;
                case 5
                    network1 = net_comp_5;
                case 6
                    network1 = net_comp_6;
                case 7
                    network1 = net_comp_7;
                case 8
                    network1 = net_comp_8;
                case 9
                    network1 = net_comp_9;
                case 10
                    network1 = net_comp_10;
            end
        case 2
            switch Sorted_Ind(1)
                case 1
                    network2 = net_comp_1;
                case 2
                    network2 = net_comp_2;
                case 3
                    network2 = net_comp_3;
                case 4
                    network2 = net_comp_4;
                case 5
                    network2 = net_comp_5;
                case 6
                    network2 = net_comp_6;
                case 7
                    network2 = net_comp_7;
                case 8
                    network2 = net_comp_8;
                case 9
                    network2 = net_comp_9;
                case 10
                    network2 = net_comp_10;
            end
        case 3
            switch Sorted_Ind(1)
                case 1
                    network3 = net_comp_1;
                case 2
                    network3 = net_comp_2;
                case 3
                    network3 = net_comp_3;
                case 4
                    network3 = net_comp_4;
                case 5
                    network3 = net_comp_5;
                case 6
                    network3 = net_comp_6;
                case 7
                    network3 = net_comp_7;
                case 8
                    network3 = net_comp_8;
                case 9
                    network3 = net_comp_9;
                case 10
                    network3 = net_comp_10;
            end
        case 4
            switch Sorted_Ind(1)
                case 1
                    network4 = net_comp_1;
                case 2
                    network4 = net_comp_2;
                case 3
                    network4 = net_comp_3;
                case 4
                    network4 = net_comp_4;
                case 5
                    network4 = net_comp_5;
                case 6
                    network4 = net_comp_6;
                case 7
                    network4 = net_comp_7;
                case 8
                    network4 = net_comp_8;
                case 9
                    network4 = net_comp_9;
                case 10
                    network4 = net_comp_10;
            end
        case 5
            switch Sorted_Ind(1)
                case 1
                    network5 = net_comp_1;
                case 2
                    network5 = net_comp_2;
                case 3
                    network5 = net_comp_3;
                case 4
                    network5 = net_comp_4;
                case 5
                    network5 = net_comp_5;
                case 6
                    network5 = net_comp_6;
                case 7
                    network5 = net_comp_7;
                case 8
                    network5 = net_comp_8;
                case 9
                    network5 = net_comp_9;
                case 10
                    network5 = net_comp_10;
            end
        case 6
            switch Sorted_Ind(1)
                case 1
                    network6 = net_comp_1;
                case 2
                    network6 = net_comp_2;
                case 3
                    network6 = net_comp_3;
                case 4
                    network6 = net_comp_4;
                case 5
                    network6 = net_comp_5;
                case 6
                    network6 = net_comp_6;
                case 7
                    network6 = net_comp_7;
                case 8
                    network6 = net_comp_8;
                case 9
                    network6 = net_comp_9;
                case 10
                    network6 = net_comp_10;
            end
        case 7
            switch Sorted_Ind(1)
                case 1
                    network7 = net_comp_1;
                case 2
                    network7 = net_comp_2;
                case 3
                    network7 = net_comp_3;
                case 4
                    network7 = net_comp_4;
                case 5
                    network7 = net_comp_5;
                case 6
                    network7 = net_comp_6;
                case 7
                    network7 = net_comp_7;
                case 8
                    network7 = net_comp_8;
                case 9
                    network7 = net_comp_9;
                case 10
                    network7 = net_comp_10;
            end
        case 8
            switch Sorted_Ind(1)
                case 1
                    network8 = net_comp_1;
                case 2
                    network8 = net_comp_2;
                case 3
                    network8 = net_comp_3;
                case 4
                    network8 = net_comp_4;
                case 5
                    network8 = net_comp_5;
                case 6
                    network8 = net_comp_6;
                case 7
                    network8 = net_comp_7;
                case 8
                    network8 = net_comp_8;
                case 9
                    network8 = net_comp_9;
                case 10
                    network8 = net_comp_10;
            end
        case 9
            switch Sorted_Ind(1)
                case 1
                    network9 = net_comp_1;
                case 2
                    network9 = net_comp_2;
                case 3
                    network9 = net_comp_3;
                case 4
                    network9 = net_comp_4;
                case 5
                    network9 = net_comp_5;
                case 6
                    network9 = net_comp_6;
                case 7
                    network9 = net_comp_7;
                case 8
                    network9 = net_comp_8;
                case 9
                    network9 = net_comp_9;
                case 10
                    network9 = net_comp_10;
            end
        case 10
            switch Sorted_Ind(1)
                case 1
                    network10 = net_comp_1;
                case 2
                    network10 = net_comp_2;
                case 3
                    network10 = net_comp_3;
                case 4
                    network10 = net_comp_4;
                case 5
                    network10 = net_comp_5;
                case 6
                    network10 = net_comp_6;
                case 7
                    network10 = net_comp_7;
                case 8
                    network10 = net_comp_8;
                case 9
                    network10 = net_comp_9;
                case 10
                    network10 = net_comp_10;
            end
    end
    
    
    Perceptron_Error_Rate = Sorted_Error(1)/size(ValSetInd,2);
    
    Error(Cross_Validation_Mum,1) = Perceptron_Error_Rate;
    clear TrainSet TrainOutput ValSet ValOutput Perceptron_Classifier_Result Perceptron_Classifier_Output net_comp_1 net_comp_2 net_comp_3 net_comp_4 net_comp_5 net_comp_6 net_comp_7 net_comp_8 net_comp_9 net_comp_10
end

Gen_Error = mean(Error)
Gen_Err_Var = var(Error)
% end