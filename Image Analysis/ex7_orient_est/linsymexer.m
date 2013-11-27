function  [LS]=linsym(inim,std,scaling)
% $Id: linsym.m,v 1.3 2000/03/22 09:40:12 josef Exp $
% (C) Josef Bigun
%           [LS,rgbim]=linsym(inim,std,scaling)
%Computes the linear symmetry (LS) in local neighborhoods. The components of LS are also 
%known as "orientation tensor", "structure tensor", "dense orientation vectors",
%..etc. Also a corner detection scheme can be implemented by using the errors.
%The details of the theory is given in 
%@InProceedings{bigun87london,
%  author =       "J. Bigun and G. H. Granlund",
%  title =        "Optimal Orientation Detection of Linear Symmetry",
%  year =         "1987",
%  booktitle =    "First International Conference on Computer Vision, {ICCV}
%                 (London)",
%  publisher =    "IEEE Computer Society Press",
%  address =      "Washington, DC.",
%  month = {June 8--11},
%  pages =        "433--438",
%                   }
%
%LS is a three dimensional matrix. It consists of  three 2-D matrices that represent the local 
%orientation as well as two error measures of the local orientation fitting.  
%The first component,  LS(:,:,1) is  2*angle where angle is the inclination 
%angle of the fit orientation wrt which a linear symmetry exists. The second component LS(:,:,2) is 
%is Lambda_{worst} -Lambda_{best} that represents the difference of the total errors when 
%worst and best orientations are fit to the local neighborhood. The third component LS(:,:,3) 
%is the sum  of the best and worst total errors, Lambda_{worst} +Lambda_{best}.
%The best fit orientation and the worst fit orientations are always orthogonal to each 
%other, so that it is not necessary to compute the worst orientation explicitly. 
%
%The difference LS(:,:,3)-LS(:,:,2) grows as the local neighborhood has less linear symmetry,
%a measure that can be used to detect corners.
%
%This function can be called with 1, 2 or 3 input arguments as:
%linsym(inim), linsym(inim,std) or linsym(inim,std,scaling).
% The default values of the omitted arguments are
%      std=[0.8, 2.5];
%      scaling='sclon';
%
%See also lsdisp to display LS.

sma1=0.8; sma2=2.5; scl='sclon'; PI=atan(1)*4;
if (1 < nargin) 
   sma1=std(1); sma2=std(2);
end

if (2<nargin) 
   scl=scaling;
end
%generate 4 1-D derivative filters
dx=gaussgen(sma1,'dxg',[1,round(sma1*6)]);
dy=-dx'; %The y coordinate should increase upwards!
gx=gaussgen(sma1,'gau',[1,round(sma1*6)]);
gy=gx';
%%%%%%%%%%%%%Fill in the missing parts below %%%%%%%%%%%%%%%%%
dxf = filter2(gy, filter2(dx, inim));  %%derivate inim with respect to x; tips use filter2
dyf = filter2(gx, filter2(dy, inim)); %%derivate inim wrt  y
LS = (dxf+1i*dyf).^2;  %%build the orientation tensor in complex representation   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%generate 2 1-D integrative filters
gx2=gaussgen(sma2,'gau',[1,round(sma2*6)]);%generate large horizontal gaussian filter
gy2=gx2';%generate vertical gaussian filter

%%%%%%%%%%Fill in the missing parts to compute i20 and i11%%%%%%%%%%%%%%%%
i20= filter2(gy2, filter2(gx2, LS)); %%average the orientation tensor with large gaussian
i11= filter2(gy2, filter2(gx2, abs(LS))); %%average the magnitutude of the orientation tensor with large gaussian
%%%%%%%%%%%%%%%%%%%%%%%

%display the results
LS(:,:,1)=mod(angle(i20),2*PI);
LS(:,:,2)=abs(i20);
LS(:,:,3)=i11;



if (~strcmp(scl,'scloff'))
   b=round(3*sma1)+round(3*sma2);
   LS=zborder(LS,b);
   mx3=max(max(LS(b:size(i11,1)-b,b:size(i11,2)-b,3 )));
   LS(:,:,2:3)=LS(:,:,2:3)/mx3;
end





