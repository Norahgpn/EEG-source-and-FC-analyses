function [sourcesignal,scouts,seeds] = getAtlas(path)
%% getAtlas.m returns 3 variables, two variables containing the vertices and seeds of the atlas and one variable containing the source-reconstructed timeseries downlsampled to the atlas regions  
% Atlas in Results_Atlas Atlas.Scouts.Vertices / Scouts.Seed gives the vertex number that is the middle of the Region
% by: N.Hagopian

atlasstruct = load(path);

% Scouts/regions with .vertices (in the region) and .seed (midpoint of the region)
scouts = atlasstruct.Atlas.Scouts;
% Vertices that are the middle points of all the regions
seeds = cell2mat({scouts(:).Seed});
% Set variable with source-space timeseries per region (averaged vertices)
sourcesignal = atlasstruct.ImageGridAmp; %downsampled to 256 Hz
end