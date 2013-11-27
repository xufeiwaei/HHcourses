% Sample : Capture images from a camera
function sample()

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
t = zeros(1,4);
for frame = 1:max_frame
    tic;
    vi_is_frame_new(VI, device_id);
    t(1) = t(1) + toc; tic;
    img = vi_get_pixels(VI, device_id);
    t(2) = t(2) + toc; tic;
    set(hnd_img, 'CData', img); 
    t(3) = t(3) + toc; tic;
    drawnow;
    t(4) = t(4) + toc;
end
t = t / max_frame;
fprintf(1, 'vi_is_frame_new: %f (msec)\n', t(1) * 1000);
fprintf(1, 'vi_get_pixels  : %f (msec)\n', t(2) * 1000);
fprintf(1, 'set            : %f (msec)\n', t(3) * 1000);
fprintf(1, 'drawnow        : %f (msec)\n', t(4) * 1000);
fprintf(1, 'total          : %f (msec)\n', sum(t) * 1000);

%------------------------------------
% Release memory
%------------------------------------
vi_stop_device(VI, device_id);
vi_delete(VI);

end