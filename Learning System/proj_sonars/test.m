for i=1:104
    Perceptron_Classifier_Result(i,1) = net(inputSonarTestDS(i,:)');
    if Perceptron_Classifier_Result(i,1)>0.5
        Perceptron_Classifier_Output(i,1) = 1;
    else
        Perceptron_Classifier_Output(i,1) = 0;
    end
end