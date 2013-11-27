% Authors:
% Stefan M. Karlsson AND Josef Bigun 

% Please reference the following publication
% Stefan M. Karlsson AND Josef Bigun, Lip-motion events analysis and lip segmentation using optical flow. CVPR Workshops 2012: 138-145)

function [edgeIm, angles] = DoEdgeStrength(dx,dy,gradInd)
% function DoEdgeStrength inputs 3D volume images, dx, dy, corresponding to the
% 2D gradients in an image volume.
% the dimensions are
% [height, width, T] =size(dx)=size(dy)
% where T is the time interval(in frames) in which the video is considered 
%
% for example, the 2D gradient in the video, at the current frame is found by:
% [dx(:,:,gradInd), dy(:,:,gradInd)];

if nargin <3
    gradInd = 1;
end

%%% at the current frame only (try this out if you are curious):
%  edgeIm = sqrt(dx(:,:,gradInd).^2+dy(:,:,gradInd).^2);

edgeIm = sum(sqrt(dx.^2+dy.^2),3)/size(dx,3);
if nargout > 1
    angles = atan2(sum(dy,3),sum(dx,3));
end
    
    