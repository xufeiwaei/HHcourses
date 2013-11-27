% sample
% Pan and tilt camera mechanically
% 2010.05.19 yohara
%
% *************************************************************************
% [Name]
% qcam_mechanical_pan_tilt
% 
% [Function]
% Does mechanical pan and tilt 
% 
% It's available only for a camera with pan and tilt control, like QCam OrbitAF.
% 
% [Usage]
% mxQCamMechanicalPanTilt(pan, tilt)
% 
% [Arguments]
% pan
% Pan angle (degree)
% positive values are clockwise rotation (seen from the top),
% negative values are counter-clockwise rotation.
% 
% tilt
% Tilt angle (degree)
% positive values are downwards, negative values are upwards.

clear all; close all; clc;

%% Parameter
pan = 5; % pan(deg). 
tilt = 5; % tilt (deg).

%% Run
qcam_mechanical_pan_tilt(pan, tilt); % pan, tilt
qcam_mechanical_pan_tilt(-pan, -tilt); % back to the original position 
