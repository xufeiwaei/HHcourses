load ChemTrainNew.mat;
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

%Partial Least Squares
[XL1,YL1,XS1,YS1,beta1,PCTVAR1,MSE1,stats1]=plsregress(X,Y,65,'cv',10);
figure,plot(1:65,cumsum(100*PCTVAR1(2,:)),'-bo');
xlabel('Number of PLS components');
ylabel('Percent Variance Explained in y');
yfit1=[ones(size(X(:,1)),1) X]*beta1;
figure,plot(1:4466,Y,'+',1:4466,yfit1,'o');
PLSfMSE = CalMSE(yfit1,Y);
TSS1=sum((Y-mean(Y)).^2);
RSS1=sum((Y-yfit1).^2);
Resquared1=1-RSS1/TSS1;
figure,[axes1,h1,h2]=plotyy(0:65,MSE1(1,:),0:65,MSE1(2,:));
set(h1,'Marker','o')
set(h2,'Marker','o')
legend('MSE Predictors','MSE Response')
xlabel('Number of Components')
YresultPLS=[ones(size(XT(:,1)),1) XT]*beta1;
PLS_MSE = CalMSE(YresultPLS,Y);
ssepls1=crossval(@critfunpls,X,Y);
msepls1=sum(ssepls1)/4466;
%another model use pls
[XL2,YL2,XS2,YS2,beta2,PCTVAR2,MSE2,stats2]=plsregress(score(:,1:10),Y,10,'cv',10);
figure,plot(1:10,cumsum(200*PCTVAR2(2,:)),'-bo');
xlabel('Number of PLS components');
ylabel('Percent Variance Explained in y');
yfit2=[ones(size(score(:,1)),1) score(:,1:10)]*beta2;
figure,plot(1:4466,Y,'+',1:4466,yfit2,'o');
TSS2=sum((Y-mean(Y)).^2);
RSS2=sum((Y-yfit2).^2);
Resquared2=1-RSS2/TSS2;
figure,[axes2,h3,h4]=plotyy(0:10,MSE2(1,:),0:10,MSE2(2,:));
set(h3,'Marker','o')
set(h4,'Marker','o')
legend('MSE Predictors','MSE Response')
xlabel('Number of Components')
ssepls2=crossval(@critfunpls2,score(:,1:10),Y);
msepls2=sum(ssepls2)/4466;

