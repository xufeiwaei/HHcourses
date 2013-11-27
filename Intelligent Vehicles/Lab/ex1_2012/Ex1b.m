% Stationary GPS receiver 
close all; clear all; 

DATA = load('gps_ex1_morningdrive2012.txt');
Longitude = DATA(:,4); % read all rows in column 4
Latitude  = DATA(:,3); % read all rows in column 3
plot(Longitude,Latitude);
title('Path of Morning Drive');
xlabel('X');
ylabel('Y');

% Transform of longitude and latitude angles 
% from NMEA-0183 into meters
% 1. longitude and latitude angles from NMEA-0183 into degrees  

LongDeg = floor(Longitude/100) + (Longitude - floor(Longitude/100)*100)/60;
LatDeg = floor(Latitude/100) + (Latitude - floor(Latitude/100)*100)/60;

% 2. longitude and latitude angles from NMEA-0183 into degrees
a = 6378137;
b = 6356752.3142;
p_lat = 56;
h = 0;
F_lon = 2*(a^2/sqrt(a^2*cos(p_lat)^2+b^2*sin(p_lat)^2)+h)*cos(p_lat); % from the table
F_lat = 2*(a^2*b^2/(sqrt(a^2*cos(p_lat)^2+b^2*sin(p_lat)^2))^3+h); % from the table

X = F_lon * LongDeg;
Y = F_lat * LatDeg;

figure, plot(X,Y);
title('Path of Morning Drive');
xlabel('X');
ylabel('Y');

% Calculate the current speed 
double Px[length(X)-1];
double Py[length(Y)-1];
double T[length(X)-1];
double V[length(X)-1];

for i = 1:(length(X)-1)
    Px(i) = X(i+1) - X(i);
    T(i) = i;
end

for j = 1:(length(Y)-1)
    Py(j) = Y(j+1) - Y(j);
end

figure,plot(T,Px)
title('Vx');
figure,plot(T,Py)
title('Vy');

for i = 1:(length(Y)-1)
    V(i) = sqrt(Px(i)^2+Py(i)^2)*3600;
end   
figure,plot(T,V)
title('Velocity of the Car');

double Orientation_Rad[length(X)-1];
double Orientation_Deg[length(X)-1];

Orientation_Rad = atan2(Py,Px);
Orientation_Deg = radtodeg(Orientation_Rad);

for i = 1:(length(X)-1)
    if Orientation_Deg(i) <= 0
        Orientation_Deg(i) = Orientation_Deg(i) + 360;
    end
end

figure,plot(T,V);
title('V & Deg')
hold on;
plot(Orientation_Deg);

figure,subplot(2,1,1);plot(T,V),title('Velocity of the Car'), subplot(2,1,2),plot(Orientation_Deg),title('Heading of the Car');
    
Head_Var1 = var(Orientation_Deg(240:310));
figure,plot(Orientation_Deg(240:310));
Head_mean1  =mean(Orientation_Deg(240:310));
Head_ex1 = Orientation_Deg(240:310) - Head_mean1;
figure,subplot(2,1,1);plot(Head_ex1),title('Error in heading when driving with high speed');
hold on

Head_Var2 = var(Orientation_Deg(700:750));
Head_mean2 = mean(Orientation_Deg(700:750));
Head_ex2 = Orientation_Deg(700:750) - Head_mean2 ;
subplot(2,1,2);plot(Head_ex2),title('Error in heading when driving with low speed');