%
%   plot_khepera(X, wd, wb, wt)
%
% Plots the Khepera mini robot (in the figure currently active) at position
% X:    [3x1] position vector (x, y, a)
% wd:   Wheel diameter
% wb:   Wheel base
% wt:   Wheel thickness
%
% The function also sleeps for 1ms to make sure the figure is actually
% plotted.
%
function plot_khepera(X, wd, wb, wt)
    % Khepera Model (2 wheels + Co-ordinate axis) at origin
    KP = [0 - wd/2, wb/2 + wt/2;      % 1
          0 - wd/2, wb/2 - wt/2;      % 2
          0 + wd/2, wb/2 - wt/2;      % 3
          0 + wd/2, wb/2 + wt/2;      % 4
          0 - wd/2, -wb/2 + wt/2;     % 5
          0 - wd/2, -wb/2 - wt/2;     % 6
          0 + wd/2, -wb/2 - wt/2;     % 7
          0 + wd/2, -wb/2 + wt/2;     % 8
          -1.2*wd, 0;                 % 9
          1.2*wd, 0;                  % 10
          0, -1.2*wb/2;               % 11
          0, 1.2*wb/2]';              % 12
          
    
    % Change to new co-ordinate system - Rotate and Translate
    R = [cos(X(3,1)) -sin(X(3,1));
         sin(X(3,1)) cos(X(3,1))];
    
    T = [X(1,1) X(2,1)]';
    
    for kk=1:12,
        KPn(1:2,kk) = R*KP(1:2,kk) + T;
    end;
    
    % Plot the Khepera
    hold on;
        % Left Wheel
        tmp = [KPn(1:2,1:4) KPn(1:2,1)];
        plot(tmp(1,:), tmp(2,:), 'r-');
        
        % Right Wheel
        tmp = [KPn(1:2,5:8) KPn(1:2,5)];
        plot(tmp(1,:), tmp(2,:), 'r-');
        
        % Co-ordinate system
        plot(KPn(1,9:10), KPn(2,9:10), 'k:');
        plot(KPn(1,11:12), KPn(2,11:12), 'k:');
    hold off;
    
    %pause(0.0001);