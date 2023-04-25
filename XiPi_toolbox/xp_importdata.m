function XiPi = xp_importdata(EEG)
% XiPi = xp_importdata(EEG) load/import EEG data using EEGLAB and convert to XiPi struct.
% Usage: XiPi = xp_importdata(EEG) / XiPi = xp_importdata([])
% Input
%   EEG --- The EEG struct using EEGLAB, if is empty,choose the .set file
%   to load/import data.

% Output
%    XiPi --- Initialized XiPi struct

% Zhihao Zhang, Oct. 15, 2022
% See also pop_loadset

    % use EEGLAB import set function.
 
    if isempty(EEG)   
        try 
            eeglab nogui
        catch
            error("ERROR : Please addpath [eeglab location]")
        end
        EEG = pop_loadset();
    end

    % new struct
    XiPi = struct();

    XiPi.filename = EEG.filename;
    XiPi.filepath = EEG.filepath;
    XiPi.nbchan = EEG.nbchan;
    XiPi.srate = EEG.srate;
    XiPi.data = EEG.data;
    XiPi.spectra = [];
    XiPi.parameters = struct;
    XiPi.history = struct;
    XiPi.separate = struct;
    
    % write history
    insertLoc = length(fieldnames(XiPi.history)) + 1;
    XiPi.history.("history_" + num2str(insertLoc)) = 'importdata';
    clearvars -except XiPi
end


