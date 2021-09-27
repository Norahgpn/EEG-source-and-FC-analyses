%% SOURCE RECONSTRUCTION VALIDATION %%
% by: N. Hagopian
%% Figure 1: source-reconstruction control
% Show intuitive validation of signal after source-reconstruction by plotting:
% (A) typical source-region signal
% (B) typical power-spectrum of source-region
% (C) Amplitude envelopes of channel with closest source-region
% (D) Power spectra of channel with closest source-region

% Set time axes for plots
timeaxes = (EEGstruct.times)/1000;

% Set default font for plots
set(0,'defaultAxesFontSize', 14, 'defaultAxesFontName', 'Baskerville');

% A %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
channelnames = {'F7'}; %input needs to be cell
[channelsofinterest] = getChannels(allchannels,channelnames);
closestRegion = computedistance(channelsofinterest,seeds,scouts,vertices);

% plot typical source signal
typicalSourceSignal = sourcesignal(closestRegion.RegionIndex,:);


subplot(3,1,1)
plot(timeaxes, typicalSourceSignal)
% plot specifications
xlabel('Time (sec)', 'FontSize', 18);
ylabel('pA-m', 'FontSize', 18);
title('Timeseries', 'FontSize', 22, 'FontWeight', 'normal');
xlim([8.25 11.25]);
set(gca, 'box', 'off'); set(gcf,'color', 'w'); %set(gca,'xcolor', 'w');

% B %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Convert source signal to EEGLAB format
SignalSource =  typicalSourceSignal; %sourcesignal(closestRegion.RegionIndex,:);    
chanlocsSource = EEGstruct.chanlocs;    fsSource = EEGstruct.srate;
EEGsource = sh_convertToEEG(SignalSource, chanlocsSource, fsSource);
% Get powerspectrum
[pxxSource,fxxSource] = sh_computePowerI(EEGsource, 'plotMode', 0, 'window', 'hanning', 'type', 'power', 'bandType', 'fixed', 'freqBand', [1, 43]);
% Set input plot
sourcePlotX = fxxSource(fxxSource>=1 & fxxSource<=100);
sourcePlotY = 10*log10(pxxSource(fxxSource>=1 & fxxSource<=100, :));

% plot POWERSPECTRUM of typical source signal
subplot(3,1,[2 3])
plot(fxxScalp(fxxScalp>=1 & fxxScalp<=100), 10*log10(pxxScalp(fxxScalp>=1 & fxxScalp<=100, :)));
% plot specification
xlabel('Frequency (Hz)', 'FontSize', 18, 'FontName', 'Baskerville');
ylabel('Power/Frequency (dB/Hz)', 'FontSize', 18);
title('Power spectrum', 'FontSize', 22, 'FontWeight', 'normal');
set(gca, 'box', 'off'); set(gcf,'color', 'w'); 
xlim([1, 50]);
%%

% Set time axes for plots
timeaxes = (EEGstruct.times)/1000;

% C %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% using computedistance.m
% Euclidian distance computed between chosen electrodes and every Region seed.
% Returns structure containing closest atlas region to channels of interest.
% Define channels of interest by name
channelnames = {'FC3'}; %input needs to be cell
[channelsofinterest] = getChannels(allchannels,channelnames);
closestRegion = computedistance(channelsofinterest,seeds,scouts,vertices);

% Get signals z-scored
scalpsign_z   = zscore(scalpsignal(closestRegion.ChannelIndex,:));
sourcesign_z  = zscore(sourcesignal(closestRegion.RegionIndex,:));
% Calculate Amplitude envelopes with absolute Hilbert transform
env_scalp   = abs(hilbert(scalpsign_z));
env_source  = abs(hilbert(sourcesign_z));

% Set time axes
min = 8.25; max = 11.25;

% Plot
figure();
subplot(3,1,1)
plot(timeaxes,env_scalp,timeaxes,env_source)
% plot specifications
xlabel('Time (sec)', 'FontSize', 18);
ylabel('z-scored Amplitude', 'FontSize', 18);
title('Amplitude envelopes', 'FontSize', 22, 'FontWeight', 'normal');
xlim([min max]);ylim([-1 4]);
set(gca, 'box', 'off'); set(gcf,'color', 'w'); %set(gca,'xcolor', 'w');
% Calculate correlation
minx = find(timeaxes==min); maxx = find(timeaxes==max);
rho = corr(env_scalp(minx:maxx)', env_source(minx:maxx)', 'type', 'Spearman');
% Get X and Y range of current window
xLimits = get(gca,'XLim');  %Get the range of the x axis
yLimits = get(gca,'YLim');  %Get the range of the y axis
% Compute positions
xPos = xLimits(1) + 0.1;
yPos = yLimits(2) - 0.5;
% Plot the rho on the graph
text(double(xPos), double(yPos),strcat('rho:',{' '} , num2str(rho)), 'horizontalalignment', 'left');

legend({'Channel','Region'},'Location','southeast','FontSize',14)

% D %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Convert source signal to EEGLAB format
SignalSource =  sourcesign_z; %sourcesignal(closestRegion.RegionIndex,:);    
chanlocsSource = EEGstruct.chanlocs;    fsSource = EEGstruct.srate;
EEGsource = sh_convertToEEG(SignalSource, chanlocsSource, fsSource);
% Get powerspectrum
[pxxSource,fxxSource] = sh_computePowerI(EEGsource, 'plotMode', 0, 'window', 'hanning', 'type', 'power', 'bandType', 'fixed', 'freqBand', [1, 43]);
% Set input plot
sourcePlotX = fxxSource(fxxSource>=1 & fxxSource<=100);
sourcePlotY = 10*log10(pxxSource(fxxSource>=1 & fxxSource<=100, :));

% Convert scalp signal to EEGLAB format
SignalScalp = scalpsign_z; %scalpsignal(closestRegion.ChannelIndex,:);    
chanlocsScalp = EEGstruct.chanlocs;    fsScalp = EEGstruct.srate;
EEGscalp = sh_convertToEEG(SignalScalp, chanlocsScalp, fsScalp);
% Get powerspectrum
[pxxScalp,fxxScalp] = sh_computePowerI(EEGscalp, 'plotMode', 0, 'window', 'hanning', 'type', 'power', 'bandType', 'fixed', 'freqBand', [1, 43]);
% Set input plot
scalpPlotX = fxxScalp(fxxScalp>=1 & fxxScalp<=100);
scalpPlotY = 10*log10(pxxScalp(fxxScalp>=1 & fxxScalp<=100, :));

% plot POWERSPECTRUM of typical source signal
subplot(3,1,[2 3])
plot(scalpPlotX,scalpPlotY,sourcePlotX,sourcePlotY);
% plot specification
xlabel('Frequency (Hz)', 'FontSize', 18, 'FontName', 'Baskerville');
ylabel('z-scored Power/Frequency (dB/Hz)', 'FontSize', 18);
title('Power spectrum', 'FontSize', 22, 'FontWeight', 'normal');
set(gca, 'box', 'off'); set(gcf,'color', 'w'); 
xlim([1, 50]);

        % Calculate correlation
        rho = corr(pxxScalp, pxxSource, 'type', 'Spearman');
        % Get X and Y range of current window
        xLimits = get(gca,'XLim');  %# Get the range of the x axis
        % Compute positions
        xPos = xLimits(1) + 1;
        yPos = yLimits(2) - 0.5;
        % Plot the rho on the graph
        text(double(xPos), double(yPos),strcat('rho:',{' '} , num2str(rho)), 'horizontalalignment', 'left');
        hold off


%% Figure 2: Unmixing from scalp to source - Data driven
% A %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Histogram inter-channel

% B %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Histogram inter-region

%% Figure 3: Unmixing from scalp to source - Hypothesis driven
% A %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Boxplot inter-channel

% B %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Boxplot inter-region

