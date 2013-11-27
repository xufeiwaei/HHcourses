%   plot_uncertainty(X, C, dim1, dim2)
%
%	Plots (1 standard deviation) 2 dimensions of the Covariance Matrix, C,
%	in the figure that is currently active.
%
%       X:      [3x1] Mean vector, which forms the centre of the error ellipse
%       C:      [3x3] Co-variance matrix
%       dim1:   [Scalar]    First dimension to plot (see below)
%       dim2:   [Scalar]    Second dimension to plot (see below)
%
%		dim1 == 1, dim2 == 2: First and Second Rows (X-Y)					  |X2 XY XR|
%		dim1 == 1, dim2 == 3: First and Third Rows  (X-R)	    assuming C == |XY Y2 YR|
%		dim1 == 2, dim2 == 3: Second and Third Rows (Y-R)					  |XR YR R2|
%
function plot_uncertainty(X, C, dim1, dim2)
    [x1 x2] = mahal_ellipse(C, dim1, dim2, 1, 10);
    
    hold on;
        plot(real(x1) + X(1,1), real(x2) + X(2,1), 'm');
    hold off;