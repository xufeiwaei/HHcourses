% Classifier Plot
    figure;
    for x = min(InputData(:,1)):(max(InputData(:,1))-min(InputData(:,1)))/30:max(InputData(:,1))
        for y = min(InputData(:,2)):(max(InputData(:,2))-min(InputData(:,2)))/30:max(InputData(:,2))
            Result = Logistic_Regression(TrainSet,TrainOutput,[x y]);
            if Result>0.5
                plot(x,y,'y*');hold on;
            else
                plot(x,y,'c*');hold on;
            end
        end
    end
    for i=1:104
        if outputSonarTrain(i) == 0
            plot(InputData(i,1),InputData(i,2),'g*'); hold on;
        else
            plot(InputData(i,1),InputData(i,2),'r*'); hold on;
        end
    end
%     for i=1:size(ValSetInd,2)
%         if outputSonarTrain(i) == 0
%             plot(ValSet(i,2),ValSet(i,1),'g*'); hold on;
%         else
%             plot(ValSet(i,2),ValSet(i,1),'r*'); hold on;
%         end
%     end