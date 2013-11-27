load ChemTrainNew.mat;

for i=1:65,

    CovXY = corrcoef(XtrainDS(:,i),YtrainDS(:,1));
    Cov_XY(i,2) = CovXY(1,2);
    Cov_XY(i,1) = i;
    
end

[Corr_XY_rank index] = sortrows(abs(Cov_XY(:,2)),1);
Corr_XY_rank(:,2)=Corr_XY_rank;
Corr_XY_rank(:,1)=index;


for j=1:10
    n=index(66-j);
    figure, scatter(XtrainDS(:,n),YtrainDS,10,[0 0 5],'b','filled');
    title(n);
    xlabel('Input');
    ylabel('Output');
end