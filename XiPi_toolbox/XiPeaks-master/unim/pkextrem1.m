function [extrem, fm] = pkextrem1(psd,freq,fmas,fmi,i)
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


rd = 0.008; % ratio to pick minima

[ppSpline,p] = my_csaps(freq,psd); % p=1 for simulation
[~, fmis] = splineMaximaMinima(ppSpline);
fmi = [fmi;fmis];

fma = fmas(i);
fmi = pickfmi(fma,fmi,ppSpline,rd);

% re...
% minNum = 1e10;
% minloc = 0;  % 最低点的位置
% for j = fmi'
%     [~,loc] = min(abs(freq - j));
%     if(psd(loc) < minNum)
%         minNum = psd(loc);
%         minloc = j;
%     end
% end

extrem.ppspline = ppSpline;
extrem.fma = fma;
extrem.fmi = fmi;
extrem.p = p;
fm = fma + fmi;
end

function fmi = pickfmi(fma,fmi,ppSpline,rd)
% remove the left and close minimas and pick the most prominient one
fmi(fmi-fma<=0)=[];
fmi(ppval(ppSpline,fma)-ppval(ppSpline,fmi)<=rd*ppval(ppSpline,fma))=[];
if ~isempty(fmi),  fmi=fmi(1); end
end