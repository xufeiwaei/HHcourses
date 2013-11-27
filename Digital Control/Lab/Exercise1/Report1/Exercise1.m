% %question C
num1 = [1 0];
den1 = [1 -3/4];
testsys1 = tf(num1,den1,-1); %-1 is the sample time, if it's undefined, it's -1
[Y1,T1] = step(testsys1);
figure,plot(T1,Y1);
figure,plot(step(testsys1));
% %question E
% num2 = [1 -5/4 3/8];
% den2 = [1 0 0];
% testsys2 = tf(num2,den2,-1);
% [Y2,T2] = step(testsys2);
% figure,plot(T2,Y2);
% %question F
% num3 = [1 0];
% den3 = [1 3/4];
% testsys3 = tf(num3,den3,-1);
% [Y3,T3] = step(testsys3);
% figure,plot(T3,Y3);
%2.question A
num2A = [1 0 0];
den2A = [1 -1 1/2];
testsys2A = tf(num2A,den2A,-1);
[Y2A,T2A] = impulse(testsys2A);
figure,plot(T2A,Y2A);
%2.question B
num2B = [1 0 0];
den2B = [1 0 -9/16];
testsys2B = tf(num2B,den2B,-1);
[Y2B,T2B] = impulse(testsys2B);
figure,plot(T2B,Y2B);
%2.question C
num2C = [1 0];
den2C = [1 -3/4];
testsys2C = tf(num2C,den2C,-1);
[Y2C,T2C] = impulse(testsys2C);
figure,plot(T2C,Y2C);
%2.question D
num2D = [1 -3/4];
den2D = [1 0];
testsys2D = tf(num2D,den2D,-1);
[Y2D,T2D] = impulse(testsys2D);
figure,plot(T2D,Y2D);
%2.question E
num2E = [1 -5/4 3/8];
den2E = [1 0 0];
testsys2E = tf(num2E,den2E,-1);
[Y2E,T2E] = impulse(testsys2E);
figure,plot(T2E,Y2E);
%2.question F
num2F = [1 0];
den2F = [1 3/4];
testsys2F = tf(num2F,den2F,-1);
[Y2F,T2F] = impulse(testsys2F);
figure,plot(T2F,Y2F);