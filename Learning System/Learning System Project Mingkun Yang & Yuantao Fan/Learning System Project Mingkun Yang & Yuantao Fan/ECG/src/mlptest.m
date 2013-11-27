% clear
% % mlp
% load simplefit_dataset
% net = newff(simplefitInputs,simplefitTargets,20, {}, 'trainbr');
% % net = newff(simplefitInputs,simplefitTargets,20)
% net.trainParam.goal = 0.0001;
% net.divideParam.trainratio = 0.8;
% net.divideParam.valratio = 0.2;
% net.divideParam.testratio = 0;
% % net.performFcn='msereg';
% % net.performParam.ratio=0.8;
% [net tr]= train(net,simplefitInputs,simplefitTargets);
% simplefitOutputs = sim(net,simplefitInputs);
% error = mean((simplefitOutputs-simplefitTargets).^2)
% %
% clear
% load simpleclass_dataset
% net = newsom(simpleclassInputs,[8 8]);
% % plotsom(net.layers{1}.positions)
% net = train(net,simpleclassInputs);
%
%
% % plot(simpleclassInputs(1,:),simpleclassInputs(2,:),'.g','markersize',20)
% hold on
% plotsom(net.iw{1,1},net.layers{1}.distances)
% hold off

% Compute mean square error for regression using 10-fold
% cross-validation
% clear
% load('fisheriris');
% y = meas(:,1);
% x = [ones(size(y,1),1) meas(:,2:4)];
% sse = crossval(@regf,x,y);
% cvMse = sum(sse)/length(y)
%
% clear
% load fisheriris
% SL = meas(51:end,1);
% SW = meas(51:end,2);
% group = species(51:end);
% h1 = gscatter(SL,SW,group,'rb','v^',[],'off');
% set(h1,'LineWidth',2)
% legend('Fisher versicolor','Fisher virginica',...
%     'Location','NW')
% 
% [X,Y] = meshgrid(linspace(4.5,8),linspace(2,4));
% X = X(:); Y = Y(:);
% [C,err,P,logp,coeff] = classify([X Y],[SL SW],...
%     group,'quadratic');
% hold on;
% gscatter(X,Y,C,'rb','.',1,'off');
% K = coeff(1,2).const;
% L = coeff(1,2).linear; 
% Q = coeff(1,2).quadratic;
% % Function to compute K + L*v + v'*Q*v for multiple vectors
% % v=[x;y]. Accepts x and y as scalars or column vectors.
% f = @(x,y) K + [x y]*L + sum(([x y]*Q) .* [x y], 2);
% 
% h2 = ezplot(f,[4.5 8 2 4]);
% set(h2,'Color','m','LineWidth',2)
% axis([4.5 8 2 4])
% xlabel('Sepal Length')
% ylabel('Sepal Width')
% title('{\bf Classification with Fisher Training Data}')

clear
load ChemTrainNew.mat
trainX = XtrainDS(:, 10);
% trainX = (trainX-mean(trainX))/std(trainX);
trainX = log(trainX);
trainY = YtrainDS;
net = newff(trainX',trainY',38, {}, 'trainbr');
% net = newff(trainX',trainY',38);
% net = newff(simplefitInputs,simplefitTargets,20)
net.trainParam.goal = 0.0001;
net.divideParam.trainratio = 0.8;
net.divideParam.valratio = 0.2;
net.divideParam.testratio = 0;
% net.performFcn='msereg';
% net.performParam.ratio=0.8;
[net tr]= train(net,trainX',trainY');
simplefitOutputs = sim(net,trainX');
error = mean((trainY'-simplefitOutputs).^2)