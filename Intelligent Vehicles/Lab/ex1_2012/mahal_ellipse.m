%   [X1,X2] = mahal_ellipse(C, row1, row2, r, no_points)
%
%	Calculates and returns the 2D Mahalanobis Ellipses for any Covariance Matrix, C:
%
%		row1 == 1, row2 == 2: First and Second Rows (X-Y)					  |X2 XY XR|
%		row1 == 1, row2 == 3: First and Third Rows  (X-R)	    assuming C == |XY Y2 YR|
%		row1 == 2, row2 == 3: Second and Third Rows (Y-R)					  |XR YR R2|
%
%		r is the Confidence Interval Factor, i.e.
%
%       r = 1       => (68.3%) Interval, i.e. 1 standard deviation
%		r = 1.2810	=> (90.0%) Interval
%		r = 1.6449	=> (95.0%) Interval
%		r = 1.9600	=> (97.5%) Interval
%		r = 2.3263	=> (99.0%) Interval
%		r = 2.5758	=> (99.5%) Interval
%
%       no_points: Number of points in the ellipse, typically 10 is enough
%
function [X1,X2] = mahal_ellipse(C, row1, row2, r, no_points)
    step = 2*r*sqrt(C(row1,row1))/no_points;	% The Ellipse is drawn from 1000 points.
    clear X1;
    clear X2;
   
    X1tmp = -r*sqrt(C(row1,row1)):step:r*sqrt(C(row1,row1));
    X2tmp(1,:) = (X1tmp*C(row1,row2) + sqrt((X1tmp.*X1tmp - r^2*C(row1,row1)) * (C(row1,row2)^2 - C(row1,row1)*C(row2,row2))))/C(row1,row1);
    X2tmp(2,:) = (X1tmp*C(row1,row2) - sqrt((X1tmp.*X1tmp - r^2*C(row1,row1)) * (C(row1,row2)^2 - C(row1,row1)*C(row2,row2))))/C(row1,row1);
   
    [ro co] = size(X1tmp);
    ms = max([ro co]);
   
    X1(1:ms) = X1tmp(1:ms);
    X1(ms+1:2*ms) = X1tmp(ms:-1:1);
   
    X2(1:ms) = X2tmp(1,1:ms);
    X2(ms+1:2*ms) = X2tmp(2,ms:-1:1);
   
    clear X1tmp;
    clear X2tmp;