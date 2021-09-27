%% Compute weighted phase lag index (wPLI) connectivity 
% by: N. Hagopian
function wpli = computeWPLI(Signal)
    if size(Signal, 1) < size(Signal, 2)
        error('Signal is flipped.');
    end
    
    % Get number of channels
    nChannels = size(Signal, 2);
    
    % Compute phase of the signal
    phaseSignal = angle(hilbert(Signal));
     
    % Compute weighted phase lag index
    wpli = nan(nChannels, nChannels);
    for channel1 = 1 : nChannels-1
        %channel1
        for channel2 = channel1 + 1 : nChannels
            phasedifference = sin(phaseSignal(channel1, :)-phaseSignal(channel2, :));
            wpli(channel1, channel2) = abs(mean(abs(phasedifference).*sign(phasedifference))/mean(abs(phasedifference)));
        end
    end
end