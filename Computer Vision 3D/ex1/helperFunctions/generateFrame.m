function newIm = generateFrame(vid, t,kindOfMovie,spdFactor)
persistent iix iiy;
if nargin<4
    spdFactor = 1;end

if strcmp(kindOfMovie,'file') 
    %get frame at t in video file, where t is "bouncing" forward and
    %backward (thus, video is played for infinity, by playing itself backwards half of the time)
    t=varyT(round(t),vid.NumberOfFrames);
    newIm = rgb2gray(read(vid, t));
elseif strcmpi(kindOfMovie,'synthetic')  % generate test image:
    
    spd    = spdFactor/300; %speed of motion of the patterns generated
    cen1   = 0.55;          %centre of circle 1
    cen2   = -cen1;         %centre of circle 2
    cen3   = -cen1;         %centre of circle 3, offset in y
    cW     = 0.33;          %radius of circles
    cFuz   = 1.5;           %fuzziness of the boundary
    cDetail= 0.67;          %detail of the interior pattern(frequency of sinusoids)

    if isempty(iix)
        [iix,iiy] = meshgrid(linspace(-1,1,vid.Height));
        iiy = iiy -0.3;
    end
    rS = 0;%spd*3;
    iX = cos(t*rS)*iix + sin(t*rS)*iiy;
	iY = sin(t*rS)*iix - cos(t*rS)*iiy;

    
    iX = (iX    -0.45*sin(pi*(t+0.5)*spd*3));
    iY = (iY-0.22-0.7*cos(pi*(t+0.5)*spd  ));

   newIm = uint8(... 
     185*(0.4+cos(2+iY*cDetail*16*pi).*cos(2+iX*cDetail*16*pi)).*sig(cW^2-(iX+cen1).^2-iY.^2, cFuz*cW/50) + ... //disk 1
     128*(1+                             cos(iX*cDetail*20*pi)).*sig(cW^2-(iX+cen2).^2-iY.^2, cFuz*cW/50) + ... //disk 2
     128*(1+cos(iY*cDetail*20*pi)                             ).*sig(cW^2-(iY-cen3).^2-iX.^2, cFuz*cW/50));  ... //disk 3
    
else %if strcmpi(kindOfMovie,'camera')  % capture from camera:
    if vid.bUseCam==2 %videoinput lib
        vi_is_frame_new(vid.camIn, vid.camID-1);
        newIm  = vi_get_pixelsProper(vid.camIn, vid.camID-1,vid.Height,vid.Width);
    else
        newIm = flipdim(squeeze(getsnapshot(vid.camIn)),2);
    end
end
