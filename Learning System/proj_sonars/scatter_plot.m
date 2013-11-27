variable_num1 = 48;
variable_num2 = 12;
figure;
for i=1:104
    if outputSonarTrain(i) == 0
        plot(inputSonarTrain(i,variable_num1),inputSonarTrain(i,variable_num2),'g*'); hold on;
    else
        plot(inputSonarTrain(i,variable_num1),inputSonarTrain(i,variable_num2),'r*'); hold on;
    end
end