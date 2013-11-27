% Stationary GPS receiver 
% (c) Björn Åstrand, 2012
clc;close all; clear all; 

DATA = load('gps_ex1_window2012.txt');
Longitude = DATA(:,4); % read all rows in column 4
Latitude  = DATA(:,3); % read all rows in column 3
figure, plot(Longitude,Latitude);
title('Position in NMEA-0183 format');
xlabel('Longitude');
ylabel('Latitude');

% 3.1 Write a function that transform your longitude and latitude angles 
% from NMEA-0183 into meters
% 1. longitude and latitude angles from NMEA-0183 into degrees  

LongDeg = floor(Longitude/100) + (Longitude - floor(Longitude/100)*100)/60;% = floor(Longitude/100) + (Longitude - floor(Longitude/100)*100)/60;
LatDeg  = floor(Latitude/100) + (Latitude - floor(Latitude/100)*100)/60; % 

figure, plot(LongDeg,LatDeg);
title('Position in degrees');
xlabel('Longitude');
ylabel('Latitude');

% 2. longitude and latitude angles from NMEA-0183 into degrees
Ave_Lat = 56;
a = 6378137;
b = 6356732.3142;
h = 0;
F_lon = (pi/180)*(a^2/sqrt(a^2*(cosd(Ave_Lat))^2+b^2*(sind(Ave_Lat))^2)+h)*cosd(Ave_Lat); % from table
F_lat = (pi/180)*(a^2*b^2/((a^2*(cosd(Ave_Lat))^2+b^2*(sind(Ave_Lat))^2)^1.5)+h); % from table

X = F_lon * LongDeg;
Y = F_lat * LatDeg;

figure, plot(X,Y,'.');
title('Position in meters');
xlabel('Longitude');
ylabel('Latitude');

% 3.2 Estimate the mean and variance of the position (in x and y)
% Matlab fuctions mean() and var()
% -> Your code here
Ex = mean(X);
Vx =  var(X);
Ey = mean(Y);
Vy =  var(Y);
Error_x = X - Ex;
Error_y = Y - Ey;
[Max_Dis,pos] = max(sqrt(Error_x.^2 + Error_y.^2));
figure, plot(Error_x , Error_y);
hold on;
plot(Error_x(pos) , Error_y(pos) , 'g' );
plot_uncertainty([0 0]', cov([Error_x , Error_y]), 1, 2);
hold off;

title('Errors');
xlabel('Error_x');
ylabel('Error_y');


figure,subplot(2,1,1);
histfit(Error_x,30);
title('Error Distribution in X');

subplot(2,1,2);
histfit(Error_y,30);
title('Error Distribution in Y');



% 3.3 Plot, with respect to time, the errors and the auto-correlation 
% in x and y separately.

% -> Your code here
figure,
subplot(2,1,1);
plot(xcorr(Error_x, 'coeff'));
title('auto-correlation in x');
subplot(2,1,2);
plot(xcorr(Error_y, 'coeff'));
title('auto-correlation in y');


R=randn(1,length(Error_x));
cn=xcorr(R-mean(R),'coeff');
subplot(2,1,1); hold; plot(cn,'r');
hold off;

subplot(2,1,2); hold; plot(cn,'r');

hold off;

% Make a new script for section 4 and onward using this script as template