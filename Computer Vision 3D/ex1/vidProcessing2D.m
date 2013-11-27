% Authors:
% Stefan M. Karlsson AND Josef Bigun 

function [dxOut, dyOut, dtOut] = vidProcessing2D(movieType, method, spdFactor,bFineScale)
% quick usage:
% vidProcessing(); - displays a sequence of test images
% vidProcessing(movieType); - same as above, but on video source indicated by the
% argument. movieType can be:
% 'synthetic' - generates a synthetic video on the fly
% 'camera' - generates video through a connected camera (requires image acquisition toolbox)
% 'cameraX' - where X is number indicating which of system cameras to use
% (default is 1). This is to be input into the string, such as e.g.: 
%         vidProcessing('camera1','edge');
% filename - name of video file in the current folder.
% example: vidProcessing('lipVid.avi'); - assumes an avi file is in the current folder
%
% explicit usage:
% [dx,dy,dt] = vidProcessing(movieType);
% Output dx, dy and dt are all WxH matrices containing the x, y, and t 
% partial derivatives over time. 
% W and H are the height and width of the video
%
% [dx,dy,dt] = vidProcessing(movieType, method); displays the same sequence, but
% with a method selected for analyzing the sequence.
% Valid options for 'method' are:
% - "LK"      (Lukas and Kanade)
% - "NOTHING" ([default] zero fields)
%
% There are 2 special aditional options for 'method', both of which 
% will not give flow output:
% - "gradient"    Displays the gradient values
% - "edge"        Displays the 2D edge detection
% 
% [dx,dy,dt] = vidProcessing('synthetic', method,spdFactor); 
% additionally sets a speed factor (spdFactor) to change the speed of the
% synthetic video generation (if spdFactor=2, then the synthetic sequence 
% is twice as fast)

% add the folder helperFunctions to the path:
originalPath = path;
path(originalPath,'.\helperFunctions');

ParseAndSetup; %script for parsing input and setup

%from this point on, we handle the video by the object 'vid'. This is how
%we get the first frame:
curIm = generateFrame(vid, 1,kindOfMovie);
% gradient calculations of the subvolume will be handled by the mex module 
% "Grad2D", which is cleared by calling with no args, and initiated by
% calling it with the first frame:
Grad2D();
[~,dx, ~, ~, dxC, ~] = Grad2D(curIm);

% at this point, "dx" is 2D, and contains the x derivative at fine scale.
% DxC, the coarse scale equivalent. We will work of several frames, so here
% we initiate our datastructures for holding several frames of derivatives:
dx = zeros(size(dx,1),size(dx,2));
dy = dx;
dt = dx;
dxC = zeros(size(dxC,1),size(dxC,2));
dyC = dxC;
dtC = dxC;

% index variable for time:
k= 1;
% main loop, runs until user shuts down the figure:
while 1
 k= k+1;
 curIm = generateFrame(vid, k,kindOfMovie,spdFactor);
 
 %calculate the gradient using "Grad2D". 
 [ dy, dx, dt, dyC,dxC,dtC] = Grad2D(curIm);

 if strcmpi(method,'edge')
     if bFineScale
         edgeIm = DoEdgeStrength(dx,dy);
     else
         edgeIm = DoEdgeStrength(dxC,dyC);
     end

     if k == 2 %if the first run, then setup graphics based on edgeIm
      checkEdgeOutput(edgeIm);
      figH = figure; set(figH, 'Name',method);
      subplot(1,2,1); hImObjEdge = imagesc(edgeIm);
      axis off;axis image;colormap gray(256); title(gca,'Edge Image');
      
      subplot(1,2,2); hImObj = imagesc( curIm,[0,250]); 
      axis off;axis image;colormap gray(256);title(gca,'original sequence');
     end
 elseif strcmpi(method,'gradient')
    if k == 2 %if the first run, then setup graphics based on dx, dy and dt
      figH = figure; set(figH,'Name','Displaying 3D gradient');
      plotRange = 0.3;
      gam = 2;
      plotRange = plotRange.^gam;

      if bFineScale
          
          subplot(2,2,1); hImObjDx = imagesc(dx,[-plotRange,plotRange]); 
          axis off;axis image;colormap gray(256);title(gca,'dx');

          subplot(2,2,2); hImObjDy = imagesc(dy,[-plotRange,plotRange]); 
          axis off;axis image;colormap gray(256);title(gca,'dy');

          subplot(2,2,3); hImObjDt = imagesc(dt,[-plotRange,plotRange]*0.5); 
          axis off;axis image;colormap gray(256);title(gca,'dt');
          
      else
          subplot(2,2,1); hImObjDx = imagesc(dxC,[-plotRange,plotRange]); 
          axis off;axis image;colormap gray(256);title(gca,'dxC');

          subplot(2,2,2); hImObjDy = imagesc(dyC,[-plotRange,plotRange]); 
          axis off;axis image;colormap gray(256);title(gca,'dyC');

          subplot(2,2,3); hImObjDt = imagesc(dtC,[-plotRange,plotRange]); 
          axis off;axis image;colormap gray(256);title(gca,'dtC');
      end      
	  subplot(2,2,4); hImObj = imagesc( curIm,[0,250]); 
      axis off;axis image;colormap gray(256);title(gca,'original sequence');
    end
 else %flow methods
     tic
   if bFineScale
    [U1, V1] = DoFlow(dx,dy,dt,method);
   else
    [U1, V1] = DoFlow(dxC,dyC,dtC,method);
   end

    if k == 2 %if the first run, then setup graphics based on size of flow field
      checkFlowOutput(U1, V1);
      flowRes = max(size(U1));
      [hImObj,hQvObjPoints,hQvObjLines] =  myGraphicsSetup(vid,kindOfMovie,flowRes);
      title(gca,['current image. Flow vectors are scaled by ' num2str(sc) ':1' ]);
      figH = gcf; set(figH, 'Name',method);
    end
 end
 
 % UPDATE GRAPHICS
 if ishandle(figH)%check if the figure is still open
    if strcmpi(method,'edge')
        set(hImObj ,'cdata',curIm);
        set(hImObjEdge ,'cdata',edgeIm);
    elseif strcmpi(method,'PLhsv') || strcmpi(method,'LKhsv')
        set(hImObjEdge ,'cdata',hsv2rgb(edgeIm));        
    elseif strcmpi(method,'gradient')
        if bFineScale
            
          gam = 1.5;
          normIm = (dx.^2+dy.^2+0.001).^((gam-1)/2);
          dxTemp = dx.*normIm;
          dyTemp = dy.*normIm;
          dtTemp = dt.*((dt.^2+0.001).^((gam-1)/2));

%             set(hImObjDx,'cdata',dxTemp);
%             set(hImObjDy,'cdata',dyTemp);
%             set(hImObjDt,'cdata',dtTemp);
            
            set(hImObjDx,'cdata',dx);
            set(hImObjDy,'cdata',dy);
            set(hImObjDt,'cdata',dt);
        else
            set(hImObjDx,'cdata',dxC);
            set(hImObjDy,'cdata',dyC);
            set(hImObjDt,'cdata',dtC);
        end
            set(hImObj  ,'cdata',curIm);
    else %flow methods
        set(hImObj ,'cdata',curIm);
        set(hQvObjLines ,'UData', sc*U1, 'VData', sc*V1);
%         set(hQvObjPoints,'UData', sc*U2, 'VData', sc*V2);
    end
 else%user has killed the main figure, break the loop and exit
    break;
 end

% a brief pause lets matlab update figures, and is good for computer 
% stability. Change this value to introduce lag-time.
pause(0.1);
end

% Clears up memory:
Grad2D();
if strcmpi(kindOfMovie,'file')
    delete(vid);   
elseif strcmpi(kindOfMovie,'camera')
  if vid.bUseCam ==2
      vi_stop_device(vid.camIn, vid.camID-1);
      vi_delete(vid.camIn);
  else
      delete(vid.camIn); 
  end
end  %observe that the pdf you have incorrect line reference here. go to line 178 for the pause
% restore the matlab path:
path(originalPath);
if bFineScale
    dxOut = dx;dyOut = dy; dtOut = dt;
else
    dxOut = dxC;dyOut = dyC; dtOut = dtC;
end