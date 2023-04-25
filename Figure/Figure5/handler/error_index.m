clc;clear;close all;

% error Index
% TP TN FN FP
load standard4.mat peakMap
load XiPi_results4.mat XiPi_peakMap
load FOF_results4.mat FOOOF_peakMap


[F_TP,F_TN,F_FN,F_FP] = getErrorIndex(peakMap,FOOOF_peakMap);
[X_TP,X_TN,X_FN,X_FP] = getErrorIndex(peakMap,XiPi_peakMap);

% Acc
F_accuracy = (F_TP+F_TN) / 5000;
X_accuracy = (X_TP+X_TN) / 5000;

% Precision
F_precision = F_TP / (F_TP+F_FP);
X_precision = X_TP / (X_TP+X_FP);

% Sensitivity
F_recall = F_TP / (F_TP+F_FN);
X_recall = X_TP / (X_TP+X_FN);

% F1-score
F_F1 = 2 * F_TP / (2*F_TP + F_FP + F_FN);
X_F1 = 2 * X_TP / (2*X_TP + X_FP + X_FN);

% plot 
bp = BarPlot('ylabel', 'Precentage(%)');
cmap = parula(8);

% create the first group of 2 bars
g = bp.addGroup('Accuarcy');
g.addBar('ξ-π', X_accuracy*100, 'FaceColor', cmap(5, :));
g.addBar('FOOOF', F_accuracy*100, 'FaceColor', cmap(7, :));
g = bp.addGroup('Precision');
g.addBar('ξ-π', X_precision*100, 'FaceColor',cmap(5, :));
g.addBar('FOOOF', F_precision*100, 'FaceColor', cmap(7, :));
g = bp.addGroup('Sensitivity');
g.addBar('ξ-π', X_recall*100, 'FaceColor', cmap(5, :));
g.addBar('FOOOF', F_recall*100, 'FaceColor', cmap(7, :));
g = bp.addGroup('F1 Score');
g.addBar('ξ-π', X_F1*100, 'FaceColor', cmap(5, :));
g.addBar('FOOOF', F_F1*100, 'FaceColor', cmap(7, :));

bp.render();

ylim([50 100])
title('The evaluation of peak detection')
set(gca,'fontName','Arial');

function [TP,TN,FN,FP] = getErrorIndex(real,fit)
    t = fit - real;
    FN = 0; FP = 0; TN = 0; TP = 0;
    for i = 1 : 50
        for j = 1 : 100
            switch t(i,j)
                case -1
                    FN = FN + 1;
                case 0
                    if real(i,j) == 1
                        TP = TP + 1;
                    end
                    if real(i,j) == 0
                        TN = TN + 1;
                    end
                case 1
                    FP = FP + 1;
            end
        end
    end
end