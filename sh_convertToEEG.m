function EEG = sh_convertToEEG(Signal, chanlocs, fs)
    if size(Signal, 2) > size(Signal, 1)
        warning('Signal is flipped. Insert signal with dimensions <channels x samples>.');
    end
    
    % Create empty EEG set
    EEG = eeg_emptyset;
    
    % Fill up EEG set
    EEG.data = Signal;
    EEG.nbchan = size(Signal, 1);
    EEG.trials = 1;
    EEG.pnts = size(Signal, 2);
    EEG.srate = fs;
    EEG.xmin = 0;
    EEG.xmax = (size(Signal, 2) / fs) - (1 / fs);
    EEG.chanlocs = chanlocs;
end
    