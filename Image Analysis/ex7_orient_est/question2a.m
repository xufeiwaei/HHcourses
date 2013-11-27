close all, clear all;

[magn, argument]=fmtest(256,[0.1,0.33]*pi, 0.75); 
LS=linsymexer(magn); %estimate the linear symmetry (LS) 
figure(1),lsdisp(LS, 0.5); truesize; %and display (give B a value!)

[magn, argument]=fmtest(256,[0.1,0.33]*pi, 0.75); 
LS=linsymexer(magn); %estimate the linear symmetry (LS) 
figure(2),lsdisp(LS, 1.5); truesize; %and display (give B a value!)

[magn, argument]=fmtest(256,[0.1,0.33]*pi, 0.75); 
LS=linsymexer(magn); %estimate the linear symmetry (LS) 
figure(3),lsdisp(LS, 3.5); truesize; %and display (give B a value!)