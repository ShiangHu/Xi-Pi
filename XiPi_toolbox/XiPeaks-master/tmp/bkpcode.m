% psd = stc([12 4; 0.39 10.1764; 15 20; 2 10]);

% tic;
% [parall,sigall,meta] = scmfitall(psdall(:,idx),freq,options,plotflag);
% toc;

% spt = psdall(:,idx);


% save fitrs5_initial psdall sigall parall meta;

% ank = sum(x00(1,:) > 0.2*max(psd_real));

%     lh(i) = sum(log(sige) + psd_real.*sigE(:,i).^2./(sige.*c.^2));

% sigk2(:,k) = monofs(sigk_sdo(:,k));

%         sigk2(:,k) = unim_bkp(sigk_sdo(:,k), freq, lmd2, options);

% sigk2(:,k) = ckvfs(sigk_sdo(:,k));

% lb(4,2:ank)=200; ub(4,2:ank)=1e10; % nu
% lb(3,1:ank)=1e-2; ub(3,1:ank)=1000; % tau
% lb(4,1:ank)=1e-3; ub(4,1:ank)=12000; % nu
% lb(3,1)=0.3914/2; ub(3,1)=1.5; % tau
%
% for monotone
% lb =  logspace(0,-2.5,nf)'.*x0;
% ub = linspace(1,5,nf)'.*x0;


%      [b, k, x] = fitxi(psd,freq);

%  [fma,fmi,ppspline,p] = pkextrem(freq,psd,mp,i);  % return Xi if i=1
