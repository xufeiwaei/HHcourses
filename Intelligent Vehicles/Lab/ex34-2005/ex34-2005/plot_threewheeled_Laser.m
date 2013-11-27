%
%   plot_threewheeled_laser(X, wdr, wbr, wtr, SteerA, wdf, wtf, L, alfa, beta, gamma, ANGLES, MEAS, view_meas)
%
% Plots the Snowhite robot (in the figure currently active) at position
%
% Robot model parameters:
% -------------------------------------------------------------------------
% X:        [3x1] position vector (x, y, a)
% wdr:      [Scalar] Wheel diameter  (Rear wheels)
% wbr:      [Scalar] Wheel base      (Rear wheels)
% wtr:      [Scalar] Wheel thickness (Rear wheels)
% SteerA:   [Scalar] Steering angle  (Front wheel)
% wdf:      [Scalar] Wheel diameter  (Front wheel)
% wtf:      [Scalar] Wheel thickness (Front wheel)
% L:        [Scalar] Distance between rear and front wheel axis
%
% Sensor model parameters:
% -------------------------------------------------------------------------
% alfa:         [Scalar] Offset between sensors centre and robots x-axis
% beta:         [Scalar] Offset between sensors centre and robots y-axis
% gamma:        [Scalar] Heading offset between sensors and robots x-axis
% ANGLES:       [Nx1] Vector containing the measurements headings (given in 
%               the sensors co-ordinate system)
% MEAS:         [Nx1] Vector containing the measured distances
% view_meas:    [Scalar] Boolean value: 
%                   0 = Don't view measurements
%                   1 = View measurements
%
% The function sleeps for 0.1ms to make sure the figure is actually
% plotted.
%
function plot_threewheeled_laser(X, wdr, wbr, wtr, SteerA, wdf, wtf, L, alfa, beta, gamma, ANGLES, MEAS, view_meas)
    % Three Wheeled Robot (2 rear wheels + Co-ordinate axis and Front wheel
    % + Co-ordinate ax)
    SW = [0 + wdr/2, wbr/2 - wtr/2;     % 1: Left wheel
          0 + wdr/2, wbr/2 + wtr/2;     % 2
          0 - wdr/2, wbr/2 + wtr/2;     % 3
          0 - wdr/2, wbr/2 - wtr/2;     % 4
          0 + wdr/2, -wbr/2 - wtr/2;    % 5: Right wheel
          0 + wdr/2, -wbr/2 + wtr/2;    % 6
          0 - wdr/2, -wbr/2 + wtr/2;    % 7
          0 - wdr/2, -wbr/2 - wtr/2;    % 8
          -1.2*wdr/2, 0;                % 9: Co-ordinate axis (Robot X)
          1.2*wdr/2, 0;                 % 10
          0, -1.2*wbr/2;                % 11: Co-ordinate axis (Robot Y)
          0, 1.2*wbr/2;                 % 12
          wdf/2, -wtf/2;                % 13: Front wheel (Drawn in origin)
          wdf/2, wtf/2;                 % 14
          -wdf/2, wtf/2;                % 15
          -wdf/2, -wtf/2;               % 16
          -1.2*wdf/2, 0;                % 17: Co-ordinate axis (Front wheel)
          1.2*wdf/2, 0;                 % 18
          0, 0;                         % 19: Centre of Laser sensor
          77.5, -93.6;                  % 20: Laser sensor (Drawn in origin)
          77.5, 54.9;                   % 21
          0, 64.6;                      % 22
          -77.5, 54.9;                  % 23
          -77.5, -93.6]';               % 24
    
    % Laser data
    LD(1,:) = MEAS.*cos(ANGLES);
    LD(2,:) = MEAS.*sin(ANGLES);
    no_ld = max(size(ANGLES));
      
    % Change the position of the Laser sensor
    R = [cos(gamma) -sin(gamma);
         sin(gamma) cos(gamma)];
    
    T(1,1:6) = alfa;
    T(2,1:6) = beta;
    
    SW(1:2,19:24) = R*SW(1:2,19:24) + T;
    T(1,1:no_ld) = alfa;
    T(2,1:no_ld) = beta; LD(1:2,:) = R*LD(1:2,:) + T; clear T;   % Laser data
      
    % Change the position of the Front Wheel (Rotation and Translation)
    R = [cos(SteerA) -sin(SteerA);
         sin(SteerA) cos(SteerA)];
    
    T(1,1:6) = L;
    T(2,1:6) = 0;    
    SW(1:2,13:18) = R*SW(1:2,13:18) + T;
    
    % Change to new co-ordinate system - Rotate and Translate
    R = [cos(X(3,1)) -sin(X(3,1));
         sin(X(3,1)) cos(X(3,1))];
    
    T(1,1:24) = X(1,1);
    T(2,1:24) = X(2,1);
    SWn(1:2,1:24) = R*SW(1:2,1:24) + T;
    T(1,1:no_ld) = X(1,1);
    T(2,1:no_ld) = X(2,1); LD(1:2,:) = R*LD(1:2,:) + T; clear T;   % Laser data
    
    % Plot the Snowhite
    hold on;
        % Left Wheel
        tmp = [SWn(1:2,1:4) SWn(1:2,1)];
        plot(tmp(1,:), tmp(2,:), 'r-');
        
        % Right Wheel
        tmp = [SWn(1:2,5:8) SWn(1:2,5)];
        plot(tmp(1,:), tmp(2,:), 'r-');
        
        % Co-ordinate system
        plot(SWn(1,9:10), SWn(2,9:10), 'k:');
        plot(SWn(1,11:12), SWn(2,11:12), 'k:');
        
        % Front Wheel
        tmp = [SWn(1:2,13:16) SWn(1:2,13)];
        plot(tmp(1,:), tmp(2,:), 'r-');
        
        % Co-ordinate ax
        plot(SWn(1,17:18), SWn(2,17:18), 'k:');
        
        % Laser Sensor
        tmp = [SWn(1:2,20:24) SWn(1:2,20)];
        plot(tmp(1,:), tmp(2,:), 'b-');
    hold off;
    
    % Plot the laser data
    if view_meas,
        hold on;
            plot(LD(1,:), LD(2,:), 'bx');
        hold off;
    end;
    
    pause(0.0001);