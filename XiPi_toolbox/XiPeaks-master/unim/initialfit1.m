function [x0, sigk_ini] = initialfit1(psd,freq,settings)
% Initialize the starting point and bounds for fmincon
% Input
%        psd --- power spectrum density in natural scale
%        freq --- frequency bins
%        settings --- [minpeakwidth  minpeakheight  npeaks]  1*3 vetor
% Ouput
%        x0 --- starting point
%        sigk_ini --- initial fitting
% See also FMINCON, PKEXTREM

% Shiang Hu, Jul. 2018

minpeakwidth = 0.8;
minpeakheight = 0.02;
npeaks = 3;

if length(settings) > 2
    npeaks = settings(3);
end
if length(settings) > 1
    minpeakheight = settings(2);
end
if ~isempty(settings)
    minpeakwidth = settings(1);
end

npsd = psd./max(psd);   % psd归一化

warning off
[pks,fma,fw] = findpeaks(npsd,freq,'minpeakwidth',minpeakwidth,'minpeakheight',minpeakheight,'minpeakprominence',0.02,'npeaks',npeaks);
if isempty(pks)
    x0=[]; sigk_ini=[];
    return;
end
[~,fmi] = findpeaks(-psd./max(psd),freq,'minpeakwidth',0.5,'minpeakheight',-0.8,'minpeakprominence',0.03,'npeaks',length(pks));
warning on

% paras
nk = length(pks) + 1;
mp = max(psd);   % 最大原始信号
x0 = zeros(4,nk);  % 4*nk 的 0 矩阵
x0(1:2,1) = [psd(1);freq(1)];
x0(1:3,2:end) = [pks';fma';fw';]; 
fmas = x0(2,:);  %起始频率+峰值y  --> x0(1,:) 起始谱值+峰值x

% roughly estimate the paras separately
if length(fma)>length(fmi)
    fmi = [fmi;freq(end)];
end   %re...

sigk_ini = zeros(length(freq),nk);

for i=1:nk
    if i==1
        [extrem, ~] = pkextrem1(psd,freq,fmas,fmi,i); %
        x0(:,i) = tp(psd, freq, extrem);
        psd_fit =  stc(x0(:,i),freq);
        % 拟合初始背景谱... ap_psd
        sigk_ini(:,i) = psd_fit;
        
        psd = psd - psd_fit;
    else
        extrem.fma = fma(i-1);
        extrem.fmi = fmi(i-1);
        
        x0(:,i) = tp(psd, freq, extrem);
        psd_fit =  stc(x0(:,i),freq);
        sigk_ini(:,i) = psd_fit;
        

        psd = psd - psd_fit;
    end
    
end

% x0=x0(:,1:nk);
% sigk_ini = stc(x0,freq);
end