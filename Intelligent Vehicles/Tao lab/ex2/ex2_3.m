%
% Dead Reckoning with Khepera Mini Robot
%
% Ola Bengtsson, 2004.02.06
%

clear all;
close all;

% %%% Khepera settings 
WHEEL_BASE = 680;                % [mm]
T = 0.05;
%WHEEL_DIAMETER = 14;          % [mm]
%PULSES_PER_REVOLUTION = 600;    %
%MM_PER_PULSE = pi*WHEEL_DIAMETER/PULSES_PER_REVOLUTION;               % [mm / pulse]


% %%% Uncertainty settings, which are be the same for the left and right encoders
SIGMA_WHEEL_ENCODER = 0.5/12;   % The error in the encoder is 0.5mm / 12mm travelled
% Use the same uncertainty in both of the wheel encoders
SIGMAl = SIGMA_WHEEL_ENCODER;
SIGMAr = SIGMA_WHEEL_ENCODER;


% Load encoder values
 ENC = load('snowhite.txt');

 
v = ENC(1:1:end,1) ;
a = ENC(1:1:end,2) ;
x = ENC(1:1:end,3) ;
y = ENC(1:1:end,4) ;
AA = ENC(1:1:end,5) ;
N = max(size(v));

% Init Robot Position, i.e. (0, 0, 90*pi/180) and the Robots Uncertainty
X(1) = 9428;
Y(1) = 5645;
A(1) = 90*pi/180;
P(1,1:9) = [1 0 0 0 1 0 0 0 (1*pi/180)^2];

% Run until no more encoder values are available
disp('Calculating ...');
for kk=2:N,
    % Change of wheel displacements, i.e displacement of left and right wheels
    dv = v(kk);
    da = a(kk);
    
    % Change of relative movements
    dD = dv*cos(da)*T;
    dA = dv*sin(da)*T/WHEEL_BASE;
    %dD = ??;   % You should write the correct one, which replaces the one above!
    %dA = ??;   % You should write the correct one, which replaces the one above!
    
    % Calculate the change in X and Y (World co-ordinates)
    dX = dD*cos(A(kk-1)+dA/2);
    dY = dD*sin(A(kk-1)+dA/2);
    %dX = ??;   % You should write the correct one, which replaces the one above!
    %dY = ??;   % You should write the correct one, which replaces the one above!
    
    % Predict the new state variables (World co-ordinates)
    X(kk) = X(kk-1) + dX;
    Y(kk) = Y(kk-1) + dY;
    A(kk) = mod(A(kk-1) + dA, 2*pi);
    
    % Predict the new uncertainty in the state variables (Error prediction)
    Cxya_old = [P(kk-1,1:3);P(kk-1,4:6);P(kk-1,7:9)];   % Uncertainty in state variables at time k-1 [3x3]    

    %Inv = dv^2;
    %Ina = da^2;
    Inv = 0.0001;
    Ina = 0.0001;
    Int = 0.000001;
    
    Cu = [Inv 0 0;0 Ina 0;0 0 Int];
    
    %Axya(kk) = [1 0 (-dD(kk)*sin(A(1)+dA(kk)/2));
    %           0 1 (dD(kk)*cos(A(1)+dA(kk)/2));
    %          0 0 1];
    %Axya = [1 0 (-dD(kk)*sin(A(kk-1)+dA(kk)/2));
    %        0 1 (dD(kk)*cos(A(kk-1)+dA(kk)/2));
    %        0 0 1];%done
    %Au = [0.5*cos(A(kk-1)+dA(kk)/2)-(0.5*dD(kk))*sin(A(kk-1)+dA(kk)/2)/WHEEL_BASE 0.5*cos(A(kk-1)+dA(kk)/2)+(0.5*dD(kk))*sin(A(kk-1)+dA(kk)/2)/WHEEL_BASE;
    %      0.5*sin(A(kk-1)+dA(kk)/2)+(0.5*dD(kk))*cos(A(kk-1)+dA(kk)/2)/WHEEL_BASE 0.5*sin(A(kk-1)+dA(kk)/2)-(0.5*dD(kk))*cos(A(kk-1)+dA(kk)/2)/WHEEL_BASE;
    %      1/WHEEL_BASE -1/WHEEL_BASE];%done
      
    Axya = [1 0 -dv*cos(da)*T*sin(A(kk-1)+0.5*dv*sin(da)*T/WHEEL_BASE);
            0 1 dv*cos(da)*T*cos(A(kk-1)+ 0.5*dv*sin(da)*T/WHEEL_BASE);
            0 0 1];
    Au =[cos(da)*T*cos(A(kk-1)+0.5*dv*sin(da)*T/WHEEL_BASE)-0.5*dv*cos(da)*T*sin(A(kk-1)+dv*sin(da)*T/WHEEL_BASE)*(0.5*sin(da)*T/WHEEL_BASE) -dv*sin(da)*T*cos(A(kk-1)+0.5*dv*sin(da)*T/WHEEL_BASE)-dv*cos(da)*T*sin(A(kk-1)+0.5*dv*sin(da)*T/WHEEL_BASE)*(0.5*dv*cos(da)*T/WHEEL_BASE) cos(da)*dv*cos(A(kk-1)+0.5*dv*sin(da)*T/WHEEL_BASE)-dv*cos(da)*T*sin(A(kk-1)+0.5*(0.5*dv*sin(da)*T/WHEEL_BASE))*sin(da)*dv/WHEEL_BASE;
         cos(da)*T*sin(A(kk-1)+0.5*dv*sin(da)*T/WHEEL_BASE)+0.5*dv*cos(da)*T*cos(A(kk-1)+dv*sin(da)*T/WHEEL_BASE)*(0.5*sin(da)*T/WHEEL_BASE) -dv*sin(da)*T*sin(A(kk-1)+0.5*dv*sin(da)*T/WHEEL_BASE)+dv*cos(da)*T*cos(A(kk-1)+0.5*dv*sin(da)*T/WHEEL_BASE)*(0.5*dv*cos(da)*T/WHEEL_BASE) cos(da)*dv*sin(A(kk-1)+0.5*dv*sin(da)*T/WHEEL_BASE)+dv*cos(da)*T*cos(A(kk-1)+0.5*(0.5*dv*sin(da)*T/WHEEL_BASE))*sin(da)*dv/WHEEL_BASE;
         sin(da)*T/WHEEL_BASE dv*cos(da)*T/WHEEL_BASE sin(da)*dv/WHEEL_BASE];  
    %Xk = [dv*cos(da)*T*cos(A(kk-1)+0.5*v*sin(a)*T/WHEEL_BASE) dv*cos(da)*T*sin(A(kk-1)+0.5*v*sin(a)*T/WHEEL_BASE) 0.5*dv*sin(a)*T/WHEEL_BASE];
    
    %Au =  jacobian([dv*cos(da)*T*cos(A(kk-1)+0.5*dv*sin(da)*T/WHEEL_BASE); dv*cos(da)*T*sin(A(kk-1)+0.5*dv*sin(da)*T/WHEEL_BASE); 0.5*dv*sin(da)*T/WHEEL_BASE],[dv da T]);
    
    %Cb=[(0.5*(dDr(kk)+dDl(kk)))^2];
    %Ab=[(0.5*(dDr(kk)+dDl(kk)))*(0.5*(dDr(kk)-dDl(kk))/(WHEEL_BASE^2))*sin(A(kk-1)+0.5*(dDr(kk)-dDl(kk))/WHEEL_BASE);
    %    (-0.5*(dDr(kk)+dDl(kk)))*(0.5*(dDr(kk)-dDl(kk))/(WHEEL_BASE^2))*cos(A(kk-1)+0.5*(dDr(kk)-dDl(kk))/WHEEL_BASE);
    %    (-1*dDr(kk)-dDl(kk))/(WHEEL_BASE^2)];
    %Ab=[0.5*cos(A(kk-1)+0.5*(dDr(kk)-dDl(kk))/WHEEL_BASE)-0.25*(dDr(kk)+dDl(kk)/WHEEL_BASE)*sin(A(kk-1)+0.5*(dDr(kk)-dDl(kk))/WHEEL_BASE) 0.5*cos(A(kk-1)+0.5*(dDr(kk)-dDl(kk))/WHEEL_BASE)+0.25*(dDr(kk)+dDl(kk)/WHEEL_BASE)*sin(A(kk-1)+0.5*(dDr(kk)-dDl(kk))/WHEEL_BASE);
    %    0.5*cos(A(kk-1)+0.5*(dDr(kk)-dDl(kk))/WHEEL_BASE)+0.25*(dDr(kk)+dDl(kk)/WHEEL_BASE)*sin(A(kk-1)+0.5*(dDr(kk)-dDl(kk))/WHEEL_BASE) 0.5*cos(A(kk-1)+0.5*(dDr(kk)-dDl(kk))/WHEEL_BASE)-0.25*(dDr(kk)+dDl(kk)/WHEEL_BASE)*sin(A(kk-1)+0.5*(dDr(kk)-dDl(kk))/WHEEL_BASE)
    %    1/WHEEL_BASE -1/WHEEL_BASE]
    
    % Use the law of error predictions, which gives the new uncertainty
    Cxya_new = Axya*Cxya_old*Axya' + Au*Cu*Au';
    
    % Store the new co-variance matrix
    P(kk,1:9) = [Cxya_new(1,1:3) Cxya_new(2,1:3) Cxya_new(3,1:3)];
end;

%for kk=2:N,
EXx =abs(X - x');
EYy =abs(Y - y');
EAa =abs(A - AA');
%end;
figure;
subplot(3,1,1); plot(EXx, 'b'); title('X [mm]');
subplot(3,1,2); plot(EYy, 'b'); title('Y [mm]');
subplot(3,1,3); plot(EAa, 'b'); title('A [mm]');

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
