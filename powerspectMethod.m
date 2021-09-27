%% Compute Powerspectrum of signal(s)
% Using Simon Houtman's powerpsectrum scripts

%% Convert signal to EEGLAB format
Signal   = sourcesignal;
chanlocs = EEGstruct.chanlocs;
fs       = EEGstruct.srate;

EEG = sh_convertToEEG(Signal, chanlocs, fs);

%% Calculate power & plot powerspectrum
[pxx,fxx] = sh_computePowerI(EEG, 'plotMode', 0, 'window', 'hanning', 'type', 'power', 'bandType', 'fixed', 'freqBand', [1, 43]);
%%
set(0,'defaultAxesFontSize', 16);
figure();
plot(fxx(fxx>=1 & fxx<=100), 10*log10(pxx(fxx>=1 & fxx<=100, :)));
xlabel('Frequency (Hz)', 'FontSize', 20);
ylabel('Power/Frequency (dB/Hz)', 'FontSize', 20);
title('Power spectrum for all electrodes', 'FontSize', 26);
xlim([1, 50]);
set(0,'defaultAxesFontSize', 10);