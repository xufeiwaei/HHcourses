clear all; close all;
k=(0:200);
u=[zeros(1,5),cos(0.1*k)];
y=filter(0.2,[1,-1,0.5,0,0,0],u);
figure;plot(y(1:201),'g','LineWidth',3);hold on;
z=exp(-1i*0.1);
G=0.2*z^5/(1-z+0.5*z^2);
ya=abs(G)*cos(0.1*k+angle(G));
plot(ya,'r*');hold off;
legend('y(k)','ya(k)');