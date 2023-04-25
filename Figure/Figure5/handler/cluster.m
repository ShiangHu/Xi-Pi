clc;clear;close all;
% cluster, to obtain no-peak set

load IEEG_spec.mat

% normalization
pxx = pxx';
pxxN = pxx./max(pxx,[],2);
clust = kmeans(pxxN,3);

[silh3,h] = silhouette(pxxN,clust);
xlabel('Silhouette Value')
ylabel('Cluster')
