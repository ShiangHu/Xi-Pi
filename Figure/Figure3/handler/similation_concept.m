clc;clear;close all;
% simulation concept

% 1. AC
load no_peak_set.mat
ac = no_peak_set(11,:);  % channel-11
% natural 
plot(f(2:101),ac(2:101),'linewidth',3,'color','black')
set(gca,'fontName','Arial','fontSize',16,'fontWeight','bold','xtick',[],'ytick',[],'Box','on')
xlabel('freq/Hz'); ylabel('Power')

% log
plot(log10(f(2:101)),log10(ac(2:101)),'linewidth',3,'color','black')
set(gca,'fontName','Arial','fontSize',16,'fontWeight','bold','xtick',[],'ytick',[],'Box','on')
xlabel('Log(freq)'); ylabel('Log(Power)')

% no_peak_set
freq = log10(f(2:101));
dat = no_peak_set_N(:,2:101)';
dat = log10(dat);

fh=figure(1);clf;
y = (mean(dat'))';
e = (std(dat'))';
x = (1:length(y))';
h = area(freq,[y - e, 2 * e]);hold on;

set(h(1),'Visible','off');
set(h(2),'EdgeColor','white','FaceColor',[0.7,0.7,1]);
plot(freq,y,'-black','LineWidth',2);

set(gca,'fontName','Arial','fontSize',18,'fontWeight','bold','xtick',[],'ytick',[])
xlabel('freq'); ylabel('Power')
%% 2. Resampling 
clc;clear;close all;
% IRASA
load irasa.mat
load no_peak_set.mat

hold on
plot(irasa_freq, irasa_original_spec,'k','linewidth',3);
plot(irasa_freq, irasa_fractal_spec,'color','r','linewidth',3);
plot(irasa_freq, irasa_original_spec-irasa_fractal_spec,'linewidth',3,'color','black');
legend('Spt','AC','PC')
set(gca,'fontName','Arial','fontSize',20,'fontWeight','bold','xtick',[],'ytick',[],'Box','on')
xlabel('freq'); ylabel('Power')

freq = f(2:101); pc = no_peak_set(11,2:101);
sub = (irasa_original_spec-irasa_fractal_spec);
cc = pc + sub(1:100);
plot(freq,cc,'linewidth',3,'color','black')
set(gca,'fontName','Arial','fontSize',16,'fontWeight','bold','xtick',[],'ytick',[],'Box','on')


%% 3. sin waves
close all;
load sin_pc.mat f sin_pc ac
plot(f(2:101),sin_pc(2:101),'linewidth',3,'color','black')
set(gca,'fontName','Arial','fontSize',14,'fontWeight','bold','xtick',[],'ytick',[])

cc = ac + sin_pc';
plot(f(2:101),cc(2:101),'linewidth',3,'color','black')
set(gca,'fontName','Arial','fontSize',14,'fontWeight','bold','xtick',[],'ytick',[])

% plot(f(2:101),pxx(2:101)+ac(2:101)','linewidth',3,'color','black')
% set(gca,'fontName','Arial','fontSize',14,'fontWeight','bold','xtick',[],'ytick',[])