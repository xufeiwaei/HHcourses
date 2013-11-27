% *************************************************************************
% [Name]
% vi_set_video_setting
% 
% [Function]
% Sets camera parameters
% 
% [Usage]
% vi_set_video_setting(VI, device_id, propertyKey, value, autoFlag)
% 
% [Arguments]
% VI
% VideoInput object
% 
% device_id
% Device ID
% (device_id starts from 0)
% 
% propertyKey
% The property type to be set
% 
% value
% setting value
% 
% autoFlag
% if autoFlag=true, the default value is used or defined automatically.
% 
% propertyKey = 1
% Brightness 
% (from 0 to 1)
% 
% propertyKey = 2
% Contrast
% (from 0 to 1)
% 
% propertyKey = 3
% Hue
% (from 0 to 1)
% [Disabled for QCam OrbitAF, Webcam Pro 9000]
% 
% propertyKey = 4
% Saturation
% (from 0 to 1)
% 
% propertyKey = 5
% Sharpness 
% (from 0 to 1)
% 
% propertyKey = 6
% Gamma
% (from 0 to 1)
% [Unavailable for QCam OrbitAF, Webcam Pro 9000]
% 
% propertyKey = 7
% Enabled color setting
% 0 : OFF, 1 : ON 
% [Unavailable for QCam OrbitAF, Webcam Pro 9000]
% 
% propertyKey = 8
% White balance
% (from 0 to 1)
% 
% propertyKey = 9
% Enabled the back light compensation 
% 0 : OFF, 1 : ON 
% [Unavailable for QCam OrbitAF, Webcam Pro 9000]
% 
% propertyKey = 10
% Gain
% (from 0 to 1)
% 
% propertyKey = 11
% Exposure
% (from 0 to 1)
% 
% [Return]
% 
% 
% [Sample]
% sample_setting_video_property.m
% 
