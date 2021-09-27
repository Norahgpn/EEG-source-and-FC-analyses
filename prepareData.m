%% PREPERATIONS %%
% by: N.Hagopian

addpath(genpath('/Users/norahagopian/Documents/Universiteit/Master_CN2/Master_thesis/Research_Project_I/Practical_files'));

kernel = load('/Volumes/Nora_files/Brainstorm/Brainstorm/brainstorm_db/Protocol02/data/BAMBI.S502/@default_study/results_MN_EEG_KERNEL_190730_1511.mat');

% get Headmodel using getHeadmodel.m
headmodelpath = '/Volumes/Nora_files/Brainstorm/Brainstorm/brainstorm_db/Protocol02/data/BAMBI.S502/@default_study/headmodel_surf_openmeeg.mat';
[headmodelstruc,vertices] = getHeadmodel(headmodelpath);

% get Channels using getChannels.m
channelpath = '/Volumes/Nora_files/Brainstorm/Brainstorm/brainstorm_db/Protocol02/data/BAMBI.S502/@default_study/channel.mat';
channelstruc = load(channelpath);
allchannels = channelstruc.Channel;    % 64 channels with coordinates in .Loc

% get Atlas using getAtlas.m & source-space tieseries downsampled to Atlas regions
atlaspath = '/Volumes/Nora_files/Brainstorm/Brainstorm/brainstorm_db/Protocol02/data/BAMBI.S502/BAMBI.S502.yyyymmdd.ASD.ECR/results_atlas_190801_1514.mat';
[sourcesignal,scouts,seeds] = getAtlas(atlaspath);

% Load channel signal timeseries (64 channels) in scalp-space
EEGstruct = pop_loadset('/Volumes/Nora_files/Clean_256Hz_AvgRef_sphericalInterp_broadBand/BAMBI/ASD/BAMBI.S502.yyyymmdd.ASD.ECR.set');
scalpsignal = EEGstruct.data; %downsampled to 256 Hz
%% Add paths
addpath(genpath('/Users/norahagopian/Documents/Universiteit/Master_CN2/Master_thesis/Research_Project_I/Practical_files/Brainstorm'));
addpath(genpath('/Volumes/Nora_files/Clean_256Hz_AvgRef_sphericalInterp_broadBand'));
addpath(genpath('/Volumes/Nora_files/Scripts_July_2019'));
addpath(genpath('/Users/norahagopian/Documents/Universiteit/Master_CN2/Master_thesis/Research_Project_I/Practical_files/NBT'));

cd('/Volumes/Nora_files/Clean_256Hz_AvgRef_sphericalInterp_broadBand');
