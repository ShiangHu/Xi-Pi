clc;clear;close all;
% qualitative simulation, visual analysis
load no_peak_set.mat
load irasa324.mat

% 1.Selecting spectra with strangely shaped peaks from the IEEG
% dataset and using IRASA to remove AC to obtain PC
freq = f(2:101);
pc = irasa_original_spec(1:100);
pc(pc < 0) = 0;  pc(1:30) = 0; pc = pc*8;

% 2. choose one from no-peak set as AC
ac = no_peak_set(11,:);
ac = ac./2; % scale
ac = ac(2:101);

% 3. calculate and mix the AC and PC
cc = ac + pc;
plot(freq,cc,'linewidth',3,'color','black')
set(gca,'fontName','Arial','fontSize',14,'fontWeight','bold')
xlabel('freq/Hz'); ylabel('Power')
hold on
plot(freq,pc,'linewidth',3,'color','r')
set(gca,'fontName','Arial','fontSize',14,'fontWeight','bold')
xlabel('freq/Hz'); ylabel('Power')
plot(freq,ac,'linewidth',3,'color','blue')
set(gca,'fontName','Arial','fontSize',14,'fontWeight','bold')
xlabel('freq/Hz'); ylabel('Power')
% ylim([0 20])

save groudtruth_324.mat ac pc cc
% 4.Use XiPi and FOOF to decompose spectra and demonstrate the comparison between AC and PC with ground truth
% compare.m