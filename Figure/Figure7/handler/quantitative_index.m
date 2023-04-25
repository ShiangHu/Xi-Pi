% index plot

% Weighted vector
clc;clear;close all;
load w.mat

w = w / sum(w);
C7=[126,15,4;122,117,119;255,163,25;135,146,73;30,93,134]./255;
bar([0.5:0.5:3.5],w(1:7),'EdgeColor','w')
hold on
bar([4:0.5:8],w(8:16),'EdgeColor','w')
bar([8.5:0.5:13.5],w(17:27),'EdgeColor','w')
bar([14:0.5:30.5],w(28:61),'EdgeColor','w')
bar([31:0.5:50],w(62:100),'EdgeColor','w')
xlabel('freq/Hz'); ylabel('Weighted value'); title('Weighted vector')
set(gca,'FontName','Arial','FontSize',11)

%% WLS(error)
clc;clear;close all;
load FOF_index.mat f_error
load XiPi_index.mat x_error

PntSet1 = log10(x_error');
PntSet2 = log10(f_error');
Y=[PntSet1,PntSet2];
C1=[59 125 183;244 146 121;242 166 31;180 68 108;220 211 30]./255;
C2=[102,173,194;36,59,66;232,69,69;194,148,102;54,43,33]./255;
C3=[38,140,209;219,51,46;41,161,153;181,138,0;107,112,196]./255;
C4=[110,153,89;230,201,41;79,79,54;245,245,245;199,204,158]./255;
C5=[235,75,55;77,186,216;2,162,136;58,84,141;245,155,122]./255;
C6=[23,23,23;121,17,36;44,9,75;31,80,91;61,36,42]./255;
C7=[126,15,4;122,117,119;255,163,25;135,146,73;30,93,134]./255;
colorList=C7;

% boxplot
boxplot(Y,'Symbol','o','OutlierSize',3,'Colors',[0,0,0]);

% axis set
ax=gca;hold on;
ax.LineWidth=1.1;
ax.FontSize=13;
ax.FontName='Arial';
ax.XTickLabel={'ξ-π','FOOOF'};
ax.Title.String='Weighted least square';
ax.Title.FontSize=15;
ax.YLabel.String='log10(WLS)';

% line width
lineObj=findobj(gca,'Type','Line');
for i=1:length(lineObj)
    lineObj(i).LineWidth=1;
    lineObj(i).MarkerFaceColor=[1,1,1].*.3;
    lineObj(i).MarkerEdgeColor=[1,1,1].*.3;
end

% box color
boxObj=findobj(gca,'Tag','Box');
for i=1:length(boxObj)
    patch(boxObj(i).XData,boxObj(i).YData,colorList(mod(i,2)+2,:),'FaceAlpha',0.5,...
        'LineWidth',1.1);
end

%% R square
clc;clear;close all;
load FOF_index.mat f_R
load XiPi_index.mat x_R

PntSet1 = x_R';
PntSet2 = f_R';
Y=[PntSet1,PntSet2];
C7=[126,15,4;122,117,119;255,163,25;135,146,73;30,93,134]./255;
colorList=C7;

% boxplot
boxplot(Y,'Symbol','o','OutlierSize',3,'Colors',[0,0,0]);

% axis set
ax=gca;hold on;
ax.LineWidth=1.1;
ax.FontSize=13;
ax.FontName='Arial';
ax.XTickLabel={'ξ-π','FOOOF'};
ax.Title.String='R square';
ax.Title.FontSize=15;
ax.YLabel.String='Value';

% line width
lineObj=findobj(gca,'Type','Line');
for i=1:length(lineObj)
    lineObj(i).LineWidth=1;
    lineObj(i).MarkerFaceColor=[1,1,1].*.3;
    lineObj(i).MarkerEdgeColor=[1,1,1].*.3;
end

% box color
boxObj=findobj(gca,'Tag','Box');
for i=1:length(boxObj)
    patch(boxObj(i).XData,boxObj(i).YData,colorList(mod(i,2)+2,:),'FaceAlpha',0.5,...
        'LineWidth',1.1);
end

ylim([0.95 1])

%% likelihood
clc;clear;close all;
load FOF_index.mat f_likelihood
load XiPi_index.mat x_likelihood

C7=[126,15,4;122,117,119;255,163,25;135,146,73;30,93,134]./255;

sub = f_likelihood - x_likelihood;
sub(sub == 0) = nan;
scatter(sub,zeros(1,500),'MarkerFaceColor',C7(2,:))
hold on
plot([-50 50],[0 0],'black')
plot([0 0],[-1 1],'--','color','r')
xlim([-50 50])
title('Log likelihood')
xlabel('likelihood difference')
set(gca,'FontName','Arial','FontSize',11,'ytick',[])