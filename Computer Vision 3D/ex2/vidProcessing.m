% Authors:
% Stefan M. Karlsson AND Josef Bigun 
function [dx, dy, dt, gradInd, U1, V1] = vidProcessing(movieType, method, bFineScale,nofTimeSlices,spdFactor, lagTime)
% quick usage:
% vidProcessing(); - displays a sequence of test images
% vidProcessing(movieType); - same as above, but on video source indicated by the
% argument. movieType can be:
% 'synthetic' - generates a synthetic video on the fly
% 'camera' - generates video through a connected camera (requires image acquisition toolbox)
% 'cameraX' - where X is number indicating which of system cameras to use
% (default is 1). This is to be input into the string, such as e.g.: 
%         vidProcessing('camera1','edge');
% filename - name of video file in the current folder.
% example: vidProcessing('lipVid.avi'); - assumes an avi file is in the current folder
%
% explicit usage:
% [dx,dy,dt] = vidProcessing(movieType);
% Output dx, dy and dt are all WxH matrices containing the x, y, and t 
% partial derivatives over time. 
% W and H are the height and width of the video
%
% [dx,dy,dt] = vidProcessing(movieType, method); displays the same sequence, but
% with a method selected for analyzing the sequence.
% Valid options for 'method' are:
% - "LK"      (Lukas and Kanade)
% - "NOTHING" ([default] zero fields)
%
% There are 2 special aditional options for 'method', both of which 
% will not give flow output:
% - "gradient"    Displays the gradient values
% - "edge"        Displays the 2D edge detection
% 
% [dx,dy,dt] = vidProcessing('synthetic', method,spdFactor); 
% additionally sets a speed factor (spdFactor) to change the speed of the
% synthetic video generation (if spdFactor=2, then the synthetic sequence 
% is twice as fast)
% final argument "lagTime" is an optional additional lag-time in seconds,
% added as a pause between each frame updates

%ensure access to functions and scripts in the folder "helperFunctions"
addpath('helperFunctions');
global g; %contains shared information, ugly solution, but the fastest

ParseAndSetupScript; %script for parsing input and setup environment

% index variable for time:
t=1;

%from this point on, we handle the video by the object 'vid'. This is how
%we get the first frame:
curIm = generateFrame(vid, t,kindOfMovie,g.spdFactor,g.arrowKey);
% gradient calculations of the subvolume will be handled by the mex module 
% "Grad2D". It has a local copy internally of the previous frame, 
% which we initialize now
dy = grad3Dm(curIm,bFineScale,1);

dx = zeros([size(dy),nofTimeSlices],'single');
dt = zeros([size(dy),nofTimeSlices],'single');
dy = zeros([size(dy),nofTimeSlices],'single');

% "bleedOffTerm" is to be used on dx dy dt, so that older values are scaled
% down. This is essentially using a IIR filter in the temporal direction
% The coeffecients of bleedOffTerm are picked so that they will be 100%
% equivalent to a gaussian FIR filtering in the t direction (half a gaussian 
% actually)
bleedOffTerm = getIIRcoefs(nofTimeSlices);

targetFramerate = 25; %for displaying only

while 1 %%%%%% MAIN LOOP, runs until user shuts down the figure  %%%%%
    tic; %time each loop iteration;
    t=t+1;
    curIm = generateFrame(vid, t,kindOfMovie,g.spdFactor,g.arrowKey);
    gradInd = mod(t,nofTimeSlices)+1;
    %implement the bleed off. Gaussian like behaviour:
    for tOffset = 1:(nofTimeSlices-1)
     gradIndOffset = mod(t-tOffset,nofTimeSlices)+1;
%      save
     dy(:,:,gradIndOffset) = dy(:,:,gradIndOffset).*bleedOffTerm(tOffset+1);
     dx(:,:,gradIndOffset) = dx(:,:,gradIndOffset).*bleedOffTerm(tOffset+1);
     dt(:,:,gradIndOffset) = dt(:,:,gradIndOffset).*bleedOffTerm(tOffset+1);
    end

    [dy(:,:,gradInd), dx(:,:,gradInd), dt(:,:,gradInd)] = grad3Dm(curIm,bFineScale);

    switch method
        case 'edge'
            edgeIm = DoEdgeStrength(dx,dy,gradInd);
        case 'gradient'%do nothing, gradient already given
        otherwise %flow methods
            [U1, V1,U2,V2] = DoFlow(dx,dy,dt,method);
     end

    % first run is t==2, then setup graphics based on method and size of data 
    if t == 2,  
        setupGraphicsScript; 
    end

    if ishandle(figH)%check if the figure is still open
        updateGraphicsScript;
    else%user has killed the main figure, break the loop and exit
        break;
    end
    % Pause to achieve target framerate, with some added lag time:
    timeToSpare = max(0, (1/targetFramerate) - toc + g.lagTime); 
    pause( timeToSpare + 0.000001 ); 

end  %%%%%%% END MAIN LOOP  %%%%%%%%%

% Clean up:
cleanUpScript;
