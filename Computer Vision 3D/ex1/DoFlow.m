% Authors:
% Stefan M. Karlsson AND Josef Bigun 

function [U1, V1] = DoFlow(dx,dy,dt,method)
% function DoFlow inputs 3D volume images, dx, dy, dt, corresponding to the
% 3D gradients in an image volume.
% the dimensions are
% [height, width, T] =size(dx)=size(dy)=size(dt)
% where T is the time interval in which the video is considered for optical
% flow calculation
%
% for example, the 2D gradient in the video, at the current frame is found by:
% [dx(:,:,gradInd), dy(:,:,gradInd)];
% 

if nargin<4
%%% possibilities for 'method' are:  %%
     method = 'LK';         %% Lucas Kanade
    %method = 'NOTHING';      %% Do nothing, i.e. return zeros
end

flowRes = 20; %resolution of the flow field in the image

%     MOMENT CALCULATIONS
      gaussStd = 1.5; % for tensor smoothing.
      gg  = gaussgen(gaussStd); %% filter for tensor smoothing

%     moment m200, calculated in three steps explicitly
%     1) make elementwise product, and sum along time direction (time integration):
      momentIm = dx.^2;
     
%     2) smooth with large seperable gaussian filter (spatial integration)
      momentIm = conv2(gg',gg,momentIm);

%     3) downsample to specified resolution:     
      m200 =  imresizeNN(momentIm ,[flowRes flowRes]);

%    The remaining moments are calculated in EXACTLY the same way as above, condensed to one liners:
 m020=imresizeNN(conv2(gg',gg, dy.^2),[flowRes flowRes]);
%TODO: fill in the missing moments(should not be zero):
 m110=imresizeNN(conv2(gg',gg, dx.*dy),[flowRes flowRes]);
 m101=imresizeNN(conv2(gg',gg, dx.*dt),[flowRes flowRes]);
 m011=imresizeNN(conv2(gg',gg, dy.*dt),[flowRes flowRes]);
%initialize the two fields to zero:
 U1 = zeros(size(m200));
 V1 = U1;

if strcmpi(method,'LK')

  % Thresholds:
EPSILONLK = 0.00001;

 
%%%%%%%%%%%%%% flow by the Lucas and Kanade algorithm  %%%%%%%%%% 
%%%%% this is a traditional, explicit way of estimating flow. It suffers
%%%%% from the problems of numerical instability and slow implementation.
%%%%% never use this implementation for anything but educational purposes
%%%%% instead, see the next method "LKimproved"
  for x=1:size(m011,1)
    for y=1:size(m011,2)
        %%%build the 2D structure tensor
        %%%TODO: build the 2D structure tensor, call it S2D!
        %%% (here you can assume that m20 = m200, m02 = m020)
        %%% you have access to the elements as m200(x,y), m020(x,y) and m110(x,y)
        %%% (it should NOT be the identity matrix, enter the correct)
        S2D  = [m200(x,y), m110(x,y);...
                m110(x,y), m020(x,y)];

        %%%%check that S2D is invertible :
        if(det(S2D)>EPSILONLK)
            %%%%%TODO form the vector 'DTd')
            %%%%% (it should NOT be the zero vector)
            b = [m101(x,y);...
                 m011(x,y)];
            %%%% TODO finally, calculate the velocity vector by the relation 
            %%%% between vector b, and matrix S2D (2D structure tensor)
            %%%% (it should NOT be the zero vector)
            v = -(S2D)\b; % Hint: the "\" operator is more efficient than actually doing inverse;            U1(x,y) = v(1);
            U1(x,y) = v(1);
            V1(x,y) = v(2);
        end
    end
  end
end