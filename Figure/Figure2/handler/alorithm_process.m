clc;clear;close all;
% alorithm process
load process_data.mat freq spt

freq = freq(2:257); spt = spt(2:257);

% a. Noralization
sptN = spt./max(spt);
plot(freq,sptN,'linewidth',4,'color','black')
set(gca,'fontName','Arial','fontSize',20,'Box','off','xtick',[],'ytick',[],'fontWeight','bold')
xlabel('freq') 
ylabel('Power')

% b. PC detection
[pks,fma,fw] = findpeaks(sptN,freq,'minpeakwidth',0.5,'minpeakheight',0.02,'minpeakprominence',0.02);
[vlys,fmi] = findpeaks(-sptN,freq,'minpeakwidth',0.5,'minpeakheight',-0.8,'minpeakprominence',0.03,'npeaks',length(pks));

plot(freq,sptN,'linewidth',4,'color','black')
set(gca,'fontName','Arial','fontSize',14,'Box','off','fontWeight','bold','xtick',[],'ytick',[])
hold on
plot(fma,pks,'v','linewidth',4,'markerfacecolor','r');
plot(fmi,-vlys,'^','linewidth',4,'markerfacecolor','blue','MarkerEdgeColor','blue');
legend({'Spt','Peaks','Valleys'});

% c. initialfit fit
close all;
plot(freq,psd_real,'linewidth',4,'color','black')
set(gca,'fontName','Arial','fontSize',14,'Box','off','fontWeight','bold','xtick',[],'ytick',[])
ylim([0 250]); axis off;
hold on
plot(freq,sigk_ini(:,1),'linewidth',5,'color','#EDB120')
plot(freq,sigk_ini(:,2),'linewidth',5,'color','green')
plot(freq,sigk_ini(:,3),'linewidth',5,'color','blue')
plot(freq,sigk_ini(:,4),'linewidth',5,'color','#4DBEEE')

% run XiPeaks
[psd_ftd,components] = scmem_unim(freq,spt);

% d. E step  [debug]
plot(freq,psd_real,'linewidth',4,'color','black')
set(gca,'fontName','Arial','fontSize',14,'Box','off','fontWeight','bold','xtick',[],'ytick',[])
ylim([0 250]); axis off;
hold on
plot(freq,sigk_sdo(:,1),'linewidth',5,'color','#EDB120')
plot(freq,sigk_sdo(:,2),'linewidth',3,'color','green')
plot(freq,sigk_sdo(:,3),'linewidth',5,'color','blue')
plot(freq,sigk_sdo(:,4),'linewidth',5,'color','#4DBEEE')

% e. M step [debug]
close all;
plot(freq,sigk_sdo(:,2),'linewidth',3,'color','green','marker','x')
set(gca,'fontName','Arial','fontSize',14,'Box','off','fontWeight','bold','xtick',[],'ytick',[])
hold on
plot(freq,sigk_up(:,2),'linewidth',5,'color','#FF00FF')

% f. end of fitting
plot(freq,spt,'linewidth',4,'color','black')
set(gca,'fontName','Arial','fontSize',14,'Box','off','fontWeight','bold','xtick',[],'ytick',[])
hold on
plot(freq,components(:,1),'linewidth',3,'color','#EDB120')
plot(freq,components(:,2),'linewidth',3,'color','green')
plot(freq,components(:,3),'linewidth',3,'color','blue')
plot(freq,components(:,4),'linewidth',3,'color','#4DBEEE')


plot(freq,spt,'linewidth',4,'color','black')
set(gca,'fontName','Arial','fontSize',14,'Box','off','fontWeight','bold','xtick',[],'ytick',[])
hold on
plot(freq,psd_ftd,'linewidth',3,'color','r')

