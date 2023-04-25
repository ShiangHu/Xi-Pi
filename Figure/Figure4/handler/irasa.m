clc;clear;close all;

% the usage of IRASA
load IEEG1772_data.mat Data_W
% 134   324  345  470  485   Precantral 56
dat = Data_W(56,:);

% simulate a 10Hz and 60 Hz oscillatory component
data.trial{1,1} = dat;
data.time{1,1}  = (0.005:0.005:13600*0.005);
data.label{1}     = 'chan';
data.trialinfo(1,1) = 1;


% chunk 2-second segments (gives 1Hz frequency resolution) for long/continous trials
cfg           = [];
cfg.length    = 2; % freqency resolution = 1/2^floor(log2(cfg.length*0.9))
cfg.overlap   = 0.5;
data          = ft_redefinetrial(cfg, data);

% compute the fractal and original spectra
tic
cfg               = [];
cfg.foilim        = [0 50];
cfg.pad           = 'nextpow2';
cfg.method        = 'irasa';
cfg.output        = 'fractal';
fractal = ft_freqanalysis(cfg, data);
cfg.output        = 'original';
original = ft_freqanalysis(cfg, data);
toc % ~28s

% subtract the fractal component from the power spectrum
cfg               = [];
cfg.parameter     = 'powspctrm';
cfg.operation     = 'x2-x1';
oscillatory = ft_math(cfg, fractal, original);

% display the spectra in log-log scale
figure();
hold on;
plot(original.freq, original.powspctrm,'k');
plot(fractal.freq, fractal.powspctrm);
plot(fractal.freq, oscillatory.powspctrm);
xlabel('freq'); ylabel('power');
legend({'original','fractal','oscillatory'});

irasa_original_spec = oscillatory.powspctrm;
save irasa538.mat irasa_original_spec