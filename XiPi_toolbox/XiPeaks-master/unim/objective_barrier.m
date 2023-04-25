function [f,g,H] = objective_barrier(t,x,A,b,c)
[m,n] = size(A);
d = A*x - b; D = diag(1./d);
f = t*c'*x - log(-d')*ones(m,1);
g = t*c - A'*D*ones(m,1);
H = A'*D^2*A;
