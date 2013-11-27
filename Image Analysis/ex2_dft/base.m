% base.m  jb 10-08-28
% Generation of baseimages in the Fouriertransform
% N x N =size of the image
% krow, kcol frequency number +/- 0,1,2,...N/2
% psi=base(N,krow,kcol)

function psi=base(N,krow,kcol)
row=0:N-1;
col=0:N-1;


psicol=exp(j*2*pi*kcol*col/N); % basefunction 1dim x
psirow=exp(j*2*pi*krow*row/N); % basefunction 1dim y
psi=transpose(psirow)*psicol; % outer product (without conjugation), baseimage
                          %Note that ' in matlab transposes AND conjugates. 

