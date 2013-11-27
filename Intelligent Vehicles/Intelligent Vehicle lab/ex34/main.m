%
% Main script that reads controller data and laser data
%
clear all;
close all;
clc;

% showing the error or not
showing_error = 0;
showing_laser_error  = 0;
showing_kalman_error = 0;

% whether to use the result from Kalman Filter to actually update the
% position of the robot or not
using_kalman_fiter = 1;

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
fig_env_match = figure;
if showing_error
    fig_error_analysis = figure;
end

% Plot the line model
figure(fig_env); plot_line_segments(REF, LINES, 1);

% Calculate all unit vectors of all lines
line_coordinates1 = REF(LINES(:,1),1:2);
line_coordinates2 = REF(LINES(:,2),1:2);
Li = line_coordinates2;
line_slope = (line_coordinates2(:,2)-line_coordinates1(:,2))./(line_coordinates2(:,1)-line_coordinates1(:,1));
unit_vector_slope = -1./line_slope(:,1);
ui = [sqrt(1./((unit_vector_slope(:,1)).^2+1)) , unit_vector_slope(:,1).*sqrt(1./((unit_vector_slope(:,1)).^2+1))];
for k=1:size(ui,1)
    ri(k)=dot(ui(k,:),Li(k,:));
end
LINEMODEL = [line_coordinates1 line_coordinates2 ui ri'];

% Uncertaity Initialization
L = 680;
P(1,1:9) = [1 0 0 0 1 0 0 0 (1*pi/180)^2];
syms x y theta alpha T_period velocity
F = [ x+velocity*cos(alpha)*T_period*cos(theta+(velocity*sin(alpha)*T_period)/(2*L))
      y+velocity*cos(alpha)*T_period*sin(theta+(velocity*sin(alpha)*T_period)/(2*L))
      theta+velocity*sin(alpha)*T_period/L];
F_vaT = jacobian(F, [velocity, alpha, T_period]);
F_xyt = jacobian(F, [x, y, theta]);
Cu = [10 0 0; 0 0.01 0; 0 0 0.000001];   % Uncertainty in the input variables [3x3]

% Predication Error Initialize
if showing_error
    ERROR_predication = [X(1) Y(1) A(1)] - CONTROL(1,4:6);
    ERROR_predication(1,3) = AngDifference(A(1),CONTROL(1,6));
    ERROR_predication = abs(ERROR_predication);
    figure(fig_error_analysis);
    subplot(3,1,1);
    hold on;plot(1,ERROR_predication(1,1),'b');
    hold on;plot(1,sqrt(P(:,1)),'r'); 
    title('X(mm): Predication (E-blue, U-red); Laser (E-pink, U-black); Kalman (E-green, U-cyan)');
    subplot(3,1,2);
    hold on;plot(1,ERROR_predication(1,2),'b');
    hold on;plot(1,sqrt(P(:,5)),'r'); 
    title('Y(mm): Predication (E-blue, U-red); Laser (E-pink, U-black); Kalman (E-green, U-cyan)');
    subplot(3,1,3);
    hold on;plot(1,ERROR_predication(1,3)*180/pi,'b');
    hold on;plot(1,sqrt(P(:,9))*180/pi,'r'); 
    title('A(degree): Predication (E-blue, U-red); Laser (E-pink, U-black); Kalman (E-green, U-cyan)');
end

for kk = 2:no_inputs,
    % Check if we should get a position fix, i.e. if the time stamp of the
    % next laser scan is the same as the time stamp of the control input
    % values
    if LD_HEAD(scan_idx,1) == CONTROL(kk,1),
        % Mark the position where the position fix is done - and the size
        % of the position fix to be found
        figure(fig_path);
%         hold on; plot(X(kk-1), Y(kk-1), 'ro'); hold off;
        hold on; plot_uncertainty_blue([X(kk-1) Y(kk-1) A(kk-1)]', Cxya_new, 1, 2); hold off;
        hold on; plot(CONTROL(kk-1,4), CONTROL(kk-1,5), 'ro'); hold off;
        hold on; plot([X(kk-1) CONTROL(kk-1,4)], [Y(kk-1) CONTROL(kk-1,5)], 'b'); hold off;
        
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
        plot_threewheeled_Laser([X(kk-1) Y(kk-1) A(kk-1)]', 100, 612, 2, CONTROL(kk-1,5), 150, 50, 680, alfa, beta, gamma, angs, meas, 1);
        
        % YOU SHOULD WRITE YOUR CODE HERE ....
        % Call the function [dx dy da C] = Cox_LineFit(angs, meas, [X(kk-1) Y(kk-1) A(kk-1)]', LINEMODEL)
        % => Position fix + Unceratinty of the position fix
        
        scan_idx
        
        disp('Matching...');
        % [dx dy da C match_result interation_time final_sample_quantity] = Cox_LineFit(angs, meas, [X(kk-1) Y(kk-1) A(kk-1)]', [alfa beta gamma]', ui, ri);
        [dx dy da C iteration_time final_sample_quantity finished_flag Dis_threshold S2] = Cox_LineFit_ultimate(angs, meas, [X(kk-1) Y(kk-1) A(kk-1)]', [alfa beta gamma]', LINEMODEL, fig_env_match, REF, LINES);
        
        % Kalman Filter Combination
        X_kalman(1:3,scan_idx) = C * inv(C + Cxya_new) * [X(kk-1) Y(kk-1) A(kk-1)]' + Cxya_new * inv(C + Cxya_new) * [X(kk-1)+dx Y(kk-1)+dy A(kk-1)+da]';
        X_kalman(4,scan_idx) = kk-1;
        C_kalman = inv(inv(C)+inv(Cxya_new));
        C_kalman_whole(scan_idx,1:9) = [C_kalman(1,1:3) C_kalman(2,1:3) C_kalman(3,1:3)];
        
        Laser_Fixed_Uncertainty(scan_idx,1:9) = [C(1,1:3) C(2,1:3) C(3,1:3)];
        
        match_performance(scan_idx,1) = dx;
        match_performance(scan_idx,2) = dy;
        match_performance(scan_idx,3) = da;
        match_performance(scan_idx,4) = iteration_time;
        match_performance(scan_idx,5) = final_sample_quantity;
        match_performance(scan_idx,6) = Dis_threshold;
        match_performance(scan_idx,7) = S2;
        match_performance(scan_idx,8) = finished_flag;
        
        X_laser(1:3,scan_idx) = [X(kk-1)+dx Y(kk-1)+dy A(kk-1)+da];
        X_laser(4,scan_idx) = kk-1;
        
        % ... AND HERE ...
        % Update the position, i.e. X(kk-1), Y(kk-1), A(kk-1) and C(kk-1)
        if finished_flag
            figure(fig_path);
            hold on; plot(X(kk-1)+dx , Y(kk-1)+dy, 'm*');
            plot([X(kk-1)+dx CONTROL(kk-1,4)], [Y(kk-1)+dy CONTROL(kk-1,5)], 'm');
            plot_uncertainty_pink([X(kk-1)+dx Y(kk-1)+dy A(kk-1)+da]', C, 1, 2);
        else
            figure(fig_path);
            hold on; plot(X(kk-1)+dx , Y(kk-1)+dy, 'mx');
            plot([X(kk-1)+dx CONTROL(kk-1,4)], [Y(kk-1)+dy CONTROL(kk-1,5)], 'm');
            plot_uncertainty_pink([X(kk-1)+dx Y(kk-1)+dy A(kk-1)+da]', C, 1, 2);
        end
        
        figure(fig_path);hold on;
        plot(X_kalman(1,scan_idx), X_kalman(2,scan_idx), 'g.');
        plot([X_kalman(1,scan_idx) CONTROL(kk-1,4)], [X_kalman(2,scan_idx) CONTROL(kk-1,5)], 'g');
        plot_uncertainty_green(X_kalman(:,scan_idx), C_kalman, 1, 2);
        
        % Use the Kalman Filter fixed position to continue
        if using_kalman_fiter
            X(kk-1) = X_kalman(1,scan_idx); 
            Y(kk-1) = X_kalman(2,scan_idx); 
            A(kk-1) = X_kalman(3,scan_idx);
            
            P(kk-1,1:9) = [C_kalman(1,1:3) C_kalman(2,1:3) C_kalman(3,1:3)];
        end
        
        % Next time use the next scan
        scan_idx = mod(scan_idx, max(size(LD_HEAD))) + 1;
        
        if showing_error
            if scan_idx == 1
                scan_idx = 48;
            end
            % plot the Laser Error
            if showing_laser_error
                figure(fig_error_analysis);hold on;
                Error_Laser(scan_idx-1,1) = X(kk-1) + dx - CONTROL(kk-1,4);
                Error_Laser(scan_idx-1,2) = Y(kk-1) + dy - CONTROL(kk-1,5);
                Error_Laser(scan_idx-1,3) = AngDifference(A(kk-1) + da,CONTROL(kk,6));
                Error_Laser = abs(Error_Laser);

                subplot(3,1,1);
                hold on; plot(kk-1,Error_Laser(scan_idx-1,1),'m.');
                % connect the points
                if scan_idx > 2
                    plot([kk-1 X_kalman(4,scan_idx-2)],[Error_Laser(scan_idx-1,1) Error_Laser(scan_idx-2,1)],'m:'); 
                end
                hold on; plot(kk-1,sqrt(Laser_Fixed_Uncertainty(scan_idx-1,1)),'k.');
                % connect the points
                if scan_idx > 2
                    plot([kk-1 X_kalman(4,scan_idx-2)],[sqrt(Laser_Fixed_Uncertainty(scan_idx-1,1)) sqrt(Laser_Fixed_Uncertainty(scan_idx-2,1))],'k:'); 
                end

                subplot(3,1,2);
                hold on; plot(kk-1,Error_Laser(scan_idx-1,2),'m.');
                % connect the points
                if scan_idx > 2
                    plot([kk-1 X_kalman(4,scan_idx-2)],[Error_Laser(scan_idx-1,2) Error_Laser(scan_idx-2,2)],'m:'); 
                end
                hold on; plot(kk-1,sqrt(Laser_Fixed_Uncertainty(scan_idx-1,5)),'k.');
                % connect the points
                if scan_idx > 2
                    plot([kk-1 X_kalman(4,scan_idx-2)],[sqrt(Laser_Fixed_Uncertainty(scan_idx-1,5)) sqrt(Laser_Fixed_Uncertainty(scan_idx-2,5))],'k:'); 
                end

                subplot(3,1,3);
                hold on; plot(kk-1,Error_Laser(scan_idx-1,3)*180/pi,'m.');
                % connect the points
                if scan_idx > 2
                    plot([kk-1 X_kalman(4,scan_idx-2)],[Error_Laser(scan_idx-1,3)*180/pi Error_Laser(scan_idx-2,3)*180/pi],'m:'); 
                end
                hold on; plot(kk-1,sqrt(Laser_Fixed_Uncertainty(scan_idx-1,9))*180/pi,'k.');
                % connect the points
                if scan_idx > 2
                    plot([kk-1 X_kalman(4,scan_idx-2)],[sqrt(Laser_Fixed_Uncertainty(scan_idx-1,9))*180/pi sqrt(Laser_Fixed_Uncertainty(scan_idx-2,9))*180/pi],'k:'); 
                end
            end

            % plot Kalman Filter Error
            if showing_kalman_error
                figure(fig_error_analysis);hold on;
                Error_Kalman(scan_idx-1,1) = X_kalman(1,scan_idx-1) - CONTROL(kk-1,4);
                Error_Kalman(scan_idx-1,2) = X_kalman(2,scan_idx-1) - CONTROL(kk-1,5);
                Error_Kalman(scan_idx-1,3) = AngDifference(X_kalman(3,scan_idx-1),CONTROL(kk,6));
                Error_Kalman = abs(Error_Kalman);
                subplot(3,1,1);
                hold on; plot(kk-1,Error_Kalman(scan_idx-1,1),'g.');
                % connect the points
                if scan_idx > 2
                    plot([kk-1 X_kalman(4,scan_idx-2)],[Error_Kalman(scan_idx-1,1) Error_Kalman(scan_idx-2,1)],'g:'); 
                end
                hold on; plot(kk-1,sqrt(C_kalman_whole(scan_idx-1,1)),'c.');
                if scan_idx > 2
                    plot([kk-1 X_kalman(4,scan_idx-2)],[sqrt(C_kalman_whole(scan_idx-1,1)) sqrt(C_kalman_whole(scan_idx-2,1))],'c:'); 
                end
                subplot(3,1,2);
                hold on; plot(kk-1,Error_Kalman(scan_idx-1,2),'g.');
                % connect the points
                if scan_idx > 2
                    plot([kk-1 X_kalman(4,scan_idx-2)],[Error_Kalman(scan_idx-1,2) Error_Kalman(scan_idx-2,2)],'g:'); 
                end
                hold on; plot(kk-1,sqrt(C_kalman_whole(scan_idx-1,5)),'c.');
                if scan_idx > 2
                    plot([kk-1 X_kalman(4,scan_idx-2)],[sqrt(C_kalman_whole(scan_idx-1,5)) sqrt(C_kalman_whole(scan_idx-2,5))],'c:'); 
                end
                subplot(3,1,3);
                hold on; plot(kk-1,Error_Kalman(scan_idx-1,3)*180/pi,'g.');
                % connect the points
                if scan_idx > 2
                    plot([kk-1 X_kalman(4,scan_idx-2)],[Error_Kalman(scan_idx-1,3)*180/pi Error_Kalman(scan_idx-2,3)*180/pi],'g:'); 
                end
                hold on; plot(kk-1,sqrt(C_kalman_whole(scan_idx-1,9))*180/pi,'c.');
                if scan_idx > 2
                    plot([kk-1 X_kalman(4,scan_idx-2)],[sqrt(C_kalman_whole(scan_idx-1,9))*180/pi sqrt(C_kalman_whole(scan_idx-2,9))*180/pi],'c:'); 
                end
            end
            if scan_idx == 48
                scan_idx = 1;
            end
        end
    end;
    
    % Mark the estimated (dead reckoning) position
    figure(fig_path);
    hold on; plot(X(kk-1), Y(kk-1), 'b.'); hold off;
    % Mark the true (from the LaserWay system) position
    hold on; plot(CONTROL(kk-1,4), CONTROL(kk-1,5), 'k.'); hold off;
    % Mark the Kalman Filter Combination position
%     hold on; plot(X_kalman(1,kk-1), X_kalman(2,kk-1), 'g.'); hold off;
    
    % Estimate the new position (based on the control inputs) and new
    % uncertainty
    v = CONTROL(kk-1,2);
    a = CONTROL(kk-1,3);
    T = 0.050;
    % L = 680;

    X(kk) = X(kk-1) + cos(a)*v*cos(A(kk-1))*T;
    Y(kk) = Y(kk-1) + cos(a)*v*sin(A(kk-1))*T;
    A(kk) = mod(A(kk-1) + sin(a)*v*T/L , 2*pi);
    
    % Uncertainty Calculation
    Cxya_old = [P(kk-1,1:3);P(kk-1,4:6);P(kk-1,7:9)];   % Uncertainty in state variables at time k-1 [3x3]
    Axya = subs(F_xyt,{theta,velocity,T_period,alpha},{A(kk),v,T,a});    % Jacobian matrix w.r.t. X, Y and A [3x3]
    Au =subs(F_vaT,{theta,velocity,T_period,alpha},{A(kk),v,T,a}); % Jacobian matrix w.r.t. v, a and T_period [3x3]
    
    Cxya_new = Axya*Cxya_old*Axya' + Au*Cu*Au';
    P(kk,1:9) = [Cxya_new(1,1:3) Cxya_new(2,1:3) Cxya_new(3,1:3)];
    % ALSO UPDATE THE UNCERTAINTY OF THE POSITION
    
    % Uncertainty Plot
    % plot_uncertainty([X(kk) Y(kk) A(kk)]', Cxya_new, 1, 2);
    
    if showing_error
        % plot the predication error
        figure(fig_error_analysis);
        ERROR_predication(kk,:) = [X(kk) Y(kk) A(kk)] - CONTROL(kk,4:6);
        ERROR_predication(kk,3) = AngDifference(A(kk),CONTROL(kk,6));
        ERROR_predication = abs(ERROR_predication);
        subplot(3,1,1);
        hold on; plot(kk,ERROR_predication(kk,1),'b');
        hold on; plot(kk,sqrt(P(kk,1)),'r'); % one sigma

        subplot(3,1,2);
        hold on; plot(kk,ERROR_predication(kk,2),'b');
        hold on; plot(kk,sqrt(P(kk,5)),'r'); % one sigma

        subplot(3,1,3);
        hold on; plot(kk,ERROR_predication(kk,3)*180/pi,'b');
        hold on; plot(kk,sqrt(P(kk,9))*180/pi,'r'); % one sigma
    end
end;



