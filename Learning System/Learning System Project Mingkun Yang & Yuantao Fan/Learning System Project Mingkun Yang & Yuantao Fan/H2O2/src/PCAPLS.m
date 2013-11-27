clear all;
Sample = load('ChemTrainNew.mat');

X=Sample.XtrainDS;
Y=Sample.YtrainDS;
XT=Sample.XtestDS;

% Xn=zeros(4466,65);
% 
% for ii=1:65;
%     Xn(:,ii)=(X(:,ii)-mean(X(:,ii)))/STD(X(:,ii));
% end

[COEFF,Xtrain,latent,tsquare] = princomp(X);

latentsum = sum(latent);
latent10=sum(latent(1:10,1));
X_mp = Xtrain(:,1:8);
Xsam = Xtrain(:,1);
ratio = latent10/latentsum;

% figure, scatter(Xtrain(:,1),Y,8,[0 0 1],'+')
% title('ScatterTest');
% xlabel('Xtrain');
% ylabel('Ytrain');

% for i=1:8,
%     p = polyfit(Xsam,Y,i);
%     Y_estimate = polyval(p,Xsam);
%     Y_E(i,1) = sum((Y - Y_estimate).^2)/size(Y_estimate,1); 
% end

indices = crossvalind('Kfold',Xsam,10);

for k=1:50
    for i = 1:10
        test = (indices == i); train = ~test;
        p = polyfit(Xsam,Y,k);
        Y_estimate = polyval(p,Xsam);
        Y_E(i,1) = sum((Y - Y_estimate).^2)/size(Y_estimate,1);  
    end
    errormin(k,1) = min(Y_E);
    errormin(k,2) = k;
end

plot(errormin(:,2),errormin(:,1))

     p = polyfit(Xsam,Y,50);
     Y_estimate = polyval(p,Xsam);
     plot(Xsam,Y,'+',Xsam,Y_estimate,'o')










