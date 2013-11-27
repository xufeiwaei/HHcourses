% Stationary GPS receiver 
% (c) Bj�rn �strand, 2012
close all; clear all; 

DATA = load('gps_ex1_morningdrive2012.txt');
Longitude = DATA(:,4); % read all rows in column 4
Latitude  = DATA(:,3); % read all rows in column 3
plot(Longitude,Latitude);
title('Path of Morning Drive');
xlabel('Longitude');
ylabel('Latitude');

% Transform of longitude and latitude angles 
% from NMEA-0183 into meters
% 1. longitude and latitude angles from NMEA-0183 into degrees  

LongDeg = floor(Longitude/100) + (Longitude - floor(Longitude/100)*100)/60;
LatDeg = floor(Latitude/100) + (Latitude - floor(Latitude/100)*100)/60;

% 2. longitude and latitude angles from NMEA-0183 into degrees
F_lon = 62393; % from table
F_lat = 111342; % from table

X = F_lon * LongDeg;
Y = F_lat * LatDeg;

figure,plot(X,Y);
title('Path of Morning Drive');
xlabel('X');
ylabel('Y');

% Calculate the current speed 
double Px[length(X)-1];
double Py[length(Y)-1];
double T[length(X)-1];
double V[length(X)-1];

for ii = 1:(length(X)-1)
    Px(ii) = X(ii+1) - X(ii);
    T(ii) = ii;
end

for jj = 1:(length(Y)-1)
    Py(jj) = Y(jj+1) - Y(jj);
end

figure,plot(T,Px)
title('Vx');
figure,plot(T,Py)
title('Vy');

for ii = 1:(length(Y)-1)
    V(ii) = sqrt(Px(ii)^2+Py(ii)^2)*3600;
end   
figure,plot(T,V)
title('Velocity of the Car');

double Head_Rad[length(X)-1];
double Head_Deg[length(X)-1];

Head_Rad = atan2(Py,Px);
Head_Deg = radtodeg(Head_Rad);

for ii = 1:(length(X)-1)
    if Head_Deg(ii) <= 0
        Head_Deg(ii) = Head_Deg(ii) + 360;
    end
end

plot(T,V);
title('V & Deg')
hold on;
plot(Head_Deg);
hold off;

subplot(2,1,1);plot(T,V), subplot(2,1,2),plot(Head_Deg);
    
Head_Var = var(Head_Deg(240:310));
plot(Head_Deg(240:310));
Head_Var = var(Head_Deg(240:310));
Head_M=mean(Head_Deg(240:310));
Head_ex1 = Head_Deg(240:310) - Head_M;
plot(Head_ex1)


Headm2 = mean(Head_Deg(700:750));
Headex2 = Head_Deg(700:750) - Headm2 ;
plot(Headex2);