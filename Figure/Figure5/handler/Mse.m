clc;clear;close all;

% calculate MSE
load standard4.mat AC CC PC
load  FOF_results4.mat FOF_AC FOF_PC 
load  XiPi_results4.mat XiPi_AC XiPi_PC

FOF_PC_mse = zeros(100,1);
XiPi_PC_mse = zeros(100,1);
FOF_AC_mse = zeros(100,1);
XiPi_AC_mse = zeros(100,1);

for i = 1 : 100
    error_pc_x = XiPi_PC(i,:) - PC(i,2:101);
    error_pc_f = FOF_PC(i,:) - PC(i,2:101);
    error_ac_x = XiPi_AC(i,:) - AC(i,2:101);
    error_ac_f = FOF_AC(i,:) - AC(i,2:101);
    
    XiPi_PC_mse(i) = mse(error_pc_x);
    FOF_PC_mse(i) = mse(error_pc_f);
    XiPi_AC_mse(i) = mse(error_ac_x);
    FOF_AC_mse(i) = mse(error_ac_f);
end

% save mse.mat FOF_PC_mse XiPi_PC_mse FOF_AC_mse XiPi_AC_mse

% plot
% pairboxplot

PntSet1 = log10(XiPi_AC_mse);
PntSet2=log10(FOF_AC_mse);
PntSet3=log10(XiPi_PC_mse);
PntSet4=log10(FOF_PC_mse);
% Y=[PntSet1,PntSet2];
Y=[PntSet1,PntSet2,PntSet3,PntSet4];

% 配色列表
C1=[59 125 183;244 146 121;242 166 31;180 68 108;220 211 30]./255;
C2=[102,173,194;36,59,66;232,69,69;194,148,102;54,43,33]./255;
C3=[38,140,209;219,51,46;41,161,153;181,138,0;107,112,196]./255;
C4=[110,153,89;230,201,41;79,79,54;245,245,245;199,204,158]./255;
C5=[235,75,55;77,186,216;2,162,136;58,84,141;245,155,122]./255;
C6=[23,23,23;121,17,36;44,9,75;31,80,91;61,36,42]./255;
C7=[126,15,4;122,117,119;255,163,25;135,146,73;30,93,134]./255;
colorList=C7;


% plot
boxplot(Y,'Symbol','o','OutlierSize',3,'Colors',[0,0,0]);

% 坐标区域属性设置
ax=gca;hold on;
% ax.LineWidth=0.7;
ax.FontSize=13;
ax.FontName='Arial';
ax.XTickLabel={'ξ-π','FOOOF','ξ-π','FOOOF'};
ax.Title.String='The simulation quantitative analysis';
ax.Title.FontSize=13;
ax.YLabel.String='Log(MSE)';

% 修改线条粗细
lineObj=findobj(gca,'Type','Line');
for i=1:length(lineObj)
    lineObj(i).LineWidth=1;
    lineObj(i).MarkerFaceColor=[1,1,1].*.3;
    lineObj(i).MarkerEdgeColor=[1,1,1].*.3;
end

% 为箱线图的框上色
boxObj=findobj(gca,'Tag','Box');
for i=1:length(boxObj)
    patch(boxObj(i).XData,boxObj(i).YData,colorList(mod(i,2)+2,:),'FaceAlpha',0.5,...
        'LineWidth',1.1);
end

% 绘制配对线
Y1 = Y(:,[1 2]);
Y2 = Y(:,[3 4]);
X=ones(size(Y1)).*[1 2];
plot(X',Y1','Color',[0,0,0,.3],'Marker','o','MarkerFaceColor',[1,1,1].*.3,...
    'MarkerEdgeColor',[1,1,1].*.3,'MarkerSize',3,'LineWidth',.6)
X=ones(size(Y2)).*[3 4];
plot(X',Y2','Color',[0,0,0,.3],'Marker','o','MarkerFaceColor',[1,1,1].*.3,...
    'MarkerEdgeColor',[1,1,1].*.3,'MarkerSize',3,'LineWidth',.6)
xlabel('AC                                              PC','fontweight','bold')