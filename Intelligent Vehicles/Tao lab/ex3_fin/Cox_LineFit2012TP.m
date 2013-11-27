% Fits (by translation and rotation) data points to a set of 
% line segments, i.e. applying the Cox's algorithm
% function [ddx,ddy,dda,C] = Cox_LineFit(ANG, DIS, POSE, LINEMODEL)
% (ANG, DIS) ([1xN], [1xN]) contains the pair of values obtained from laser sensor.
function [ddx,ddy,dda,C] = Cox_LineFit2012TP(ANG, DIS, POSE, LINEMODEL, SensorPose)
    % Init variables
    ddx = 0; ddy = 0; dda = 0;
	% State variables.
    X = POSE(1,1); Y = POSE(2,1); Theta = POSE(3,1);
    x_offset = SensorPose(1);
    y_offset = SensorPose(2);
    alpha = SensorPose(3);
    max_iterations = 15;
    no_update = 0;
	% To test whether this image point is an outlier. Unit is [mm]
	% TODO reasonable value.
    DISTANCE_THRESHOLD = 1000;
    % 0) Normal vectors (length = 1) to the line segments
    [noLines tmp] = size(LINEMODEL);
    for kk = 1:noLines,
		% Rotate pi/2 to get orthogonal vector.
        R = [0 -1;1 0];
		% LINEMODEL [x1 y1 x2 y2]
		% Two points on this line.
		v = [LINEMODEL(kk, 1:2)];
		u = [LINEMODEL(kk, 3:4)];
		V = R*(u-v)';
		V = V';
		U(kk, 1:2) = V / sqrt(dot(V, V));
		RI(kk, 1) = dot(U(kk, 1:2), v);
    end;
    
    % World coordinate [N x 2]; N is the number of image points
    imagePoints = zeros(size(DIS, 2), 2);
    distance = zeros(size(DIS'));
	% This one doesn't contain outliers: realDistance
    target = zeros(size(DIS'));
	B = zeros(3, 1);
    % REPEAT UNTIL THE PROCESS CONVERGE
    for iteration = 1:max_iterations,
        % Coordinate transform
        for i = 1:size(imagePoints,1)
            % 1.1) Relative measurements => Sensor co-ordinates
            x = DIS(i)*cos(ANG(i));
            y = DIS(i)*cos(ANG(i));
            % 1.2) Sensor co-ordinates => Robot co-ordinates
            R = [cos(alpha) -sin(alpha) x_offset; ...
                sin(alpha) cos(alpha) y_offset; ...
                0 0 1];
            % Sensor coordinate
            Xs = R*[x y 1]';
            % 1.3) Robot co-ordinates => World co-ordinates
            R = [cos(Theta) -sin(Theta) Xs(1); ...
                sin(Theta) cos(Theta) Xs(2); ...
                0 0 1];
            tmp = R*[X Y 1]';
            imagePoints(i, 1:2) = tmp(1:2,:)';
        end
		% Get average value along row dimension. [1 x 2]
        imagePoints_mean = mean(imagePoints, 1);
        % Translate and rotate data points
        imagePoints_new = zeros(size(imagePoints));
        for i = 1:size(imagePoints,1)
            imagePoints_new(i, 1:2) = [B(1,1) B(2,1)] + ...
                (B(3,1) * [0 -1;1 0] ...
                * (imagePoints(i, :) - imagePoints_mean)')' ...
                + imagePoints(i, :);
        end
        imagePoints = imagePoints_new;
        imagePoints_mean = mean(imagePoints, 1);
        % 2) -------------- Find targets for data points
        for i = 1:size(imagePoints,1)
            distanceToEachLine = zeros(size(U,1),1);
            for j = 1:noLines
                distanceToEachLine(j)= abs(RI(j) - ...
						abs(dot(U(j, :), imagePoints(i, :))));
            end
            [distance(i) target(i)] = min(distanceToEachLine);
            if distance(i) > DISTANCE_THRESHOLD;
				% Mark this point as outlier.
               distance(i) = -1;
            end
        end

        % Set up linear equation system, 
		j = 1;
		for i = 1:size(distance, 1)
			if distance(i) >= 0
				realDistance(j, 1) = distance(i);
				X1(j) = U(target(i),1);
				X2(j) = U(target(i),2);
				X3(j) = U(target(i), :) * [0 -1; 1 0] ...
						* (imagePoints(i) - imagePoints_mean)';
				j = j+1;
			end
		end
		A = [X1; X2; X3];
		% [imagePoints.row x 3]
		A = A';
		% Note you have to handle situations then det(A'*A) == 0
		% TODO How? When will this happend?
		B = inv(A'*A)*A'*realDistance;
		% Calculate the variance of the fit!
		% TODO why substract 4?
		variance = dot(realDistance - A*B, realDistance -A*B) ...
			/(size(realDistance,1)-4);
		C = variance * inv(A'*A);

		% Add latest contribution to the overall congruence
		ddx = ddx + B(1,1);
		ddy = ddy + B(2,1);
		dda = dda + B(3,1);

		% Check if the process has converged
		if ( sqrt(B(1,1)^2 + B(2,1)^2) < 5 ...
			&& (abs(B(3,1) < 0.1*pi/180)) )
			break;
		end
	end;
	% Check if max number off iterations is reached, i.e. no congurance!
	if iteration == max_iterations
		ddx = 0;
		ddy = 0;
		dda = 0;
		C(1) = -1;
	end
