function XiPi = xp_parameterize(XiPi,varargin)
% XiPi = xp_parameterize(XiPi,varargin) parameterize xi component and pi
% components.This step is not necessary, but it is the demand of
% quantitative EEG.
% Usage: XiPi = xp_parameterize(XiPi,varargin)
% Input
%   XiPi --- XiPi struct. The xp_separateSpec must be run first,which
%   meas that XiPi.separate can not be empty.
% Varargin
%   apEquation : The fitting function of xi(aperiodic) component.
%   peakEquation : The fitting function of pi(periodic) components.
%   scale :  
%   The scale of parameterize,'natural' or 'logarithm'. Its effect is influenced by
%   separate_scale. [defalut:'logarithm']
%   -------------------------------------------------------
%   |   separate_scale |  parameterize_scale |          Note
%   |    'natural'     |     'logarithm'     | xi component -> logarithm scale
%   |   'logarithm'    |     'logarithm'     | parameterize diretly
%   |    'natural'     |      'natural'      | ap/peakEq must be definced
%   |   'logarithm'    |      'natural'      | Not allowed

% Output
%    XiPi --- The XiPi.parameters will be updated.

% Zhihao Zhang, Oct. 15, 2022

    % init XiPi.parameters
    XiPi.parameters = [];

    input = inputParser();
    input.addParameter('ap_equation','offset - log10(x^exponent)',@ischar);
    input.addParameter('peak_equation','power*exp(-((x-center)/bandwidth)^2)',@ischar);
    input.addParameter('scale','logarithm',@ischar);
    input.parse(varargin{:});
    apEquation = input.Results.ap_equation;
    peakEquation = input.Results.peak_equation;
    scale = input.Results.scale;
    XiPi.parameterizeSalce = scale;

    disp(['The apEquation : ',apEquation]);
    disp(['The peakEquation : ',peakEquation]);warning("off")
    disp(['Scale - separate : ',XiPi.separateSalce,' ---->  ','parameterize : ', scale])
    % scale converion 
    sc = scaleConverion (XiPi.separateSalce,scale);
    % parameterize
    for i = 1:size(XiPi.separate.xi,1)
        switch sc
            case 1
                data = log10(XiPi.separate.xi(i,:));
            case 2
                data = XiPi.separate.xi(i,:);
            case 3
                if strcmp(apEquation,"b - log10(x^a)")
                    error("ERROR : apEquation must be specified")
                else
                    data = XiPi.separate.xi(i,:);
                end
            case -1
                error(['ERROR : scale converion error, separate : ',XiPi.separateSalce, ', parameterize : ',scale])
        end
        ap = apFit(XiPi.freq, data, apEquation);
        XiPi.parameters.xi_paras.("spectra_" + num2str(i)) = ap;
    end
    
    channels = fieldnames(XiPi.separate.pi);
    for i = 1 : length(channels)
        currentChannel = channels{i,1};
        parameter = struct;
        for j = 1 : size(XiPi.separate.pi.(currentChannel),1)
            switch sc
                case 1
                    data = XiPi.separate.pi.(currentChannel)(j,:);
                case 2
                    data = XiPi.separate.pi.(currentChannel)(j,:);
                case 3
                    data = XiPi.separate.pi.(currentChannel)(j,:);
                case -1
                    error(['ERROR : scale converion error, separate : ',XiPi.separateSalce, ', parameterize : ',scale])
            end
            peak = peakFit(XiPi.freq, data, peakEquation);
            parameter.("peak_" + num2str(j)) = peak;
        end
        XiPi.parameters.pi_paras.("spectra_" + num2str(i)) = parameter;
    end
    
    % notify
    disp('success! see XiPi.parameters for results')
    warning("on")
    
    % write history
    insertLoc = length(fieldnames(XiPi.history)) + 1;
    XiPi.history.("history_" + num2str(insertLoc)) = 'parameterization';
end

function s = scaleConverion(scale1,scale2)
    if strcmp(scale1,"natural") && strcmp(scale2,"logarithm")
        s = 1;
    elseif strcmp(scale1,"logarithm") && strcmp(scale2,"logarithm")
        s = 2;
    elseif strcmp(scale1,"natural") && strcmp(scale2,"natural")
        s = 3;
    else 
        s = -1;
    end
end