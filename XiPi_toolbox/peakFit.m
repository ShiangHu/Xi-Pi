function [fitresult, gof] = peakFit(freq, data, peakEquation)

[xData, yData] = prepareCurveData( freq, data );

% Set up fittype and options.
ft = fittype( peakEquation, 'independent', 'x', 'dependent', 'y' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Lower = [-Inf -Inf 0];
opts.Display = 'Off';
% opts.StartPoint = [0.424349039815375 0.460916366028964 0.770159728608609];

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );



