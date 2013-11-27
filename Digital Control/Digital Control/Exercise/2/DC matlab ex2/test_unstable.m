clear all; close all;
w=0:0.001:2*pi;
z=exp(-1i*w);
G=0.1*z.^2./((1-0.1*z).*(1-0.7*z).*(1-1.1*z));
plot(real(G),imag(G));
hold on;
% plot(-0.8:0.01:0.6,0,'b-');
% plot(0,-0.8:0.01:0.8,'b-');
% plot(-0.5346,0,'ro')
axis('equal');
hold off;