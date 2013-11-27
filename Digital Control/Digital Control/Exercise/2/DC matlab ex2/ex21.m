clear all; close all;
w=0:0.01:pi;
z=exp(-1i*w);
G=0.2*z.^5./(1-z+0.5*z.^2);
plot(real(G),imag(G));
hold on;
plot(-0.8:0.01:0.6,0,'b-');
plot(0,-0.8:0.01:0.8,'b-');
plot(-0.5346,0,'ro')
hold off;