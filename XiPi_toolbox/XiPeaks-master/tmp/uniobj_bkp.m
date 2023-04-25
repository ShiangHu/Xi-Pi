function [f,g] = uniobj_bkp(n,psd_real,lmd,C)
% objective function for unimodal fitting
% f -- objective function scalar
% g -- gradient vector 

sm = ones(204,1);
f = sm'*(log(n)+psd_real./n)+lmd*sum(n'*C*n);
g = sm.*(1./n - psd_real./n.^2) + lmd*(C+C')*n ;
end