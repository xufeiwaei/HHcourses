load ChemTrainNew.mat;
X=XtrainDS;
Y=YtrainDS;

for loop3=1:65
    chooseindex(loop3)=loop3;
end
[B,SE,PVAL,INMODEL,STATS,NEXTSTEP,HISTORY]=stepwisefit(X,Y,'inmodel',chooseindex);


%  cvp = cvpartition(Y,'k',10); 
%  [fs,history] = sequentialfs(@classf,X,Y,'cv',cvp,'direction','backward');