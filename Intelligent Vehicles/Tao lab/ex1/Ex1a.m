% Stationary GPS receiver 
% (c) Björn Åstrand, 2012
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
F_lon = 62393; % from table
F_lat = 111342; % from table

X = F_lon * LongDeg;
Y = F_lat * LatDeg;

figure, plot(X,Y);
title('Position in meters');
xlabel('Longitude');
ylabel('Latitude');

% 3.2 Estimate the mean and variance of the position (in x and y)
% Matlab fuctions mean() and var()
% -> Your code here

X_Mean = mean(X);
Y_Mean = mean(Y);

X_Var = var(X);
Y_Var = var(Y);

figure, plot(X(1:20),Y(1:20));
title('Some fragment of data');
%figure,hist(X,100);
%title('X Histogram');
figure,hist(Y,100);
title('Y Histogram');

% Max Error

X_MaxError = max(X) - X_Mean;
Y_MaxError = max(Y) - Y_Mean;

%Error
Ex = X - X_Mean;
Ey = Y - Y_Mean;

subplot(2,1,1); hist(Ex,100), subplot(2,1,2); hist(Ey,100);
    
% Calculate and plot the covariance 

plot_uncertainty([0 0]',cov([X Y]),1,2,Ex,Ey);

% 3.3 Plot, with respect to time, the errors and the auto-correlation 
% in x and y separately.

R = randn(1,length(X));
cn = xcorr(R - mean(R),'coeff');
cx = xcorr(X - mean(X), 'coeff');
cy = xcorr(Y - mean(Y), 'coeff');
subplot(4,1,1); plot(Ex), subplot(4,1,2); plot(Ey),...
subplot(4,1,3); hold;plot(cx),plot(cn), subplot(4,1,4);hold; plot(cy);plot(cn);

subplot(2,1,1); hold;plot(cx),plot(cn), subplot(2,1,2);hold; plot(cy);plot(cn);
% Make a new script for section 4 and onward using this script as template

