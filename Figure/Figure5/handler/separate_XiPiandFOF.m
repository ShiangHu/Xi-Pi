clc;clear;close all;
% Using XiPi and FOOOF to decompose spectral and calculate some index (MSE，number of peaks,error Index...)

load standard4.mat
load standard3.mat f

% 0.5-50Hz
AC = AC(:,2:101); CC = CC(:,2:101); PC = PC(:,2:101); freq = f(2:101);

% XiPi
XiPi_PC = [];
XiPi_AC = [];
XiPi_peakMap = zeros(50,100);
XiPi_peaks_num = zeros(100,1);
% 78 84 error
for i = 1 : size(CC,1)
    disp(i)
    [psd_ftd,components] = scmem_unim(freq,CC(i,:)');
    % peakmap
    [~,loc] = max(components(:,2:end));
    loc = freq(loc);
    XiPi_peakMap(loc,i) = 1;
    % pc
    XiPi_PC = [XiPi_PC;(psd_ftd-components(:,1))'];
    % ac
    XiPi_AC = [XiPi_AC;components(:,1)'];
    % peaknum
    XiPi_peaks_num(i) = size(components,2)-1;
end

save XiPi_results3.mat XiPi_PC XiPi_AC XiPi_peaks_num XiPi_peakMap

% FOF
FOF_PC = [];
FOF_AC = [];
FOOOF_peakMap = zeros(50,100);
FOF_peaks_num = zeros(100,1);
settings = struct('max_n_peaks',5);
for i = 1 : size(CC,1)
    fooof_results = fooof(freq,CC(i,:),[0 50], settings, 1);
     % peakmap
    components = fooof_results.peak_params(:,1);
    loc = round(components);
    FOOOF_peakMap(loc,i) = 1;
    % pc
    FOF_PC = [FOF_PC;10.^fooof_results.fooofed_spectrum - 10.^fooof_results.ap_fit];
    % ac
    FOF_AC = [FOF_AC;10.^fooof_results.ap_fit];
    FOF_peaks_num(i) = size(fooof_results.peak_params,1);
end

save FOF_results4.mat FOF_PC FOF_AC FOF_peaks_num FOOOF_peakMap