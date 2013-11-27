clear all
close all;

L = 680;
T_period = 0.05;
% Load encoder values
ENC = load('snowhite.txt');
v = ENC(1:1:end,1);
a = ENC(1:1:end,2);

N = max(size(v));
% Init Robot Position, i.e. (0, 0, 90*pi/180) and the Robots Uncertainty
X(1) = ENC(1,3);
Y(1) = ENC(1,4);
A(1) = ENC(1,5);
P(1,1:9) = [1 0 0 0 1 0 0 0 (1*pi/180)^2];
syms x y theta alpha T velocity
F = [ x+velocity*cos(alpha)*T*cos(theta+(velocity*sin(alpha)*T)/(2*L)) 
      y+velocity*cos(alpha)*T*sin(theta+(velocity*sin(alpha)*T)/(2*L))
      theta+velocity*sin(alpha)*T/L];
F_vaT = jacobian(F, [velocity, T, alpha]);
F_xyt = jacobian(F, [x, y, theta]);

disp('Calculating ...');
Cu = [0.001^2 0 0; 0 ((1*pi)/180)^2 0; 0 0 0.001^2];   % Uncertainty in the input variables [3x3]
for kk=2:N,
    dD = v(kk)*cos(a(kk))*T_period;
    dA = v(kk)*sin(a(kk))*T_period/L;
    
    dX = dD * cos(A(kk-1) + dA / 2);   % You should write the correct one, which replaces the one above!
    dY = dD * sin(A(kk-1) + dA / 2);   % You should write the correct one, which replaces the one above!
    % Predict the new state variables (World co-ordinates)
    X(kk) = X(kk-1) + dX;
    Y(kk) = Y(kk-1) + dY;
    A(kk) = mod(A(kk-1) + dA, 2*pi);
    
    Cxya_old = [P(kk-1,1:3);P(kk-1,4:6);P(kk-1,7:9)];   % Uncertainty in state variables at time k-1 [3x3]    
    Axya =subs(F_xyt,{theta,velocity,T,alpha},{A(kk),v(kk-1),T_period,a(kk-1)});    % Jacobian matrix w.r.t. X, Y and A [3x3]
    Au =subs(F_vaT,{theta,velocity,T,alpha},{A(kk),v(kk-1),T_period,a(kk-1)}); % Jacobian matrix w.r.t. dD and dA [3x2]
 
     % Use the law of error predictions, which gives the new uncertainty
    Cxya_new = Axya*Cxya_old*Axya' + Au*Cu*Au';
    
    % Store the new co-variance matrix
    P(kk,1:9) = [Cxya_new(1,1:3) Cxya_new(2,1:3) Cxya_new(3,1:3)];
end;

disp('Plotting ...');

% Plot the path taken by the robot, by plotting the uncertainty in the current position
figure,
for kk = 1:N,
    C = [P(kk,1:3);P(kk,4:6);P(kk,7:9)];
    plot_uncertainty([X(kk) Y(kk) A(kk)]', C, 1, 2);
end;
%compare the estimated variables to the true values
figure,
subplot(3,1,1);plot(abs(X'-ENC(:, 3)));title('X[mm]');
subplot(3,1,2);plot(abs(Y'-ENC(:, 4)));title('Y[mm]');
subplot(3,1,3);plot(mod(abs(A'-ENC(:, 5)), 2*pi));title('A[mm]');
% Plot the estimated variances (in X, Y and A) - 1 standard deviation
figure;
    subplot(3,1,1); plot(X, 'b'); title('X [mm]');
    subplot(3,1,2); plot(Y, 'b'); title('Y [mm]');
    subplot(3,1,3); plot(A*180/pi, 'b'); title('A [deg]');
subplot(3,1,1); hold on;
    plot(X'+sqrt(P(:,1)),'b:');
    plot(X'-sqrt(P(:,1)),'b:');
hold off;
subplot(3,1,2); hold on;
    plot(Y'+sqrt(P(:,5)),'b:');
    plot(Y'-sqrt(P(:,5)),'b:');
hold off;
subplot(3,1,3); hold on;
    plot((A'+sqrt(P(:,9)))*180/pi,'b:');
    plot((A'-sqrt(P(:,9)))*180/pi,'b:');
hold off;

disp('The distance[mm] of this path: ')
sum(ENC(:,1) * T_period)
disp('The total time[sec]: ')
N * T_period