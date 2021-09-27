function [] = signalplot(scalpsignal,sourcesignal,timeaxes,closestRegion,type,fftScalp,psdScalp,fftSource,psdSource)
% Plots displaying the results of 6 different data analyses
% by: N.Hagopian
% The variable "type" indicates which of the analyses should be executed
%
if ~exist('fftScalp', 'var')
        fftScalp = 0;
end
if ~exist('psdScalp', 'var')
        psdScalp = 0;
end
if ~exist('fftSource', 'var')
        fftSource = 0;
end
if ~exist('fftSource', 'var')
        fftSource = 0;
end

%% Plot channel signals next to (averaged) closest region signal and overlapping
if type == 1
    %for the subplot positioning
    row1 = 1:3:15; row2 = 2:3:15; row3 = 3:3:15;

    xlimits = 0:10:max(timeaxes);

    for j = 1:length(xlimits)
        for i = 1:5
            subplot(5,3,row1(i))
            plot(timeaxes,scalpsignal(closestRegion(i).ChannelIndex,:))
            xlim([xlimits(j) xlimits(j+1)])
            title(strcat(closestRegion(i).Channels));
            xlabel('time in sec'); ylabel('electric potential in mV');

            subplot(5,3,row2(i))
            plot(timeaxes, sourcesignal(closestRegion(i).RegionIndex,:))
            xlim([xlimits(j) xlimits(j+1)]);
            title(strcat(closestRegion(i).Region));
            xlabel('time in sec'); ylabel('current-density in pA');

            subplot(5,3,row3(i))
            plot(timeaxes,scalpsignal(closestRegion(i).ChannelIndex,:),timeaxes, (sourcesignal(closestRegion(i).RegionIndex,:))*10^11)
            xlim([xlimits(j) xlimits(j+1)]);
            legend('Channel','Region *10^1^1')
            xlabel('time in sec');
        end

        header = sgtitle('Channels (scalp-space signal)                                                 Closest Region (source-space signal)                                                 Channel &  closest Region signal');
        header.FontSize = 15;

        w = waitforbuttonpress;
        if w
            p = get(gcf, 'CurrentCharacter');
        end
    end
end

%% Plot from 1 channel the Z-scored signal overlapping (averaged) closest region signal including Correlation between signals
if type == 2
    xlimits = 0:5:max(timeaxes);

    for j = 1:length(xlimits)
            % Get signals of chosen channel defined by i
            i = 1;
            scalpsignal_i   = scalpsignal(closestRegion(i).ChannelIndex,:);
            sourcesignal_i  = sourcesignal(closestRegion(i).RegionIndex,:);

            % Calculate z-scored signals
            zscore_scalp    = zscore(scalpsignal_i);
            zscore_source   = zscore(sourcesignal_i);
            % Plot signals
            plot(timeaxes,zscore_scalp, timeaxes,zscore_source)
            xlim([xlimits(j) xlimits(j+1)]); ylim([-5 5]);
            legend('Channel','Region')
            xlabel('time in sec');

            % Calculate correlation
            minx = find(timeaxes==(xlimits(j))); maxx = find(timeaxes==(xlimits(j+1)));
            rho = corr(scalpsignal_i(minx:maxx)', sourcesignal_i(minx:maxx)', 'type', 'Spearman');
            % Get X and Y range of current window
            xLimits = get(gca,'XLim');  %# Get the range of the x axis
            yLimits = get(gca,'YLim');  %# Get the range of the y axis
            % Compute positions
            xPos = xLimits(1) + 0.1;
            yPos = yLimits(2) - 0.5;
            % Plot the rho on the graph
            text(double(xPos), double(yPos),strcat('rho:',{' '} , num2str(rho)), 'horizontalalignment', 'left');

            % Wait for button press to run and show next window
            w = waitforbuttonpress;
            if w
                p = get(gcf, 'CurrentCharacter');

        end
    end
end

%% Plot from channel and second neighbors the Z-scored signal overlapping (averaged) closest region signal including Correlation between signals
if type == 3
    % PLOT Neighboring channels with their closest regions
    xlimits = 0:5:max(timeaxes);
    
    for j = 1:length(xlimits)
        for i = 1:3
            scalpsignal_i   = scalpsignal(closestRegion(i).ChannelIndex,:);
            sourcesignal_i  = sourcesignal(closestRegion(i).RegionIndex,:);

            % Calculate z-scored signals
            zscore_scalp    = zscore(scalpsignal_i);
            zscore_source   = zscore(sourcesignal_i);

            % Plot signals
            subplot(3,1,i)
            plot(timeaxes,zscore_scalp, timeaxes,zscore_source)
            xlim([xlimits(j) xlimits(j+1)]); ylim([-5 5]);
            title(strcat(closestRegion(i).Channels,' - ',closestRegion(i).Region));
            legend('Channel','Region')
            xlabel('time in sec');

            % Calculate correlation
            minx = find(timeaxes==(xlimits(j))); maxx = find(timeaxes==(xlimits(j+1)));
            rho = corr(scalpsignal_i(minx:maxx)', sourcesignal_i(minx:maxx)', 'type', 'Spearman');
            % Get X and Y range of current window
            xLimits = get(gca,'XLim');  %# Get the range of the x axis
            yLimits = get(gca,'YLim');  %# Get the range of the y axis
            % Compute positions
            xPos = xLimits(1) + 0.1;
            yPos = yLimits(2) - 0.5;
            % Plot the rho on the graph
            text(double(xPos), double(yPos),strcat('rho:',{' '} , num2str(rho)), 'horizontalalignment', 'left');

        end

        header = sgtitle('Channel - closest Region');
        header.FontSize = 15;

        % Wait for button press to run and show next window
        w = waitforbuttonpress;
        if w
            p = get(gcf, 'CurrentCharacter');
        end
    end
end

%% Plot from one channel the Z-scored signal overlapping (averaged) closest, 2nd and 3d region signal including Correlation between signals
if type == 4
    % PLOT one channel with 1st, 2nd and 3d closest region
    xlimits = 0:5:max(timeaxes);
    
    for j = 1:length(xlimits)
        for i = 1:3
            scalpsignal_i   = scalpsignal(closestRegion.ChannelIndex,:);
            sourcesignal_i  = sourcesignal(closestRegion.RegionIndex(i),:);

            % Calculate z-scored signals
            zscore_scalp    = zscore(scalpsignal_i);
            zscore_source   = zscore(sourcesignal_i);

            % Plot signals
            subplot(3,1,i)
            plot(timeaxes,zscore_scalp, timeaxes,zscore_source)
            xlim([xlimits(j) xlimits(j+1)]); ylim([-5 5]);
            if i == 1
                label = closestRegion.Region;
            elseif i == 2
                label = closestRegion.secondRegion;
            elseif i == 3
                label = closestRegion.thirdRegion;
            end
            title(strcat(closestRegion.Channels,' - ',label));
            legend('Channel','Region')
            xlabel('time in sec');

            % Calculate correlation
            minx = find(timeaxes==(xlimits(j))); maxx = find(timeaxes==(xlimits(j+1)));
            rho = corr(zscore_scalp(minx:maxx)', zscore_source(minx:maxx)', 'type', 'Spearman');
            % Get X and Y range of current window
            xLimits = get(gca,'XLim');  %# Get the range of the x axis
            yLimits = get(gca,'YLim');  %# Get the range of the y axis
            % Compute positions
            xPos = xLimits(1) + 0.1;
            yPos = yLimits(2) - 0.5;
            % Plot the rho on the graph
            text(double(xPos), double(yPos),strcat('rho:',{' '} , num2str(rho)), 'horizontalalignment', 'left');

        end

        header = sgtitle('Channel - closest Region');
        header.FontSize = 15;

        % Wait for button press to run and show next window
        w = waitforbuttonpress;
        if w
            p = get(gcf, 'CurrentCharacter');
        end
    end
end

%% Plot timeries and power-spectra of different neigbouring and further away channels and region to investigate the role of Volume Conduction.
if type == 5
    % PLOT Neighboring channels with their closest regions
    xlimits = 0:3:max(timeaxes);
    for j = 1:length(xlimits)
        for i = 1:length(closestRegion)
            % Set curent channel and region
            channel	= closestRegion(i).Channels;
            region  = closestRegion(i).Region;                          %%% CHANGE FOR DIFFERENT REGION %%%
            % Get index number of channel and region from the name
            channelnum = closestRegion(i).ChannelIndex;
            regionnum  = closestRegion(i).RegionIndex(1);               %%% CHANGE FOR DIFFERENT REGION %%%
            % Get signal of current channel and region
            scalpsignal_i   = scalpsignal(channelnum,:);
            sourcesignal_i  = sourcesignal(regionnum,:);
            % Calculate z-scored signals
            zscore_scalp    = zscore(scalpsignal_i);
            zscore_source   = zscore(sourcesignal_i);
            % If i is not 1, set previous channel and region variables
            if i > 1
                % Variables for previous channel and region signals
                prevchannel = closestRegion(i-1).Channels;
                prevregion  = closestRegion(i-1).Region;                %%% CHANGE FOR DIFFERENT REGION %%%
                prevchannelnum = closestRegion(i-1).ChannelIndex;
                prevregionnum  = closestRegion(i-1).RegionIndex(1);      %%% CHANGE FOR DIFFERENT REGION %%%
                scalpsignalprev_i   = scalpsignal(prevchannelnum,:);
                sourcesignalprev_i  = sourcesignal(prevregionnum,:);
                % Calculate z-scored signals
                zscore_scalpprev    = zscore(scalpsignalprev_i);
                zscore_sourceprev   = zscore(sourcesignalprev_i);
            end
            
            region2         = closestRegion(i).secondRegion; 
            region3         = closestRegion(i).thirdRegion; 
            sourcesignal2   = scalpsignal(closestRegion(i).RegionIndex(2),:);
            sourcesignal3   = scalpsignal(closestRegion(i).RegionIndex(3),:);
            zscore_source2  = zscore(sourcesignal2);
            zscore_source3  = zscore(sourcesignal3);
    

            % PLOT SCALP SIGNALS
            subplot(3,1,1)
            %%% line color
            c1 = gca;
            if i == 1
                c1.ColorOrderIndex = 1; 
            else
                c1.ColorOrderIndex = 2;
            end
            %%%
            plot(timeaxes,zscore_scalp)
            xlim([xlimits(j) xlimits(j+1)]); ylim([-5 5]);
            ylabel('Amplitude (z-scored)','FontSize',14);
            title('Scalp-signals from chosen channels','FontSize',14);
            %%% legend
            if i == 1
                legend(channel) 
            else
                legend(prevchannel,channel)
            end
            %%%
            set(gca, 'box', 'off'); set(gcf,'color','w'); set(gca,'xcolor','w');
            hold on
            if i > 1 
            % Calculate correlation for source signals
            minx = find(timeaxes==(xlimits(j))); maxx = find(timeaxes==(xlimits(j+1)));
            % Calculate correlation for source signals
            rho = corr(zscore_scalpprev(minx:maxx)', zscore_scalp(minx:maxx)', 'type', 'Spearman');
            % Get X and Y range of current window
            xLimits = get(gca,'XLim');  %# Get the range of the x axis
            yLimits = get(gca,'YLim');  %# Get the range of the y axis
            % Compute positions
            xPos = xLimits(1) + 0.1;
            yPos = yLimits(2) - 0.5;
            % Plot the rho on the graph
            text(double(xPos), double(yPos),strcat('rho:',{' '} , num2str(rho)), 'horizontalalignment', 'left');
            end
            
            % PLOT SOURCE SIGNALS
            subplot(3,1,2)
            %%% line color
            c2 = gca;
            if i == 1
                c2.ColorOrderIndex = 1;
            else
                c2.ColorOrderIndex = 2;
            end
            %%%
            plot(timeaxes,zscore_source)
            xlim([xlimits(j) xlimits(j+1)]); ylim([-5 5]);
            xlabel('time (sec)','FontSize',14); ylabel('Amplitude (z-scored)','FontSize',14);
            title('Source-signals of closest Regions from channels','FontSize',14);
            %%% legend
            if i == 1
                legend(region) 
            else
                legend(prevregion,region)
            end
            %%%
            set(gca, 'box', 'off'); %set(gca,'xcolor','w');
            hold on
            if i > 1
            % Calculate correlation for source signals
            rho = corr(zscore_sourceprev(minx:maxx)', zscore_source(minx:maxx)', 'type', 'Spearman');
            % Plot the rho on the graph
            text(double(xPos), double(yPos),strcat('rho:',{' '} , num2str(rho)), 'horizontalalignment', 'left');
            end
            
            hold on
            
            % PLOT OVERLAYING REGION SOURCE SIGNALS
            subplot(3,1,3)
            plot(timeaxes,zscore_source,timeaxes,zscore_source2,timeaxes,zscore_source3)
            xlim([xlimits(j) xlimits(j+1)]); ylim([-5 5]);
            xlabel('time (sec)','FontSize',14); ylabel('Amplitude (z-scored)','FontSize',14);
            title('Source-signals of first, second & third closest Regions','FontSize',14);
            % legend
            legend(region,region2,region3)
            set(gca, 'box', 'off');
            % Calculate correlation for source signals
            minx = find(timeaxes==(xlimits(j))); maxx = find(timeaxes==(xlimits(j+1)));
            % Calculate correlation for source signals
            rho = corrcoef([zscore_source(minx:maxx)', zscore_source2(minx:maxx)', zscore_source3(minx:maxx)'], 'Rows','pairwise');
            rho(rho==1) = [];
            % Get X and Y range of current window
            xLimits = get(gca,'XLim');  %# Get the range of the x axis
            yLimits = get(gca,'YLim');  %# Get the range of the y axis
            % Compute positions
            xPos = xLimits(1) + 0.1;
            yPos = yLimits(2) - 0.5;
            % Plot the rho on the graph
            text(double(xPos), double(yPos),strcat('rho:',{' '} , num2str(unique(rho,'stable'))), 'horizontalalignment', 'left');       
    
        end

        % Wait for button press to run and show next window
        w = waitforbuttonpress;
        if w
            p = get(gcf, 'CurrentCharacter');
        end
        
    end
end 
%% Plot timeseries, amplitude envelopes and power-spectra of one channel with it's closest region in one Figure.
if type == 6
 % PLOT Neighboring channels with their closest regions
    xlimits = 0:3:max(timeaxes);
    
    % Z-scored signals
    zscore_scalp    = scalpsignal;%zscore(scalpsignal);
    zscore_source   = sourcesignal;%zscore(sourcesignal);
    % Calculate Amplitude envelopes with absolute Hilbert transform
    env_scalp   = abs(hilbert(zscore_scalp));
    env_source  = abs(hilbert(zscore_source));
    
    % Add image
    img = imread('/Users/norahagopian/Documents/Universiteit/Master_CN2/Master_thesis/Research_Project_I/Figures/channels.png');
    img = imrotate(img,180);
    
    for j = 1:length(xlimits)
        
        % Plot signals (timeseries)
        subplot(2,5,[1 2 3])
        plot(timeaxes,zscore_scalp,timeaxes,zscore_source)
        xlim([xlimits(j) xlimits(j+1)]); ylim([-5 5]);
        set(gca, 'box', 'off'); set(gcf,'color','w'); set(gca,'xcolor','w');
        legend({'Channel','Region'},'Location','southeast','FontSize',14)
        ylabel('Amplitude (z-scored)','FontSize',14);
        title('Timeseries','FontSize', 16);
        % Calculate correlation
        minx = find(timeaxes==(xlimits(j))); maxx = find(timeaxes==(xlimits(j+1)));
        rho = corr(zscore_scalp(minx:maxx)', zscore_source(minx:maxx)', 'type', 'Spearman');
        % Get X and Y range of current window
        xLimits = get(gca,'XLim');  %Get the range of the x axis
        yLimits = get(gca,'YLim');  %Get the range of the y axis
        % Compute positions
        xPos = xLimits(1) + 0.1;
        yPos = yLimits(2) - 0.5;
        % Plot the rho on the graph
        text(double(xPos), double(yPos),strcat('rho:',{' '} , num2str(rho)), 'horizontalalignment', 'left');

        % Plot amplitude envelopes
        subplot(2,5,[6 7 8])
        plot(timeaxes,env_scalp,timeaxes,env_source)
        set(gca, 'box', 'off');
        xlim([xlimits(j) xlimits(j+1)]); ylim([0 5]); ylim([-1 5]);
        xlabel('time (sec)','FontSize',14); ylabel('Amplitude (z-scored)','FontSize',14);
        title('Amplitude envelopes','FontSize', 16);
        % Calculate correlation
        rho = corr(env_scalp(minx:maxx)', env_source(minx:maxx)', 'type', 'Spearman');
        % Plot the rho on the graph
        text(double(xPos), double(yPos),strcat('rho:',{' '} , num2str(rho)), 'horizontalalignment', 'left');
        
        % Plot powerspectra
        subplot(2,5,[4 5 9 10])
        plot(fftScalp, 10*log10(psdScalp), fftSource, 10*log10(psdSource));
        set(gca, 'box', 'off');
        xlim([0, 50]);
        xlabel('Frequency (Hz)', 'FontSize', 14);
        ylabel('Power/Frequency (dB/Hz)','FontSize',14);
        title('Power-spectra','FontSize', 16);
        % Plot image
        hold on
        yLimits = get(gca,'YLim');  % Get the range of the y axis
        image('CData',img,'XData',[22 52],'YData',[(yLimits(2)-20) yLimits(2)])
%       hold on
%       center=size(img)/2+.5; xim = center(1); yim = center(2);
%       plot(xim,yim,'o','linewidth',2)
%       hold off
        ylim(yLimits)
        % Calculate correlation
        rho = corr(psdScalp, psdSource, 'type', 'Spearman');
        % Get X and Y range of current window
        xLimits = get(gca,'XLim');  %# Get the range of the x axis
        % Compute positions
        xPos = xLimits(1) + 1;
        yPos = yLimits(2) - 0.5;
        % Plot the rho on the graph
        text(double(xPos), double(yPos),strcat('rho:',{' '} , num2str(rho)), 'horizontalalignment', 'left');
        hold off
        
        % Wait for button press to run and show next window
        w = waitforbuttonpress;
        if w
            p = get(gcf, 'CurrentCharacter');
        end
    end
end

end