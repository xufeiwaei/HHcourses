% Stationary GPS receiver 
close all; clear all; 

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

LongDeg = floor(Longitude/100) + (Longitude - floor(Longitude/100)*100)/60;
LatDeg = floor(Latitude/100) + (Latitude - floor(Latitude/100)*100)/60;

figure, plot(LongDeg,LatDeg);
title('Position in degrees');
xlabel('Longitude');
ylabel('Latitude');

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
title('Position in meters');
xlabel('Longitude');
ylabel('Latitude');

% 3.2 Estimate the mean and variance of the position (in x and y)
% Matlab fuctions mean() and var()

X_Mean = mean(X);
Y_Mean = mean(Y);

X_Var = var(X);
Y_Var = var(Y);

figure,plot(X(1:30),Y(1:30));
title('Some fragment of data');
figure,hist(Y,100);
title('Y Histogram');

% Max Error

X_MaxError = max(X) - X_Mean;
Y_MaxError = max(Y) - Y_Mean;

%Error
Ex = X - X_Mean;
Ey = Y - Y_Mean;

subplot(2,1,1); histfit(Ex,100), subplot(2,1,2); histfit(Ey,100);

figure,plot_uncertainty([0 0]', cov([Ex,Ey]),1,2);

% 
% % 3.3 Plot, with respect to time, the errors and the auto-correlation 
% % in x and y separately.
% 
R = randn(1,length(X));
cn = xcorr(R - mean(R),'coeff');
cx = xcorr(X - mean(X), 'coeff');
cy = xcorr(Y - mean(Y), 'coeff');
figure,subplot(2,1,1); plot(Ex), subplot(2,1,2); plot(Ey);
figure,subplot(2,1,1); hold on;plot(cx),plot(cn,'r'), subplot(2,1,2);hold on; plot(cy);plot(cn,'g');
% % Make a new script for section 4 and onward using this script as template