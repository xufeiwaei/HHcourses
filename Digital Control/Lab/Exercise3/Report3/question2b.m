%question2b
num2A = [0 1.7];
den2A = [1 0.7];
testsys2A = tf(num2A,den2A,-1);
[Y2A,T2A] = step(testsys2A);
figure,plot(T2A,Y2A);
figure,zplane(num2A,den2A);