%question 3
c3050 = c(mod(30,256)+1,mod(50,256)+1) % c(30,50) is shown on the screen
c3050c = c(mod(-30,256)+1,mod(-50,256)+1) % c(?30,?50) is shown on the screen
abspoint = abs(c3050);
abspointc = abs(c3050c);
anglepoint = angle(c3050);
anglepointc = angle(c3050c);
realpoint = real(c3050);
realpointc = real(c3050c);