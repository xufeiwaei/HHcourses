function KNNOutput = ex5_KNN_M(N,TrainSetInput,TrainSetOutput,Input)
    
    % Seperate Data
    Class_0_index = 1;
    Class_1_index = 1;
    for i=1:size(TrainSetOutput,1)
        if TrainSetOutput(i) == 0
            Class_0(Class_0_index,:) = TrainSetInput(i,:);
            Class_0_index = Class_0_index + 1;
        else
            Class_1(Class_1_index,:) = TrainSetInput(i,:);
            Class_1_index = Class_1_index + 1;
        end
    end
    clear Class_0_index Class_1_index
    
    Cov_Matrix_0 = cov(Class_0);
    Cov_Matrix_1 = cov(Class_1);
    
    for i=1:size(TrainSetInput,1)
        if TrainSetOutput == 0
            Mahalanobis_Distance(i,1) = (TrainSetInput(i,:)-Input)*Cov_Matrix_0*(TrainSetInput(i,:)-Input)';
        else
            Mahalanobis_Distance(i,1) = (TrainSetInput(i,:)-Input)*Cov_Matrix_1*(TrainSetInput(i,:)-Input)';
        end
    end
    [Sorted_Dis Sorted_Ind] = sort(Mahalanobis_Distance);
    for i=1:N
        Neighbour(i,1) = Sorted_Ind(i);
        Neighbour(i,2) = Sorted_Dis(i);
    end
    for i=1:N
        Weight(i,1) = Neighbour(i,2)/sum(Neighbour(:,2));
    end
    
    KNNOutput = 0;
    for i=1:N
        KNNOutput = KNNOutput + Weight(i,1)*TrainSetOutput(Neighbour(i,1));
    end
end