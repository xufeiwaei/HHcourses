load('ChemTrainNew.mat');

X=XtrainDS;
Y=YtrainDS;
XT=XtestDS;

%Principal component analysis
stdrX=std(X);
stdrSR=X./repmat(stdrX,4466,1);
[coeff, score, latent, tsquared] = pca(stdrSR);
latentsum = sum(latent);
latentop10=sum(latent(1:10,1));
ratio = latentop10/latentsum;
latent=100*latent/sum(latent);
figure,pareto(latent);

%to get the feature that choose by stepwise
[B,SE,PVAL,INMODEL,STATS,NEXTSTEP,HISTORY]=stepwisefit(X,Y);
Xindexff=double(INMODEL);
newXcountff=0;
for loop11=1:65
    if(Xindexff(loop11)==1)
        newXcountff=newXcountff+1;
        newffX(newXcountff)=loop11;
    end
end


for loop12=1:newXcountff
    newffXDS(:,loop12)=X(:,newffX(loop12));
    newffTDS(:,loop12)=XtestDS(:,newffX(loop12));
end

R1 = [3 6 16 49 50 51 52 53 65];
R2 = [4 10 19 27 28 38 42 50];



X1 = X(:,R1);
X2 = X(:,R2);
XT1 = XT(:,R1);
XT2 = XT(:,R2);

for nodes=1:7
    net1 = newff(X1',Y',nodes+3);
    net1.trainParam.goal=0.005;
    net1.trainParam.epochs=500;
    net1.trainParam.show=20;
    net1.trainParam.lr=0.5;
    net1.divideParam.trainRatio = 0.8;
    net1.divideParam.valRatio = 0.2;
    [net1 tr1] = train(net1,X1',Y');
    MLP_p1(nodes,2) = tr1.best_vperf;
    MLP_p1(nodes,1) = nodes;
end
MLP_p1sort1=sortrows(MLP_p1,2);
net1 = newff(X1',Y',MLP_p1sort1(1,1)+3);
net1.trainParam.goal=0.005;
net1.trainParam.epochs=500;
net1.trainParam.show=20;
net1.trainParam.lr=0.5;
net1.divideParam.trainRatio = 0.8;
net1.divideParam.valRatio = 0.2;
[net1 tr1] = train(net1,X1',Y');

figure,plot(MLP_p1(:,1),MLP_p1(:,2));

for nodes=1:7
    net2 = newff(X2',Y',nodes+3);
    net2.trainParam.goal=0.005;
    net2.trainParam.epochs=500;
    net2.trainParam.show=20;
    net2.trainParam.lr=0.5;
    net2.divideParam.trainRatio = 0.8;
    net2.divideParam.valRatio = 0.2;
    [net2 tr2] = train(net2,X2',Y');
    MLP_p2(nodes,2) = tr2.best_vperf;
    MLP_p2(nodes,1) = nodes;
end
MLP_p1sort2=sortrows(MLP_p2,2);
net2 = newff(X2',Y',MLP_p1sort2(1,1)+3);
net2.trainParam.goal=0.005;
net2.trainParam.epochs=500;
net2.trainParam.show=20;
net2.trainParam.lr=0.5;
net2.divideParam.trainRatio = 0.8;
net2.divideParam.valRatio = 0.2;
[net2 tr2] = train(net2,X2',Y');

figure,plot(MLP_p2(:,1),MLP_p2(:,2));

for nodes=1:7
    net3 = newff(newffXDS',Y',nodes+3);
    net3.trainParam.goal=0.005;
    net3.trainParam.epochs=500;
    net3.trainParam.show=20;
    net3.trainParam.lr=0.5;
    net3.divideParam.trainRatio = 0.8;
    net3.divideParam.valRatio = 0.2;
    [net3 tr3] = train(net3,newffXDS',Y');
    MLP_p3(nodes,2) = tr3.best_vperf;
    MLP_p3(nodes,1) = nodes;
end
MLP_p1sort3=sortrows(MLP_p3,2);
net3 = newff(newffXDS',Y',MLP_p1sort3(1,1)+3);
net3.trainParam.goal=0.005;
net3.trainParam.epochs=500;
net3.trainParam.show=20;
net3.trainParam.lr=0.5;
net3.divideParam.trainRatio = 0.8;
net3.divideParam.valRatio = 0.2;
[net3 tr3] = train(net3,newffXDS',Y');

figure,plot(MLP_p3(:,1),MLP_p3(:,2));

simplefitOutputs = sim(net3,newffTDS');
mplefitOutputs = sim(net3,newffXDS');
MLPtestY=simplefitOutputs';
MLPYfit=mplefitOutputs';
MLPfMSE = CalMSE(MLPYfit,Y);
figure,plot(1:size(Y(:,1)),Y,'o',1:size(Y(:,1)),MLPYfit,'r.');

simplefitOutputs1 = sim(net1,XT1');
mplefitOutputs1 = sim(net1,X1');
MLPtestY1=simplefitOutputs1';
MLPYfit1=mplefitOutputs1';
MLPfMSE1 = CalMSE(MLPYfit1,Y);

simplefitOutputs2 = sim(net2,XT2');
mplefitOutputs2 = sim(net2,X2');
MLPtestY2=simplefitOutputs2';
MLPYfit2=mplefitOutputs2';
MLPfMSE2 = CalMSE(MLPYfit2,Y);




