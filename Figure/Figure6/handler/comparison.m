clc;clear;close all;
load sleep_data

[wakeSpt,~] = pwelch(wake,hamming(128),64,256,128);
[n2Spt,~] = pwelch(n2,hamming(128),64,256,128);
[remSpt,f] = pwelch(rem,hamming(128),64,256,128);
freq = f(2:101); wakeSpt = wakeSpt(2:101);   n2Spt = n2Spt(2:101);  remSpt = remSpt(2:101);
% freq = log10(freq);

% original data
plot(log10(freq),log10(wakeSpt),'linewidth',3,'lineStyle',':','color','#0E6BF8')
hold on
plot(log10(freq),log10(n2Spt),'linewidth',3,'lineStyle',':','color','#13F267')
plot(log10(freq),log10(remSpt),'linewidth',3,'lineStyle',':','color','#EA501C')


%% 自然尺度拟合
% Xi-Pi
[wake_psd_x,~] = scmem_unim(freq,wakeSpt,[]);  
[n2_psd_x,~] = scmem_unim(freq,n2Spt,[]);  
[rem_psd_x,~] = scmem_unim(freq,remSpt,[]);

[wake_fit, ~] = apFit(freq,log10(wake_psd_x),'offset - log10(x^exponent)');
[n2_fit, ~] = apFit(freq,log10(n2_psd_x),'offset - log10(x^exponent)');
[rem_fit, ~] = apFit(freq,log10(rem_psd_x),'offset - log10(x^exponent)');

wake_Spt_Fit = wake_fit.offset - log10(freq .^ wake_fit.exponent);
n2_psd_Fit = n2_fit.offset - log10(freq .^ n2_fit.exponent);
rem_psd_Fit = rem_fit.offset - log10(freq .^ rem_fit.exponent);
plot(log10(freq),wake_Spt_Fit,'linewidth',3,'color','#0E6BF8')
hold on
plot(log10(freq),n2_psd_Fit,'linewidth',3,'color','#13F267')
plot(log10(freq),rem_psd_Fit,'linewidth',3,'color','#EA501C')
% legend('Wake Spt','N2 Spt','REM Spt','Wake Fit','N2 Fit','REM Fit')
% legend('Wake Spt','Wake Fit','N2 Spt','N2 Fit','REM Spt','REM Fit')
set(gca,'xtick',log10([1 5 10 30 50]),'xtickLabel',[1 5 10 30 50],'fontName','Arial')

% FOOOF
settings = [];
wake_results = fooof(freq,wakeSpt,[0 50], settings, 1);
n2_results = fooof(freq,n2Spt,[0 50], settings, 1);
rem_results = fooof(freq,remSpt,[0 50], settings, 1);

wake_Spt_Fit_fof =  wake_results.aperiodic_params(1) - log10(freq .^ wake_results.aperiodic_params(2));
n2_Spt_Fit_fof =  n2_results.aperiodic_params(1) - log10(freq .^ n2_results.aperiodic_params(2));
rem_Spt_Fit_fof =  rem_results.aperiodic_params(1) - log10(freq .^ rem_results.aperiodic_params(2));
plot(log10(freq),wake_Spt_Fit_fof,'linewidth',3,'color','#0E6BF8')
hold on
plot(log10(freq),n2_Spt_Fit_fof,'linewidth',3,'color','#13F267')
plot(log10(freq),rem_Spt_Fit_fof,'linewidth',3,'color','#EA501C')
% legend('Wake','N2','REM','FOOOF fit - Wake','FOOOF fit - N2','FOOOF fit - REM')