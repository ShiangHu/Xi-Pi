function [f,g] = uniobj2(x,psd_real,lmd,C)
% objective function for unimodal fitting
% f -- objective function scalar
% g -- gradient vector 

sm = ones(length(psd_real),1);
f = sm'*(log(x)+psd_real./x)+lmd*x'*C*x;
g = sm./x - sm.*psd_real./(x.^2) + lmd*(C+C')*x;
g = g';
end