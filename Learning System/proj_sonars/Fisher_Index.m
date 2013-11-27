function output = Fisher_Index(InputData,OutputData)
    
    % seperate data
    Class_0_index = 1;
    Class_1_index = 1;
    for i=1:size(InputData,1)
        if OutputData(i) == 0
            Class_0(Class_0_index,:) = InputData(i,:);
            Class_0_index = Class_0_index + 1;
        else
            Class_1(Class_1_index,:) = InputData(i,:);
            Class_1_index = Class_1_index + 1;
        end
    end
    clear Class_0_index Class_1_index
    
    
    % Fisher Index
    for i=1:size(InputData,2)
        mean_0 = mean(Class_0(:,i));
        mean_1 = mean(Class_1(:,i));
        var_0  =  var(Class_0(:,i));
        var_1  =  var(Class_1(:,i));
        FI(i,1) = (mean_0 - mean_1)^2/((size(Class_0,1)-1)*var_0 + (size(Class_1,1)-1)*var_1);
        FI(i,2) = i;
    end
    output = sortrows(FI,-1);
    
end