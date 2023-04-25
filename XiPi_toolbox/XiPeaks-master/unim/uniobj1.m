function [f,g] = uniobj1(n,psd_real,lmd,C)
% objective function for unimodal fitting
% f -- objective function scalar
% g -- gradient vector 

sm = ones(length(psd_real),1);
f = sm'*(n.*exp(n)+psd_real)+lmd*exp(n')*C*exp(n);
g = sm.*(exp(n)+n.*exp(n)) + lmd*(C+C')*exp(n) ;
end