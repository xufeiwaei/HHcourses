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

class1=Y(:,1);
class2=Y(:,2);
class3=Y(:,3);

%to construct the initial KNN model
mdlknninitial=ClassificationKNN.fit(X,Yclass);
rloosinitial=resubLoss(mdlknninitial);
cvmdlknninitial=crossval(mdlknninitial,'kfold',10);
klossinitial=kfoldLoss(cvmdlknninitial);

%to find the best K of KNN
rloos(:,1)=[1;2;3;4;5;6;7;8;9;10];
kloss(:,1)=[1;2;3;4;5;6;7;8;9;10];
for loop1=1:10
    mdlknnf=ClassificationKNN.fit(X,Yclass,'NumNeighbors',loop1,'NSMethod','exhaustive',...
                              'Distance','euclidean');
    rloos(loop1,2)=resubLoss(mdlknnf);
    cvmdlknnf=crossval(mdlknnf,'kfold',10);   
    kloss(loop1,2)=kfoldLoss(cvmdlknnf);
end


outputkloss = sortrows(kloss,2);
%the final KNN classifier
mdlknn=ClassificationKNN.fit(X,Yclass,'NumNeighbors',outputkloss(1,1),'NSMethod','exhaustive',...
                              'Distance','euclidean');
rloosknn=resubLoss(mdlknn);
cvmdlknn=crossval(mdlknn,'kfold',10);
klossknn=kfoldLoss(cvmdlknn);

rlooskfeature(:,2)=[1:21];
klosskfeature(:,2)=[1:21];
MSEfeature(:,2)=[1:21];

%choose the features
choosefeature=FI(:,1);
choosefeature=choosefeature';
for loopfeature=1:size(FI(:,1))

    Xfeature=X(:,choosefeature(1,1:loopfeature));
    mdlkfeature=ClassificationKNN.fit(Xfeature,Yclass,'NumNeighbors',outputkloss(1,1),'NSMethod','exhaustive',...
                              'Distance','euclidean');
    rlooskfeature(loopfeature,1)=resubLoss(mdlkfeature);
    cvmdlkfeature=crossval(mdlkfeature,'kfold',10);
    klosskfeature(loopfeature,1)=kfoldLoss(cvmdlkfeature);
    Yfitfeatures=predict(mdlkfeature,Xfeature);
    MSEfeature(loopfeature,1)=CalMSE(Yfitfeatures,Yclass);
end

figure,plot(rlooskfeature(:,2),rlooskfeature(:,1));    
title('rloos');
xlabel('features');
ylabel('rloos');
figure,plot(klosskfeature(:,2),klosskfeature(:,1));    
title('kloss');
xlabel('features');
ylabel('kloss');
figure,plot(MSEfeature(:,2),MSEfeature(:,1));    
title('MSE');
xlabel('features');
ylabel('MSE');
Ypredict=predict(mdlknn,testThyroidInput);
Yfitallfeatures=predict(mdlknn,X);
MSEallfeature=CalMSE(Yfitallfeatures,Yclass);
%process the result to three column
Ypredictf=zeros(2000,3);
for resultloop=1:2200
    if Ypredict(resultloop,1)==1
        Ypredictf(resultloop,1)=1;
    elseif Ypredict(resultloop,1)==2
        Ypredictf(resultloop,2)=1;
    else
        Ypredictf(resultloop,3)=1;
    end
end

XfinalDS=X(:,choosefeature(1,1:6));
mdlkfinal=ClassificationKNN.fit(XfinalDS,Yclass,'NumNeighbors',outputkloss(1,1),'NSMethod','exhaustive',...
                              'Distance','euclidean');
mdlkfinal2=ClassificationKNN.fit(X(:,choosefeature(1,1:2)),Yclass,'NumNeighbors',outputkloss(1,1),'NSMethod','exhaustive',...
                              'Distance','euclidean');
rlooskfinal2=resubLoss(mdlkfinal2);
cvmdlkfinal2=crossval(mdlkfinal2,'kfold',10);
klosskfinal2=kfoldLoss(cvmdlkfinal2);
Yfit6fertures2=predict(mdlkfinal2,X(:,choosefeature(1,1:2)));
MSEfinalKNN2=CalMSE(Yfit6fertures2,Yclass);
rlooskfinal=resubLoss(mdlkfinal);
cvmdlkfinal=crossval(mdlkfinal,'kfold',10);
klosskfinal=kfoldLoss(cvmdlkfinal);
Yresult=predict(mdlkfinal,XT(:,choosefeature(1,1:6)));
Yfit6fertures=predict(mdlkfinal,X(:,choosefeature(1,1:6)));
MSEfinalKNN=CalMSE(Yfit6fertures,Yclass);

%process the result to three column
Yresultsp=zeros(2000,3);
for resultloop=1:2200
    if Yresult(resultloop,1)==1
        Yresultsp(resultloop,1)=1;
    elseif Yresult(resultloop,1)==2
        Yresultsp(resultloop,2)=1;
    else
        Yresultsp(resultloop,3)=1;
    end
end

Knnfunctionoutput=KNNfunction(3,X,Y,XT);
Knnfunctionresult=KNNfunction(3,XfinalDS,Y,XT(:,choosefeature(1,1:6)));

%scatter plot

col_num1 = 20;
col_num2 = 19;
figure;
for scatterloop=1:500
    if Yclass(scatterloop) == 1
        plot(X(scatterloop,col_num1),X(scatterloop,col_num2),'b*'); hold on;
    elseif Yclass(scatterloop) == 2
        plot(X(scatterloop,col_num1),X(scatterloop,col_num2),'y*'); hold on;
    else
        plot(X(scatterloop,col_num1),X(scatterloop,col_num2),'r*'); hold on;
    end
end
figure;
for scatterloop=1:500
    if Yfit6fertures(scatterloop) == 1
        plot(X(scatterloop,col_num1),X(scatterloop,col_num2),'b*'); hold on;
    elseif Yfit6fertures(scatterloop) == 2
        plot(X(scatterloop,col_num1),X(scatterloop,col_num2),'y*'); hold on;
    else
        plot(X(scatterloop,col_num1),X(scatterloop,col_num2),'r*'); hold on;
    end
end
figure;
for scatterloop=1:500
    if Yfit6fertures2(scatterloop) == 1
        plot(X(scatterloop,col_num1),X(scatterloop,col_num2),'b*'); hold on;
    elseif Yfit6fertures2(scatterloop) == 2
        plot(X(scatterloop,col_num1),X(scatterloop,col_num2),'y*'); hold on;
    else
        plot(X(scatterloop,col_num1),X(scatterloop,col_num2),'r*'); hold on;
    end
end
figure;
for scatterloop=1:500
    if Yfitallfeatures(scatterloop) == 1
        plot(X(scatterloop,col_num1),X(scatterloop,col_num2),'b*'); hold on;
    elseif Yfitallfeatures(scatterloop) == 2
        plot(X(scatterloop,col_num1),X(scatterloop,col_num2),'y*'); hold on;
    else
        plot(X(scatterloop,col_num1),X(scatterloop,col_num2),'r*'); hold on;
    end
end



