% part of the image analysis course at Halmstad university
% Authors: Stefan Karlsson and Josef Bigun, copyright 2012

% This script calls the function 'vidProcessing'. vidProcessing is our main
% entry point for all video processing in this course. Once its called, a
% figure will open and display the video together with whatever else
% information we desire
% 
% Once you have finished viewing the results of the video processing,
% simply close the window to return back from the function. At that point,
% the datastructures dx, dy and dt are returned.
%
% dx, dy and dt make up the 3D gradient of the video. However, they are
% generally not 2D matrices, but 3D. That is to say, dx is going to be
% of some width and height, roughly equal to the width and height of the
% video, but dx will also have a depth. This depth will be equal to 
% "nofTimeSlices". At any single time in the video, we will have a dx, dy
% and dt, and the depth will correspond to how far back in time we wish to
% incorporate information, in order to estimate something at the given
% time.

%%%%% argument 'movieType' %%%%%%%%
% This indicates the source of the video to process. You may choose from a
% synthetic video sequence(created on the fly), or load a video through a
% video file (such as 'LipVid.avi'), or to capture video from a connected
% camera. 
movieType = 'synthetic';
% movieType = 'LipVid.avi';
% movieType = 'camera';

%%%%% argument 'method'      %%%%%%%%
%%%%%  optical flow method.  %%%%%%%
method = 'LK';      %(Lucas and Kanade)
% method = 'bonus';   %(implement your own ideas) 
% method = 'nothing';
%%% There are 2 special options for 'method', both of which %%% 
%%% will not give flow output:                              %%%
% method = 'gradient';  %Displays the gradient values
% method = 'edge';      %Displays the 2D edge detection

%%%%% argument 'spdFactor' %%%%%%%%
%%%% a variable to modify the speed of the motion in the synthetic sequence.
%%%% It is ignored unless movieType = 'synthetic'
spdFactor = 1;

%%%%% argument 'bFineScale' %%%%%%%%
%%% determines the scale of differentiation, fine scale otherwise a coarse 
%%% scale. coarse scale gives better stability to large motions, but at the
%%% cost of loosing fine scale information in the video. It determines the
%%% width and height of dx, dy, dt
bFineScale = 1;

[dx, dy, dt] = vidProcessing(movieType, method, spdFactor, bFineScale);

