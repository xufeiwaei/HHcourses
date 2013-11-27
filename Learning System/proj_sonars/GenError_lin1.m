clear all; close all;
Origin = [0.2800 0.0369];
GenError = [0.3300 0.0579
            0.3100 0.0432
            0.2400 0.0316
            0.2800 0.0373
            0.3000 0.0422
            0.2700 0.0334
            0.2600 0.0382
            0.3000 0.0400
            0.2800 0.0484
            0.2900 0.0521];
        
figure;
plot(1:10,GenError(:,1),'r'); hold on;
plot(1:10,sqrt(GenError(:,2))); hold on;