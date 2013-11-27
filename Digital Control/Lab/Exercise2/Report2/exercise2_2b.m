clear all;close all;
alpha = [0:0.01:pi];
angle = [0:0.01:2 * pi];
z = exp(-i*alpha);
G=0.2*z.^5./(1-z+0.5*z.^2);
neg_imag_G = [];
account = 1;
figure(1);
plot(real(G),imag(G),'b','LineWidth',2);axis equal;
hold on;
plot(0,0,'rx');
x = inline('imag(0.2*exp(-5*i*w)/(1-exp(-i*w)+0.5*exp(-2*i*w)))','w');
w = fzero(x,0.5);
nag_z = real(0.2*exp(-5*i*w)/(1-exp(-i*w)+0.5*exp(-2*i*w)));
K_max = abs(1/nag_z);
G_closed=0.2*z.^5./(1-z+0.5*z.^2+K_max*0.2*z.^5);
A = [0 0 0 0 0 0.2];
B = [1 -1 0.5 0 0 K_max*0.2];
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
zero_p=[0.2];
pole_p=[1 -1 0.5 0 0 K_max*0.2];
figure(2),[z_p,p_p,l_p]=zplane(zero_p,pole_p);
sys = tf(zero_p,pole_p,-1);
figure(3),plot(impulse(sys));
axis([0 100 -0.2 0.2]);
