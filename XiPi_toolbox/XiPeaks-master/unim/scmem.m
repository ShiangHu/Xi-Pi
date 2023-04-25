function [psd_ftd,sigk,sigk_ini,sige_sdo] = scmem(psd_real,freq,options,plotflag)
% SCM EM algorithm
% Input
%       psd_real --- power spectrum nf*1
%               freq --- frequency vector nf*1
%          options --- options for fmincon
%          plotflag --- [1 0 0], plot for initialization
% Output
%          psd_ftd --- [nf*1] fitted spectrum
%                sigk --- [nf*ank] decomposed components
%               sige --- [nf*1] fitting noise
%           sigk_ini --- [nf*ank] initialized components
%        meta --- [4*maxIt], lh, aic, bic and exitflag with iterations
% See SCM-EM v7

% Shiang Hu, Aug. 2, 2018

% Heuristic fitting
[x00,lb0,ub0] = initialscmopt(psd_real,freq,plotflag(1:2));
ank = sum(x00(1,:) > 0.2*max(psd_real));  % censor minor components
[~,sigk_ini]=stc(x00(:,1:ank));

% EM intialization
maxIt = 30;
sigk= sigk_ini;
sige_sdo = 1e-1*ones(size(psd_real));
psd_ftd = sum(sigk,2);
x0s = cell(ank,1); for i=1:ank, x0s{i} = zeros(4,15); x0s{i}(:,i) = x00(:,i); end

figure, plot(freq,[psd_real,psd_ftd]); title('Heuristic Fitting');
figure, ax=cell(ank,1); for k=1:ank, ax{k}=subplot(ank,1,k); end

sdo = zeros(204,ank,30);
sig = zeros(204,ank,30);
% EM
progressbar;
for i=1:maxIt
    %     E step
    c = sum(sigk,2)+sige_sdo;
    w = repmat((psd_real-c)./c.^2,[1,ank]);
    sigk_sdo = sigk + w.*sigk.^2;
    sige_sdo = sige_sdo + w(:,1).*sige_sdo.^2;
    
    %     M step
    [x0_up,sigk] = mstep(sigk_sdo, x0s, lb0, ub0, options);
     
    for k=1:ank, plot(ax{k},freq,sigk_sdo(:,k),'b-',freq,sigk(:,k),'r.'); title(ax{k},strcat('C',num2str(k))); hold(ax{k},'on'); end
    
    psd_ftd = sum(sigk,2);
    if sum(abs(psd_real-psd_ftd))<1, break; end
    
    x0s = x0_up; sdo(:,:,i) = sigk_sdo; sig(:,:,i) = sigk;
    progressbar(i/maxIt);
    % drawnow;
end

save Xitest sdo sig
end