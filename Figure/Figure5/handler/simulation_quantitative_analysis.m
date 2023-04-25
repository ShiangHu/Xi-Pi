clc;clear;close all;
% 定量分析，计算指标 [old]
load no_peak_set.mat

% 模拟2 - 100次

% 1. 从无峰集中随机选取一个，作为AC
x = randi(37,1,100);
AC = no_peak_set(x,:);

% 2. 随机选择若干正弦波， 随机位置，随机power
fs = 200; N = 13600;
n=0:N-1; t = n/fs;

PC = [];
peakNums = zeros(1,100);
A = [5 8 11 14 17 20 23 26 29 32 35 38 41 44 47];
peakMap = zeros(50,100);  % freq * sample
for i = 1:100
    ac = AC(i,:);
    pc = zeros(1,13600);
    peakNum = randi(6,1,1)-1; % 0-5
    CF = A(randperm(numel(A),peakNum));
    peakMap(CF,i) = 1;
    PW = rand(1,peakNum)*2-1 + p(x(i)); 
    
    for j = 1:peakNum
        pc = pc + PW(j) * sin(2 * pi * CF(j) * t);
    end
    [pxx,f] = pwelch(pc,hamming(400),200,400,200); 
    PC = [PC;pxx'];
    peakNums(i) = peakNum;
end

% 3. 混合AC PC -> CC
CC = AC + PC;

save standard.mat CC AC PC peakNums peakMap