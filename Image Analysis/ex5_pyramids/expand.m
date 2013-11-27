function E=expand(I,L)


E = zeros(size(I,1)*L,size(I,2)*L);
E(1:L:end,1:L:end) = I;


end

