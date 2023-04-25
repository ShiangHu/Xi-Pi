clc;clear;close all;
% sleep study, all results have been calculated.

%% A - exponent dst
load exponent.mat
bp = BarPlot('ylabel', 'Exponent');

mycolor3 = [0.86,0.82,0.11;...
    0.23,0.49,0.71];

g = bp.addGroup('ξ-π');
b1 = g.addViolinBar('Wake', exp(:,1), 'FaceColor', mycolor3(2, :), 'locationType', 'median');
b2 = g.addViolinBar('NREM', exp(:,2), 'FaceColor', mycolor3(2, :), 'locationType', 'median');
b3 = g.addViolinBar('REM', exp(:,3), 'FaceColor', mycolor3(2, :), 'locationType', 'median');

g = bp.addGroup('FOOOF');
b4 = g.addViolinBar('Wake', exp(:,1), 'FaceColor', mycolor3(1, :), 'locationType', 'median');
b5 = g.addViolinBar('NREM', exp(:,2), 'FaceColor', mycolor3(1, :), 'locationType', 'median');
b6 = g.addViolinBar('REM', exp(:,3), 'FaceColor', mycolor3(1, :), 'locationType', 'median');

bp.addBridge('***', b1, b2, 'FontSize', 12);
bp.addBridge('***', b2, b3, 'FontSize', 12);
bp.addBridge('**', b4, b5, 'FontSize', 12);
bp.addBridge('**', b5, b6, 'FontSize', 12);
bp.render();

%% B - sleep staging
clc;clear;close all;
bp = BarPlot('ylabel', 'Accuracy(%)');

cmap = parula(8);

g = bp.addGroup('Wake-N2');
b1 = g.addBar('ξ-π', 83.47, 'confInt', [79.52 87.42], 'FaceColor', cmap(5, :)); 
b2 = g.addBar('FOOOF', 79.73, 'confInt', [75.54 83.92], 'FaceColor', cmap(7, :)); 

g = bp.addGroup('Wake-REM');
b3 = g.addBar('ξ-π', 98.43, 'confInt', [97.82 99.04], 'FaceColor', cmap(5, :));
b4 = g.addBar('FOOOF', 96.33, 'confInt', [94.94 97.72], 'FaceColor', cmap(7, :));

g = bp.addGroup('N2-REM');
b5 = g.addBar('ξ-π', 84.46, 'confInt', [80.31 88.61], 'FaceColor', cmap(5, :));
b6 = g.addBar('FOOOF', 81.68, 'confInt', [76.75 86.61], 'FaceColor', cmap(7, :));

bp.addBridge('*', b1, b2, 'FontSize', 12);
bp.addBridge('**', b3, b4, 'FontSize', 12);
bp.addBridge('*', b5, b6, 'FontSize', 12);
w = 0.4;
b1.Width = w;b2.Width = w;b3.Width = w;b4.Width = w;b5.Width = w;b6.Width = w;
bp.render();

hold on
plot([0:0.5:9],ones(1,19)*50,'--')