clear
Sample1 = load('MLP2.mat');
Sample2 = load('MLP3.mat');
Sample3 = load('H2O2MLP.mat');

w = [14.2301 11.341 9.2611];


y = [Sample1.simplefitOutputs' Sample2.simplefitOutputs' Sample3.simplefitOutputs'];
ytest = y*(1./w')/sum(1./w);



