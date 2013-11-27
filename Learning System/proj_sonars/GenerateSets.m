function [TrainSetInd, ValSetInd] = GenerateSets(TrainingQuantity)
    Random_Table = randperm(104);
    for i=1:TrainingQuantity
        TrainSetInd(i) = Random_Table(i);
    end
    for i=TrainingQuantity+1:104
        ValSetInd(i-TrainingQuantity) = Random_Table(i);
    end
end