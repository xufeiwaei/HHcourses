This folder contains mex files with the following features

	* Captures images from a camera using videoinput library
		* based on videoInput.lib, https://github.com/ofTheo/videoInput

	* Sets camera properties
		* based on DirectShow API,
		http://msdn.microsoft.com/en-us/library/ms783323.aspx

	* Pan and tilt a camera
		* based on DirectShow Pan/Tilt/Zoom sample for Logitech QuickCam devices,
		http://www.quickcamteam.net/documentation/how-to/how-to-control-pan-tilt-zoom-on-logitech-cameras
			

HOW TO SETUP:
1. Uncompress the downloaded file at the arbitrary folder where you want to put mex files.
2. Start up MATLAB, and run the follwoing command.
    >> edit startup.m
    (If you don't have startup.m at "MyDocuments\startup.m", 
	see MATLAB help, and create it.)
3. Add "addpath" command and set the path where you put the mex files.
    (About "addpath" command, see MATLAB help)
4. To make the change effective, restart MATLAB.
   Now, You can use our mex files after these setting. 

We provide the following files :
------------------------------------------------------------------------------------
* vi_create.mexw32 (for 32bit)
* vi_create.mexw64 (for 64bit)
	The function to create VideoInput object which is for capturing images from a camera

* vi_setup_devices.mexw32 (for 32bit)
* vi_setup_devices.mexw64 (for 64bit)
	The function to initialise to capture images from devices

* vi_delete.mexw32 (for 32bit)
* vi_delete.mexw64 (for 64bit)
	The function to delete VideoInput object

* vi_stop_devices.mexw32 (for 32bit)
* vi_stop_devices.mexw32 (for 64bit)
	The function to stop capturing images		
	
* vi_get_pixels.mexw32 (for 32bit)
* vi_get_pixels.mexw64 (for 64bit)
	The function to capture an image

* vi_is_frame_new.mexw32 (for 32bit)
* vi_is_frame_new.mexw64 (for 64bit)
	While this function runs, it keeps to wait 
	until the device is ready for capturing the next frame

* vi_list_devices.mexw32 (for 32bit)
* vi_list_devices.mexw64 (for 64bit)
	This function returns the number of available devices

* vi_set_video_setting.mexw32 (for 32bit)
* vi_set_video_setting.mexw64 (for 64bit)
	The function to set camera properties

* qcam_mechanical_pan_tilt.mexw32 (for 32bit)
* qcam_mechanical_pan_tilt.mexw64 (for 64bit)
	The function to pan and tilt a camera

* sample_vi.m
	The sample file to capture images from a camera

* sample_setting_video_property.m
	The sample file to set a given value to camera properties

* sample_qcam_mechanical_pan_tilt.m
	The sample file to pan and tilt a camera

* vi_create.m
* vi_delete.m
* vi_get_pixels.m and so on 
        Command help files. 
	For example, when you put the command,
	>> help vi_create
	you can see the explanation and usage of this command.
	They should be at the same folder which our providing mex files exist.

------------------------------------------------------------------------------------

MATLAB is registered trademarks of The MathWorks, Inc.

Please see www.mathworks.com/trademarks for a list of additional trademarks.
Other product or brand names may be trademarks or registered trademarks of their respective holders.

DirectShow is registered trademarks of Microsoft Corporation.
Microsoft Windows Sotfware Development Kit, Copyright (C) Microsoft Corporation. All rights reserved.
Please see http://www.microsoft.com/about/legal/en/us/intellectualproperty/trademarks/
Other product or brand names may be trademarks or 
registered trademarks of their respective holders.

Logitech QuickCam device, Copyright 2011 (c) Logitech. All Rights Reserved.
Logitech, QCam and QuickCam is registered trademarks of Logitech Inc.
Please see http://www.logitech.com/en-us/footer/terms-of-use
Other product or brand names may be trademarks or registered trademarks of 
their respective holders.
