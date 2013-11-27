%
% Calculates the difference between the two angles A1 [rad] and A2 [rad]
% A1 and A2 can be row-vectors [Nx1] or scalars [1x1]
%
function [EA] = AngDifference(A1, A2)
    EA = (A1-A2) + ((A1-A2) < -pi)*(2*pi) + ((A1-A2) > pi)*(-2*pi);