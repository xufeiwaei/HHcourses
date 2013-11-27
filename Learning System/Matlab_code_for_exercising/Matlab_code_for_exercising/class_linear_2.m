n1=800;	% Data number in one cluster
n2=800;

S=[.8 0.85; 0.85 1]; % kovariacine matrica

	% means
m1=[1.4  0.2];		
m2=[-1.4 -0.2];

	% Transformation matrix
[W,L]=eig(S);
C=W*L^0.5;

	% Two data clusters d1 ir d2
a=randn(2,n1);
d1=C*a+m1'*ones(1,n1);
a=randn(2,n2);
d2=C*a+m2'*ones(1,n2);

%figure(1);clf;hold on
%plot(d1(1,:),d1(2,:),'r+');
%plot(d2(1,:),d2(2,:),'g+');
%axis('equal');

Euclid_pseudoinverse_perceptron;
