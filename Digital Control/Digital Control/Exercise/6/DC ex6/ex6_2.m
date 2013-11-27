clear all;clc;
load('down_data.mat');

R = [1,-1.205227573785277,0.333523029149839];
S = [-0.379683429745841,5.377649837140578e-2,0.107155478091893];

r0  = R(1); r1 = R(2); r2 = R(3);
s0  = S(1); s1 = S(2); s2 = S(3);

Ac0 = A0*r0
Ac1 = A0*r1 + A1*r0 + B1*s0
Ac2 = A0*r2 + A1*r1 + A2*r0 + B1*s1 + (B2-B1)*s0
Ac3 = A1*r2 + A2*r1 + B1*s2 + (B2-B1)*s1 + (-B2)*s0
Ac4 = A2*r2 + (B2-B1)*s2 + (-B2)*s1
Ac5 = (-B2)*s2

T   = r0 + r1 + r2;
BT0 = T*B0
BT1 = T*B1
BT2 = T*(B2-B1)
BT3 = T*(-B2)

sys=tf([BT0 BT1 BT2 BT3 0 0],[Ac0 Ac1 Ac2 Ac3 Ac4 Ac5],-1)
zplane([BT0 BT1 BT2 BT3 0 0],[Ac0 Ac1 Ac2 Ac3 Ac4 Ac5]);
figure;plot(step(sys));

steady_state_gain = (BT0+BT1+BT2+BT3)/(Ac0+Ac1+Ac2+Ac3+Ac4+Ac5)

disp(['v = ', num2str(T), '*r + (', num2str(-s0), ')*y + (', num2str(-s1), ')*samples(100,3) + (', num2str(-s2), ')*samples(99,3) + (', num2str(-r1), ')*x + (', num2str(-r2), ')*samples(100,5)']);