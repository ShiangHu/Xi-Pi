function [fma,fmi,ppSpline,p] = pkfstextrem(freq,psd,maxpsd,varargin)
% Using Cubic Smoothing Spline to adaptively fit the raw spectrum
% pcik the most prominent fma and fmi in currently remained spectrum
% Rule: current maxima >= rm*maxpsd, current maxima - current minima>=rd*current maxima
% Input
%        freq --- frequency bins
%        psd --- current remained psd curve in the fitting process
%        maxpsd --- maximum value of the original spectrum
% Output
%        fma --- frequency bin of maximum psd
%        fmi --- frequency bin of minimum psd
% See also CSAPS, SPLINEMAXIMAMINIMA, PPVAL

% Shiang Hu, Jul. 2018

rm = 0.05; % ratio for pick maxima
rd = 0.25; % ratio to pick minima

% return all maximas and minimas
[ppSpline,p] = csaps(freq,psd); % p=1 for simulation
[fma, fmi] = splineMaximaMinima(ppSpline);

% check if it is for Xi process
if nargin==4&&varargin{1}==1&&~isempty(fmi)
    fma=0.3914; fmi = pickfmi(fma,fmi,ppSpline,rd);
    
elseif ~isempty(fma)&&~isempty(fmi)
    % remove the minor maximas and pick the first one
    fma(ppval(ppSpline,fma)<=rm*maxpsd)=[];
    %     [~,idx]=max(ppval(ppSpline,fma));
    
    if ~isempty(fma), fma=fma(1); fmi = pickfmi(fma,fmi,ppSpline,rd); end
end

end

function fmi = pickfmi(fma,fmi,ppSpline,rd)
% remove the left and close minimas and pick the most prominient one
fmi(fmi-fma<=0)=[];
fmi(ppval(ppSpline,fma)-ppval(ppSpline,fmi)<=rd*ppval(ppSpline,fma))=[];
if ~isempty(fmi),  fmi=fmi(1); end
end