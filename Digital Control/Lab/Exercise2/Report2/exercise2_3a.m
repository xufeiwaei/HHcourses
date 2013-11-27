clear all;close all;
alpha = [0:0.001:pi];
angle = [0:0.001:2*pi];
z = exp(-i*alpha);
G=0.1*z.^2./((1-0.1*z).*(1-0.7*z).*(1-0.9*z));
neg_imag_G = [];
account = 1;
figure(1);
plot(real(G),imag(G),'b','LineWidth',2);axis equal;
hold on;
plot(0,0,'rx');
x = inline('imag(0.1*exp(-2*i*w)/((1-0.1*exp(-i*w))*(1-0.7*exp(-i*w))*(1-0.9*exp(-i*w))))','w');
w = fzero(x,0.5);
nag_z = real(0.1*exp(-2*i*w)/((1-0.1*exp(-i*w))*(1-0.7*exp(-i*w))*(1-0.9*exp(-i*w))));
hold on;
plot(nag_z,0,'ro');
K_max = abs(1/nag_z);
G_closed=0.1*z.^2./((1-0.1*z).*(1-0.7*z).*(1-0.9*z)+0.1*z.^5);
B = [1 -1.7 0.79 -0.063 0 0.1];
roots = roots(B);
for k = 1:size(roots)
    hold on;
    plot(real(roots(k)),imag(roots(k)),'ro');
end
hold on;
rtemp=1;% radius
xplot=0 + rtemp * cos(angle);
yplot=0 + rtemp * sin(angle);
plot(xplot,yplot,'g');
hold off;
zero_p=[0.1];
pole_p=[1 -1.7 0.79 -0.063 0 0.1];
figure(2),[z_p,p_p,l_p]=zplane(zero_p,pole_p);
sys = tf(zero_p,pole_p,-1);
figure(3),plot(impulse(sys));
axis([0 100 -0.3 0.3]);
