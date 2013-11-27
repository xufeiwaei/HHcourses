s=load('data1.txt');
y=s(3:100,3); y1=s(1:98,3); y2=s(2:99,3); u1=s(1:98,2); u2=s(2:99,2);
y=y-mean(y); y1=y1-mean(y1); y2=y2-mean(y2); u1=u1-mean(u1); u2=u2-mean(u2);
W = [y1 y2 u1 u2]; th = (W'*W)\W'*y