%
% Main script that reads controller data and laser data
%
clear all;
close all;

% Control inputs (velocity and steering angle)
CONTROL = load('control_joy.txt');

% Laser data
LD_HEAD   = load('laser_header.txt');
LD_ANGLES = load('laser_angles.txt');
LD_MEASUR = load('laser_measurements.txt');
LD_FLAGS  = load('laser_flags.txt');

[no_inputs co] = size(CONTROL);


% Extract the true position data and add the noise
sigma_x = 10; sigma_y = 10; sigma_a = 1*pi/180;
C_pf = [sigma_x^2 0 0 ; 0 sigma_y^2 0 ; 
    0 0 sigma_a^2];
X_true = CONTROL(:,4);
Y_true = CONTROL(:,5);
A_true = CONTROL(:,6);
X_pf = X_true + sigma_x*randn(size(X_true,1),1);
Y_pf = Y_true + sigma_y*randn(size(Y_true,1),1);
A_pf = A_true + sigma_a*randn(size(A_true,1),1);


% Robots initial position
X(1) = CONTROL(1,4);
Y(1) = CONTROL(1,5);
A(1) = CONTROL(1,6);

scan_idx = 1;


fig_path = figure;



% Uncertaity Initialization
L = 680;
P(1,1:9) = [1 0 0 0 1 0 0 0 (1*pi/180)^2];
syms x y theta alpha T_period velocity
F = [ x+velocity*cos(alpha)*T_period*cos(theta+(velocity*sin(alpha)*T_period)/(2*L)) 
      y+velocity*cos(alpha)*T_period*sin(theta+(velocity*sin(alpha)*T_period)/(2*L))
      theta+velocity*sin(alpha)*T_period/L];
F_vaT = jacobian(F, [velocity, alpha, T_period]);
F_xyt = jacobian(F, [x, y, theta]);
Cu = [10 0 0; 0 0.01 0; 0 0 0.001^2];   % Uncertainty in the input variables [3x3]

% First Kalman Filter Combination
X_kalman(:,1) = C_pf * inv(C_pf + [P(1,1:3);P(1,4:6);P(1,7:9)]) * [X(1) Y(1) A(1)]' + [P(1,1:3);P(1,4:6);P(1,7:9)] * inv(C_pf + [P(1,1:3);P(1,4:6);P(1,7:9)]) * [X_pf(1) Y_pf(1) A_pf(1)]';
C_kalman = inv(inv(C_pf)+inv([P(1,1:3);P(1,4:6);P(1,7:9)]));
C_kalman_whole(1,1:9) = [C_kalman(1,1:3) C_kalman(2,1:3) C_kalman(3,1:3)];

% Mark the first estimated (dead reckoning) position
figure(fig_path);
hold on; plot(X(1), Y(1), 'b.'); hold off;
% Mark the true with noise position
hold on; plot(X_pf(1,1), Y_pf(1,1), 'k.'); hold off;
% Mark the Kalman Filter Combination position
hold on; plot(X_kalman(1,1), X_kalman(2,1), 'g.'); hold off;


% First Uncertainty Plot
hold on;plot_uncertainty_blue([X(1) Y(1) A(1)]', [P(1,1:3);P(1,4:6);P(1,7:9)], 1, 2); hold off;
hold on;plot_uncertainty([X_pf(1,1) Y_pf(1,1) A_pf(1,1)]', C_pf, 1, 2); hold off;
hold on; plot_uncertainty_green(X_kalman(:,1), C_kalman, 1, 2); hold off;




for kk = 2:no_inputs,
    % Check if we should get a position fix, i.e. if the time stamp of the
    % next laser scan is the same as the time stamp of the control input
    % values
    
    
    % Estimate the new position (based on the control inputs) and new
    % uncertainty
    v = CONTROL(kk-1,2);
    a = CONTROL(kk-1,3);
    T = 0.050;
    % L = 680;

    X(kk) = X(kk-1) + cos(a)*v*cos(A(kk-1))*T;
    Y(kk) = Y(kk-1) + cos(a)*v*sin(A(kk-1))*T;
    A(kk) = mod(A(kk-1) + sin(a)*v*T/L , 2*pi);
    
    % Uncertainty Calculation
    Cxya_old = [P(kk-1,1:3);P(kk-1,4:6);P(kk-1,7:9)];   % Uncertainty in state variables at time k-1 [3x3]
    Axya = subs(F_xyt,{theta,velocity,T_period,alpha},{A(kk),v,T,a});    % Jacobian matrix w.r.t. X, Y and A [3x3]
    Au =subs(F_vaT,{theta,velocity,T_period,alpha},{A(kk),v,T,a}); % Jacobian matrix w.r.t. v, a and T_period [3x3]
    
    Cxya_new = Axya*Cxya_old*Axya' + Au*Cu*Au';
    P(kk,1:9) = [Cxya_new(1,1:3) Cxya_new(2,1:3) Cxya_new(3,1:3)];
    % ALSO UPDATE THE UNCERTAINTY OF THE POSITION
    
    
    
    % Kalman Filter Combination
    X_kalman(:,kk) = C_pf * inv(C_pf + Cxya_new) * [X(kk) Y(kk) A(kk)]' + Cxya_new * inv(C_pf + Cxya_new) * [X_pf(kk) Y_pf(kk) A_pf(kk)]';
    % Eliminate the error caused by the periodic feature of the Angle
    if abs(A(kk)-A_pf(kk)) > pi
        if A(kk) > A_pf(kk)
            A_pf(kk) = A_pf(kk) + 2*pi;
        else
            A(kk) = A(kk) + 2*pi;
        end
        X_kalman(:,kk) = C_pf * inv(C_pf + Cxya_new) * [X(kk) Y(kk) A(kk)]' + Cxya_new * inv(C_pf + Cxya_new) * [X_pf(kk) Y_pf(kk) A_pf(kk)]';
    end
    C_kalman = inv(inv(C_pf)+inv(Cxya_new));
    C_kalman_whole(kk,1:9) = [C_kalman(1,1:3) C_kalman(2,1:3) C_kalman(3,1:3)];

    % use the Kalman result to update the position of the robot
%     X(kk) = X_kalman(1,kk);
%     Y(kk) = X_kalman(2,kk);     % maybe wrong ???
%     A(kk) = X_kalman(3,kk);
    
    % Mark the estimated (dead reckoning) position
    figure(fig_path);
    hold on; plot(X(kk), Y(kk), 'b.'); hold off;
    % Mark the true with noise position
    hold on; plot(X_pf(kk,1), Y_pf(kk,1), 'k.'); hold off;
    % Mark the Kalman Filter Combination position
    hold on; plot(X_kalman(1,kk), X_kalman(2,kk), 'g.'); hold off;
    
    
    % Uncertainty Plot
    hold on; plot_uncertainty_blue([X(kk) Y(kk) A(kk)]', Cxya_new, 1, 2); hold off;
    hold on; plot_uncertainty([X_pf(kk,1) Y_pf(kk,1) A_pf(kk,1)]', C_pf, 1, 2); hold off;
    hold on; plot_uncertainty_green(X_kalman(:,kk), C_kalman, 1, 2); hold off;
    
    kk
    
end;