function [x0, lb, ub, ank] = initialfit(psd,freq,plotflag)
% Initialize the starting point and bounds for fmincon
% Input
%        psd --- power spectrum density in natural scale
%        freq --- frequency bins
%        plotflag --- [1 1], plot initialized separate components & picked extremes; ~1, not plot
% Ouput
%        x0 --- starting point
%        lb/ub --- lower/upper bounds
%        ank --- actual number of components
% See also FMINCON, PKEXTREM

% Shiang Hu, Jul. 2018

if nargin==2
    plotflag = [];
end

% paras
nk = 15;
x0 = zeros(4,15);
mp = max(psd);

% vis
if plotflag(1)==1,    f1=figure; end % show components
if plotflag(2)==1,    f2=figure; end % show extremes

% roughly estimate the paras separately
for i=1:nk
    % pick the extremes
    [extrem, fm] = pkextrem(freq,psd,mp,i);
    
    if isempty(fm)
        if plotflag(1)==1, figure(f1), plotspfit(freq,psd,[],i,mp); end
        break;
    end
    
    % fit component
    x0(:,i) = tp(psd, freq, extrem);
    psd_fit =  stc(x0(:,i),freq);
    
    if plotflag(1)==1, figure(f1), plotspfit(freq, psd, psd_fit, i, mp); end
    if plotflag(2)==1, figure(f2), plotextrem(freq, psd, extrem, i, mp);  end
    
    % remaining
    psd = psd - psd_fit;
end

if nargout>1
[x0, lb, ub, ank] = tcon(x0);
end