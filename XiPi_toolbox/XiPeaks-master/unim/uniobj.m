function [f,g] = uniobj(n,psd_real,lmd,C)
% objective function for unimodal fitting
% f -- objective function scalar
% g -- gradient vector
% 
% See also uniobj1 uniobj2

sm = ones(length(psd_real),1);
f = sm'*(n+psd_real.*exp(-n))+lmd*exp(n')*C*exp(n);
g = sm - sm.*psd_real.*exp(-n) + lmd*(C+C')*exp(n) ;
end