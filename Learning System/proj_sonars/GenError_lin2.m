clear all; close all;
Origin = [0.2400 0.0560];
GenError = [0.2900 0.0432
            0.3300 0.0490
            0.2300 0.0290
            0.2500 0.0317
            0.2800 0.0440
            0.2500 0.0228
            0.2500 0.0494
            0.2800 0.0307
            0.2800 0.0551
            0.2700 0.0423];
        
figure;
plot(1:10,GenError(:,1),'r'); hold on;
plot(1:10,sqrt(GenError(:,2))); hold on;