function  [sigIt, sigk, sige, lh, maxIt, ank, nf]= em_initial (sigk_ini, maxIt)
% initialize variables for EM
% Input
%     sigk_ini --- [nf*ank] initialized components
% Output
%      sigk --- [nf*ank] decomposed components
%      sige --- [nf*1] fitting noise
%      sigk_ini --- [nf*ank] initialized components
%      sigIt --- save sigk, sige, sigk_sdo in each interation as structure

if nargin ==1
    maxIt = 100;
end

[nf,ank] = size(sigk_ini);

sigk = sigk_ini;
sige = 1e-2*ones(nf,1);

lh = zeros(maxIt,1);
sigIt.sdo = zeros(nf,ank,maxIt);

sigIt.K = zeros(nf,ank,maxIt+1);
sigIt.K(:,:,1) = sigk;

sigIt.E = zeros(nf,maxIt+1);
sigIt.E(:,1) = sige;
end