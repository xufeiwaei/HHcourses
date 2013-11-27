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
im=imread('s7img1.gif');


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


imagecoords=   [
                       %FILL obtain imagecoords via ginput on a zoomed version of the image
  ];




% Now put together the  matrix B, block by block. 
% For this construct first sub-blocks of B as wh,  zblock, cblock and
% rblock appropriately into a single matrix.
wh=[worldcoords ones(NPOINTS,1)];  %world coordinates in homogeneous coordinates
cblock= (imagecoords(:,1)*ones(1,4)).*wh;% a block computed from wh and image-column coordinates
rblock= (imagecoords(:,2)*ones(1,4)).*wh;%a block computed from wh and image-row coordinates
zblock= [];                          % FILL a block consisting of zeros


B=[                 %FILL as appropriate using wh, zblock, cbolock, rblock. Mind the signs!!
];


%%%%%%%%%%%%%%%%%%%%%%%%%%
% Find the projection matrix M by computing the SVD of B.
% Look at Eq. 13.61 and 13.62 in Bigun's book and the 
% explanation. Note howvector m is formed by rearranging the
% components of M into a column vector (Eq 13.53).
%%%%%%%%%%%%%%%%%%%%%%%%%%
    
m=[]  %FILL...collect the m from svd decomposition of B as a vector.
M=[]  %FILL...reshape it to a 3x4 matrix. 

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

gamma=[ 1 ] %REPLACE [ 1 ] WITH THE CORRECT EXPRESSION 
M=M/gamma

%%%%%%%%%%%%%%%%%%%%%%%
% Compute  
% the camera intrinsic parameters fx, fy, c0, r0
% by taking scalar products between the (sub)rows of M

      %REPLACE [  ] WITH THE CORRECT EXPRESSION
c0= []
r0= []
fx= []
fy= []
MI=[% Fill in MI using c0,r0,fx,fy
    ]
%Compute the extrinsic camera parameters R and t
%by remembering that M=MI*ME

    %REPLACE [  ] WITH THE CORRECT EXPRESSION
ME=[]
R= [] %This takes a vector in world coordinates to camera coordinates.
t= [] %t is in camera coordinates. If you want to have it in 
            %world coordinates then it is -R'*t
            


%Optional assignment: Refine R via SVD.
%ideally a rotation matrix has 1 as singular values. We
%force the singular values to be 1 and reconstruct R via
%svd. The reconstructed R, called RR,  has for sure orthogonal
%columns, whereas there is no guarantee that R has orthogonal columns.



