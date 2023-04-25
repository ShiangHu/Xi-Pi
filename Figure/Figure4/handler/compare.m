clc;clear;close all;
% compare the results of qualitative simulation for XiPi and FOOOF 
load groudtruth_176.mat
load IEEG_spec.mat f
freq = f(2:101);

% GroudTruth
plot(freq,cc,'linewidth',3,'color','black')
set(gca,'fontName','Arial','fontSize',14,'fontWeight','bold')
xlabel('freq/Hz'); ylabel('Power')
hold on
plot(freq,ac,'linewidth',3,'color','r')
set(gca,'fontName','Arial','fontSize',14,'fontWeight','bold')
plot(freq,pc,'linewidth',3,'color','#EDB120')
set(gca,'fontName','Arial','fontSize',14,'fontWeight','bold')
legend('CC','AC','PC')
title('GroudTruth')

%% XiPi
[psd_ftd,components] = scmem_unim(freq,cc');
% ALL
close all;
plot(freq,cc,'linewidth',3,'color','black')
set(gca,'fontName','Arial','fontSize',14,'fontWeight','bold','xtick',[],'ytick',[])
hold on
plot(freq,components(:,1),'linewidth',3,'color','r')
plot(freq,components(:,2),'linewidth',3,'color','blue')
plot(freq,components(:,3),'linewidth',3,'color','green')
legend('Spt','ξ-π AC','ξ-π PC_1','ξ-π PC_2')

% AC
close all;
plot(freq,ac,'linewidth',3,'color','black')
set(gca,'fontName','Arial','fontSize',14,'fontWeight','bold','xtick',[],'ytick',[])
hold on
plot(freq,components(:,1),'linewidth',3,'color','#77AC30')

% PC
close all;
plot(freq,pc,'linewidth',3,'color','black')
hold on
plot(freq,psd_ftd - components(:,1),'linewidth',3,'color','#77AC30')
set(gca,'fontName','Arial','fontSize',14,'fontWeight','bold','xtick',[],'ytick',[])
% ylim([0 60])

%% FOOOF
% settings = struct('peak_width_limits',[1 12]);
settings = [];
fooof_results = fooof(freq,cc,[0 50], settings, 1);

% ALL
plot(freq,cc,'linewidth',3,'color','black')
set(gca,'fontName','Arial','fontSize',14,'fontWeight','bold')
hold on
plot(freq,10.^fooof_results.ap_fit,'linewidth',3,'color','r')
% ylim([0 60])
for i=1:size(fooof_results.gaussian_params,1)
    c = fooof_results.gaussian_params(i,1);
    a = fooof_results.gaussian_params(i,2);
    w = fooof_results.gaussian_params(i,3);
    peak = a*exp(-((fooof_results.freqs-c).^2) / (2 * w^2));
    plot(freq,10.^(fooof_results.ap_fit+peak)-10.^fooof_results.ap_fit,'linewidth',3)
end
set(gca,'fontName','Arial','fontSize',14,'fontWeight','bold','xtick',[],'ytick',[])
legend('Spt','FOOOF AC','FOOOF PC_1','FOOOF PC_2','FOOOF PC_3')

% AC
plot(freq,ac,'linewidth',3,'color','black')
set(gca,'fontName','Arial','fontSize',14,'fontWeight','bold')
hold on
plot(freq,10.^fooof_results.ap_fit,'linewidth',3,'color','#EDB120')
set(gca,'fontName','Arial','fontSize',14,'fontWeight','bold')
legend('AC','AC - ξ-π','AC - FOOOF')

% PC
plot(freq,pc,'linewidth',3,'color','black')
hold on
plot(freq, 10.^(fooof_results.fooofed_spectrum) - 10.^(fooof_results.ap_fit),'linewidth',3,'color','#EDB120')
legend('PC','PC - ξ-π','PC - FOOOF')
ylim([0 60])
set(gca,'fontName','Arial','fontSize',18,'fontWeight','bold')