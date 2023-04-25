function psd_unim = unim_bkp(psd_real, lmd, options)
% unimodal regression with log-concave smoothing 
% Input
%         psd_real --- real spectrum to fit
% Output
%         psd_unim --- fitted spectrum

% Shiang Hu, Aug. 10. 2018

freq = 0.3914*(1:204);
nf = length(freq);
C = diff(eye(nf),3); C = sparse(C'*C); 

psd_x0 = log(psd_real);
lb = psd_x0 - 0.1*mean(abs(psd_x0));
ub = psd_x0 + 0.1*mean(abs(psd_x0));

% kpa = 1e8;
% A = diff(eye(nf),3); b = zeros(nf-3,1);

% kpav =logspace(-1,6,8);

% figure,
% for i=1:8
%     kpa = kpav(i);
% tic;
psd_unim = fmincon(@(x)sum(log(x)+psd_real./x)+lmd*sum((C*x).^2),psd_x0,[],[],[],[],lb,ub,@asp1,options);
% toc;

% D = sparse(diff(eye(nf),2));
% D = sparse(toeplitz([2 -1 zeros(1,202)]));
% b = zeros(204,1);
% b = -0.5*ones(202,1);
% psd_unim= exp(fmincon(@(n)uniobj(n,psd_real,lmd,C),psd_x0,D,b,[],[],lb,ub,[],options));
% tic; 
% psd_unim = fminunc(@(x)sum(log(x)+psd_real./x)+lmd*sum((C*x).^2)+kpa*asp(x),psd_x0);
% toc;
% plot(gca,(1:202)',diff(eye(204),2)*log(psd_unim)); hold on; 
% psd_unim = psd_unim;
end

function [c, ceq] = asp(x)
% asymmetric penalty for unimodal regression

th = 1e-3;
a = diff(eye(204),2)*log(x);

a (a<0.01) =0;
% c = mean(a.^2)-th;
c = sum(a.^2);
ceq =[];
end

function [c, ceq] = asp1(x)
% asymmetric penalty for unimodal regression

th = 1e-3;
a = diff(eye(204),2)*log(x);

a (a<0) =0;
c = mean(a.^2)-th;
ceq =[];
end