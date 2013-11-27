% part of the image analysis course at Halmstad university
% Authors: Stefan Karlsson and Josef Bigun, copyright 2012

function edgeIm = DoEdgeStrength(dx,dy,gradInd)
% function DoEdgeStrength inputs images, dx, dy, corresponding to the
% 2D gradients of an image slice in a video feed (a frame).

if nargin <3
    gradInd = 1;
end

% TODO: estimate the strength of edges 
%%% should not be zeros
edgeIm = zeros(size(dx,1),size(dx,2));