%
% function plot_line_segments(NODES, LINES)
%
% Plots the line segements in matrix, LINES, in the current figure
%
function plot_line_segments(NODES, LINES, clearing)
    if clearing == 1,
        X = [NODES(LINES(1,1), 1) NODES(LINES(1,2), 1)]';
        Y = [NODES(LINES(1,1), 2) NODES(LINES(1,2), 2)]';
        
        plot(X, Y, 'r');
        hold on;
        plot(X, Y, 'ro');
        
        line = 2;
    else,
        hold on;
        line = 1;
    end;
    
    for kk = line:max(size(LINES)),
        X = [NODES(LINES(kk,1), 1) NODES(LINES(kk,2), 1)]';
        Y = [NODES(LINES(kk,1), 2) NODES(LINES(kk,2), 2)]';
        
        plot(X, Y, 'r');
        plot(X, Y, 'ro');
    end;
    hold off;