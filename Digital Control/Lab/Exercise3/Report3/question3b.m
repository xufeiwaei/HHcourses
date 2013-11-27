%question3b
num2A = [0 1.44 -0.9];
den2A = [1 -0.56 0.1];
testsys2A = tf(num2A,den2A,-1);
[Y2A,T2A] = step(testsys2A);
roots = roots(den2A);
figure,plot(T2A,Y2A);
figure,
[z,p,l]=zplane(num2A,den2A);