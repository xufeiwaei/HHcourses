%
% Checks if two lines cross each other, the lines are determined by the
% follwoing parameters:
%
% x0, y0: start of line segement 0
% x1, y1: end of line segement 0
% x2, y2: start of line segement 1
% x3, y3: end of line segment 1
%
function [c, s, t] = Crossing(x0, y0, x1, y1, x2, y2, x3, y3)
    % Calculate crossing parameters (t and s)
    if (((y3-y2)*(x1-x0) - (x3-x2)*(y1-y0)) == 0) | ((x1 - x0) == 0),
        % Rotate around x0, y0
        alfa = 45*pi/180;
        R = [cos(alfa) -sin(alfa);
             sin(alfa)  cos(alfa)];
         
        Z = R*([x1 y1]' - [x0 y0]') + [x0 y0]'; x1 = Z(1,1); y1 = Z(2,1);
        Z = R*([x2 y2]' - [x0 y0]') + [x0 y0]'; x2 = Z(1,1); y2 = Z(2,1);
        Z = R*([x3 y3]' - [x0 y0]') + [x0 y0]'; x3 = Z(1,1); y3 = Z(2,1);
    end;

    t = ((y0-y3)*(x1-x0) + (x3-x0)*(y1-y0)) / ((y3-y2)*(x1-x0) - (x3-x2)*(y1-y0));
    s = (x3 - x0 + t*(x3 - x2)) / (x1 - x0);

    % Rules for determining crosses
    c = (s >= 0) & (s <= 1) & (t <= 0) & (t >= -1);

    % For DEBUG only
    %if c,
    %    str = sprintf('Crossing');
    %else,
    %    str = sprintf('Not Crossing');
    %end;
    %disp(str);
