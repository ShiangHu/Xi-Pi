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

clust = kmeans(pxxN,3);

[silh3,h] = silhouette(pxxN,clust);
xlabel('Silhouette Value')
ylabel('Cluster')

% plot
c1 = pxxN(clust==1,:);
c2 = pxxN(clust==2,:);
c3 = pxxN(clust==3,:);

dat = c3';
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
xlabel('freq');
ylabel('Power');
set(gca,'fontName','Arial','fontSize',20,'fontWeight','bold')
