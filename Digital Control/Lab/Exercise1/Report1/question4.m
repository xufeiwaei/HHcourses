%4.question A
num4A = [0 0 1 0 0];
den4A = [1 -13/12 -19/36 41/36 -15/36];
testsys4A = tf(num4A,den4A,-1);
[Y4A,T4A] = step(testsys4A);
figure,plot(T4A(1:20),Y4A(1:20));
%4.question B
num4B = [0 0 1];
den4B = [1 -4/3 5/9];
testsys4B = tf(num4B,den4B,-1);
[Y4B,T4B] = step(testsys4B);
figure,plot(T4B,Y4B);
%4.question C
num4C = [0 0 1 -4/3 5/9];
den4C = [1 -3/4 0 0 0];
testsys4C = tf(num4C,den4C,-1);
[Y4C,T4C] = step(testsys4C);
figure,plot(T4C(1:20),Y4C(1:20));
%4.question D
num4D = [0 0 1 1];
den4D = [1 -4/3 5/9 0];
testsys4D = tf(num4D,den4D,-1);
[Y4D,T4D] = step(testsys4D);
figure,plot(T4D,Y4D);
%4.question E
num4E = [0 0 1 -3/4];
den4E = [1 -4/3 5/9 0];
testsys4E = tf(num4E,den4E,-1);
[Y4E,T4E] = step(testsys4E);
figure,plot(T4E,Y4E);