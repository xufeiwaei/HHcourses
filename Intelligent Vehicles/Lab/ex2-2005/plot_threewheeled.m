%
%   plot_threewheeled(X, wdr, wbr, wtr, SteerA, wdf, wtf, L)
%
% Plots the Snowhite robot (in the figure currently active) at position
% X:        [3x1] position vector (x, y, a)
% wdr:      Wheel diameter  (Rear wheels)
% wbr:      Wheel base      (Rear wheels)
% wtr:      Wheel thickness (Rear wheels)
% SteerA:   Steering angle  (Front wheel)
% wdf:      Wheel diameter  (Front wheel)
% wtf:      Wheel thickness (Front wheel)
% L:        Distance between rear and front wheel axis
%
% The function also sleeps for 1ms to make sure the figure is actually
% plotted.
%
function plot_threewheeled(X, wdr, wbr, wtr, SteerA, wdf, wtf, L)
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
          1.2*wdf/2, 0]';               % 18
    
    % Change the position of the Front Wheel (Rotation and Translation)
    R = [cos(SteerA) -sin(SteerA);
         sin(SteerA) cos(SteerA)];
    
    T = [L 0]';
    
    for kk=13:18,
        SW(1:2,kk) = R*SW(1:2,kk) + T;
    end;
    
    % Change to new co-ordinate system - Rotate and Translate
    R = [cos(X(3,1)) -sin(X(3,1));
         sin(X(3,1)) cos(X(3,1))];
    
    T = [X(1,1) X(2,1)]';
    
    for kk=1:18,
        SWn(1:2,kk) = R*SW(1:2,kk) + T;
    end;
    
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
    hold off;
    
    %pause(0.0001);