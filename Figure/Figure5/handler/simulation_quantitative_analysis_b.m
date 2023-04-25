clc;clear;close all;
% quantitative analysis
load no_peak_set.mat

% simulation  - 100 times

% 1. Random select from no-peak set as AC
x = randi(33,1,100);
% x = zeros(1,100) + 11;
AC = no_peak_set(x,:);

% 2. Random select some sin waves, the center frequency according to band
fs = 200; N = 13600;
n=0:N-1; t = n/fs;

PC = [];
peakNums = zeros(1,100);
A = [8 13;5 6;15 30;1 1;31 42];  % center frequency, sorted by alpha,theta,beta,delta,gamma
B = [4;3;3;7;2];

peakMap = zeros(50,100);  % freq * sample
for i = 1:100
    ac = AC(i,:);
    pc = zeros(1,13600);
    peakNum = randi(6,1,1)-1; % 0-5
    
    % set CF
    CF = zeros(1,peakNum);
    for j = 1:peakNum
        CF(j) = randi(A(j,:));
    end
    peakMap(CF,i) = 1;
    
    % set Power
%     PW = rand(1,peakNum)*2-1 + p(x(i));
    for j = 1:peakNum
        PW(j) = B(j)+p(x(i)) + rand(1,1)*2-1;  % B +- 1
    end
    
    for j = 1:peakNum
        pc = pc + PW(j) * sin(2 * pi * CF(j) * t);
    end
    [pxx,f] = pwelch(pc,hamming(400),200,400,200); 
    PC = [PC;pxx'];
    peakNums(i) = peakNum;
end

% 3. mix AC and PC -> CC
CC = AC + PC;

save standard.mat CC AC PC peakNums peakMap