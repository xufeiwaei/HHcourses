Sample = load('ECGITtrain.mat');

X=Sample.inputECGITtrain;
Y=Sample.outputECGITtrain;
XT=Sample.inputECGITtest;

indices = Y;
index1 = (indices == 1); train1 = ~index1;
index0 = (indices == 0); train0 = ~index0;

Yr0 = Y(train1,:);
Yr1 = Y(train0,:);
Xr0 = X(train1,:);
Xr1 = X(train0,:);

Ch = zeros(200:26:12);

for i=1:12
    k = i+25;
    Ch(:,:,i) = X(:,i:k);
end

Ch1 = Ch(train1,:,:);
Ch0 = Ch(train0,:,:);

ii1 = 25;
ii2 = 8;
s1 = 1;
s2 = 5;

% figure, scatter(Ch(index0,ii1,s1),Y(index0),40,[1 0 0],'o');
% hold on,scatter(Ch(index1,ii1,s1),Y(index1),40,[0 0 1],'+');
% title('ScatterTest');
% xlabel('dur');
% ylabel('ampl');
% hold off;

 figure, scatter(Xr0(:,202),Yr0,40,[1 0 0],'o');
 hold on,scatter(Xr1(:,202),Yr1,40,[0 0 1],'+');
title('ScatterTest');
xlabel('Xtrain');
ylabel('Ytrain');
hold off;
% 202	310	298	286	203	299	311	274	287	262






















% Idur = Xr0, 
% Qdur, 
% Rdur, 
% Sdur, 
% Rpdur, 
% Spdur,
% Kdur,
% 
% I ampl,
% Q ampl,
% R ampl, 
% S ampl, 
% Rp ampl, 
% Sp ampl, 
% K ampl





% figure, scatter(Xr0(:,19),Yr0,8,[1 0 0],'o');
% hold on,scatter(Xr1(:,19),Yr1,8,[0 0 1],'+');
% title('ScatterTest');
% xlabel('Xtrain');
% ylabel('Ytrain');
% hold off;
% 
% figure, scatter(Xr0(:,15),Yr0,8,[1 0 0],'o');
% hold on,scatter(Xr1(:,15),Yr1,8,[0 0 1],'+');
% title('ScatterTest');
% xlabel('Xtrain');
% ylabel('Ytrain');
% hold off;










