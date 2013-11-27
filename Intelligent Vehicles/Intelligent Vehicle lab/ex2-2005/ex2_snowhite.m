%
% Dead Reckoning with Snowshite Mini Robot
%
% Gao Sun, 2013.02.21
%

clear all;
close all;
% %%% Snowhite settings 
L = 680;                % distance between the front and rear wheel axis [mm]


% SIGMA_WHEEL_ENCODER = 0.5/12;   % The error in the encoder is 0.5mm / 12mm travelled
% % Use the same uncertainty in both of the wheel encoders
% SIGMAl = SIGMA_WHEEL_ENCODER;
% SIGMAr = SIGMA_WHEEL_ENCODER;


% Load values
DATA = load('snowhite.txt');

% Extract values
sample_unit   = 0.05;    % ms
sample_period = 1;
v = DATA(1:sample_period:end,1);
a = DATA(1:sample_period:end,2);
X_true = DATA(1:sample_period:end,3);
Y_true = DATA(1:sample_period:end,4);
A_true = DATA(1:sample_period:end,5);
N = max(size(v));


d = sqrt((Y_true(2:end) - Y_true(1:end-1)).^2 + (X_true(2:end) - X_true(1:end-1)).^2);
Distance = sum(d)

% Init Robot Position, i.e. (0, 0, 90*pi/180) and the Robots Uncertainty
X(1) = DATA(1,3);
Y(1) = DATA(1,4);
A(1) = DATA(1,5);
P(1,1:9) = [1 0 0 0 1 0 0 0 (1*pi/180)^2];


% Run until no more encoder values are available
disp('Calculating ...');
for kk=2:N,
    
    X(kk) = X(kk-1) + v(kk-1)*cos(a(kk-1))*(sample_unit*sample_period)*cos(A(kk-1)+v(kk-1)*sin(a(kk-1))*(sample_unit*sample_period)/(2*L));
    Y(kk) = Y(kk-1) + v(kk-1)*cos(a(kk-1))*(sample_unit*sample_period)*sin(A(kk-1)+v(kk-1)*sin(a(kk-1))*(sample_unit*sample_period)/(2*L));
    A(kk) = mod(A(kk-1) + v(kk-1)*sin(a(kk-1))*(sample_unit*sample_period)/L, 2*pi);
    
    % Predict the new uncertainty in the state variables (Error prediction)
    Cxya_old = [P(kk-1,1:3);P(kk-1,4:6);P(kk-1,7:9)];   % Uncertainty in state variables at time k-1 [3x3]    

    Cu =   [10 0 0; 0 0.01 0; 0 0 0.000001];               % Uncertainty in the input variables [2x2]
    
    Axya = [
            1    0    -(sample_unit*sample_period)*v(kk-1)*sin(A(kk-1)+((sample_unit*sample_period)*v(kk-1)*sin(a(kk-1)))/(2*L))*cos(a(kk-1))
            0    1     (sample_unit*sample_period)*v(kk-1)*cos(A(kk-1)+((sample_unit*sample_period)*v(kk-1)*sin(a(kk-1)))/(2*L))*cos(a(kk-1))
            0    0    1
           ];     % Jacobian matrix w.r.t. X, Y and A [3x3]
    Au   = [
            (sample_unit*sample_period)*cos(A(kk-1)+((sample_unit*sample_period)*v(kk-1)*sin(a(kk-1)))/(2*L))*cos(a(kk-1))-((sample_unit*sample_period)^2*v(kk-1)*sin(A(kk-1)+((sample_unit*sample_period)*v(kk-1)*sin(a(kk-1)))/(2*L))*cos(a(kk-1))*sin(a(kk-1)))/(2*L)    -(sample_unit*sample_period)*v(kk-1)*cos(A(kk-1)+((sample_unit*sample_period)*v(kk-1)*sin(a(kk-1)))/(2*L))*sin(a(kk-1))-((sample_unit*sample_period)^2*v(kk-1)^2*sin(A(kk-1)+((sample_unit*sample_period)*v(kk-1)*sin(a(kk-1)))/(2*L))*cos(a(kk-1))^2)/(2*L)    v(kk-1)*cos(a(kk-1))*cos(A(kk-1) + ((sample_unit*sample_period)*v(kk-1)*sin(a(kk-1)))/(2*L)) - ((sample_unit*sample_period)*v(kk-1)^2*cos(a(kk-1))*sin(a(kk-1))*sin(A(kk-1) + ((sample_unit*sample_period)*v(kk-1)*sin(a(kk-1)))/(2*L)))/(2*L)
            (sample_unit*sample_period)*sin(A(kk-1)+((sample_unit*sample_period)*v(kk-1)*sin(a(kk-1)))/(2*L))*cos(a(kk-1))+((sample_unit*sample_period)^2*v(kk-1)*cos(A(kk-1)+((sample_unit*sample_period)*v(kk-1)*sin(a(kk-1)))/(2*L))*cos(a(kk-1))*sin(a(kk-1)))/(2*L)    -(sample_unit*sample_period)*v(kk-1)*sin(A(kk-1)+((sample_unit*sample_period)*v(kk-1)*sin(a(kk-1)))/(2*L))*sin(a(kk-1))+((sample_unit*sample_period)^2*v(kk-1)^2*cos(A(kk-1)+((sample_unit*sample_period)*v(kk-1)*sin(a(kk-1)))/(2*L))*cos(a(kk-1))^2)/(2*L)    v(kk-1)*cos(a(kk-1))*sin(A(kk-1) + ((sample_unit*sample_period)*v(kk-1)*sin(a(kk-1)))/(2*L)) + ((sample_unit*sample_period)*v(kk-1)^2*cos(a(kk-1))*sin(a(kk-1))*cos(A(kk-1) + ((sample_unit*sample_period)*v(kk-1)*sin(a(kk-1)))/(2*L)))/(2*L)
            ((sample_unit*sample_period)*sin(a(kk-1)))/L                                                                                                                                                                                                                    ((sample_unit*sample_period)*v(kk-1)*cos(a(kk-1)))/L                                                                                                                                                                                                            (v(kk-1)*sin(a(kk-1)))/L
           ];           % Jacobian matrix w.r.t. dD and dA [3x3]
    
    %Axya = ??; % You should write the correct one, which replaces the one above!
    %Au = ??;   % You should write the correct one, which repleces the one above!
    %Cu = ??;   % You should write the correct one, which replaces the one above!
    
    % Use the law of error predictions, which gives the new uncertainty
    Cxya_new = Axya*Cxya_old*Axya' + Au*Cu*Au';
    
    % Store the new co-variance matrix
    P(kk,1:9) = [Cxya_new(1,1:3) Cxya_new(2,1:3) Cxya_new(3,1:3)];
end;



Error_x = X' - X_true;
Error_y = Y' - Y_true;
Error_a = AngDifference(A' , A_true);

SD_x    = sqrt(P(:,1));
SD_y    = sqrt(P(:,5));
SD_a    = sqrt(P(:,9));


disp('Plotting ...');

% Plot the path taken by the robot, by plotting the uncertainty in the current position
figure;
    title('Path taken by the robot [Snowhite]');
    xlabel('X [mm] World co-ordinates');
    ylabel('Y [mm] World co-ordinates');
    hold on;
        for kk = 1:1:N,
            C = [P(kk,1:3);P(kk,4:6);P(kk,7:9)];
            plot_uncertainty([X(kk) Y(kk) A(kk)]', C, 1, 2);
        end;
    hold on;
%     plot(X, Y, 'b.');
    hold off;
    axis('equal');

% After the run, plot the results (X,Y,A), i.e. the estimated positions 
figure;
    subplot(3,1,1); plot(X, 'b'); title('X [mm]');
    subplot(3,1,2); plot(Y, 'b'); title('Y [mm]');
    subplot(3,1,3); plot(A*180/pi, 'b'); title('A [deg]');

% Plot the estimated variances (in X, Y and A) - 1 standard deviation
subplot(3,1,1); hold on;
    plot(X'+sqrt(P(:,1)), 'b:');
    plot(X'-sqrt(P(:,1)), 'b:');
hold off;
subplot(3,1,2); hold on;
    plot(Y'+sqrt(P(:,5)), 'b:');
    plot(Y'-sqrt(P(:,5)), 'b:');
hold off;
subplot(3,1,3); hold on;
    plot((A'+sqrt(P(:,9)))*180/pi, 'b:');
    plot((A'-sqrt(P(:,9)))*180/pi, 'b:');
hold off;


% Plot the standard deviation and the error
figure;
    subplot(3,1,1); plot(abs(Error_x), 'b'); title('X [mm]');
    subplot(3,1,2); plot(abs(Error_y), 'b'); title('Y [mm]');
    subplot(3,1,3); plot(abs(Error_a)*180/pi, 'b'); title('A [deg]');

subplot(3,1,1); hold on;
    plot(SD_x, 'g');
hold off;
subplot(3,1,2); hold on;
    plot(SD_y, 'g');
hold off;
subplot(3,1,3); hold on;
    plot((SD_a)*180/pi, 'g');
hold off;
    


disp('Finished!');