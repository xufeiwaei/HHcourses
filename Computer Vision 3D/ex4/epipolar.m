% Implementation of the 8 point algorithm. The
% epipolar constraint is verified by drawing the
% epipolar lines associated to two points on the
% images (for further details Big?n 13.6)
%
% (C) F. Smeraldi, Oct 11th 2000
% Modified by M. Persson, Feb 8th 2006
%Modified by J. Bigun, Nov. 2011
%%%%%%%%%%%%%%%%%%%%%%%%%%%
% These comments mark parts to be completed
%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;close all;clc;

% Image size
XSIZE=768;
YSIZE=576;

%Show the left image in figure 1
figure(1),imshow('images/left.bmp');
hold on;

%Show the right image in figure 2
figure(2),imshow('images/right.bmp');
hold on;



%%%%%%%%%%%%%%%%%%%%
% Write the number of clicked points here (see below)
%%%%%%%%%%%%%%%%%%%%

NPOINTS= 15;%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%
% Find the coordinates of at least NPOINTS corresponding points in the
% (left and right) image frame (pixel coordinates):
%%%%%%%%%%%%%%%%%%%%%%

% % Left image; You can use ginput to get the points...and then comment the
% code after having secured pl, pr by displaying and cutting and pasting
% into pl, pr, so that you dont need to click more than 15 NPOINTS (otherwise
% you end-up clicking everytime you run this code;
% pl=[]; pr=[];
% for k=1:NPOINTS
%     % Left image
%     figure(1); %put focus on the left image for clicking...
%     onepl= ginput(1);
%     pl= [pl
%         onepl 1 
%      ];
%     text(pl(k,1),pl(k,2),['* ' num2str(k)],'FontSize',10,'color','r'); %OPTIONAL visualize what you clicked
%  
%  
%     % Right image
%     figure(2); %put focus on the right image  for clicking...
%     onepr= ginput(1);
%         pr= [pr
%             onepr 1 %%%
%          ];
%     text(pr(k,1),pr(k,2),['* ' num2str(k)],'FontSize',10,'color','g'); %OPTIONAL visualize what you clicked
%      
% end


pl =[ 244.0000   379.0000    1.0000
      608.0000   346.0000    1.0000
      188.0000   310.0000    1.0000
      250.0000   344.0000    1.0000
      207.0000   248.0000    1.0000
      275.0000   277.0000    1.0000
      254.0000   225.0000    1.0000
       27.0000    28.0000    1.0000
       42.0000    30.0000    1.0000
       54.0000    77.0000    1.0000
      601.0000    26.0000    1.0000
      587.0000    69.0000    1.0000
      258.0000    50.0000    1.0000
      411.0000   174.0000    1.0000
      460.0000   182.0000    1.0000
      %display pl in command window and copy and paste it here.
];



pr =[ 215.0000    423.0000    1.0000
      657.0000    420.0000    1.0000
      216.0000    342.0000    1.0000
      265.0000    383.0000    1.0000
      230.0000    277.0000    1.0000
      288.0000    314.0000    1.0000
      294.0000    254.0000    1.0000
       98.0000     40.0000    1.0000
      112.0000     41.0000    1.0000
      126.0000     90.0000    1.0000
      753.0000     44.0000    1.0000
      737.0000     94.0000    1.0000
      412.0000     66.0000    1.0000
      428.0000    207.0000    1.0000
      473.0000    219.0000    1.0000
      %display pr in command window and copy and paste it here.
  ];


figure(1); %put focus on the left image  for displaying clicked points...
for k=1:NPOINTS
text(pl(k,1),pl(k,2),['* ' num2str(k)],'FontSize',10,'color','r'); %OPTIONAL visualize what you clicked
end

figure(2); %put focus on the right image  for displaying clicked points.... 
for k=1:NPOINTS
text(pr(k,1),pr(k,2),['* ' num2str(k)],'FontSize',10,'color','g'); %OPTIONAL visualize what you clicked
end


% %FIRST DO THE EXERCISE WITHOUT NORMALIZATION, I.E. KEEP THE COMMENTS LIKE
%                       "Normaliztion consequence   x" 
% %in place....
% %Normalization consequence 1
% % Construct matrices hl and hr to normalize these coordinates
% % so that the average of each component is 0 
% %(forcing the centroid to be the origin) and its variance
% % is normalized to 1 (making the lengths be represented more accurately)
plr = [pl; pr];
plr_msd = plr(:,1) + sqrt(-1) * plr(:,2);
d = mean(abs(plr_msd - mean(plr_msd)));
% %%%%%%%%%%%%%%%%%%%%%
% % First construct hl...
% %%%%%%%%%%%%%%%%%%%%%
hl=[
    1/d   0  -mean(pl(:,1))/d
    0    1/d  -mean(pl(:,2))/d 
    0     0    1
    ];
% %%%%%%%%%%%%%%%%%%%%%
% % ...and then hr:
% %%%%%%%%%%%%%%%%%%%%%
hr=[
    1/d   0  -mean(pr(:,1))/d
    0    1/d  -mean(pr(:,2))/d 
    0     0    1
    ];
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Compute the normalized coordinates
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
pl=(hl*pl')';
pr=(hr*pr')';

prhat=pr;  
plhat=pl;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Now compute Ftilde from Q.
% Row i of the matrix Q of the coefficients is obtained
% from the components in prhat(i,:) and plhat(i,:).
% So first create matrix Q (equations 13.125 to 13.129 should give you an
% idea) 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ons=ones(NPOINTS,1);
q1=[prhat(:,1) prhat(:,1) prhat(:,1) prhat(:,2) prhat(:,2) prhat(:,2) ons        ons        ons];
q2=[plhat(:,1) plhat(:,2) ons        plhat(:,1) plhat(:,2) ons        plhat(:,1) plhat(:,2) ons];
Q=q1.*q2;


%%%%%%%%%%%%%%%%%%%%%
% And then compute the total least square solution of Q*Ftilde=0, which is given by the
%eigenvector corresponding to the smallest eigenvalue
% of Q'*Q or alternatively you can use the SVD decomposition (Q=U*S*V')for this.
%%%%%%%%%%%%%%%%%%%%%
[U,S,V] = svd(Q);

%%%%%%%%%%%%%%%%%%%%%%%%%%
% Reshape vector  Ftilde into  matrix F. 
%%%%%%%%%%%%%%%%%%%%%%%%%%
f = V(:,9);
for i = 1:3
    F(i,:) = f(3*i-2:3*i);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ensure that F is singular: first compute its SVD, i.e.  
%find UF, SF, VF such that   UF*SF*VF'=F
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[UF,SF,VF] = svd(F);


%%%%%%%%%%%%%%%%%%%%%%%
% Then enforce singularity by setting the smallest singular value to
% zero
%%%%%%%%%%%%%%%%%%%%%%%
SF(3,3) = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ... and finally recompute F
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
F = UF * SF * VF';



% %Normalization consequence 3 
% %Now we get our real F that takes in unnormalized coordinates from left and
% %right to produce a scalar...a sandwich.
F = hr'*F*hl;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The left epipole lies in the null space of F; the right epipole
% belongs to the null space of F'. You can obtain them directly
% from the SVD of F you have just computed
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%...

 disp('Left epipole');
 el = VF(3,:);%%%%%
 disp('Right epipole');
 er = UF(3,:);%%%%%
%### Verification of the epipolar constraint using pr'*F*pl=0 ###
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Verify the epipolar constraint: choose a point,  in one image
% (say the right first). Draw the corresponding epipolar line on the other
% image where the epipolar line equation is
% fullfilled. Verify that the line passes through the corresponding point in 
% the other image.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

x=1:XSIZE; %Let x coordinates run all possible column coordinates
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		% Below are the epipolar lines on the left image
		% associated to points pr(%%,:) on the right image.
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Obtain the coefficients of the the first line equation in the vector, abc        

for i = 1:15
    abc=pr(i,:)*F;    %This is obtained by inspecting pr'*F*pl=0, for the point pr(1,:).
    abc=abc/abc(2);   %We make sure that the coefficient of y in the line-equation is 1
                      %We assumed that abc(2) is not zero
    y=-abc(1)*x - abc(3);
    figure(1);plot(x,y,'g'); 
end


        %%%%%%%%%%%%%%%%%%%%%%%%%%%
		% Now draw on the right image the epipolar lines
		% associated with  two points
		% on the left image
		%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i = 1:15
    abc=pl(i,:)*F;    %This is obtained by inspecting pr'*F*pl=0, for the point pr(1,:).
    abc=abc/abc(2);   %We make sure that the coefficient of y in the line-equation is 1
                      %We assumed that abc(2) is not zero
    y=-abc(1)*x - abc(3);
    figure(2);plot(x,y,'g');
end
	    


% Write the two images with the epipolar lines to the disk
figure(1);Im=getframe; imwrite(Im.cdata,'left.jpg')
figure(2);Im=getframe; imwrite(Im.cdata,'right.jpg')
