% Clears up memory:
% Grad2D();
if strcmpi(kindOfMovie,'file')
    delete(vid);   
elseif strcmpi(kindOfMovie,'camera')
  if vid.bUseCam ==2
      vi_stop_device(vid.camIn, vid.camID-1);
      vi_delete(vid.camIn);
  else
      delete(vid.camIn); 
  end
end 
