%sums along x and y only:
energyOfDxComps = squeeze(sum(sum(dx.^2)));
%displays the result
figure(1); stem(energyOfDxComps); xlabel('depth'); ylabel('energy');

edgeIm = DoEdgeStrength(dx,dy,gradInd);
figure(2);
imagesc(edgeIm);
colormap gray;axis off;axis image;