  clear all;close all;
  w = [0:0.01:2*pi];
  z = exp(-i*w);
  %a
  Az1 = 1 - 1.5*z + 0.9*z.^2;
  figure(1);plot(real(Az1),imag(Az1));axis equal;
  hold on;
  plot(0,0,'rx');
  A1 = [1 -1.5 0.9];
  roots1 = roots(A1);
  for i = 1:size(roots1)
      hold on;
      plot(real(roots1(i)),imag(roots1(i)),'ro');
  end
  hold on;
  rtemp=1;% radius
  xplot=0 + rtemp * cos(w);
  yplot=0 + rtemp * sin(w);
  plot(xplot,yplot,'g');
  %b
  Az2 = 1 - 3*z + 2*z.^2 - 0.5*z.^3;
  figure(2),plot(real(Az2),imag(Az2));axis equal;
  hold on;
  plot(0,0,'rx');
  A2 = [1 -3 2 -0.5];
  roots2 = roots(A2);
  for i = 1:size(roots2)
      hold on;
      plot(real(roots2(i)),imag(roots2(i)),'ro');
  end
  hold on;
  rtemp=1;% radius
  xplot=0 + rtemp * cos(w);
  yplot=0 + rtemp * sin(w);
  plot(xplot,yplot,'g');
  %c
  Az3 = 1 - 2*z + 2*z.^2 - 0.5*z.^3;
  figure(3),plot(real(Az3),imag(Az3));axis equal;
  hold on;
  plot(0,0,'rx');
  A3 = [1 -2 2 -0.5];
  roots3 = roots(A3);
  for i = 1:size(roots3)
      hold on;
      plot(real(roots3(i)),imag(roots3(i)),'ro');
  end
  hold on;
  rtemp=1;% radius
  xplot=0 + rtemp * cos(w);
  yplot=0 + rtemp * sin(w);
  plot(xplot,yplot,'g');
  %d
  Az4 = 2 - 3*z + 1.8*z.^2;
  figure(4),plot(real(Az4),imag(Az4));axis equal;
  hold on;
  plot(0,0,'rx');
  A4 = [2 -3 1.8];
  roots4 = roots(A4);
  for i = 1:size(roots4)
      hold on;
      plot(real(roots4(i)),imag(roots4(i)),'ro');
  end
  hold on;
  rtemp=1;% radius
  xplot=0 + rtemp * cos(w);
  yplot=0 + rtemp * sin(w);
  plot(xplot,yplot,'g');
  %e
  Az5 = 1 + 5*z - 0.25*z.^2 - 1.25*z.^3;
  figure(5),plot(real(Az5),imag(Az5));axis equal;
  hold on;
  plot(0,0,'rx');
  A5 = [1 5 -0.25 -1.25];
  roots5 = roots(A5);
  for i = 1:size(roots5)
      hold on;
      plot(real(roots5(i)),imag(roots5(i)),'ro');
  end
  hold on;
  rtemp=1;% radius
  xplot=0 + rtemp * cos(w);
  yplot=0 + rtemp * sin(w);
  plot(xplot,yplot,'g');
  %f
  Az6 = 1 - 1.7*z + 1.7*z.^2 - 0.7*z.^3;
  figure(6),plot(real(Az6),imag(Az6));axis equal;
  hold on;
  plot(0,0,'rx');
  A6 = [1 -1.7 1.7 -0.7];
  roots6 = roots(A6);
  for i = 1:size(roots6)
      hold on;
      plot(real(roots6(i)),imag(roots6(i)),'ro');
  end
  hold on;
  rtemp=1;% radius
  xplot=0 + rtemp * cos(w);
  yplot=0 + rtemp * sin(w);
  plot(xplot,yplot,'g');