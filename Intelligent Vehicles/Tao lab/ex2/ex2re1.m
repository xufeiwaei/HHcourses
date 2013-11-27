%
% Dead Reckoning with Khepera Mini Robot
%
% Ola Bengtsson, 2004.02.06
%

clear all;
close all;

% %%% Khepera settings 
WHEEL_BASE = 53;                % [mm]
%WHEEL_BASE = 45;
WHEEL_DIAMETER = 15.3;          % [mm]
%WHEEL_DIAMETER = 14;
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
%ENC = load('khepera.txt');


% Transform encoder values (pulses) into distance travelled by the wheels (mm)
Dr = ENC(1:1:end,2) * MM_PER_PULSE;
Dl = ENC(1:1:end,1) * MM_PER_PULSE;
N = max(size(Dr));

% Init Robot Position, i.e. (0, 0, 90*pi/180) and the Robots Uncertainty
X(1) = 0;
Y(1) = 0;
A(1) = 90*pi/180;
P(1,1:9) = [1 0 0 0 1 0 0 0 (1*pi/180)^2];

% Run until no more encoder values are available
disp('Calculating ...');
for kk=2:N,
    % Change of wheel displacements, i.e displacement of left and right wheels
    dDr(kk) = Dr(kk) - Dr(kk-1);
    dDl(kk) = Dl(kk) - Dl(kk-1);
    
    % Change of relative movements
    % dD = 0;
    % dA = 0.017;
    dD(kk) = (dDr(kk)+dDl(kk))/2;
    dA(kk) = (dDr(kk)-dDl(kk))/WHEEL_BASE;
    %dD = ??;   % You should write the correct one, which replaces the one above!
    %dA = ??;   % You should write the correct one, which replaces the one above!
    
    % Calculate the change in X and Y (World co-ordinates)
    % dX = 1;
    % dY = 1;
    dX(kk) = dD(kk)*cos(A(kk-1)+dA(kk)/2);
    dY(kk) = dD(kk)*sin(A(kk-1)+dA(kk)/2);
    %dX = ??;   % You should write the correct one, which replaces the one above!
    %dY = ??;   % You should write the correct one, which replaces the one above!
    
    % Predict the new state variables (World co-ordinates)
    X(kk) = X(kk-1) + dX(kk);
    Y(kk) = Y(kk-1) + dY(kk);
    A(kk) = mod(A(kk-1) + dA(kk), 2*pi);
  
    
    
    % Predict the new uncertainty in the state variables (Error prediction)
    Cxya_old = [P(kk-1,1:3);P(kk-1,4:6);P(kk-1,7:9)];   % Uncertainty in state variables at time k-1 [3x3]    

    %  Cu =   [1 0;0 1];               % Uncertainty in the input variables [2x2]
    %  Axya = [1 0 0;0 1 0;0 0 1];     % Jacobian matrix w.r.t. X, Y and A [3x3]
    %  Au =   [0 0;0 0;0 0];           % Jacobian matrix w.r.t. dD and dA [3x2]
    Cu = [(dDr(kk)^2+dDl(kk)^2)/4 0;0 (dDr(kk)^2-dDl(kk)^2)/WHEEL_BASE^2];
    %Axya(kk) = [1 0 (-dD(kk)*sin(A(1)+dA(kk)/2));
    %           0 1 (dD(kk)*cos(A(1)+dA(kk)/2));
    %          0 0 1];
    Axya = [1 0 (-dD(kk)*sin(A(kk-1)+dA(kk)/2));
            0 1 (dD(kk)*cos(A(kk-1)+dA(kk)/2));
            0 0 1];
    Au = [cos(A(kk-1)+dA(kk)/2) (-0.5*dD(kk))*sin(A(kk-1)+dA(kk)/2);
          sin(A(kk-1)+dA(kk)/2) 0.5*dD(kk)*cos(A(kk-1)+dA(kk)/2);
          0 1];
    %Axya = ??; % You should write the correct one, which replaces the one above!
    %Au = ??;   % You should write the correct one, which repleces the one above!
    %Cu = ??;   % You should write the correct one, which replaces the one above!
    
    % Use the law of error predictions, which gives the new uncertainty
    Cxya_new = Axya*Cxya_old*Axya'; % + Au*Cu*Au';
    
    % Store the new co-variance matrix
    P(kk,1:9) = [Cxya_new(1,1:3) Cxya_new(2,1:3) Cxya_new(3,1:3)];
end;



disp('Plotting ...');

% Plot the path taken by the robot, by plotting the uncertainty in the current position
figure; 
    %plot(X, Y, 'b.');
    title('Path taken by the robot [Wang]');
    xlabel('X [mm] World co-ordinates');
    ylabel('Y [mm] World co-ordinates');
    hold on;
        for kk = 1:1:N,
            C = [P(kk,1:3);P(kk,4:6);P(kk,7:9)];
            plot_uncertainty([X(kk) Y(kk) A(kk)]', C, 1, 2);
        end;
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
