%% Plot Histogram of inter-channel and inter-region connectivity of all signals from all subjects.
% by: N. Hagopian
%% Get scalp- and region-signals of all subjects

% Index all recordings in the folder with clean files
cd('/Volumes/Nora_files/Clean_256Hz_AvgRef_sphericalInterp_broadBand/BAMBI/ASD');
allRecordings1 = sh_rdir(pwd, {'.set', 'ECR'}, {'analysis', 'info'}, 1);
cd('/Volumes/Nora_files/Clean_256Hz_AvgRef_sphericalInterp_broadBand/SPACE/ASD');
allRecordings2 = sh_rdir(pwd, {'.set', 'ECR'}, {'analysis', 'info'}, 1);
allRecordings = horzcat(allRecordings1, allRecordings2);
clear allRecordings1 allRecordings2

% get Atlas using getAtlas.m & source-space timeseries downsampled to Atlas regions
cd('/Users/norahagopian/Documents/Universiteit/Master_CN2/Master_thesis/Research_Project_I/Practical_files/Brainstorm/brainstorm_db/Protocol02/data');
allSourcemodels = sh_rdir(pwd, {'.mat', 'results_atlas'}, {'analysis', 'info'}, 1);

%% Compute mean all-to-all electrode connectivity 
meanconnectivitiesScalp = NaN(64,length(allRecordings));
%connectivitiesScalp = NaN(1,length(allRecordings));

for i = 1:length(allRecordings)
    i %keep track of progression
    EEGstruct = pop_loadset(allRecordings{i});
    scalpsignal = EEGstruct.data;
    connectMatrixScalp = computeWPLI(scalpsignal');
    meanconnectivitiesScalp(:,i) = nanmean(connectMatrixScalp);
    %connectivitiesScalp(i) = mean(mean(connectMatrixScalp));
end
%% Compute mean all-to-all region connectivity
meanconnectivitiesRegion = zeros(68,length(allSourcemodels));

for i = 1:length(allSourcemodels)
    i %keep track of progression
    regionsignal = getAtlas(allSourcemodels{i});
    connectMatrix = computeWPLI(regionsignal');
    meanconnectivitiesRegion(:,i) = nanmean(connectMatrix);
end

%% Plot histograms of connectivities
% The averaged all-to-all inter-channel connectivity, measured with wPLI, over all subject (n = 118)
figure();
histogram(meanconnectivitiesScalp,41,'FaceColor','black')
title('inter-electrode'); ylabel('Frequency'); xlabel('Connectivity');
ylim([0 500]);
set(gca, 'box', 'off'); set(gcf,'color', 'w'); 
%%
% The averaged average wPLI between all-to-all source-region signals over all subjects (n = 118) 
figure();
histogram(meanconnectivitiesRegion,41,'FaceColor','black')
title('inter-region'); ylabel('Frequency'); xlabel('Connectivity');
ylim([0 500]); xlim([0 1]);
set(gca, 'box', 'off'); set(gcf,'color', 'w'); 

%% Get average of the connectivity distribution
% indicates inter-channel and inter-region functional connectivity
mean(nanmean(meanconnectivitiesScalp))
mean(nanmean(meanconnectivitiesRegion))

