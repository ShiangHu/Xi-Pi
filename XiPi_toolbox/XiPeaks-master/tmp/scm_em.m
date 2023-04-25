function [s,sig2,sige2,sig_comp] = scmem(psd,freq,plotflag)
% SCM EM algorithm
% Input
%        psd --- power spectrum nf*1
%        freq --- frequency vector nf*1
%        ank --- actual # of components
% Output
%         s --- fitted spectrum
%        sig2 --- ank*nf decomposed components
%        sige2 --- fitting noise
% See SCM-EM v4 

% Shiang Hu, Aug. 2, 2018

[x0,lb,ub,ank] = initialscmopt(psd,freq,plotflag(1:2));
nk = sum(x0(1,:) > 0.2*max(psd)) ;
[~,sig_comp]=stc(x0,freq); sig_comp = sig_comp(:,1:ank)';

% initialization
sig2 = sig_comp(1:nk,:);
sige2 = psd'-sum(sig2);
maxIt = 300;

% EM
for i=1:maxIt
    c = sum(sig2)+sige2;
    w = repmat((psd'-c)./c.^2,[size(sig2,1),1]);
    sig2 = sig2 + w.*sig2.^2;
    sige2 = psd'./c.^2.*sige2.^2;

    if sum(abs(sige2))<1e-2
        break
    end
    
    disp(i);
end

if size(sig2,1)~=1
s = sum(sig2);
else 
s = sig2;    
end