function xi_up = mono(xi_real, freq, lmd)
% unimodal smoothing with monotonic constraint
% Input
%         xi_real --- real spectrum to fit
%              lmd --- smoothing parameter
% Output
%         xi_up --- fitted spectrumat at the M step

% Shiang Hu, Aug. 10. 2018

% smoothing
nf = length(freq);
C = diff(eye(nf),3); 
C = sparse(C'*C); 

% 1st diff
D = sparse(diff(eye(nf)));
[~,mu] = max(xi_real);
if mu>=2
    D(1:mu-1,1:mu) = -1*D(1:mu-1,1:mu); 
end

% fmin
fun = @(x)objmono(x,xi_real,C,lmd);
x0 = xi_real;
A = D;
b =  0*ones(nf-1,1);
Aeq = [];
beq =[];
lb = zeros(nf,1);
ub = [];
nonlcon = [];
xi_up = fmincon(fun, x0, A, b, Aeq, beq, lb, ub, nonlcon, option);
if any(D*xi_up>0), warning('Xi not monotonously decreasing!'); end
end

function [f,g] = objmono(x,s,C,lmd)
% g --- gradient
% lmd = 0.02 * abs(sum(log(x)+s./x)) / (x'*C*x);
f = sum(log(x)+s./x) + lmd*x'*C*x;
a = ones(length(x),1);
g = 2*lmd*C*x - s.*a./x.^2 + a./x;
end