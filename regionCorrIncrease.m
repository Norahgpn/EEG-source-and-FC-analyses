%% Plot three Regions with an incresing size and their closest channels
% by: N. Hagopian
%%
% Set time axes for plots
timeaxes = (EEGstruct.times)/1000;

% using computedistance.m
% Euclidian distance computed between chosen electrodes and every Region seed.

i %keep track of progression
channelnames = {'F7','FC3','Fz'}; %input needs to be cell
[channelsofinterest] = getChannels(allchannels,channelnames);
% Returns structure containing closest atlas region to channels of interest.
closestRegion = computedistance(channelsofinterest,seeds,scouts,vertices);

% Get signals z-scored
scalpsign_z1   = zscore(scalpsignal(closestRegion(1).ChannelIndex,:));
sourcesign_z1  = zscore(sourcesignal(closestRegion(1).RegionIndex,:));
scalpsign_z2   = zscore(scalpsignal(closestRegion(2).ChannelIndex,:));
sourcesign_z2  = zscore(sourcesignal(closestRegion(2).RegionIndex,:));
scalpsign_z3   = zscore(scalpsignal(closestRegion(3).ChannelIndex,:));
sourcesign_z3  = zscore(sourcesignal(closestRegion(3).RegionIndex,:));

% Set time axes
min = 12; max = 15;

% Plot timeseries of a SMALL region with its closest channel
subplot(3,2,[1 2])
plot(timeaxes,scalpsign_z1,timeaxes,sourcesign_z1)
% plot specifications
xlabel('Time (sec)', 'FontSize', 18);
ylabel('z-scored Amplitude', 'FontSize', 18);
title('Timeseries F7', 'FontSize', 22, 'FontWeight', 'normal');
xlim([min max]);ylim([-5 5]);
set(gca, 'box', 'off'); set(gcf,'color', 'w'); %set(gca,'xcolor', 'w');
% Calculate correlation
rho = corr(scalpsign_z1', sourcesign_z1', 'type', 'Spearman');
% Get X and Y range of current window
xLimits = get(gca,'XLim');  %Get the range of the x axis
yLimits = get(gca,'YLim');  %Get the range of the y axis
% Compute positions
xPos = xLimits(1) + 0.1;
yPos = yLimits(2) - 0.5;
% Plot the rho on the graph
text(double(xPos), double(yPos),strcat('rho:',{' '} , num2str(rho)), 'horizontalalignment', 'left');

% Plot timeseries of a MEDIUM region with its closest channel
subplot(3,2,[3 4])
plot(timeaxes,scalpsign_z2,timeaxes,sourcesign_z2)
% plot specifications
xlabel('Time (sec)', 'FontSize', 18);
ylabel('z-scored Amplitude', 'FontSize', 18);
title('Timeseries FC3', 'FontSize', 22, 'FontWeight', 'normal');
xlim([min max]);ylim([-5 5]);
set(gca, 'box', 'off'); set(gcf,'color', 'w'); %set(gca,'xcolor', 'w');
% Calculate correlation
rho = corr(scalpsign_z2', sourcesign_z2', 'type', 'Spearman');
% Get X and Y range of current window
xLimits = get(gca,'XLim');  %Get the range of the x axis
yLimits = get(gca,'YLim');  %Get the range of the y axis
% Compute positions
xPos = xLimits(1) + 0.1;
yPos = yLimits(2) - 0.5;
% Plot the rho on the graph
text(double(xPos), double(yPos),strcat('rho:',{' '} , num2str(rho)), 'horizontalalignment', 'left');

% Plot timeseries of a LARGE region with its closest channel
subplot(3,2,[5 6])
plot(timeaxes,scalpsign_z3,timeaxes,sourcesign_z3)
% plot specifications
xlabel('Time (sec)', 'FontSize', 18);
ylabel('z-scored Amplitude', 'FontSize', 18);
title('Timeseries Fz', 'FontSize', 22, 'FontWeight', 'normal');
xlim([min max]);ylim([-5 5]);
set(gca, 'box', 'off'); set(gcf,'color', 'w'); %set(gca,'xcolor', 'w');
% Calculate correlation
rho = corr(scalpsign_z3', sourcesign_z3', 'type', 'Spearman');
% Get X and Y range of current window
xLimits = get(gca,'XLim');  %Get the range of the x axis
yLimits = get(gca,'YLim');  %Get the range of the y axis
% Compute positions
xPos = xLimits(1) + 0.1;
yPos = yLimits(2) - 0.5;
% Plot the rho on the graph
text(double(xPos), double(yPos),strcat('rho:',{' '} , num2str(rho)), 'horizontalalignment', 'left');


legend({'Channel','Region'},'Location','southeast','FontSize',14)