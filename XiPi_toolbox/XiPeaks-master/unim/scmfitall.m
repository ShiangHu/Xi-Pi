function [parall,sigall,meta] = scmfitall(psdall,freq,options,plotflag)
% Fit the neural spectrum by EM algorithm, return the parameters with
% optimization toolbox in the M step and add the orthogonal constraints
% Predefined maximum # of components=15, help scmobj
% # of components selection is picked at the least aic/bic
% Input
%         psdall: [nf*nc] spectrum density for all channels
%            freq: frequencies
%      options: set for fmincon, help optimoptions
%      plotflag: [1 1 1] plot initialized seprate components, picked extremes, and information criteria in stepwise forward optimization fitting
% Output
%        parall: [4[rho,mu,tau,nu]*15*nc], parameters for all channels
%        sigall: [nf*nc], fitted spectrum density
%        meta: [4[lh,aic,bic,exitflag]*nc], likelihood, aic, bic and
%        exitflag at minimum aic/bic in the loop of step forward fitting
% See also OPTIMOPTIONS, SCMOBJ

% Shiang Hu, Jul. 2018

[nf,nc] = size(psdall); % # of frequency bins and channels
parall=zeros(4,7,nc);
sigall=zeros(nf,nc) ;
meta = zeros(4,nc); % lh, aic, bic, exitflag

% parfor_progress(nc);
for chn=1:nc
    psd = psdall(:,chn);
    [psd_ftd,sigk,sigk_ini] = scmem(psd,freq,options,plotflag);
    
    figure, 
    subplot(121), plot(freq,[psd,psd_ftd,sigk]); legend({'Real','Fitted'}); title('After EM');
    subplot(122), plot(freq,[psd,sum(sigk_ini,2),sigk_ini]); legend({'Real','Fitted'}); title('Initialized');
    
    %         parfor_progress;
    close all;
end
% parfor_progress(0);
end