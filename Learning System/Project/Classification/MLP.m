load thyroidTrain.mat;
load FI.mat;
FI=outputFI;
X=trainThyroidInput;
Y=trainThyroidOutput;
XT=testThyroidInput;
%process the class
for loopclass=1:size(Y(:,1))
    if (Y(loopclass,1)==1)
        Yclass(loopclass,1)=1;
    elseif (Y(loopclass,2)==1)
        Yclass(loopclass,1)=2;
    else
        Yclass(loopclass,1)=3;
    end
end

%MLP classifier
for nodes=1:7
    net = newff(X',Y',nodes+3);
    net.trainParam.goal=0.005;
    net.trainParam.epochs=500;
    net.trainParam.show=20;
    net.trainParam.lr=0.5;
    net.divideParam.trainRatio = 0.8;
    net.divideParam.valRatio = 0.2;
    [net tr] = train(net,X',Y');
    MLP_p(nodes,2) = tr.best_vperf;
    MLP_p(nodes,1) = nodes;
end
MLP_pnnsort=sortrows(MLP_p,2);
net = newff(X',Y',MLP_pnnsort(1,1)+3);
net.trainParam.goal=0.005;
net.trainParam.epochs=500;
net.trainParam.show=20;
net.trainParam.lr=0.5;
net.divideParam.trainRatio = 0.8;
net.divideParam.valRatio = 0.2;
[net tr] = train(net,X',Y');
fitAllfeatures = sim(net,X');
fitAllfeatures = fitAllfeatures';
%process the result 
nnfitAllfeatures=zeros(5000,3);
for loopresult1=1:5000
    if fitAllfeatures(loopresult1,1)>0.5
        nnfitAllfeatures(loopresult1,1)=1;
    elseif fitAllfeatures(loopresult1,2)>0.5
        nnfitAllfeatures(loopresult1,2)=1;
    else
        nnfitAllfeatures(loopresult1,3)=1;
    end
end


figure,plot(MLP_p(:,1),MLP_p(:,2));

%choose the features

choosefeature=FI(:,1);
choosefeature=choosefeature';
for features=1:21
    Xfeature=X(:,choosefeature(1,1:features));
    net1 = newff(Xfeature',Y',7);
    net1.trainParam.goal=0.005;
    net1.trainParam.epochs=500;
    net1.trainParam.show=20;
    net1.trainParam.lr=0.5;
    net1.divideParam.trainRatio = 0.8;
    net1.divideParam.valRatio = 0.2;
    [net1 tr1] = train(net1,Xfeature',Y');
    MLP_pfea(features,2) = tr1.best_vperf;
    MLP_pfea(features,1) = features;
end
figure,plot(MLP_pfea(:,1),MLP_pfea(:,2));
MLP_pfeasort=sortrows(MLP_pfea,2);
net1 = newff((X(:,choosefeature(1,1:MLP_pfeasort(1,1))))',Y',7);
net1.trainParam.goal=0.005;
net1.trainParam.epochs=500;
net1.trainParam.show=20;
net1.trainParam.lr=0.5;
net1.divideParam.trainRatio = 0.8;
net1.divideParam.valRatio = 0.2;
[net1 tr1] = train(net1,(X(:,choosefeature(1,1:MLP_pfeasort(1,1))))',Y');



netf1 = newff((X(:,choosefeature(1,1:MLP_pfeasort(1,1))))',Y',7);
netf1.trainParam.goal=0.005;
netf1.trainParam.epochs=500;
netf1.trainParam.show=20;
netf1.trainParam.lr=0.5;
netf1.divideParam.trainRatio = 0.8;
netf1.divideParam.valRatio = 0.2;
[netf1 trf1] = train(netf1,(X(:,choosefeature(1,1:MLP_pfeasort(1,1))))',Y');
%my rbf-bp mixed NN
netf = newff((X(:,choosefeature(1,1:MLP_pfeasort(1,1))))',Y',[4,4],{'radbas' 'tansig' 'purelin'});
netf.trainParam.goal=0.005;
netf.trainParam.epochs=500;
netf.trainParam.show=20;
netf.trainParam.lr=0.5;
netf.divideParam.trainRatio = 0.8;
netf.divideParam.valRatio = 0.2;
[netf trf] = train(netf,(X(:,choosefeature(1,1:MLP_pfeasort(1,1))))',Y');
fit10features = sim(netf,(X(:,choosefeature(1,1:MLP_pfeasort(1,1))))');
fit10features = fit10features';
MLPCresult = sim(netf,(XT(:,choosefeature(1,1:MLP_pfeasort(1,1))))');
MLPCresult = MLPCresult';
%process the fit result 
nnfit10features=zeros(5000,3);
for loopresult2=1:5000
    if fit10features(loopresult2,1)>0.5
        nnfit10features(loopresult2,1)=1;
    elseif fit10features(loopresult2,2)>0.5
        nnfit10features(loopresult2,2)=1;
    else
        nnfit10features(loopresult2,3)=1;
    end
end

for loopconfit=1:size(nnfit10features(:,1))
    if (nnfit10features(loopconfit,1)==1)
        YfitMLPcon(loopconfit,1)=1;
    elseif (nnfit10features(loopconfit,2)==1)
        YfitMLPcon(loopconfit,1)=2;
    else
        YfitMLPcon(loopconfit,1)=3;
    end
end

%process the result 
nnMLPCresult=zeros(2200,3);
for loopresult3=1:2200
    if MLPCresult(loopresult3,1)>0.5
        nnMLPCresult(loopresult3,1)=1;
    elseif MLPCresult(loopresult3,2)>0.5
        nnMLPCresult(loopresult3,2)=1;
    else
        nnMLPCresult(loopresult3,3)=1;
    end
end

for loopconresult=1:size(nnMLPCresult(:,1))
    if (nnMLPCresult(loopconresult,1)==1)
        YresultMLPcon(loopconresult,1)=1;
    elseif (nnMLPCresult(loopconresult,2)==1)
        YresultMLPcon(loopconresult,1)=2;
    else
        YresultMLPcon(loopconresult,1)=3;
    end
end

MSEfinalMLP=CalMSE(YresultMLPcon,Yclass);

%scatter plot

col_num1 = 20;
col_num2 = 19;
figure;
for scatterloop=1:500
    if Yclass(scatterloop) == 1
        plot(X(scatterloop,col_num1),X(scatterloop,col_num2),'g*'); hold on;
    elseif Yclass(scatterloop) == 2
        plot(X(scatterloop,col_num1),X(scatterloop,col_num2),'b*'); hold on;
    else
        plot(X(scatterloop,col_num1),X(scatterloop,col_num2),'y*'); hold on;
    end
end
figure;
for scatterloop=1:500
    if nnfitAllfeatures(scatterloop,1) == 1
        plot(X(scatterloop,col_num1),X(scatterloop,col_num2),'g*'); hold on;
    elseif nnfitAllfeatures(scatterloop,2) == 1
        plot(X(scatterloop,col_num1),X(scatterloop,col_num2),'b*'); hold on;
    else
        plot(X(scatterloop,col_num1),X(scatterloop,col_num2),'y*'); hold on;
    end
end
figure;
for scatterloop=1:500
    if nnfit10features(scatterloop,1) == 1
        plot(X(scatterloop,col_num1),X(scatterloop,col_num2),'g*'); hold on;
    elseif nnfit10features(scatterloop,2) == 1
        plot(X(scatterloop,col_num1),X(scatterloop,col_num2),'b*'); hold on;
    else
        plot(X(scatterloop,col_num1),X(scatterloop,col_num2),'y*'); hold on;
    end
end

