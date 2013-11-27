%
% Main script that reads controller data and laser data
%
clear all;
close all;

T_value = 0.050;
L = 680;
syms x y theta
syms velocity alpha T
f = [
     x + velocity*cos(alpha)*T*cos(theta + velocity*sin(alpha)*T/(2*L))
     y + velocity*cos(alpha)*T*sin(theta + velocity*sin(alpha)*T/(2*L))
     theta + velocity*sin(alpha)*T/L
     ];
f_xytheta = jacobian(f, [x, y, theta]);
f_velocityalphaT = jacobian(f, [velocity, alpha, T]);


% Co-ordinates of the ref. nodes
REF = [1920 9470;   % 01
       10012 8179;  % 02
       9770 7590;   % 03
       11405 7228;  % 04
       11275 6451;  % 05
       11628 6384.5;% 06
       11438 4948;  % 07
       8140 8274;   % 08
       8392 8486;   % 09
       3280 2750;   % 10
       7250 2085;   % 11
       9990 1620;   % 12
       7485 3225;   % 13
       9505 3893;   % 14
       9602 4278;   % 15
       10412 4150;  % 16
       4090 7920;   % 17
       8010 5290;   % 18
       8255 6099;   % 19
       7733 6151;   % 20
       7490 6136;   % 21
       7061 5420;   % 22
       7634 5342];  % 23

% LINE SEGMENT MODEL (Indeces in the REF-vector)
LINES = [1 8;       % L01
         9 2;       % L02
         2 3;       % L03
         3 4;       % L04
         4 5;       % L05
         5 6;       % L06
         6 7;       % L07
         17 10;     % L08
         10 12;     % L09
         11 13;     % L10
         12 16;     % L11
         16 15;     % L12
         15 14;     % L13
         19 21;     % L14
         22 18;     % L15
         20 23];    % L16
         
% Control inputs (velocity and steering angle)
CONTROL = load('control_joy.txt');

% Laser data
LD_HEAD   = load('laser_header.txt');
LD_ANGLES = load('laser_angles.txt');
LD_MEASUR = load('laser_measurements.txt');
LD_FLAGS  = load('laser_flags.txt');

[no_inputs co] = size(CONTROL);

% Robots initial position
X(1) = CONTROL(1,4);
Y(1) = CONTROL(1,5);
A(1) = CONTROL(1,6);

scan_idx = 1;
fig_path = figure;
fig_env = figure;
fig_error = figure;

P(1,1:9) = [1 0 0 0 1 0 0 0 (1*pi/180)^2];
% Plot the line model
figure(fig_env); plot_line_segments(REF, LINES, 1);
% to access the data
LINEMODEL = [REF(LINES(:,1),1:2) REF(LINES(:,2),1:2)];
Cvat = [1 0 0; 0 (1*pi/180)^2 0; 0 0 0.001^2];
N = 300;

for kk = 2:no_inputs,
    % Check if we should get a position fix, i.e. if the time stamp of the
    % next laser scan is the same as the time stamp of the control input
    % values
    if LD_HEAD(scan_idx,1) == CONTROL(kk,1),
        % Mark the position where the position fix is done - and the size
        % of the position fix to be found
        figure(fig_path);
        hold on; plot(X(kk-1), Y(kk-1), 'ro'); hold off;
        hold on; plot(CONTROL(kk-1,4), CONTROL(kk-1,5), 'ro'); hold off;
        hold on; plot([X(kk-1) CONTROL(kk-1,4)], [Y(kk-1) CONTROL(kk-1,5)], 'r'); hold off;
        
        % Get the position fix - Use data points that are ok, i.e. with
        % flags = 0
        DATAPOINTS = find(LD_FLAGS(scan_idx,:) == 0);
        angs = LD_ANGLES(scan_idx, DATAPOINTS);
        meas = LD_MEASUR(scan_idx, DATAPOINTS);
        
        % Plot schematic picture of the Snowhite robot
        alfa = 660;
        beta = 0;
        gamma = -90*pi/180;
        figure(fig_env); plot_line_segments(REF, LINES, 1);
        plot_threewheeled_laser([X(kk-1) Y(kk-1) A(kk-1)]', 100, 612, 2, CONTROL(kk-1,5), 150, 50, 680, alfa, beta, gamma, angs, meas, 1);
        
        % YOU SHOULD WRITE YOUR CODE HERE ....
        [dx dy da C] = Cox_LineFit2012(angs, meas, [X(kk-1) Y(kk-1) A(kk-1)]', LINEMODEL, [660 0 -pi/2]);
        
        % Without sensor fusion. Just replace previous values with ones
		% obtained from this algorithm.
		X_estimated = X(kk-1) + dx;
		Y_estimated = Y(kk-1) + dy;
		A_estimated = A(kk-1) + da;
        % Update the position, i.e. X(kk-1), Y(kk-1), A(kk-1) and C(kk-1)
		if C(1) ~= -1
			X(kk-1) = X_estimated;
			Y(kk-1) = Y_estimated;
			A(kk-1) = A_estimated;
			C(kk-1) = C;
		end

        
        % Call the function [dx dy da C] = Cox_LineFit(angs, meas, [X(kk-1) Y(kk-1)
        % A(kk-1)]', LINEMODEL) => Position fix + Unceratinty of the
        % position fix
        
        % ... AND HERE ...
        % Update the position, i.e. X(kk-1), Y(kk-1), A(kk-1) and C(kk-1)
        
        % Next time use the next scan
        scan_idx = mod(scan_idx, max(size(LD_HEAD))) + 1;
    end;
    
    % Mark the estimated (dead reckoning) position
    figure(fig_path);
    hold on; plot(X(kk-1), Y(kk-1), 'b.'); hold off;
    % Mark the true (from the LaserWay system) position
    hold on; plot(CONTROL(kk-1,4), CONTROL(kk-1,5), 'k.'); hold off;
    
    % Estimate the new position (based on the control inputs) and new
    % uncertainty
    v = CONTROL(kk-1,2);
    a = CONTROL(kk-1,3);
    T = 0.050;
    L = 680;

    X(kk) = X(kk-1) + cos(a)*v*cos(A(kk-1))*T;
    Y(kk) = Y(kk-1) + cos(a)*v*sin(A(kk-1))*T;
    A(kk) = A(kk-1) + sin(a)*v*T/L;
    
    % ALSO UPDATE THE UNCERTAINTY OF THE POSITION
end;