function pks_up = stcfit(pks_real, freq)
% T curve fit for peaks
% Input
%         pks_real --- real spectrum to fit
% Output
%         pks_up --- fitted spectrum

% Shiang Hu, Aug. 10. 2018

option;
options.SpecifyObjectiveGradient=false;

% extrem = pkextrem(freq,pks_real);
% x0 = tp(pks_real, freq, extrem);

x0 = zeros(4,1);

[pks,fma,fw] = findpeaks(pks_real,freq,'npeaks',1);
[~,fmi] = findpeaks(-pks_real,freq,'npeaks',1);
if isempty(fmi), fmi = fma + 2*fw; end
extrem.fma = fma;
extrem.fmi = fmi;

x0(1:3) = [pks fma fw]; 
par = tp(pks_real, freq, extrem);
x0(4) = par(4);

lb = [0.9999*pks; 0.9999*fma; 0.5*fw; 1e-2*x0(4)];
ub = [1.0001*pks; 1.0001*fma; 2*fw; 1e2*x0(4)];

% figure,plot(freq,[pks_real,stc(x0,freq)]);

% fmin
fun = @(n)stcobj(n,pks_real,freq);
% [x0, lb, ub] = tcon(x0,freq);
A = [];
b = [];
Aeq = [];
beq = [];
nonlcon = [];
par_up = fmincon(fun, x0, A, b, Aeq, beq, lb, ub, nonlcon, options);
pks_up = stc(par_up,freq);
end


