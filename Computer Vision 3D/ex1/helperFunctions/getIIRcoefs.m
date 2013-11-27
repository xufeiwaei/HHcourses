%generate coefficients for IIR filtering in temporal direction of the
%gradient image
function IIRcoeffs = getIIRcoefs(n)

g= gaussgen(0.5*(n-1),(n-1)*2+1);
g=g(n:end)/g(n);
IIRcoeffs = ([1 g(2:n)./g(1:n-1)]).^(1/2);
