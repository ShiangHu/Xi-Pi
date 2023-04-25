function XiPi = xp_calculateSpec(XiPi,time_range,limited_freq,varargin)
% xp_calculateSpec calculates the spectral matrix with pwelch method.

% Usage: XiPi = xp_calculateSpec(XiPi,[1 30],50,'select_chan',[1 2])
% Input
%   XiPi --- Initialized XiPi struct
%   time_range --- Intercept from the original data according to time_range
%   limited_freq --- calculate spectrum in [0 - limited_freq] Hz
% Varargin
%   select_chan : select the specific channels [defult:[1:XiPi.nbchan]]
%   window_size : welch's method window_size [defult:XiPi.srate]
%   overlapping : welch's method overlapping [defult:XiPi.srate/2]
%   freqResolution : frequency resolution [defult:0.5]
% Output
%    XiPi --- the XiPi.spectra and XiPi.history will be updated.

% Zhihao Zhang, Oct. 15, 2022
% See also pwelch

    % init XiPi.spectra
    XiPi.spectra = [];
    
    % acq parameters
    input = inputParser();
    input.addParameter('select_chan',1:XiPi.nbchan);
    input.addParameter('window_size',XiPi.srate*2,@isscalar);
    input.addParameter('overlapping',XiPi.srate,@isscalar);
    input.addParameter('freqResolution',0.5,@isscalar);
    input.parse(varargin{:});

    select_chan = input.Results.select_chan;
    window_size = input.Results.window_size;
    overlapping = input.Results.overlapping;
    freqResolution = input.Results.freqResolution;

    % default paras
    if isempty(XiPi)
        error('Import data first, and init XiPi struct')
    end

    if isempty(time_range)
        time_range = [0 size(XiPi.data,2) / XiPi.srate];
    end
    if isempty(limited_freq)
        if XiPi.srate > 100
            limited_freq = 50;
        else 
            error('Limited_freq is neccessary');
        end
    end
    if XiPi.srate / freqResolution < window_size
        warning('WARNING : The FFT < window_size,which will casue information loss')
    end
    % calculate specdata - pwelch
    startTime = time_range(1);
    endTime = time_range(2);
    data = XiPi.data(select_chan,startTime * XiPi.srate + 1: endTime* XiPi.srate);
    [pxx,f] = pwelch(data',hamming(window_size),overlapping,XiPi.srate / freqResolution,XiPi.srate);
    spectra = pxx';
    freq = f';
    XiPi.freq = freq(2:limited_freq / freqResolution + 1);
    XiPi.spectra = spectra(:,2:limited_freq / freqResolution + 1);

    % notify
    disp('success! see XiPi.spectra for results')
    
    % write history
    insertLoc = length(fieldnames(XiPi.history)) + 1;
    XiPi.history.("history_" + num2str(insertLoc)) = 'calculate spectra';
end