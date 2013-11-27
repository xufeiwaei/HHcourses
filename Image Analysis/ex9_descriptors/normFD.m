% Normalization of the Fourier descripters (Fds) representing the 
% complex contour f=x + i*y, x and y are the N contour points.
% The Fds are invariant to translation, scaling, rotation, and 
% starting point.
% inputs: F=the Fds, k=which of the Fds shall be used e.g., [-4 -3 -2 -1 2 3 4].
% Note that k is an index that can take 0 as well as negative values.
% output: out=normalized Fds

function out=normFD(F,k)

P=length(F);
out=abs(F(mod(k,P)+1))/abs(F(2));

return 
