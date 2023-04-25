clc;clear;close all;
% IEEG atlas quantitative analysis, calculating some index
load IEEG_spec.mat
load w.mat
freq = f(2:101); pxx = pxx(2:101,:);  % 0.5-50Hz

w = w / sum(w);
% WLS
f_error = zeros(1,1772);
settings = struct('peak_width_limits',[1 10]);
for i = 1 : 1772
    disp(i)
    fooof_results = fooof(freq,pxx(:,i),[0 50], settings, 1);
    e = (10.^fooof_results.fooofed_spectrum - pxx(:,i)').^2;
    e = sum(w .* e);
    f_error(i) = e;
end
