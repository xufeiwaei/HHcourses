% Computes intrinsic and extrinsic camera parameters
% (See Bigun, Vision with Direction Sections 13.1-3
%
% (C) F. Smeraldi, Oct 4th 2000
% Modified by M. Persson, Feb 2nd 2006
% Modified by J. Bigun, Nov. 2011
%%%%%%%%%%%%%%%%%%%%%%%%%%
% The code is to be completed by the student as appropriate.
%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(1);imshow('cal_points.gif');
figure(2);imshow('s7img1.gif');
%im=imread('images/s7img1.gif');


% Number of points used for calibration
NPOINTS=14;

% World coordinates of the points marked in the image - row vects
% (X, Y, Z) (The origin is the lower leftmost corner of the stairs, marked as 
% point 1 in cal_points.gif illustrates)
%

worldcoords= [   0,  0   ,   0 ; 	% point  1
		 0,  10.08,   0;	% point  2
		5.04, 10.08, 8.73;	% point  3
		5.04, 20.16, 8.73; 	% point  4
		10.08, 20.16, 17.46; 	% point  5
		10.08, 30.24, 17.46;	% point  6
	      	-120.38,  0,    69.50;	% point  7
		-120.38, 10.08, 69.50; 	% point  8
		-115.34, 10.08, 78.23; 	% point  9
		-115.34, 20.16, 78.23;	% point 10
		-110.30, 20.16, 86.96; 	% point 11
		-110.30, 30.24, 86.96; 	% point 12
		-59.33,  0, 175.23; 	% point 13
		-59.33, 120.2, 175.23]; % point 14


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Find the image coordinates of these points on image S7img1.gif, using
% appropriate tools, e.g.  ginput or impixel. Use the matlab help if you
% dont know how to use them.  Store image coordinates in imagecoords as row vectors:
% imagecoords = [x1 y1;
%		 x2 y2;
%		 .....;
%		 ......];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% pl=[]; pr=[];
% for k=1:NPOINTS
% % Left image
% figure(1); %put focus on the left image for clicking...
% onepl= ginput(1);
%     pl= [pl
%         onepl 1 
%      ];
% text(pl(k,1),pl(k,2),['* ' num2str(k)],'FontSize',10,'color','r'); %OPTIONAL visualize what you clicked
%  
%  
% % Right image
% figure(2); %put focus on the right image  for clicking...
% onepr= ginput(1);
%     pr= [pr
%         onepr 1 %%%
%      ];
% text(pr(k,1),pr(k,2),['* ' num2str(k)],'FontSize',10,'color','g'); %OPTIONAL visualize what you clicked
%      
% end
% 

imagecoords=   [
   384.6875e+000   431.4375e+000 %obtained via ginput on a zoomed version of the image
   384.4375e+000   412.8125e+000
   400.4375e+000   412.5625e+000
   400.4375e+000   394.5625e+000
   415.3125e+000   393.5625e+000
   415.4375e+000   375.8125e+000
   541.4375e+000   474.6875e+000
   541.4375e+000   452.1875e+000
   559.4375e+000   450.5625e+000
   559.5625e+000   428.3125e+000
   577.4375e+000   427.4375e+000   
     577.4375e+000   405.3125e+000
      735.6875e+000   450.8125e+000
735.3125e+000   217.5625e+000
%
% 384.0000e+000   432.0000e+000   
%  384.0000e+000   413.0000e+000     
%  400.0000e+000   412.0000e+000    
%    401.0000e+000   394.0000e+000      
%    416.0000e+000   393.0000e+000 
%    415.0000e+000   376.0000e+000 
%      542.0000e+000   475.0000e+000
%    541.0000e+000   453.0000e+000
%    559.0000e+000   451.0000e+000
%    559.0000e+000   428.0000e+000
%    577.0000e+000   427.0000e+000
%     577.0000e+000   405.0000e+000
% 736.0000e+000   451.0000e+000
%   735.0000e+000   217.0000e+000
  ];

%imagecoords(:,2)=size(im,1)-imagecoords(:,2);

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % In order to minimize numerical errors problems, subtract
% % from the image points the coordinates of their centroid.
% % Then normalize the centered points by dividing them by
% % the maximum of imagecoords (computed after subtracting the
% % centroid).
% %%%%%%%%%%%%%%%%%%%%%%%%%%%
% cn=mean(imagecoords);
% mx=max(max(abs(imagecoords)));
% cnmat=ones(NPOINTS,1)*cn;
% 
% imagecoords=imagecoords-cnmat;
% imagecoords=imagecoords/mx;



% %Now put together the  matrix B,  by juxtaposing wh,  zblock, cblock and
% rblock appropriately into a single matrix.
wh=[worldcoords ones(NPOINTS,1)]; 
zblock=zeros(NPOINTS,4);
cblock=(imagecoords(:,1)*ones(1,4)) .*wh;
rblock=(imagecoords(:,2)*ones(1,4)) .*wh;
B=[
    wh zblock  -cblock
    zblock wh  -rblock
];


%%%%%%%%%%%%%%%%%%%%%%%%%%
% Find the projection matrix M by computing the SVD of B.
% Look at Eq. 13.61 and 13.62 in Bigun's book and the 
% explanation. Note howvector m is formed by rearranging the
% components of M into a column vector (Eq 13.53).
%%%%%%%%%%%%%%%%%%%%%%%%%%

[U,S,V]=svd(B);
m= V(:,12); %collect the unknown from svd decomposition of B as a vector.
M= reshape(m,4,3)'; %reshape it to a 3x

%Notice that the norm of m is always 1 because it is an "eigen" vector.
%This means that m as well as gamma*m are solutions for the equation B*m=0, 
%not just the particular m that is returned by svd and has the norm 1. 
%The factor gamma can be recovered from two facts. 
%1) We know that the vector M(3,1:3) is a row in a rotation (orthogonal)
%matrix, so that its norm is 1. This gives the magnitude of gamma.
%2)To recover the sign of gamma we use the common sense that the object, 
%to which world-frame is attached, is in front of the camera 
%(otherwise it will not be visible to the camera). This means the world-frame origin 
%as seen in  the camera frame must be at a point 
%that has positive Z component. The latter is by definition t_Z  and
%equals to M(3,4). Using these two facts we recover next,  M from the scaling effect of
%gamma.

gamma=sign(M(3,4))*norm(M(3,1:3));
M=M/gamma;

%%%%%%%%%%%%%%%%%%%%%%%
% Compute  
% the camera intrinsic parameters fx, fy, c0, r0
q1=M(1,1:3)';q2=M(2,1:3)';q3=M(3,1:3)';
c0= q1'*q3;
r0= q2'*q3;
fx= sqrt(q1'*q1-c0^2);
fy= sqrt(q2'*q2-r0^2);
MI=[-fx  0   c0
    0   -fy  r0
    0    0   1
];
%Compute the extrinsic camera parameters R and t
%by remembering that M=MI*ME

ME= inv(MI)*M;
R= ME(:,1:3)%This takes a vector in world coordinates to camera coordinates.
t= ME(:,4) %t is in camera coordinates. 
            
tw= -R'*t %t in world coordinates is -R'*t

% Before you output the intrinsic matrix, you have to
% compensate for the normalization of imagecoords, if you applied any.
% Do this by multiplying [fx, fy] and [c0, r0] by the normalization
% factor by which you divided the coordinate values. Also, add to
% [c0, r0] the coordinates of the centroid.
% Note the typo error in the equations on page 291, cx and cy should be c0
% and r0 respectively.
%%%%%%%%%%%%%%%%%%%%%%%
% MI(1:2,:)=MI(1:2,:)*mx;
% MI(1,3)=MI(1,3)+cn(1);
% MI(2,3)=MI(2,3)+cn(2);

MI

%Optional assignment: Refine R via SVD.
%ideally a rotation matrix has 1 as singular values. We
%force the singular values to be 1 and reconstruct R via
%svd. The reconstructed R, called RR,  has for sure orthogonal
%columns, whereas there is no guarantee that R has orthogonal columns.