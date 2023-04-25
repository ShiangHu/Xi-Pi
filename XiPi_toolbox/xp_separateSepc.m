function XiPi = xp_separateSepc(XiPi,varargin)
% XiPi = xp_separateSepc(XiPi,varargin) decompose neural power spectral
% into xi component and pi components.
% Usage: XiPi = xp_separateSepc(XiPi,varargin)
% Input
%   XiPi --- XiPi struct. The xp_calculateSpec must be run first,which
%   meas that XiPi.spectra can not be empty.
% Varargin
%   choose_channels : select the specific channels [defult:1 : size(XiPi.spectra,1)]
%   scale : The scale of separating,'natural' or 'logarithm'. If 'natural',
%   the spectra will be separated directly. If 'logarithm', the spectra
%   will be converted into logarithm scale, then separated. [default:'natural']

% Output
%    XiPi --- The XiPi.separate will be updated.

% Zhihao Zhang, Oct. 15, 2022

    % init
    XiPi.separate = [];

    % new saparate spectra struct
    XiPi.separate.xi = [];
    XiPi.separate.pi = struct;
    XiPi.separate.combining = [];

    input = inputParser();
    input.addParameter('choose_channels', 1 : size(XiPi.spectra,1));
    input.addParameter('scale', 'natural',@ischar);
    input.addParameter('settings',[]);
    input.parse(varargin{:});
    channels = input.Results.choose_channels;
    scale = input.Results.scale;
    settings = input.Results.settings;
    XiPi.separateSalce = scale;

    % waitbar
    h = waitbar(0,'processing...');

    % separate spectra. natural
    if  strcmp(scale,'natural')
        for i = channels
            try 
                [overallfitting,components] = scmem_unim(XiPi.freq',XiPi.spectra(i,:)',settings);
                XiPi.separate.xi = [XiPi.separate.xi;components(:,1)'];
                XiPi.separate.pi.("spectra_" + num2str(i)) = components(:,2:end)';
                XiPi.separate.combining = [XiPi.separate.combining;overallfitting'];
            catch
                XiPi.separate.xi = [XiPi.separate.xi;XiPi.spectra(i,:)];
                XiPi.separate.pi.("spectra_" + num2str(i)) = [];
                XiPi.separate.combining = [XiPi.separate.combining;XiPi.spectra(i,:)];
            end
            str = ['running separateSpectra...',num2str(i/length(channels)*100),'%'];
            waitbar(i/length(channels),h,str);
        end
        delete(h)
    end
    % separate spectra. log, scalp eeg
    if  strcmp(scale,'logarithm')
        for i = channels
            try 
            [overallfitting,components] = scmem_unim_log(XiPi.freq',log10(XiPi.spectra(i,:)'),settings);
            catch
                XiPi.separate.xi = [XiPi.separate.xi;zeros(1,length(XiPi.freq))];
                XiPi.separate.pi.("spectra_" + num2str(i)) = [];
                XiPi.separate.combining = [XiPi.separate.combining;zeros(1,length(XiPi.freq))];
            end
            XiPi.separate.xi = [XiPi.separate.xi;components(:,1)'];
            XiPi.separate.pi.("spectra_" + num2str(i)) = components(:,2:end)';
            XiPi.separate.combining = [XiPi.separate.combining;overallfitting'];

            str = ['running separateSpectra...',num2str(i/length(channels)*100),'%'];
            waitbar(i/length(channels),h,str);
        end
        delete(h)
    end

    % notify
    disp('success! see XiPi.separate for results, you can parameterize the components through xp_parameterlize')

    % write history
    insertLoc = length(fieldnames(XiPi.history)) + 1;
    XiPi.history.("history_" + num2str(insertLoc)) = 'separate spectra'; 
end