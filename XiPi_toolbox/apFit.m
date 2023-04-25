function [fitresult, gof] = apFit(freq, data, apEquation)

[xData, yData] = prepareCurveData( freq, data );

% Set up fittype and options.
ft = fittype( apEquation, 'independent', 'x', 'dependent', 'y' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
% opts.StartPoint = [0.460916366028964 0.770159728608609];

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );

