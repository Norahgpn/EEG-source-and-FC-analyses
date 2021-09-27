%% Get the inter-vertex connectivity of a region extracted from two atlases for comparison
% by: N. Hagopian
%% Inter-vertex connectivity of region from the 68-regions atlas 

%%%%%% "scout" is the file (extracted from Brainstorm) containing the %%%%%%
%%%%%% vertices (and seed) of the region of interest from the 68-regions atlas %%%%%%
region = scout; clear scout

% Get vertices from the region
vertices = region.Vertices;

%%%%%% "SourceData" is the file with all the timeseries of all vertices %%%%%%
%%%%%% of the chosen subject %%%%%%
% Get the timeseries of all the vertices
sources = SourceData(:,vertices);

% Compute intra-region connectivity by inter-vertex wPLI
tic
connectMat = computeWPLI(sources);
toc

% Compute the mean of the connectivity matrices
meanConnect = nanmean(connectMat);
nanmean(meanConnect)

%% Inter-vertex connectivity of region from the 136-regions atlas 

% "scout2" is the file (extracted from Brainstorm) containing the vertices
% (and seed) of the regions of interest from the 136-regions atlas
region2 = scout2; clear scout2 

% Get the vertices from the divided regions that correspond with the region (of interest)
% extracted from 68-region atlas
vertRegion1 = region2(1).Vertices;
vertRegion2 = region2(2).Vertices;
vertRegion3 = region2(3).Vertices;
vertRegion4 = region2(4).Vertices;

% Get the timeseries of all the vertices & compute inter-vertex wPLI per sub-region
sources1 = SourceData(:,vertRegion1);
cMat1 = computeWPLI(sources1);
sources2 = SourceData(:,vertRegion2);
cMat2 = computeWPLI(sources2);
sources3 = SourceData(:,vertRegion3);
cMat3 = computeWPLI(sources3);
sources4 = SourceData(:,vertRegion4);
cMat4 = computeWPLI(sources4);

% Compute mean of the connectivity matrices
meanMat1 = nanmean(cMat1);
nanmean(meanMat1)
meanMat2 = nanmean(cMat2);
nanmean(meanMat2)
meanMat3 = nanmean(cMat3);
nanmean(meanMat3)
meanMat4 = nanmean(cMat4);
nanmean(meanMat4)

% Merge the separate sub-region mean connectivities
meanMatAll = nan(4,78);
meanMatAll(1,1:length(meanMat1)) = meanMat1;
meanMatAll(2,1:length(meanMat2)) = meanMat2;
meanMatAll(3,1:length(meanMat3)) = meanMat3;
meanMatAll(4,1:length(meanMat4)) = meanMat4;
nanmean(meanConnect)
nanmean(nanmean(meanMatAll))

%% Plot Histograms
% Plot Histogram of inter-vertex connectivity of the region extracted from
% 68-regions atlas
figure();
histogram(meanConnect,35,'FaceColor','black')
title('DK 68'); ylabel('number of vertices'); xlabel('inter-vertex connectivity');
xlim([0 1]); %ylim([0 30]);
set(gca, 'box', 'off'); set(gcf,'color', 'w'); 
% Plot Histogram of inter-vertex connectivity of the region extracted from
% 136-regions atlas
figure();
histogram(meanMatAll,35,'FaceColor','black')
title('DK 136 combined'); ylabel('number of vertices'); xlabel('inter-vertex connectivity');
xlim([0 1]); ylim([0 35]);
set(gca, 'box', 'off'); set(gcf,'color', 'w'); 

