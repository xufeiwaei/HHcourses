% Sample : Sets camera properties
function sample_setting_property()

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

propertyKey = 1;

autoFlag = false;

device_id = 0;
width     = 960;%720;
height    = 720;%480;
fps       = 30;

%------------------------------------
% Initialise
%------------------------------------
VI = vi_create();
numDevices = vi_list_devices(VI);
fprintf(1, '%d cameras detected.\n', numDevices);
vi_setup_device(VI, device_id, width, height, fps);

%------------------------------------
% Capture images
%------------------------------------
img = zeros(height, width, 3, 'uint8');
figure(1);
hnd_img = imshow(img);
drawnow;
max_frame = 100;
t = zeros(1,5);
for frame = 1:max_frame
    tic;
    vi_is_frame_new(VI, device_id);
    t(1) = t(1) + toc; tic;
    img = vi_get_pixels(VI, device_id);
    t(2) = t(2) + toc; tic;
    set(hnd_img, 'CData', img); 
    t(3) = t(3) + toc; tic;
    vi_set_video_setting(VI, device_id, propertyKey, frame/100, autoFlag);
    t(4) = t(4) + toc; tic;
    drawnow;
    t(5) = t(5) + toc;
end
t = t / max_frame;
fprintf(1, 'vi_is_frame_new: %f (msec)\n', t(1) * 1000);
fprintf(1, 'vi_get_pixels  : %f (msec)\n', t(2) * 1000);
fprintf(1, 'set            : %f (msec)\n', t(3) * 1000);
fprintf(1, 'drawnow        : %f (msec)\n', t(5) * 1000);
fprintf(1, 'total          : %f (msec)\n', sum(t) * 1000);

%------------------------------------
% Release memory
%------------------------------------
vi_stop_device(VI, device_id);
vi_delete(VI);

end