if nargin <1
    movieType  = 'synthetic'; end
if nargin <2
    method = 'NOTHING'; end
if nargin <3
    spdFactor = 1; end
if nargin <4
    bFineScale = 1; end     

sc =8; %scale vectors for plotting 
camID = 0; %camera id..
if strcmpi(movieType,'synthetic')
    kindOfMovie  = 'synthetic';
    movieType = '';
    sc =10/spdFactor; %scale vectors, faster motion-> scale down 
elseif (strfind(movieType,'camera')==1) %starts with 'camera'
    if strcmpi(movieType,'camera') %exactly 'camera'
     	kindOfMovie  = 'camera';
        movieType = '';
        camID =1; 
    else %argument longer than just 'camera'
        camID = str2double(movieType(7:end));  %last part of string to number
        if ~isempty(camID) %valid number, assume a
            kindOfMovie  = 'camera';
            movieType = '';
        else %it was not a valid number for a camera, assume a file name
            kindOfMovie  = 'file';
        end
    end
else
	kindOfMovie  = 'file';
end



%a function that sets up the video:
vid =  myVidSetup(kindOfMovie,movieType,128,128,camID);

