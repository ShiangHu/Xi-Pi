function [x0_up,sigk2] = mstep(sigk_sdo, x0s,lb0,ub0,options)
% Separately update the fitting for each spectrum component in the M step
% using the nonlinear contrained programming solver (fmincon)
% Input
% sigk_sdo --- [nf*ank] pseudo components updated in E step
%       xs0 --- [4*15] initialized parameters in updating
%       lb0  --- [4*15] lower bound
%       yb0 --- [4*15] upper bound
% options --- optimoptions for fmincon
% Output
%   x0_up --- updated parameters
%   sigk2  --- updated components
% See also scmfmin_em

% Shiang Hu, Aug. 9, 2018

lmd =0;
freq = 0.3914*(1:204);
ank = size(sigk_sdo,2);
x0_up = cell(ank,1);
sigk2 = zeros(size(sigk_sdo));

for k=1:ank
    x0 = x0s{k};
    lb = zeros(4,15);  lb(:,k) = lb0(:,k);
    ub = zeros(4,15); ub(:,k) = ub0(:,k);

    x0_up{k} = fmincon(@(x)scmobj(sigk_sdo(:,k),freq,x,lmd),x0,[],[],[],[],lb,ub,@(x)othcon(x,k),options);
    
    [~,sigk2(:,k)] = stc(x0_up{k}(:,k));
end