% part of the image analysis course at Halmstad university
% Authors: Stefan Karlsson and Josef Bigun, copyright 2012

function [U1, V1, U2, V2] = DoFlow(dx,dy,dt,method,gradInd)
% function DoFlow inputs images, dx, dy, dt, corresponding to the
% 3D gradients in an video sequence.

if nargin<5
    gradInd = 1;
end
if nargin<4
%%% possibilities for 'method' are:  %%
%     method = 'LK';      %% Lucas Kanade
%     method = 'BONUS';  %% If you feel inclined to implement your own
    method = 'NOTHING';  %% Do nothing, i.e. return zeros
end

flowRes = 21; %resolution of the flow field in the image

%     MOMENT CALCULATIONS
gaussStd = 1.5; % for tensor smoothing.
gg  = gaussgen(gaussStd,'gau'); %% filter for tensor smoothing

%     moment m200, calculated in three steps explicitly
%     1) make elementwise product:
      momentIm = dx.^2;
     
%     2) smooth with large seperable gaussian filter (spatial integration)
      momentIm = filter2(gg',filter2(gg,momentIm));

%     3) downsample to specified resolution:     
      m200 =  imresize(   momentIm ,[flowRes flowRes],'nearest');

%    The remaining moments are calculated in EXACTLY the same way as above, condensed to one liners:
 m020=imresize(filter2(gg',filter2(gg,(dy.^2 ))),[flowRes flowRes],'nearest');
%TODO: fill in the missing moments(should not be zero):
 m110=zeros(flowRes);
 m101=zeros(flowRes);
 m011=zeros(flowRes);

 %initialize the field to zero:
 U1 = zeros(size(m200));
 V1 = U1;
 U2 = U1;
 V2 = U1;
 % Thresholds:
EPSILONLK = 0.00000001;

if strcmpi(method,'LK')
%%%%%%%%%%%%%% flow by the Lucas and Kanade algorithm  %%%%%%%%%% 
  for x=1:size(m011,1)
    for y=1:size(m011,2)
        %%%TODO: build the 2D structure tensor, call it S2D!
        %%% (here you can assume that m20 = m200, m02 = m020)
        %%% you have access to the elements as m200(x,y), m020(x,y) and m110(x,y)
        %%% (it should NOT be the identity matrix, enter the correct)
        S2D  = [0, 0;...
                0, 0];

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
                 0]; % Hint: the "\" operator is more efficient than actually doing inverse;
            U1(x,y) = v(1);
            V1(x,y) = v(2);
        end
    end
  end

elseif strcmpi(method,'BONUS')
    
%%%%%%%%%(BONUS) experiment with your own ideas %%%%%%%%%% 
%%%% as an example, here is a more efficient implementation of Lukas and
%%%% Kanade with "regularization" using a tikhinov constant(uncomment below)

% %%%%%%%%%%%%%% Parallell and regularized Lukas Kanade: %%%%%%%%%%     
%%%% this introduces stability to linear motions. It does not let
%%%% you label the motions as 'point' or 'line' as the structure tensor
%%%% does however. This method is faster too:
% 
% TikConst = 0.00001; 
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
