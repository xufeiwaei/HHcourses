clear all; close all;
w=0:0.001:2*pi;
z=exp(-1i*w);
plot(real(z),imag(z),'g--');
hold on;
w=0:0.001:pi;
z=exp(-1i*w);
G=0.1*z.^2./((1-0.1*z).*(1-0.7*z).*(1-0.9*z));
plot(real(G),imag(G));
plot(-2:0.05:4,0,'b-');
plot(0,-3:0.05:3,'b-');
plot(-0.3194,0,'ro');  % w = 0.6120
plot(-0.6065,-0.7951,'rx');  % w = 0.2861
axis([-1.5 4 -2.5 2.5])
axis('equal');
hold off;