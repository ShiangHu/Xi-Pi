function psd_mono = unim_mono(psd_real, lmd, options)
% unimodal smoothing with monotonic constraint
% Input
%         psd_real --- real spectrum to fit
%         psd_x0 --- heuristic fitting or the value updated at the E step
%              lmd --- tuning parameter
% Output
%         psd_mono --- fitted spectrumat at the M step

% Shiang Hu, Aug. 10. 2018

freq = 0.3914*(1:204);
nf = length(freq);
C = diff(eye(nf),3); C = sparse(C'*C); 

psd_x0 = log(psd_real);
lb = psd_x0 - 0.1*mean(abs(psd_x0));
ub = psd_x0 + 0.1*mean(abs(psd_x0));

D = sparse(diff(eye(nf)));
[~,mu] = max(psd_real);
if mu>=2
    D(1:mu-1,1:mu) = -1*D(1:mu-1,1:mu);
end
% dlt = -0.01; kpa = 1e8;
% kpav =logspace(-1,6,8);

b = zeros(203,1);
% figure,

% for i=1:8
%     kpa = kpav(i);
% A = diff(eye(nf));b = zeros(nf-1,1);
% psd_mono= fmincon(@(x)sum(log(x)+psd_real./x)+sum(lmd*(C*x).^2),psd_x0,[],[],[],[],lb,ub,@(x)asp1(x,mu),options);

psd_mono= exp(fmincon(@(n)uniobj(n,psd_real,lmd,C),psd_x0,D,b,[],[],lb,ub,[],options));
% psd_mono= fminunc(@(x)sum(log(x)+psd_real./x)+sum(lmd*(C*x).^2)+kpa*asp(x,mu,dlt),psd_x0);
% plot(gca,(1:203)',diff(eye(204))*psd_mono); hold on; 
end
% end

function [c, ceq] = asp1(x,mu)
% asymmetric penalty for unimodal regression
% mu --- peak location

th = 1e-6;
A = diff(eye(204));

if mu>=2
    A(1:mu-1,1:mu) = -1*A(1:mu-1,1:mu);
end
    
a = A*x;
a (a<0) = 0;
c = mean(a.^2) - th;
ceq =[];
end

function [c, ceq] = asp(x,mu,dlt)
% asymmetric penalty for unimodal regression
% mu --- peak location

th = 1e-6;
A = diff(eye(204));

if mu>=2
    A(1:mu-1,1:mu) = -1*A(1:mu-1,1:mu);
end
    
a = A*x;
a (a<-dlt) = 0;
c = sum(a.^2);
ceq =[];
end