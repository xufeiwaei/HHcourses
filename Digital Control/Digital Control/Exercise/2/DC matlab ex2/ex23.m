clear all; close all;
k=3;
num=[0.1 zeros(1,k)];
den=[1 -1.7 0.79 -0.063 zeros(1,k-2) 0.1];
zplane(num,den);
sys=tf(num,den,-1);
figure;plot(impulse(sys));
axis([0 70 -0.3 0.3])