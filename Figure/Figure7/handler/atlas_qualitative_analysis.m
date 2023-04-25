clc;clear;close all;
% IEEG atlas qualitative
load IEEG_spec.mat

% channel - 3
freq = f(2:101); cc = pxx(2:101,3);  %0.5-50Hz

%% XiPi
[psd_ftd,components] = scmem_unim(freq,cc);
plot(freq,cc,'linewidth',3,'color','black');
hold on
plot(freq,components(:,1),'linewidth',3)
plot(freq,components(:,2),'linewidth',3)
title('ξ-π - human iEEG')
xlabel('freq/Hz')
ylabel('Power')
% legend('Original','AC','PC')
set(gca,'fontName','Arial')
ylim([0 25])

% log - log
close all;
plot(log10(freq),log10(cc),'linewidth',1.5);
hold on
plot(log10(freq),log10(components(:,1)),'linewidth',1.5)
plot(log10(freq),log10(psd_ftd),'linewidth',1.5)
% title('ξ-π - human IEEG')
xlabel('Log10(freq/Hz)')
ylabel('Log10(Power)')
% legend('Original','AC','PC')
set(gca,'fontName','Arial')

%% FOF
close all;
settings = struct('peak_width_limits',[1 8]);
fooof_results = fooof(freq,cc,[0 50], settings, 1);
plot(freq,cc,'linewidth',3,'color','black');
hold on
plot(freq,10.^fooof_results.ap_fit,'linewidth',3)
for i=1:size(fooof_results.gaussian_params,1)
    c = fooof_results.gaussian_params(i,1);
    a = fooof_results.gaussian_params(i,2);
    w = fooof_results.gaussian_params(i,3);
    peak = a*exp(-((fooof_results.freqs-c).^2) / (2 * w^2));
    plot(freq,10.^(fooof_results.ap_fit+peak)-10.^fooof_results.ap_fit,'linewidth',3)
end
title('FOOOF - human iEEG')
xlabel('freq/Hz')
ylabel('Power')
% legend('Original','AC','PC')
set(gca,'fontName','Arial')
ylim([0 25])

% log - log
close all;
plot(log10(freq),log10(cc),'linewidth',1.5);
hold on
plot(log10(freq),fooof_results.ap_fit,'linewidth',1.5)
plot(log10(freq),fooof_results.fooofed_spectrum,'linewidth',1.5)
% title('FOOOF - human IEEG')
xlabel('Log10(freq/Hz)')
ylabel('Log10(Power)')
% legend('Original','AC','PC')
set(gca,'fontName','Arial')