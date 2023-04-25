function pks_up = lgckv(pks_real, freq, lmd)
% unimodal regression with log-concave smoothing 
% Input
%         pks_real --- real spectrum to fit
% Output
%         pks_up --- fitted spectrum

% Shiang Hu, Aug. 10. 2018

% smoothing
nf = length(freq);
C = diff(eye(nf),3); 
C = sparse(C'*C); 

% 2nd diff
D = sparse(diff(eye(nf),2));
w = 2*abs(freq - freq(pks_real==max(pks_real)))/max(freq);

% fmin
fun = @(n)uniobj(n,pks_real,lmd,C);
x0 = log(pks_real);
A = D;
b = zeros(nf-2,1);
Aeq =[];
beq = [];
lb  = x0 - w*mean(abs(x0));
ub = x0 + w*mean(abs(x0));
nonlcon = [];
pks_up = fmincon(fun, x0, A, b, Aeq, beq, lb, ub, nonlcon, option);
if any(D*pks_up>0), warning('Pks not fully concave!'); end
pks_up = exp(pks_up);
end


