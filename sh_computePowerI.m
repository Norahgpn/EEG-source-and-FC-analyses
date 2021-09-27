% sh_computePower() - Compute average power of a signal within a frequency
%                     band using pwelch. Power can be computed for individual
%                     or for predefined frequency bands.
% Usage:
%   >> sh_computePower(Signal, SignalInfo);
%
% Inputs:
%   Signal     - NBT Signal with dimensions [samples x channels]
%   SignalInfo - NBT SignalInfo containing meta-info about Signal
%
% Optional inputs:
%   'type'     - [string] 'psd' for power spectral density or 'power'
%   'bandType' - [string] 'fixed' for psd calculation within the specified
%                frequency band or 'individual' for individual frequency band
%                based on the peak frequency within 'boundaries'. For
%                'individual', 'boundaries' has to be specified.
%   'window'   - [string] window used to compute power spectral density, e.g.,
%                'hanning' or 'hamming'
%   'overlap'  - [integer] overlap of the windows for computing psd
%   'freqband' - [float x float] frequency band to compute the power
%   'boundaries' - [float x float] frequency band for finding the peak
%   'electrodes' - [cell array of strings] electrode labels where peak has
%                  to be computed
%   'bandWidth'  - [float] bandwidth of the individual frequency band.
%                  Individual frequency band is defined as peak frequency
%                  +- bandWidth/2
%
% Outputs:
%   Power       - PowerObject of class sh_Power
%
% Author: Simon J. Houtman, 2019

% Copyright (C) 2019 Simon J. Houtman, simon.houman@gmail.com
%
% This program is intellectual property of the author and is automatically
% protected by the copyright law of the Netherlands (Auteurswet, BWBR0001886).
% Distribution or modification of this program without explicit permission
% of the author is prohibited. If you received this code from the author,
% it may be used for your own purposes.
%
% 2019-04-23 - Added function to shoutman toolbox
% 2019-04-24 - Added functionality to compute power for individual bands
%              based on individual peak frequency within specified boundaries

function [pxx,fxx] = sh_computePowerI(EEG, varargin)
%[pxx_band, SNR] = sh_computePower(EEG, varargin)
    tic
    if nargin < 1
        help sh_computePower
        return
    else
        for argIdx = 1 : 2 : length(varargin)
            eval([varargin{argIdx}, ' = varargin{argIdx+1};']);
        end
    end
    
    if ~exist('type', 'var')
        type = 'psd';
    end
    
    if ~exist('bandType', 'var')
        bandType = 'fixed';
    end
    
    if ~exist('window', 'var')
        window = 'hanning';
    end
    
    if ~exist('overlap', 'var')
        overlap = [];
    end
    
    if ~exist('freqBand', 'var')
        freqBand = [1, 45];
%         freqBand = SignalInfo.frequencyRange;
    end
    
    if ~exist('boundaries', 'var')
        warning(['No boundaries for individual band computation were specified. Using freqBand as boundaries.']);
        boundaries = freqBand;
    end
    
    if ~exist('electrodes', 'var')
        warning(['No electrodes for individual band computation were specified. Using O1 and O2.']);
        electrodes = {'O1', 'O2'};
    end
    
    if ~exist('bandWidth', 'var')
        warning(['No bandWidth for individual band computation was specified. Using bandWidth of ''boundaries''.']);
        bandWidth = boundaries(2) - boundaries(1);
    end
    
    if ~exist('plotMode', 'var')
        plotMode = 0;
    end
    
    disp(['[SH] - Computing ', type, ' for ', bandType, ' frequency range ', num2str(freqBand(1)), ' - ',  num2str(freqBand(2)), ' using a ', window, ' window']);
    
    % Number of channels
    nChannels = size(EEG.data, 1);
    fs = EEG.srate;
    windowSize = 2 ^ nextpow2(fs * 8);
    window = hanning(windowSize);
    nfft = windowSize;
    
    % Compute power spectral density
    pxx = nan((windowSize/2)+1, nChannels);
    for channelIdx = 1 : nChannels
        [pxx(:, channelIdx), fxx] = pwelch(EEG.data(channelIdx, :), window, overlap, nfft, fs, type);
    end
    
    SNR = NaN;
%     if strcmp(bandType, 'fixed')
%         % Compute psd for fixed frequency range
%         pxx_band = mean(pxx(fxx>=freqBand(1)&fxx<=freqBand(2), :), 1);
%         
%         set(0,'defaultAxesFontSize', 16);
%         figure();
%         plot(fxx(fxx>=1 & fxx<=100), 10*log10(pxx(fxx>=1 & fxx<=100, :)));
%         xlabel('Frequency (Hz)', 'FontSize', 20);
%         ylabel('Power/Frequency (dB/Hz)', 'FontSize', 20);
%         title('Power spectrum for all electrodes', 'FontSize', 26);
%         xlim([1, 100]);
%         set(0,'defaultAxesFontSize', 10);
%     elseif strcmp(bandType, 'individual')
%         % Compute psd for individual frequency range based on peak within
%         % predefined boundaries
%         
%         % Find electrode indices
%         electrodeIndices = sh_getElectrodeIndices(EEG.chanlocs, electrodes);
%         
%         % Find peak frequency
%         [PF, IB, SBL, SBR] = sh_findPeakFrequency(pxx, fxx, boundaries, bandWidth, electrodeIndices);
%         pxx_band = mean(pxx(fxx>=IB(1)&fxx<=IB(2), :), 1);
%         
%         % Plot the power spectrum with the individual band, side bands and
%         % peak frequency marked
%         if plotMode == 1
%             sh_plotPowerSpectrum(pxx, fxx, PF, IB, SBL, SBR, electrodeIndices, electrodes);
%         end
%     end
    
%     figure();
%     [topoplotHandle,~,~,~,~,x,y] = sh_topoplot(pxx_band, EEG.chanlocs, 'headrad', 'rim','maplimits',[-3 3],'style','both','numcontour',7,'electrodes','on','circgrid',300,'gridscale',150,'shading','flat');
%     sh_plotColorbar(1, min(pxx_band), max(pxx_band), 7, '');
%     disp(['[SH] - Finished in ', num2str(toc), ' seconds.']);
end