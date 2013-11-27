%
% Dead Reckoning with Khepera Mini Robot
%
% Ola Bengtsson, 2004.02.06
%

clear all;
% close all;
% %%% Khepera settings 
WHEEL_BASE = 30;                % [mm]
WHEEL_DIAMETER = 10;          % [mm]
PULSES_PER_REVOLUTION = 600;    %
MM_PER_PULSE = pi*WHEEL_DIAMETER/PULSES_PER_REVOLUTION;               % [mm / pulse]
%MM_PER_PULSE = ??; % You should write the correct one, which replaces the one above!


% %%% Uncertainty settings, which are be the same for the left and right encoders
SIGMA_WHEEL_ENCODER = 0.5/12;   % The error in the encoder is 0.5mm / 12mm travelled
% Use the same uncertainty in both of the wheel encoders
SIGMAl = SIGMA_WHEEL_ENCODER;
SIGMAr = SIGMA_WHEEL_ENCODER;


% Load encoder values
ENC = load('khepera_circle.txt');

% Transform encoder values (pulses) into distance travelled by the wheels (mm)
sample_period = 10;
Dr = ENC(1:sample_period:end,2) * MM_PER_PULSE;
Dl = ENC(1:sample_period:end,1) * MM_PER_PULSE;
N = max(size(Dr));

Diff_d = ((Dr(2:end) - Dr(1:end-1)) + (Dl(2:end) - Dl(1:end-1)))/2;
Diff_a = ((Dr(2:end) - Dr(1:end-1)) - (Dl(2:end) - Dl(1:end-1)))/WHEEL_BASE;


% Init Robot Position, i.e. (0, 0, 90*pi/180) and the Robots Uncertainty
X(1) = 0;
Y(1) = 0;
A(1) = 90*pi/180;
P(1,1:9) = [1 0 0 0 1 0 0 0 (1*pi/180)^2];

% Run until no more encoder values are available
disp('Calculating ...');
for kk=2:N,
    % Change of wheel displacements, i.e displacement of left and right wheels
    dDr = Dr(kk) - Dr(kk-1);
    dDl = Dl(kk) - Dl(kk-1);
    
    % Change of relative movements
    dD = (dDr + dDl)/2;
    dA = (dDr - dDl)/WHEEL_BASE;
    %dD = ??;   % You should write the correct one, which replaces the one above!
    %dA = ??;   % You should write the correct one, which replaces the one above!
    
    % Calculate the change in X and Y (World co-ordinates)
    if dA~=0
        dX = sin(dA/2)/(dA/2)*dD*cos(A(kk-1)+dA/2);
        dY = sin(dA/2)/(dA/2)*dD*sin(A(kk-1)+dA/2);
    else    
        dX = dD*cos(A(kk-1)+dA/2);
        dY = dD*sin(A(kk-1)+dA/2);
    end
    %dX = ??;   % You should write the correct one, which replaces the one above!
    %dY = ??;   % You should write the correct one, which replaces the one above!
    
    % Predict the new state variables (World co-ordinates)
    X(kk) = X(kk-1) + dX;
    Y(kk) = Y(kk-1) + dY;
    A(kk) = mod(A(kk-1) + dA, 2*pi);
    
    % Predict the new uncertainty in the state variables (Error prediction)
    Cxya_old = [P(kk-1,1:3);P(kk-1,4:6);P(kk-1,7:9)];   % Uncertainty in state variables at time k-1 [3x3]    

    Cu =   [(SIGMAl^2+SIGMAr^2)/4 0;0 (SIGMAl^2-SIGMAr^2)/WHEEL_BASE^2];               % Uncertainty in the input variables [2x2]
    if dA==0
        Axya = [1 0 -dD*sin(A(kk-1)+dA/2);0 1 dD*cos(A(kk-1)+dA/2);0 0 1];     % Jacobian matrix w.r.t. X, Y and A [3x3]
        Au =   [cos(A(kk-1)+dA/2) -dD/2*sin(A(kk-1)+dA/2);sin(A(kk-1)+dA/2) dD/2*cos(A(kk-1)+dA/2);0 1];           % Jacobian matrix w.r.t. dD and dA [3x2]
    else
        Axya = [1 0 -(2*dD*sin(dA/2)*sin(A(kk-1) + dA/2))/dA;0 1 (2*dD*sin(dA/2)*cos(A(kk-1) + dA/2))/dA;0 0 1];     % Jacobian matrix with compensation
        Au =   [(2*sin(dA/2)*cos(A(kk-1) + dA/2))/dA (dD*cos(dA/2)*cos(A(kk-1) + dA/2))/dA - (2*dD*sin(dA/2)*cos(A(kk-1) + dA/2))/dA^2 - (dD*sin(dA/2)*sin(A(kk-1) + dA/2))/dA ; (2*sin(dA/2)*sin(A(kk-1) + dA/2))/dA (dD*cos(dA/2)*sin(A(kk-1) + dA/2))/dA + (dD*sin(dA/2)*cos(A(kk-1) + dA/2))/dA - (2*dD*sin(dA/2)*sin(A(kk-1) + dA/2))/dA^2 ; 0 1];           % Jacobian matrix with compensation
    end
    %Axya = ??; % You should write the correct one, which replaces the one above!
    %Au = ??;   % You should write the correct one, which repleces the one above!
    %Cu = ??;   % You should write the correct one, which replaces the one above!
    
    % Use the law of error predictions, which gives the new uncertainty
    Cxya_new = Axya*Cxya_old*Axya' + Au*Cu*Au';
    
    % Store the new co-variance matrix
    P(kk,1:9) = [Cxya_new(1,1:3) Cxya_new(2,1:3) Cxya_new(3,1:3)];
end;


disp('Plotting ...');

% Plot the path taken by the robot, by plotting the uncertainty in the current position
% figure; 
    %plot(X, Y, 'b.');
%     title('Path taken by the robot [Wang]');
%     xlabel('X [mm] World co-ordinates');
%     ylabel('Y [mm] World co-ordinates');
    hold on;
        for kk = 1:1:N,
            C = [P(kk,1:3);P(kk,4:6);P(kk,7:9)];
            plot_uncertainty_blue([X(kk) Y(kk) A(kk)]', C, 1, 2);
        end;
    hold off;
    axis('equal');

