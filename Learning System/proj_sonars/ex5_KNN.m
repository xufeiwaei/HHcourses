function KNNOutput = ex5_KNN(N,TrainSetInput,TrainSetOutput,Input)
    
    for i=1:size(TrainSetInput,1)
        Euclidean_Distance(i,1) = (TrainSetInput(i,:)-Input)*(TrainSetInput(i,:)-Input)';
    end
    [Sorted_Dis Sorted_Ind] = sort(Euclidean_Distance);
    for i=1:N
        Neighbour(i,1) = Sorted_Ind(i);
        Neighbour(i,2) = Sorted_Dis(i);
    end
    for i=1:N
        Weight(i,1) = (1/Neighbour(i,2))/sum(1./Neighbour(:,2));
    end
    
    KNNOutput = 0;
    for i=1:N
        KNNOutput = KNNOutput + Weight(i,1)*TrainSetOutput(Neighbour(i,1));
    end
end