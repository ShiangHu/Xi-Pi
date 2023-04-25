% Figure1 - Strangely shaped spectrum
clc;clear;

load IEEG1772_data.mat
% get Precentral gyrus(29) data 
data = Data_W(ChannelRegion==29,:);

% calculate spectra
[pxx,f] = pwelch(data',hamming(400),200,400,200); 
% 0-50Hz
pxx = pxx(2:101,:)';
freq = f(2:101)';

% normalize
m = max(pxx,[],2);
pxxN = pxx./m;
dat = pxxN';

fh=figure(1);clf;
y = (mean(dat'))';
e = (std(dat'))';
x = (1:length(y))';
h = area(freq,[y - e, 2 * e]);hold on;

set(h(1),'Visible','off');
set(h(2),'EdgeColor','white','FaceColor',[0.7,0.7,1]);
plot(freq,y,'-b','LineWidth',2);

set(gca,'xtick',[],'xticklabel',[])
set(gca,'ytick',[],'yticklabel',[])
xlabel('freq/Hz');
ylabel('power');
set(gca,'fontWeight','bold','fontName','Arial','fontSize',12)
title('Precentral gyrus - 123ch')