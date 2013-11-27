clear all;close all;clc;
load('up_data.mat');

R = [1, -2.191611659843037, 1.174471268501992];
S = [2.399126574105173, -0.815918501363259, -1.533614335334607e-2];

r0  = R(1); r1 = R(2); r2 = R(3);
s0  = S(1); s1 = S(2); s2 = S(3);

Ac0 = A0*r0;
Ac1 = A0*r1 + A1*r0 + B1*s0;
Ac2 = A0*r2 + A1*r1 + A2*r0 + B1*s1 + (B2-B1)*s0;
Ac3 = A1*r2 + A2*r1 + B1*s2 + (B2-B1)*s1 + (-B2)*s0;
Ac4 = A2*r2 + (B2-B1)*s2 + (-B2)*s1;
Ac5 = (-B2)*s2;

lamda = roots([Ac0 Ac1 Ac2 Ac3 Ac4 Ac5]);
[max_abs n] = max(abs(lamda))
lamda_s = lamda(n)

R1  = r0 + r1 + r2;

T0 = R1/(1-lamda_s);
T1 = -lamda_s*R1/(1-lamda_s);

BT0 = T0*B0;
BT1 = T1*B0 + T0*B1;
BT2 = T0*(B2-B1) + T1*B1;
BT3 = T0*(-B2) + T1*(B2-B1);
BT4 = T1*(-B2);

sys=tf([BT0 BT1 BT2 BT3 BT4 0],[Ac0 Ac1 Ac2 Ac3 Ac4 Ac5],-1)
zplane([BT0 BT1 BT2 BT3 BT4 0],[Ac0 Ac1 Ac2 Ac3 Ac4 Ac5]);
figure;plot(step(sys));
steady_state_gain = (BT0+BT1+BT2+BT3+BT4)/(Ac0+Ac1+Ac2+Ac3+Ac4+Ac5)

disp(['v = ', num2str(T0), '*r + (', num2str(T1), ')*r_o + (', num2str(-s0), ')*y + (', num2str(-s1), ')*samples(100,3) + (', num2str(-s2), ')*samples(99,3) + (', num2str(-r1), ')*x + (', num2str(-r2), ')*samples(100,5)']);