% Implementation of the 8 point algorithm. The
% epipolar constraint is verified by drawing the
% epipolar lines associated to two points on the
% images (for further details Big?n 13.6)
%
% (C) F. Smeraldi, Oct 11th 2000
% Modified by M. Persson, Feb 8th 2006
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
% These comments mark parts to be completed
%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Image size
XSIZE=768;
YSIZE=576;

%JB
h1 = figure; imshow('images/left.bmp');
hold on;   %OPTIONAL...to plot the points we click and then keep them

h2= figure; imshow('images/right.bmp');
hold on;   %OPTIONAL...to plot the points we click and then keep them

%%%%%%%%%%%%%%%%%%%%
% Write the number of clicked points here (see below)
%%%%%%%%%%%%%%%%%%%%
NPOINTS=15;%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%
% Find the coordinates of at least NPOINTS corresponding points in the
% (left and right) image frame (pixel coordinates):
%%%%%%%%%%%%%%%%%%%%%%

% Left image; You can use ginput to get the points...and then comment the
% code after having secured pl, pr by displaying and cutting and pasting
% into pl, pr, so that you dont need to click more than 15 NPOINTS (otherwise
% you end-up clicking everytime you run this code;
% pl=[]; pr=[];
% for k=1:NPOINTS
% % Left image
% figure(h1); %put focus on the left image for clicking...
% onepl= ginput(1);
%     pl= [pl
%         onepl 1 
%      ];
% text(pl(k,1),pl(k,2),['* ' num2str(k)],'FontSize',10,'color','r'); %OPTIONAL visualize what you clicked
%  
%  
% % Right image
% figure(h2); %put focus on the right image  for clicking...
% onepr= ginput(1);
%     pr= [pr
%         onepr 1 %%%
%      ];
% text(pr(k,1),pr(k,2),['* ' num2str(k)],'FontSize',10,'color','g'); %OPTIONAL visualize what you clicked
%      
% end


pl =[
  209.5579  246.8471    1.0000
  275.4091  276.9959    1.0000
  252.4008  223.8388    1.0000
  315.0785  264.3017    1.0000
  461.8554  182.5826    1.0000
  457.8884  302.3843    1.0000
  531.6736  168.3017    1.0000
  544.3678  221.4587    1.0000
  513.4256  249.2273    1.0000
  586.4174   68.3347    1.0000
  272.2355   52.4669    1.0000
  257.1612   51.6736    1.0000
   54.8471   75.4752    1.0000
   64.3678  499.9380    1.0000
  245.2603  380.1364    1.0000
];



pr =[
  231.7727  276.9959    1.0000
  288.8967  315.0785    1.0000
  296.0372  254.7810    1.0000
  350.7810  304.7645    1.0000
  476.1364  222.2521    1.0000
  471.3760  354.7479    1.0000
  567.3760  208.7645    1.0000
  577.6901  266.6818    1.0000
  534.8471  296.0372    1.0000
  736.3678   92.9298    1.0000
  427.7397   66.7479    1.0000
  411.8719   65.9545    1.0000
  126.2521   89.7562    1.0000
  134.1860  532.4669    1.0000
  215.1116  422.9793    1.0000
  ];

figure(h1); %put focus on the right image  for displaying clicked points...
for k=1:NPOINTS
text(pl(k,1),pl(k,2),['* ' num2str(k)],'FontSize',10,'color','r'); %OPTIONAL visualize what you clicked
end

figure(h2); %put focus on the right image  for displaying clicked points.... 
for k=1:NPOINTS
text(pr(k,1),pr(k,2),['* ' num2str(k)],'FontSize',10,'color','g'); %OPTIONAL visualize what you clicked
end


%FIRST DO THE EXERCISE WITHOUT NORMALIZATION, I.E. KEEP THE COMMENTS LIKE
%                      "Normaliztion consequence   x" 
%in place....
%Normalization consequence 1
% Construct matrices hl and hr to normalize these coordinates
% so that the average of each component is 0 
%(forcing the centroid to be the origin) and its variance
% is normalized to 1 (making the lengths be represented more accurately)

% plr=[pl; pr];
% plr_msd=plr(:,1)+i*plr(:,2);
% d= mean(abs(plr_msd-mean(plr_msd)));
% %%%%%%%%%%%%%%%%%%%%%
% % First construct hl...
% %%%%%%%%%%%%%%%%%%%%%
% hl=[
%     1/d   0  -mean(pl(:,1))/d
%     0    1/d  -mean(pl(:,2))/d 
%     0     0    1
%     ]; 
% %%%%%%%%%%%%%%%%%%%%%
% % ...and then hr:
% %%%%%%%%%%%%%%%%%%%%%
% hr=[
%     1/d   0  -mean(pr(:,1))/d
%     0    1/d  -mean(pr(:,2))/d 
%     0     0    1
%     ];
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Compute the normalized coordinates
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%  pl=(hl*pl')';
%  pr=(hr*pr')';
% 
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

[U,S,V]=svd(Q);
Ftilde=V(:,9);

%%%%%%%%%%%%%%%%%%%%%%%%%%
% Reshape vector  Ftilde into  matrix F. 
%%%%%%%%%%%%%%%%%%%%%%%%%%

F=reshape(Ftilde, 3,3)';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ensure that F is singular: first compute its SVD
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 [UF,SF,VF]=svd(F);

%%%%%%%%%%%%%%%%%%%%%%%
% Then enforce singularity by setting the smallest singular value to
% zero
%%%%%%%%%%%%%%%%%%%%%%%
 SF(3,3)=0;
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ... and finally recompute F
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 F=UF*SF*VF';

% %Normalization consequence 3 
% %Now we get our real F that takes in unnormalized coordinates from left and
% %right to produce a scalar...a sandwich.
% F=hr'*F*hl;





% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % The left epipole lies in the null space of F; the right epipole
% % belongs to the null space of F'. You can obtain them directly
% % from the SVD of F you have just computed
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
 disp('Left epipole');
 el=VF(:,3)%%%%%
 disp('Right epipole');
 er=UF(:,3)%%%%%
% 
% % ############ Verification of the epipolar constraint ###############
% 
% % Load the images
% leftim=imread('images/left.bmp','bmp');
% rightim=imread('images/right.bmp','bmp');
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Verify the epipolar constraint: choose a point,  in one image
% % (say the right). Draw the corresponding epipolar line on the other
% % image by changing the pixel-value to 255 (or 9) when epipolar line equation is
% %fullfilled.
% % Verify that the line passes through the corresponding point in the other image.
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

x=1:XSIZE; %Let x coordinates run all possible column coordinates
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		% Below are the epipolar lines on the left image
		% associated to points pr(%%,:) on the right image.
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for pointToUse = 1:NPOINTS
    %Obtain the coefficients of the the first line equation in the vector, abc        
    abc=pr(pointToUse,:)*F;    %This is obtained by inspecting pr'*F*pl=0, for the point pr(1,:).
    abc=abc/abc(2); %We make sure that the coefficient of y in the line-equation is 1
                    %We assumed that abc(2) is not zero
    y=-abc(1)*x - abc(3);
    figure(h1);plot(x,y,'g'); 


    abc=F*pl(pointToUse,:)';    %This is obtained by inspecting pr'*F*pl=0, for the point pr(1,:).
    abc=abc/abc(2); %We make sure that the coefficient of y in the line-equation is 1
                    %We assumed that abc(2) is not zero
    y=-abc(1)*x - abc(3);
    figure(h2);plot(x,y,'g'); 

end

%put back the clicked points....
figure(h1); %put focus on the right image  for displaying clicked points...
for k=1:NPOINTS
text(pl(k,1),pl(k,2),['* ' num2str(k)],'FontSize',10,'color','r'); %OPTIONAL visualize what you clicked
end

figure(h2); %put focus on the right image  for displaying clicked points....
for k=1:NPOINTS
text(pr(k,1),pr(k,2),['* ' num2str(k)],'FontSize',10,'color','g'); %OPTIONAL visualize what you clicked
end
