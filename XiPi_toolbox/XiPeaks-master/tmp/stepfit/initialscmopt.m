function [x0, lb, ub, ank] = initialfit(psd,freq,plotflag)
% Initialize the starting point and bounds for fmincon
% Input
%        psd --- power spectrum density in natural scale
%        freq --- frequency bins
%  plotflag --- [1 1], plot initialized separate components & picked extremes; ~1, not plot
% Ouput
%         x0 --- starting point
%          lb --- lower bounds
%         ub --- upper bounds
%        ank --- actual number of components
% See also FMINCON, PKEXTREM

% Shiang Hu, Jul. 2018

% default maximum # of components
nk = 15;
dltf = freq(2)-freq(1);

% paras
x0 = zeros(4,nk);
lb = zeros(4,nk);
ub = zeros(4,nk);
maxpsd = max(psd);

% vis
if plotflag(1)==1,    f1=figure; end % show initialized separate components
if plotflag(2)==1,    f2=figure; end % show seprate extremes

% roughly estimate the paras separately
for i=1:nk
    % pick the extremes
    [fma,fmi,ppspline,p] = pkextrem(freq,psd,maxpsd,i);  % return Xi if i=1
    [b, k, x] = fitxi(psd,freq);
    
    if isempty(fma)||isempty(fmi), break; end
    if plotflag(2)==1, figure(f2), subplot(4,4,i), plotextrem(freq,psd,fma,fmi,ppspline,p);end
    
    % rou
    [~,maxloc]=min(abs(freq-fma));
    rou =psd(maxloc);
    % mu
    mu =freq(maxloc);
    % tau --- peak half
    tmp=abs(psd-0.5*rou)<0.08*rou;
    tau=min(abs(freq(tmp)-mu));  if isempty(tau), tau=dltf/2; end
    % nu
    [~,minloc]=min(abs(freq-fmi)); a=psd(minloc); if a<=0, a=eps; end
    nu =1.2*(log(a)-log(rou))/log((tau^2)/(tau^2+(freq(minloc)-mu)^2));
    
    % fitted component
    x0(:,i) = [rou;mu;tau;nu];
    psd_det =  stc(x0(:,i),freq);
    if plotflag(1)==1, figure(f1), plotspfit(freq,psd,psd_det,i,maxpsd);end
    
    % remained spectrum
    psd = psd - psd_det;
end

% plot the fitting error
if plotflag(1)==1, figure(f1), plotspfit(freq,psd,[],i,maxpsd);end

% add constrains
ank = sum(x0(1,:)~=0);
lb(1,:)=0.25*x0(1,:); ub(1,:)=1.1*x0(1,:);% rou
lb(2,:)=0.99999*x0(2,:); ub(2,:)=1.000001*x0(2,:);% mu
lb(3,1:ank)=dltf/2; ub(3,1:ank)=40; % tau
% lb(3,1)=0.3914/2; ub(3,1)=1.5; % tau
lb(4,1:ank)=0.2; ub(4,1:ank)=120; % nu
% lb(4,2:ank)=200; ub(4,2:ank)=1e10; % nu
% lb(3,1:ank)=1e-2; ub(3,1:ank)=1000; % tau
% lb(4,1:ank)=1e-3; ub(4,1:ank)=12000; % nu

% reorder as descending amplitudes
[~,odr] = sort(x0(1,:),2,'descend');
[~,loc] = min(x0(2,x0(1,:)~=0));
odr = [loc setdiff(odr, loc, 'stable')];

x0 = x0(:,odr);
lb = lb(:,odr);
ub = ub(:,odr);
end