% Authors:
% Stefan M. Karlsson AND Josef Bigun 

% This script calls the function 'vidProcessing'. vidProcessing is our main
% entry point for all video processing. Once its called, a
% figure will open and display the video together with whatever else
% information we desire
% 
% Once you have finished viewing the results of the video processing,
% simply close the window to return back from the function. 

%%%%% argument 'movieType' %%%%%%%%
% This indicates the source of the video to process. You may choose from a
% synthetic video sequence(created on the fly), or load a video through a
% video file (such as 'LipVid.avi'), or to capture video from a connected
% camera(requires the image acquisition toolbox). 
%  movieType = 'LipVid.avi'; %assumes a file 'LipVid.avi' in current folder
%  movieType = 'camera'; %assumes a camera available in the system.
%  movieType = 'camera2'; %for any integer, use when choosing between several cameras
  movieType = 'synthetic'; %generate synthetic video
    
%%%%% argument 'method'      %%%%%%%%
%%%%%  optical flow method.  %%%%%%%
% method = 'LK';             %% traditional, explicit Lucas and Kanade
  method = 'TS';      %% 3D structure tensor
% method = 'nothing';      %% output zero fields
% method = 'LKimproved';   %% tikhinov-regularized Lucas and Kanade
%%% There are 2 other options for 'method', both of which                        %%% 
%%% will not give optical flow output, but are useful for testing(and fun):      %%%
% method = 'gradient';  %Displays the gradient values
% method = 'edge';      %Displays the 2D edge detection

%%%%% argument 'bFineScale' %%%%%%%%
%%% determines the scale of differentiation, fine scale otherwise a coarse 
%%% scale. coarse scale gives better stability to large motions, but at the
%%% cost of loosing fine scale information in the video. It determines the
%%% width and height of dx, dy, dt
bFineScale = 1;


%%%%% argument 'nofTimeSlices' %%%%%%%%
%%% the length of temporal integration. This tells how big our sub-volumes
%%% should be for calculations. This gives the depth of dx, dy and dt
nofTimeSlices = 4;


disp('Shut down figure to stop. DONT MINIMIZE AND ISSUE NEW COMMANDS IN MATLAB!');
[dx, dy, dt, gradInd] = vidProcessing(movieType, method, bFineScale,nofTimeSlices);
