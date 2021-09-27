function [] = timefreqAnalyses(timeseries,EEG,type,allchannels,scouts)
%
%
%
%
%%
if ~exist('allchannels', 'var')
        allchannels = 0;
end
if ~exist('scouts', 'var')
        scouts = 0;
end

%%
% Plot powerspectra
for i = 1:size(timeseries,1)

    % Define signal
    signal = timeseries(i,:);
    
    % Compute powerspectrum
    [fft,psd] = powerspect(signal,EEG);
    %Plot
    plot(fft, 10*log10(psd));
    xlim([0, 50]);
    xlabel('Frequency (Hz)')%, 'FontSize', 16);
    ylabel('Power/Frequency (dB/Hz)')%, 'FontSize', 16);
    %%%
    if strcmp(type,'c')
        title(strcat('Channel:'," ",allchannels(i).Name,' - ',num2str(i),'/',num2str(size(timeseries,1))));
    elseif strcmp(type,'r')
        title(strcat('Region:'," ",scouts(i).Label,' - ',num2str(i),'/',num2str(size(timeseries,1))));
    end
    %%%
%    hold off
    
    % Wait for button press to run and show next window
    w = waitforbuttonpress;
    if w
        p = get(gcf, 'CurrentCharacter');
    end
end
end

