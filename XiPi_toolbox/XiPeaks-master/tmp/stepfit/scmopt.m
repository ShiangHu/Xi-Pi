% Spctrum Components Model OPTimized
addpath(genpath(cd)); clean; 
dbstop if error; 
idx=3;
load psdf;
options = optimoptions(@fmincon,'display','iter-detailed');
options.MaxFunctionEvaluations = 1e5;
options.MaxIterations = 2e3;
options.OptimalityTolerance = 1.000000e-015;
options.StepTolerance = 1.000000e-015;
% options.Algorithm='sqp';
% options.SpecifyObjectiveGradient=true;

plotflag = [1 1 1]; % plot initialized seprate components and peaks/thoughs

% parpool(210);
tic;
[parall,sigall,meta] = scmstepfit(psdall(:,idx),freq(:),options,plotflag);
toc;

save fitrs5_initial psdall sigall parall meta;