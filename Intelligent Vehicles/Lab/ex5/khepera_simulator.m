%
% Simulates Khepera walking randomly
%
clear all;
close all;

% Environment
ENV_MODEL = [-200 -200 -200  500;   % L1: x0, y0, x1, y1
             -200  500  600  500;
              600  500  600 -200;
              600 -200 -200 -200;
              200  250  200  350;   % L5: x0, y0, x1, y1
              200  350  300  350;
              300  350  300  250;
              300  250  200  250;
              350    0  350  100;   % L9: x0, y0, x1, y1
              350  100  450  100;
              450  100  450    0;
              450    0  350    0];
          
fig_env = figure; hold on;
    TMP = [ENV_MODEL(1:4,1:2); ENV_MODEL(1,1:2)];
    plot(TMP(:,1), TMP(:,2), 'k');
    TMP = [ENV_MODEL(5:8,1:2); ENV_MODEL(5,1:2)];
    plot(TMP(:,1), TMP(:,2), 'k');
    TMP = [ENV_MODEL(9:12,1:2); ENV_MODEL(9,1:2)];
    plot(TMP(:,1), TMP(:,2), 'k');
hold off;
          
% Vehicle constants
WHEEL_BASE = 53;            % [mm]
PULSE_PER_MM = 12.48;       % [pulse / mm]
GAMMA = [-45 45]*pi/180;

FREE = 1;
OBSTACLE = 2;
PATH = FREE;


% Sampling time
T = 0.50;
% Encoder resolutions
resL = 600;
resR = 600;
SIGMA_ENC = 0.5/12;

X(1) = 0; Y(1) = 0; A(1) = pi/2;
P(1,1:9) = [10^2 0 0 0 10^2 0 0 0 (1*pi/180)^2];
tX(1) = 0; tY(1) = 0; tA(1) = pi/2;

% Init encoders
[dL(1) dR(1)] = vehicle_setencoders(0, 0);
eL(1) = floor(dL(1));
eR(1) = floor(dR(1));

% Run the simulation
for kk = 2:500,
    % Velocities
    switch PATH
        case FREE       % Make the vehicle move forward
            wL = 110*pi/180;
            wR = 90*pi/180;
        case OBSTACLE   % Make the vehicle turn
            if randn < 0,
                wL = -70*pi/180;
                wR = 70*pi/180;
            else,
                wL = -70*pi/180;
                wR = 70*pi/180;
            end;
            PATH = FREE;
    end;            
    
    [dL(kk) dR(kk)] = vehicle_setspeed(wL, wR, dL(kk-1), dR(kk-1), T, resL, resR);
    eL(kk) = floor(dL(kk) + 75*randn);
    eR(kk) = floor(dR(kk) + 75*randn);
    
    % Relative movements
    ddL = (eL(kk) - eL(kk-1)) / PULSE_PER_MM;   % [mm]
    ddR = (eR(kk) - eR(kk-1)) / PULSE_PER_MM;   % [mm]
    
    dD = (ddR + ddL) / 2;
    dA = (ddR - ddL) / WHEEL_BASE;
    
    % Predict new position
    X(kk) = X(kk-1) + dD * cos(A(kk-1) + dA/2);
    Y(kk) = Y(kk-1) + dD * sin(A(kk-1) + dA/2);
    A(kk) = A(kk-1) + dA;
    
    % Predict new co-variance matrix
    Jxya = [1 0 -dD*sin(A(kk-1) + dA/2);
            0 1  dD*cos(A(kk-1) + dA/2);
            0 0  1];
    Jda = [cos(A(kk-1) + dA/2) -0.5*dD*sin(A(kk-1) + dA/2);
           sin(A(kk-1) + dA/2)  0.5*dD*cos(A(kk-1) + dA/2);
           0                    1];
    Cda = [SIGMA_ENC^2/2 0;0 2*SIGMA_ENC^2/WHEEL_BASE^2];
    
    OLD = [P(kk-1,1:3);P(kk-1,4:6);P(kk-1,7:9)];
    NEW = Jxya*OLD*Jxya' + Jda*Cda*Jda';
    P(kk,1:9) = [NEW(1,1:3) NEW(2,1:3) NEW(3,1:3)];
    
    
    
    
    % Calculate the 'TRUE' position of the vehicle
    % 'TRUE' Relative movements
    ddL = (dL(kk) - dL(kk-1)) / PULSE_PER_MM;   % [mm]
    ddR = (dR(kk) - dR(kk-1)) / PULSE_PER_MM;   % [mm]
    
    dD = (ddR + ddL) / 2;
    dA = (ddR - ddL) / WHEEL_BASE;

    tX(kk) = tX(kk-1) + dD * cos(A(kk-1) + dA/2);
    tY(kk) = tY(kk-1) + dD * sin(A(kk-1) + dA/2);
    tA(kk) = tA(kk-1) + dA;
    
    % Plot the Vehicle
    figure(fig_env); hold on;
        plot(tX(kk), tY(kk), 'k.');
        plot(X(kk), Y(kk), 'b.');
        pause(T/1000);
    hold off;
    
    
    
    % Assume the robot has an rotating laser sensor in the centre of the robot
    % Check for observations - which should be done every 1s, i.e. when 
    % mod(kk, (round(1/T)) == 0
    MaxRangeLS = 100;
    if mod(kk, round(1/T)) == 0,
        no_beacons = 0;
        % Observation is done - process them (we are only interested in corners)
        for beacon = 1:12,
            % Simulate beacon readings
            dist2 = (tX(kk) - ENV_MODEL(beacon,1))^2 + (tY(kk) - ENV_MODEL(beacon,2))^2;
            if dist2 <= MaxRangeLS^2,
                no_beacons = no_beacons + 1;
                BEACONS(no_beacons) = beacon;
                
                
                %%% ------------------------------------------------------ %%%
                %%%              ADD YOUR KALMAN FILTER HERE               %%%
                %%%                                                        %%%
                %%%  It should constrain the estimated positions by using  %%%
                %%%  the latest observation.                               %%%
                %%%                                                        %%%
                %%% ------------------------------------------------------ %%%                
                
                
                % Plot the observed beacon
                figure(fig_env); hold on; 
                    plot([tX(kk) ENV_MODEL(beacon,1)]', [tY(kk) ENV_MODEL(beacon,2)]', 'r');
                hold off;
            end;
        end;
    end;
    
    
    
    % Check sensors for detecting obstacles - Assumed to be in the centre of the robot
    MaxRangeUS = 55;
    for sensor = 1:2,
        xL(sensor) = tX(kk) + MaxRangeUS*cos(tA(kk) + GAMMA(sensor));
        yL(sensor) = tY(kk) + MaxRangeUS*sin(tA(kk) + GAMMA(sensor));
    end;
    for ll = 1:12,
        [c1 s1 t1] = Crossing(ENV_MODEL(ll,1), ENV_MODEL(ll,2), ENV_MODEL(ll,3), ENV_MODEL(ll,4), tX(kk), tY(kk), xL(1), yL(1));
        if c1,
            PATH = OBSTACLE;
            break;
        end;
        [c2 s2 t2] = Crossing(ENV_MODEL(ll,1), ENV_MODEL(ll,2), ENV_MODEL(ll,3), ENV_MODEL(ll,4), tX(kk), tY(kk), xL(2), yL(2));
        if c2,
            PATH = OBSTACLE;
            break;
        end;
    end;
end;

% Plot path and estimated uncertainties
figure; hold on;
    % Plot the path
    plot(tX, tY, 'k');
    plot(X, Y, 'b:');
    legend('True positions', 'Estimated positions');
    
    % Plot the environment
    TMP = [ENV_MODEL(1:4,1:2); ENV_MODEL(1,1:2)];
    plot(TMP(:,1), TMP(:,2), 'k');
    TMP = [ENV_MODEL(5:8,1:2); ENV_MODEL(5,1:2)];
    plot(TMP(:,1), TMP(:,2), 'k');
    TMP = [ENV_MODEL(9:12,1:2); ENV_MODEL(9,1:2)];
    plot(TMP(:,1), TMP(:,2), 'k');
    
    % Plot the uncertainties
    [N tmp] = size(P);
    for kk = 1:10:N,
        [x1 x2] = mahal_ellipse([P(kk,1:3);P(kk,4:6);P(kk,7:9)], 1, 2, 1, 10);
        plot(x1+X(kk), x2+Y(kk), 'b:');
    end;
hold off;
