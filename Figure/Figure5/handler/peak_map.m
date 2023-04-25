clc;clear;close all;

% peakMap

load standard4.mat peakMap
load XiPi_results4.mat XiPi_peakMap
load FOF_results4.mat FOOOF_peakMap

%% imagesc
% standrad
imagesc(peakMap)
set(gca,'fontSize',16)
xlabel('Repeated simulations')  
ylabel('freq/Hz')
title('The set centering frequency')
set(gca,'fontName','Arial')

% XiPi
XiPi_sub = XiPi_peakMap - peakMap;
imagesc(XiPi_sub)
set(gca,'fontSize',16)
xlabel('Sample')  
ylabel('freq/Hz')
title('ξ-π')

FOOOF_sub = FOOOF_peakMap - peakMap;
imagesc(FOOOF_sub)
set(gca,'fontSize',16)
xlabel('Sample')  
ylabel('freq/Hz')
title('FOOOF')