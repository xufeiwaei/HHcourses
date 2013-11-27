clear all;
Sample = load('ChemTrainNew.mat');

X=Sample.XtrainDS;
Y=Sample.YtrainDS;
XT=Sample.XtestDS;

NN = size(X,2);
Corr_XY = zeros(NN,2);


for kk=1:NN,

   %CovXY = cov(X(:,kk),Y(:,1));
    CorrXY = corrcoef(X(:,kk),Y(:,1));
    Corr_XY(kk,1) = CorrXY(1,2);
    Corr_XY(kk,2) = kk;
    
end

[Corr_XY_rank index] = sortrows(abs(Corr_XY(:,1)),1);
Corr_XY_rank(:,1)=Corr_XY_rank;
Corr_XY_rank(:,2)=index;

Impa = Corr_XY_rank(56:65,2);

% for i=1:9,
%     
%     figure, scatter(X(:,Impa(i,1)),Y,8,[1 0 0],'+')
%     title('ScatterTest');
%     xlabel('X log feature(extract)');
%     ylabel('Ytrain');
% 
% end
    figure, scatter(X(:,37),Y,8,[0 0 1],'+')
    title('ScatterTest #37');
    xlabel('X / feature #37');
    ylabel('Ytrain');











