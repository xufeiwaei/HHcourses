%
% Set rotational speed of left and right wheels and returns the new encoder
% values after driving the robot for T seconds using the velocities (wL,
% wR)
%
function [eL, eR] = vehicle_setspeed(wL, wR, eL, eR, T, resL, resR)
    % Radians
    aL = wL * T;
    aR = wR * T;
    
    % Pulses per radian
    pprL = resL / (2*pi);
    pprR = resR / (2*pi);
    
    % Pulses
    deL = pprL * aL;
    deR = pprR * aR;
    
    % Encoder values
    eL = eL + deL;
    eR = eR + deR;