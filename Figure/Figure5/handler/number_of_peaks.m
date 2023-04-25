clc;clear;close all;

% the comparison of peak Number
load standard4.mat peakNums
load  FOF_results4.mat FOF_peaks_num
load  XiPi_results4.mat XiPi_peaks_num

% bubble - XiPi nums
t = tiledlayout(1,1);
nexttile
x = [0 0 0 0 0 0 1 1 1 1 1 1 2 2 2 2 2 2 3 3 3 3 3 3 4 4 4 4 4 4 5 5 5 5 5 5];
y = [0:5,0:5,0:5,0:5,0:5,0:5];
sz = zeros(1,36);
for i = 1:100
    a = peakNums(i);
    b = XiPi_peaks_num(i);
    sz(1,6*a+b+1) = sz(1,6*a+b+1) + 1;
end
bubblechart(x,y,sz,sz,'MarkerFaceAlpha',0.5,'MarkerFaceColor','#FF7F50','MarkerEdgeColor','none');

hold on

% bubble - FOF nums
x = [0 0 0 0 0 0 1 1 1 1 1 1 2 2 2 2 2 2 3 3 3 3 3 3 4 4 4 4 4 4 5 5 5 5 5 5];
y = [0:5,0:5,0:5,0:5,0:5,0:5];
sz = zeros(1,36);
for i = 1:100
    a = peakNums(i);
    b = FOF_peaks_num(i);
    if b > 5
        b = 4;
    end
    sz(1,6*a+b+1) = sz(1,6*a+b+1) + 1;
end
map = colormap(summer(10000));
bubblechart(x,y,sz,sz,'MarkerFaceAlpha',0.5,'MarkerFaceColor','#00CED1','MarkerEdgeColor','none');


blgd = bubblelegend('Sample size');
lgd = legend('ξ-π fit','FOOOF fit');
blgd.Layout.Tile = 'east';
lgd.Layout.Tile = 'east';
title('The comparison of peaks number')
xlabel('Number of simulated peaks')
ylabel('Number of fit peaks')
set(gca,'fontWeight','bold','fontName','Arial')
