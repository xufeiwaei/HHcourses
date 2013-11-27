close all,clear all;

load char_e;
e = char_e;
subplot(2,2,1); imshow(e); axis on;
se=ones(3,3); % 3 x 3 structuring element 
se %print it on screen
ime1=imerode(e,se);
subplot(2,2,3); imshow(ime1); axis on; 
innerbound = e & ~ime1; % equal to b3/b3e
ime2=imdilate(e,se);
outerbound=~e & ime2;
subplot(2,2,4); imshow(outerbound); axis on; title('outerboundary');
% extract the ?inner boundary?, can be interpreted as the difference b3-b3e 
subplot(2,2,2); imshow(innerbound); axis on; title('innerboundary');