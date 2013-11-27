function [outim]=zborder(inim,b)
[H,W,D]=size(inim);
outim=zeros(H,W,D);

outim(b+1:H-b,b+1:W-b,:)=inim(b+1:H-b,b+1:W-b,:);
