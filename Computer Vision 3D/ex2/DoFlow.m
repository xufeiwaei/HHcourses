% part of the image analysis course at Halmstad university
% Authors: Stefan Karlsson and Josef Bigun, copyright 2012

function [U1, V1, U2, V2] = DoFlow(dx,dy,dt,method,gradInd)
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

if nargin<5
    gradInd = 1;
end
if nargin<4
%%% possibilities for 'method' are:  %%
%     method = 'LK';      %% Lucas Kanade
%     method = 'TS';      %% 3D structure tensor
%     method = 'BONUS';  %% If you feel inclined to implement your own
    method = 'NOTHING';  %% Do nothing, i.e. return zeros
end

      flowRes = 20; %resolution of the flow field in the image

      %     MOMENT CALCULATIONS
      gaussStd = 2; % for tensor smoothing.
      gg  = gaussgen(gaussStd); %% filter for tensor smoothing

%     moment m200, calculated in three steps explicitly
%     1) make elementwise product, AND sum in the temporal direction:
      momentIm = sum(dx.^2,3);
     
%     2) smooth with large seperable gaussian filter (spatial integration)
      momentIm = conv2(gg,gg,momentIm,'same');

%     3) downsample to specified resolution (imresizeNN function is found in "helperFunctions"):     
      m200 =  imresizeNN(momentIm ,[flowRes flowRes]);

%    The remaining moments are calculated in EXACTLY the same way as above, condensed to one liners:
 m020=imresizeNN(conv2(gg,gg, sum(dy.^2 ,3),'same'),[flowRes flowRes]);
%TODO: fill in the missing moments(should not be zero):
 m002=imresizeNN(conv2(gg,gg, sum(dt.^2 ,3),'same'),[flowRes flowRes]);
 m110=imresizeNN(conv2(gg,gg, sum(dx.*dy,3),'same'),[flowRes flowRes]);
 m101=imresizeNN(conv2(gg,gg, sum(dx.*dt,3),'same'),[flowRes flowRes]);
 m011=imresizeNN(conv2(gg,gg, sum(dy.*dt,3),'same'),[flowRes flowRes]);

 %initialize the two fields to zero:
 U1 = zeros(size(m200));
 V1 = zeros(size(m200));
 U2 = zeros(size(m200));
 V2 = zeros(size(m200));
 % Thresholds:
GAMMA=0.7;
EPSILONLK = 0.00000001;  
EPSILONTS = 0.0000000001; 

if strcmpi(method,'LK')
%%%%%%%%%%%%%% flow by the Lucas and Kanade algorithm  %%%%%%%%%% 
  for x=1:size(m011,1)
    for y=1:size(m011,2)
        %%%TODO: build the 2D structure tensor, call it S2D!
        %%% (here you can assume that m20 = m200, m02 = m020)
        %%% you have access to the elements as m200(x,y), m020(x,y) and m110(x,y)
        %%% (it should NOT be the identity matrix, enter the correct)
        S2D  = [1, 0;...
                0, 1];

        %%%%check that S2D is invertible :
        if(det(S2D)>EPSILONLK)
            %%%%%TODO form the vector 'DTd')
            %%%%% (it should NOT be the zero vector)
            b = [0;...
                 0];
            %%%% TODO finally, calculate the velocity vector by the relation 
            %%%% between vector b, and matrix S2D (2D structure tensor)
            %%%% (it should NOT be the zero vector)
            v = [0;...
                 0];
            U1(x,y) = v(1);
            V1(x,y) = v(2);
        end
    end
  end
elseif strcmpi(method,'TS')
%%%%%%%%%%%%%% flow by the structure tensor algorithm  %%%%%%%%%% 
 for x=1:size(m011,1)
    for y=1:size(m011,2)
    %%%TODO build the 3D structure tensor, call it S3D:
    %%%(it should NOT be the identity matrix)
    S3D =  [m200(x,y), m110(x,y), m101(x,y);...
            m110(x,y), m020(x,y), m011(x,y);...
            m101(x,y), m011(x,y), m002(x,y)];

    % Compute the eigenvalues
	[eigenvects, eigenvals]=eig(S3D);
	eigenvals=diag(eigenvals);

	% And sort them. eigenvals(1) is the smallest; eigenvals(3)
	% is the largest. You can use index to access the corresponding
	% eigenvectors; for instance eigenvects(:,index(3)) is the
	% eigenvector associated to the largest eigenvalue.
	[eigenvals, index]=sort(eigenvals);   

	sumeig=sum(eigenvals); 
    %%% We only proceed if we are in a spatio temporal region with
    %%% variation. The sum of the eigenvalues tell us this
    %%% (if we are in a constant region, sumeig=0 and we skip it):
	if sumeig >EPSILONTS	
        % TODO: check for the case of single spatial orientation and
        % motion (motion of lines). Should NOT be [(0) > GAMMA]
        if (eigenvals(3)-eigenvals(2))/(eigenvals(3) + eigenvals(2)) > GAMMA
			% In this case we have spatial orientation and
			% constant motion. 
			% Only one eigenvalue is different from zero;
			% the corresponding eigenvector gives us the
			% normal velocity according to Eq. (13.59)
			e=eigenvects(:,index(3)); % largest eigenvalue
			denom=(e(1)^2+e(2)^2);
			if denom>EPSILONTS
                %TODO: write the expression for the motion of lines:
                    U1(x,y)=- e(3)*e(1)/denom;
                    V1(x,y)=- e(3)*e(2)/denom;
			end
        else
        % TODO check for distributed spatial structure and motion:
%         Should NOT be [(0) > GAMMA]
        if (eigenvals(2)-eigenvals(1))/(eigenvals(2)+eigenvals(1)) > GAMMA
	     	e=eigenvects(:,index(1)); % smallest eigenvalue
            if e(3)>EPSILONTS
                %TODO: write the expression for the motion of points:
                        U2(x,y)=e(1)/(e(3));
                        V2(x,y)=e(2)/(e(3));
            end
	     else
            % Distributed spatial structure and
            % non-constant motion. We do nothing in this case
         end
        end
	end %if sumeig
    end % for x
 end
elseif strcmpi(method,'LKimproved')
    
%%%%%%%%%(BONUS) experiment with your own ideas %%%%%%%%%% 
%%%% as an example, here is a more efficient implementation of Lukas and
%%%% Kanade with "regularization" using a tikhinov constant(uncomment below)

% %%%%%%%%%%%%%% Parallell and regularized Lukas Kanade: %%%%%%%%%%     
%%%% this introduces stability to linear motions. It does not let
%%%% you label the motions as 'point' or 'line' as the structure tensor
%%%% does however. This method is faster too:

% TikConst = 100; 
% m200 = (m200 + TikConst);
% m020 = (m020 + TikConst);
% tensDet = (m020.*m200 - m110.^2);
% U1 =(-m101.*m020 + m011.*m110)./tensDet;
% V1 =( m101.*m110 - m011.*m200)./tensDet;

elseif strcmpi(method,'NOTHING')
    return;
else %then a method string we dont recognize => Error
    error(['undefined method "' method '". Choose from "LK", "TS", "BONUS", or "NOTHING".']);
end
