n1=800;	% Data number in cluster 1
n2=800;	% Data number in cluster 2


S=[.1 0.2; 0.2 1]; % covariance matrix

	% means
m1=[1.5 -.4];		
m2=[-1 0.4];

	% transformation matrix
[W,L]=eig(S);
C=W*L^0.5;

	% two data clusters d1 ir d2
a=randn(2,n1);
d1=C*a+m1'*ones(1,n1);
a=randn(2,n2);
d2=C*a+m2'*ones(1,n2);


%	 Visualization:
%	 1 Euclidean distance classifier
%	 2 Classifier based on the pseudo-inverse matrix
%	 3 Perceptron

Euclid_pseudoinverse_perceptron;