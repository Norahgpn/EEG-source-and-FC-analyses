% by: N.Hagopian
%% PREPARATIONS %% --> SEE: prepareData.m <--
% Run preparations before following with this script: prepareData.m

%% COMPUTE DISTANCE %%

% using computedistance.m
% Euclidian distance computed between chosen electrodes and every Region seed.
% Returns structure containing closest atlas region to channels of interest.

% [closestRegion] = computedistance(channelsofinterest,seeds,scouts,vertices);


%% PLOTTING %% 
%% PLOT channel signals next to (averaged) closest region signal and overlapping
% Plot channel timeseries with closest region timeseries
% Define channels of interest by name
channelnames = {'Cz', 'Fpz', 'Iz', 'T8', 'T7'}; %input needs to be cell
[channelsofinterest] = getChannels(allchannels,channelnames);
% Compute distance
[closestRegion] = computedistance(channelsofinterest,seeds,scouts,vertices);
timeaxes = (EEGstruct.times)/1000;
signalplot(scalpsignal,sourcesignal,timeaxes,closestRegion,1);

%% PLOT from 1 channel the Z-scored signal overlapping (averaged) closest region signal including Correlation between signals
% Plot channel timeseries with closest region timeseries
% Define channels of interest by name
channelnames = {'Cz', 'Fpz', 'Iz', 'T8', 'T7'}; %input needs to be cell
[channelsofinterest] = getChannels(allchannels,channelnames);
% Compute distance
[closestRegion] = computedistance(channelsofinterest,seeds,scouts,vertices);
% Plot
timeaxes = (EEGstruct.times)/1000;
signalplot(scalpsignal,sourcesignal,timeaxes,closestRegion,2);

%% PLOT from channel and second neighbors the Z-scored signal overlapping (averaged) closest region signal including Correlation between signals
% Define channels of interest by name
channelnames = {'Cz', 'C3', 'C4'}; %input needs to be cell
[channelsofinterest] = getChannels(allchannels,channelnames);
% Compute distance
[closestRegion] = computedistance(channelsofinterest,seeds,scouts,vertices);
% Plot
timeaxes = (EEGstruct.times)/1000;
signalplot(scalpsignal,sourcesignal,timeaxes,closestRegion,3);

%% PLOT from one channel the Z-scored signal overlapping (averaged) closest, 2nd and 3d region signal including Correlation between signals
% Define channels of interest by name
channelnames = {'F4'}; %input needs to be cell
[channelsofinterest] = getChannels(allchannels,channelnames);
% Compute diastance
[closestRegion] = computedistance(channelsofinterest,seeds,scouts,vertices,1);
% Plot
timeaxes = (EEGstruct.times)/1000;
signalplot(scalpsignal,sourcesignal,timeaxes,closestRegion,4);

%% Plot timeries of different neigbouring and further away channels and region & overlay different regions
% to inspect the influence of Volume Conduction
timeaxes = (EEGstruct.times)/1000;
% Define channel of interest by name (here: one channel)
channelnames = {'F2','C2'}; %input needs to be cell string
[channelsofinterest] = getChannels(allchannels,channelnames);
% Compute distance
[closestRegion] = computedistance(channelsofinterest,seeds,scouts,vertices,1);
% Plot
signalplot(scalpsignal,sourcesignal,timeaxes,closestRegion,5);



%% TIME FREQUENCY ANALYSES %%

%% Plot power-spectrum of sensor-signals from all channels
timefreqAnalyses(scalpsignal,EEGstruct,'c',allchannels)

%% Plot power-spectrum of source-signals from all regions 
timefreqAnalyses(sourcesignal,EEGstruct,'r',0,scouts)

%% Plot timeseries, amplitude envelopes and power-spectra of one channel with it's closest region in one Figure.
timeaxes = (EEGstruct.times)/1000;

% Define channel of interest by name (here: one channel)
channelnames = {'Fz'}; %input needs to be cell string
[channelsofinterest] = getChannels(allchannels,channelnames);
% Compute distance
[closestRegion] = computedistance(channelsofinterest,seeds,scouts,vertices);
% Compute power-spectra
scalpsign_z   = zscore(scalpsignal(closestRegion.ChannelIndex,:));
sourcesign_z  = zscore(sourcesignal(closestRegion.RegionIndex,:));
[fftScalp, psdScalp]   = powerspect(scalpsign_z,EEGstruct);
[fftSource,psdSource]  = powerspect(sourcesign_z,EEGstruct);

Region = closestRegion.Region
rhoSignal = corr(scalpsign_z',sourcesign_z','type', 'Spearman')
% Plot
signalplot(scalpsign_z,sourcesign_z,timeaxes,closestRegion,6,fftScalp,psdScalp,fftSource,psdSource);

