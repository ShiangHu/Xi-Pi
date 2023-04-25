function options = option
% set optimoptions for fmincon, fminunc

options = optimoptions(@fmincon,'display','notify-detailed');
options.MaxFunctionEvaluations = 5e4;
options.MaxIterations = 1e4;
options.OptimalityTolerance = 1e-015;
options.StepTolerance = 1e-015;
options.SpecifyObjectiveGradient=true;
% options.DerivativeCheck = 'on';
% options.Diagnostics = 'on';

end