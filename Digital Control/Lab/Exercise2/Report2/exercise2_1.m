  clear all;close all;
  w = [0:0.01:2*pi];
  z = exp(-i*w);
  %a
  Az1 = 1 - 1.5*z + 0.9*z.^2;
  figure(1);plot(real(Az1),imag(Az1));axis equal;
  hold on;
  plot(0,0,'rx');
  A1 = [1 -1.5 0.9];
  A1d = [1 0 0];
  roots1 = roots(A1);
  testsys1 = tf(A1,A1d,-1); %-1 is the sample time, if it's undefined, it's -1
  [Y1,T1] = step(testsys1);
  figure,plot(T1,Y1);
  figure,plot(step(testsys1));
%   for i = 1:size(roots1)
%       hold on;
%       plot(real(roots1(i)),imag(roots1(i)),'ro');
%   end
%   hold on;
%   rtemp=1;% radius
%   xplot=0 + rtemp * cos(w);
%   yplot=0 + rtemp * sin(w);
%   plot(xplot,yplot,'g');
  %b
  Az2 = 1 - 3*z + 2*z.^2 - 0.5*z.^3;
  figure(2),plot(real(Az2),imag(Az2));axis equal;
  hold on;
  plot(0,0,'rx');
  A2 = [1 -3 2 -0.5];
  A2d = [1 0 0 0];
  roots2 = roots(A2);
  testsys2 = tf(A2,A2d,-1); %-1 is the sample time, if it's undefined, it's -1
  [Y2,T2] = step(testsys2);
  figure,plot(T2,Y2);
  figure,plot(step(testsys2));
%   for i = 1:size(roots2)
%       hold on;
%       plot(real(roots2(i)),imag(roots2(i)),'ro');
%   end
%   hold on;
%   rtemp=1;% radius
%   xplot=0 + rtemp * cos(w);
%   yplot=0 + rtemp * sin(w);
%   plot(xplot,yplot,'g');
  %c
  Az3 = 1 - 2*z + 2*z.^2 - 0.5*z.^3;
  figure(3),plot(real(Az3),imag(Az3));axis equal;
  hold on;
  plot(0,0,'rx');
  A3 = [1 -2 2 -0.5];
  A3d = [1 0 0 0];
  roots3 = roots(A3);
  testsys3 = tf(A3,A3d,-1); %-1 is the sample time, if it's undefined, it's -1
  [Y3,T3] = step(testsys3);
  figure,plot(T3,Y3);
  figure,plot(step(testsys3));
%   for i = 1:size(roots3)
%       hold on;
%       plot(real(roots3(i)),imag(roots3(i)),'ro');
%   end
%   hold on;
%   rtemp=1;% radius
%   xplot=0 + rtemp * cos(w);
%   yplot=0 + rtemp * sin(w);
%   plot(xplot,yplot,'g');
  %d
  Az4 = 2 - 3*z + 1.8*z.^2;
  figure(4),plot(real(Az4),imag(Az4));axis equal;
  hold on;
  plot(0,0,'rx');
  A4 = [2 -3 1.8];
  roots4 = roots(A4);
%   for i = 1:size(roots4)
%       hold on;
%       plot(real(roots4(i)),imag(roots4(i)),'ro');
%   end
%   hold on;
%   rtemp=1;% radius
%   xplot=0 + rtemp * cos(w);
%   yplot=0 + rtemp * sin(w);
%   plot(xplot,yplot,'g');
  %e
  Az5 = 1 + 5*z - 0.25*z.^2 - 1.25*z.^3;
  figure(5),plot(real(Az5),imag(Az5));axis equal;
  hold on;
  plot(0,0,'rx');
  A5 = [1 5 -0.25 -1.25];
  A5d = [1 0 0 0];
  roots5 = roots(A5);
  testsys5 = tf(A5,A5d,-1); %-1 is the sample time, if it's undefined, it's -1
  [Y5,T5] = step(testsys5);
  figure,plot(T5,Y5);
  figure,plot(step(testsys5));
%   for i = 1:size(roots5)
%       hold on;
%       plot(real(roots5(i)),imag(roots5(i)),'ro');
%   end
%   hold on;
%   rtemp=1;% radius
%   xplot=0 + rtemp * cos(w);
%   yplot=0 + rtemp * sin(w);
%   plot(xplot,yplot,'g');
  %f
  Az6 = 1 - 1.7*z + 1.7*z.^2 - 0.7*z.^3;
  figure(6),plot(real(Az6),imag(Az6));axis equal;
  hold on;
  plot(0,0,'rx');
  A6 = [1 -1.7 1.7 -0.7];
  A6d = [1 0 0 0];
  roots6 = roots(A6);
  testsys6 = tf(A6,A6d,-1); %-1 is the sample time, if it's undefined, it's -1
  [Y6,T6] = step(testsys6);
  figure,plot(T6,Y6);
  figure,plot(step(testsys6));
%   for i = 1:size(roots6)
%       hold on;
%       plot(real(roots6(i)),imag(roots6(i)),'ro');
%   end
%   hold on;
%   rtemp=1;% radius
%   xplot=0 + rtemp * cos(w);
%   yplot=0 + rtemp * sin(w);
%   plot(xplot,yplot,'g');