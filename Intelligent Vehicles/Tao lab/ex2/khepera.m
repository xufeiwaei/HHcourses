%
% Dead Reckoning with Khepera Mini Robot
%
% Ola Bengtsson, 2004.02.06
%

clear all;
close all;

% %%% Khepera settings 
WHEEL_BASE = 53;                % [mm]
WHEEL_DIAMETER = 15.3;          % [mm]
PULSES_PER_REVOLUTION = 600;    %
MM_PER_PULSE = WHEEL_DIAMETER * pi/ PULSES_PER_REVOLUTION;               % [mm / pulse]


% %%% Uncertainty settings, which are be the same for the left and right encoders
SIGMA_WHEEL_ENCODER = 0.5/12;   % The error in the encoder is 0.5mm / 12mm travelled
% Use the same uncertainty in both of the wheel encoders
SIGMAl = SIGMA_WHEEL_ENCODER;
SIGMAr = SIGMA_WHEEL_ENCODER;

% Load encoder values
% ENC = load('khepera_circle.txt');
ENC = load('khepera.txt');

% Transform encoder values (pulses) into distance travelled by the wheels (mm)
Dr = ENC(1:1:end,2) * MM_PER_PULSE;
Dl = ENC(1:1:end,1) * MM_PER_PULSE;
N = max(size(Dr));

% Init Robot Position, i.e. (0, 0, 90*pi/180) and the Robots Uncertainty
X(1) = 0;
Y(1) = 0;
A(1) = 90*pi/180;
P(1,1:9) = [1 0 0 0 1 0 0 0 (1*pi/180)^2];

syms x y theta
syms deltaD deltaTheta
f = [
     x+deltaD*cos(theta+deltaTheta/2)
     y+deltaD*sin(theta+deltaTheta/2)
     theta+deltaTheta
    ];
f_xytheta = jacobian(f, [x, y, theta]);
f_deltaDdeltaTheta = jacobian(f, [deltaD, deltaTheta]);

% Run until no more encoder values are available
disp('Calculating ...');
compensation = zeros(1, N-1);
for kk=2:N,
    % Change of wheel displacements, i.e displacement of left and right wheels
    dDr = Dr(kk) - Dr(kk-1);
    dDl = Dl(kk) - Dl(kk-1);
    
    % Change of relative movements
    dD = (dDr+dDl)/2;
    dA = (dDr-dDl)/WHEEL_BASE;
    
    % Calculate the change in X and Y (World co-ordinates)
%     compensation(kk) = sin(dA+eps/2)/(dA+eps/2);
    compensation(kk) = 1;
    dX = compensation(kk)*dD*cos(A(kk-1) + dA/2);
    dY = compensation(kk)*dD*sin(A(kk-1) + dA/2);
    
    % Predict the new state variables (World co-ordinates)
    X(kk) = X(kk-1) + dX;
    Y(kk) = Y(kk-1) + dY;
    A(kk) = mod(A(kk-1) + dA, 2*pi);
    
    % Predict the new uncertainty in the state variables (Error prediction)
    Cxya_old = [P(kk-1,1:3);P(kk-1,4:6);P(kk-1,7:9)];   % Uncertainty in state variables at time k-1 [3x3]    

    Cu =   [(SIGMAl^2+SIGMAr^2)/4 0;0 (SIGMAl^2+SIGMAr^2)/WHEEL_BASE^2];               % Uncertainty in the input variables [2x2]
    Axya = subs(f_xytheta, {deltaD, deltaTheta, theta}, {dD, dA, A(kk-1)}); % Jacobian matrix w.r.t. X, Y and A [3x3]
    Au = subs(f_deltaDdeltaTheta, {deltaD, deltaTheta, theta}, {dD, dA, A(kk-1)});  % Jacobian matrix w.r.t. dD and dA [3x2]
 
    % Use the law of error predictions, which gives the new uncertainty
    Cxya_new = Axya*Cxya_old*Axya' + Au*Cu*Au';
    % Store the new co-variance matrix
    P(kk,1:9) = [Cxya_new(1,1:3) Cxya_new(2,1:3) Cxya_new(3,1:3)];
end;
% warning off

disp('Plotting ...');

% Plot the path taken by the robot, by plotting the uncertainty in the current position
figure; 
    %plot(X, Y, 'b.');
    title('Model without compensation term');
%     title('Model with compensation term');
    xlabel('X [mm] World co-ordinates');
    ylabel('Y [mm] World co-ordinates');
    hold on;
        for kk = 1:1:N,
            C = [P(kk,1:3);P(kk,4:6);P(kk,7:9)];
            plot_uncertainty([X(kk) Y(kk) A(kk)]', C, 1, 2);
        end;
    hold off;
    axis('equal');
%     print(1, '-dpng', 'circle_without');
%     print(1, '-dpng', 'circle_with');
    print(1, '-dpng', 'noncircle_without');
%     print(1, '-dpng', 'noncircle_with');

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
