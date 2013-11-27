% part of the image analysis course at Halmstad university
% Authors: Stefan Karlsson and Josef Bigun, copyright 2012

function edgeIm = DoEdgeStrength(dx,dy,gradInd)
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


% TODO: estimate the strength of edges 
%%% should not be zeros
%  edgeIm = zeros(size(dx,1),size(dx,2));
 %edgeIm = sum(sqrt(dx(:,:,gradInd).^2 + dy(:,:,gradInd).^2),3);
 edgeIm = sum(sqrt(dx.^2 + dy.^2),3);

