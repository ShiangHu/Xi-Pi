function [parall,sigall,meta] = scmstepfit(psdall,freq,options,plotflag)
% Fit the neural spectrum by step forward method and optimization toolbox
% Predefined maximum # of components=15, help scmobj
% # of components selection is picked at the least aic/bic
% Input
%         psdall: [nf*nc] spectrum density for all channels
%            freq: frequencies
%      options: set for fmincon, help optimoptions
%      plotflag: [1 1 1] plot initialized seprate components, picked extremes, and information criteria in stepwose forward optimization fitting
% Output
%        parall: [4[rho,mu,tau,nu]*15*nc], parameters for all channels
%        sigall: [nf*nc], fitted spectrum density
%        meta: [4[lh,aic,bic,exitflag]*nc], likelihood, aic, bic and
%        exitflag at minimum aic/bic in the loop of step forward fitting
% See also OPTIMOPTIONS, SCMOBJ

% Shiang Hu, Jul. 2018

[nf,nc] = size(psdall); % # of frequency bins and channels
lmd=0; % regularization parameter for LASSO
parall=zeros(4,15,nc);
sigall=zeros(nf,nc) ;
meta = zeros(4,nc); % lh, aic, bic, exitflag

% parfor_progress(nc);
for chn=1:nc
    psd = psdall(:,chn);
    [x0, lb0, ub0, ank] = initialscmopt(psd,freq,plotflag(1:2));
    
    if ank~=0
        xm = zeros(4,15,ank);        sigma = zeros(nf,ank);        metastep = zeros(4,ank);
        xs = zeros(size(x0));        lb = zeros(size(lb0));        ub = zeros(size(ub0)); % 2D
        
        for i=1:ank
            if i<=ank     % stepwise forward additive fitting
                xs(:,i) = x0(:,i);
                lb(:,i) = lb0(:,i);            ub(:,i) = ub0(:,i);
            else            % backfitting
                psd=psdall(:,chn)-stc(xs,freq)+stc(xs(:,i-ank),freq); % component to be backfitted
                x_rem = xs(:,setdiff(1:ank,i-ank)); % fixed paras
                xs = zeros(size(x0));        xs(:,i-ank)=x0(:,i-ank); % reinitialize para
                lb = zeros(size(lb0));        ub = zeros(size(ub0)); % reinitialize bounds
                lb(:,i-ank)=lb0(:,i-ank);       ub(:,i-ank) = ub0(:,i-ank);
            end
            
            [xs,~,metastep(4,i)] = fmincon(@(x)scmobj(psd,freq,x,lmd),xs,[],[],[],[],lb,ub,[],options); % exitflag
            [metastep(1,i),~,sigma(:,i), metastep(2,i), metastep(3,i)] = scmobj(psd,freq,xs,lmd); % lh, abic
            
            if i>ank, xs(:,setdiff(1:ank,i-ank))=x_rem; end
            xm(:,:,i)=xs;
        end
        
        [~,loc]=min(metastep(2:3,:),[],2); k = max(loc)+1; if k>ank,k=ank;end
        parall(:,:,chn)=xm(:,:,k);  sigall(:,chn)=sigma(:,k) ;  meta(:,chn)=metastep(:,k); plotic(metastep,plotflag(3))
        
    end
    
    %         parfor_progress;
    close all;
end
% parfor_progress(0);
end