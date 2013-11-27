load thyroidTrain.mat;
X=trainThyroidInput;
Y=trainThyroidOutput;

class1=Y(:,1);
class2=Y(:,2);
class3=Y(:,3);


for i=1:21,

    CovXY1 = corrcoef(X(:,i),Y(:,1));
    CovXY2 = corrcoef(X(:,i),Y(:,2));
    CovXY3 = corrcoef(X(:,i),Y(:,3));
    Cov_XY1(i,2) = CovXY1(1,2);
    Cov_XY1(i,1) = i;
    Cov_XY2(i,2) = CovXY2(1,2);
    Cov_XY2(i,1) = i;
    Cov_XY3(i,2) = CovXY3(1,2);
    Cov_XY3(i,1) = i;
    
end

[Corr_XY_rank1 index1] = sortrows(abs(Cov_XY1(:,2)),1);
Corr_XY_rank1(:,2)=Corr_XY_rank1;
Corr_XY_rank1(:,1)=index1;
[Corr_XY_rank2 index2] = sortrows(abs(Cov_XY2(:,2)),1);
Corr_XY_rank2(:,2)=Corr_XY_rank2;
Corr_XY_rank2(:,1)=index2;
[Corr_XY_rank3 index3] = sortrows(abs(Cov_XY3(:,2)),1);
Corr_XY_rank3(:,2)=Corr_XY_rank3;
Corr_XY_rank3(:,1)=index3;


    n1=index1(19);
    n2=index2(19);
    n3=index3(19);
    figure, scatter(X(:,n1),Y(:,1),10,[0 0 5],'b','filled');
    title(n1);
    xlabel('Input');
    ylabel('Output');
    figure, scatter(X(:,n2),Y(:,2),10,[0 0 5],'b','filled');
    title(n2);
    xlabel('Input');
    ylabel('Output');
    figure, scatter(X(:,n3),Y(:,3),10,[0 0 5],'b','filled');
    title(n3);
    xlabel('Input');
    ylabel('Output');