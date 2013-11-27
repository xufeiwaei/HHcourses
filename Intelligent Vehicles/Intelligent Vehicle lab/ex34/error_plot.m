% count how many examples at most can be plotted
n = min([size(X,2),size(Y,2),size(A,2),size(P,1)]);

% calculate the predication error
ERROR_predication = [X(1:n)' Y(1:n)' A(1:n)'] - CONTROL(1:n,4:6);
ERROR_predication(:,3) = AngDifference(A(1:n)',CONTROL(1:n,6));
ERROR_predication = abs(ERROR_predication);

% calculate the laser error
for k = 1:size(X_laser,2)
    ERROR_laser(k,1) = X_laser(1,k) - CONTROL(X_laser(4,k),4);
    ERROR_laser(k,2) = X_laser(2,k) - CONTROL(X_laser(4,k),5);
    ERROR_laser(k,3) = AngDifference(X_laser(3,k) , CONTROL(X_laser(4,k),6));
end
ERROR_laser = abs(ERROR_laser);

% calculate the Kalman error
for k = 1:size(X_kalman,2)
    ERROR_Kalman(k,1) = X_kalman(1,k) - CONTROL(X_kalman(4,k),4);
    ERROR_Kalman(k,2) = X_kalman(2,k) - CONTROL(X_kalman(4,k),5);
    ERROR_Kalman(k,3) = AngDifference(X_kalman(3,k) , CONTROL(X_kalman(4,k),6));
end
ERROR_Kalman = abs(ERROR_Kalman);

% plot
figure;
subplot(3,1,1);
hold on; plot(ERROR_predication(:,1),'b');
hold on; plot(sqrt(P(1:n,1)),'r'); % one sigma
hold on; plot(X_laser(4,:) , ERROR_laser(:,1)','m.');
hold on; plot(X_laser(4,:) , ERROR_laser(:,1)','m:');
hold on; plot(X_laser(4,1:size(Laser_Fixed_Uncertainty,1)) , sqrt(Laser_Fixed_Uncertainty(:,1)'),'k.');
hold on; plot(X_laser(4,1:size(Laser_Fixed_Uncertainty,1)) , sqrt(Laser_Fixed_Uncertainty(:,1)'),'k:');
hold on; plot(X_kalman(4,:) , ERROR_Kalman(:,1)','g.');
hold on; plot(X_kalman(4,:) , ERROR_Kalman(:,1)','g:');
hold on; plot(X_laser(4,1:size(C_kalman_whole,1)) , sqrt(C_kalman_whole(:,1)'),'c.');
hold on; plot(X_laser(4,1:size(C_kalman_whole,1)) , sqrt(C_kalman_whole(:,1)'),'c:');
title('X(mm): Predication (E-blue, U-red); Laser (E-pink, U-black); Kalman (E-green, U-cyan)');


subplot(3,1,2);
hold on; plot(ERROR_predication(:,2),'b');
hold on; plot(sqrt(P(1:n,5)),'r'); % one sigma
hold on; plot(X_laser(4,:) , ERROR_laser(:,2)','m.');
hold on; plot(X_laser(4,:) , ERROR_laser(:,2)','m:');
hold on; plot(X_laser(4,1:size(Laser_Fixed_Uncertainty,1)) , sqrt(Laser_Fixed_Uncertainty(:,5)'),'k.');
hold on; plot(X_laser(4,1:size(Laser_Fixed_Uncertainty,1)) , sqrt(Laser_Fixed_Uncertainty(:,5)'),'k:');
hold on; plot(X_kalman(4,:) , ERROR_Kalman(:,2)','g.');
hold on; plot(X_kalman(4,:) , ERROR_Kalman(:,2)','g:');
hold on; plot(X_laser(4,1:size(C_kalman_whole,1)) , sqrt(C_kalman_whole(:,5)'),'c.');
hold on; plot(X_laser(4,1:size(C_kalman_whole,1)) , sqrt(C_kalman_whole(:,5)'),'c:');
title('Y(mm): Predication (E-blue, U-red); Laser (E-pink, U-black); Kalman (E-green, U-cyan)');


subplot(3,1,3);
hold on; plot(ERROR_predication(:,3)*180/pi,'b');
hold on; plot(sqrt(P(1:n,9))*180/pi,'r'); % one sigma
hold on; plot(X_laser(4,:) , ERROR_laser(:,3)*180/pi','m.');
hold on; plot(X_laser(4,:) , ERROR_laser(:,3)*180/pi','m:');
hold on; plot(X_laser(4,1:size(Laser_Fixed_Uncertainty,1)) , sqrt(Laser_Fixed_Uncertainty(:,9)')*180/pi,'k.');
hold on; plot(X_laser(4,1:size(Laser_Fixed_Uncertainty,1)) , sqrt(Laser_Fixed_Uncertainty(:,9)')*180/pi,'k:');
hold on; plot(X_kalman(4,:) , ERROR_Kalman(:,3)*180/pi','g.');
hold on; plot(X_kalman(4,:) , ERROR_Kalman(:,3)*180/pi','g:');
hold on; plot(X_laser(4,1:size(C_kalman_whole,1)) , sqrt(C_kalman_whole(:,9)')*180/pi,'c.');
hold on; plot(X_laser(4,1:size(C_kalman_whole,1)) , sqrt(C_kalman_whole(:,9)')*180/pi,'c:');
title('A(degree): Predication (E-blue, U-red); Laser (E-pink, U-black); Kalman (E-green, U-cyan)');