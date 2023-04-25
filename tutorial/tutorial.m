%% Quick Getting Start
clc;clear;close all;
load tutorial_data
% calculate Spt
[spt,freq] = pwelch(tutorial_data,hamming(200),100,200,100); 
% separate
[psd_ftd1,components1] = scmem_unim(freq(2:101),spt(2:101));
% or
settings = [0.8 0.05 3];
[psd_ftd2,components2] = scmem_unim(freq(2:101),spt(2:101),settings);


%% Expansion
clc;clear;close all;

% load data, need eeglab support
XiPi = xp_importdata([]);clearvars -except XiPi

% calculateSpec
XiPi = xp_calculateSpec(XiPi,[1 30],50);

% separateSepc
XiPi = xp_separateSepc(XiPi,'choose_channels',1);

% plot
% XiPi = xp_plot(XiPi,1:100);

% parameterization
XiPi = xp_parameterize(XiPi);