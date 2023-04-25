function sigk_up = mstep_unim(sigk_sdo, freq,~)
% Separately update the fitting for each spectrum component in the M step
% using the nonlinear contrained programming solver (fmincon) and unimodal
% nonparametric fitting
% Input
% psd_real --- []
% sigk_sdo --- [nf*ank] pseudo components updated in E step
%       xs0 --- [4*15] initialized parameters in updating
% Output
%   x0_up --- updated parameters
%   sigk_up  --- updated components
% See also scmfmin_em

% Shiang Hu, Aug. 9, 2018

% initialize
ank = size(sigk_sdo,2);
sigk_up = zeros(size(sigk_sdo));

% smoothing paras
nfreq = length(freq);

for k=1:ank
    if k == 1
        prescription = slmset('plot','off','k',...
           floor(nfreq/2),'predictions',nfreq,'minvalue',0,'decreasing','on','leftvalue',sigk_sdo(1));
       [~,~,yp] = slmengine(freq,sigk_sdo(:,k),prescription); 
    else
        [~,loc] = max(sigk_sdo(:,k));
        center = freq(loc);
        % 左半边
        prescription = slmset('plot','off','k',floor(nfreq/3),'increasing','on',...
            'predictions',loc,'minvalue',0,'leftmaxvalue',0);
        [~,~,y1] = slmengine(freq(1:loc),sigk_sdo(1:loc,k),prescription); 
        % 右半边
        prescription = slmset('plot','off','k',floor(nfreq/3),'decreasing','on',...
            'predictions',nfreq-loc,'minvalue',0);
        [~,~,y2] = slmengine(freq(loc+1:end),sigk_sdo(loc+1:end,k),prescription); 
        yp = [y1';y2'];
    end
    sigk_up(:,k) = yp;
end