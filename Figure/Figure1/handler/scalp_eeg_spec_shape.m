clc;clear;
% plot shape of scalp eeg spectrum

load scalp_eeg_spec.mat

% normalize
m = max(scalp_eeg_spec,[],2);
pxxN = scalp_eeg_spec./m;
dat = pxxN';

fh=figure(2);clf;
y = (mean(dat'))';
e = (std(dat'))';
x = (1:length(y))';
h = area(freq,[y - e, 2 * e]);hold on;

set(h(1),'Visible','off');
set(h(2),'EdgeColor','white','FaceColor',[0.7,0.7,1]);
plot(freq,y,'-b','LineWidth',2);

set(gca,'xtick',[],'xticklabel',[])
set(gca,'ytick',[],'yticklabel',[])
xlabel('freq');
ylabel('Power');
set(gca,'fontName','Arial','fontSize',20,'fontWeight','bold')
