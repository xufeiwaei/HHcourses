%group problem
Bg = [0 0.13 0.13];
Ag = [1 -1.6 0.73];
figure,zplane(Bg,Ag);
testsysgp = tf(Bg,Ag,-1);
[Ygp,Tgp] = step(testsysgp);
figure,plot(Tgp,Ygp);