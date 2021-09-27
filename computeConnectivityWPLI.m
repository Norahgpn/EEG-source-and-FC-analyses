% Set fieldtrip scripts as current directory
restoredefaultpath
addpath('/Users/norahagopian/Documents/MATLAB/Practicum/fieldtrip-master');
ft_defaults

%% Prepare data
datapath        = '/Volumes/Nora_files/Clean_256Hz_AvgRef_sphericalInterp_broadBand/BAMBI/ASD/BAMBI.S502.yyyymmdd.ASD.ECR.set';
cfg = [];
cfg.dataset     = datapath;
cfg.channel     = 'all';
%cfg.continuous  = 'yes';

data = ft_preprocessing(cfg);
%% Make trials (repetitions) through epoching


%% Compute connectivity analyses to obtain Cross-spectral density matrix


%% Compute connectivity analysis
% Prepare input (cfg)
cfg.method      = 'wpli';  %OR: 'wpli_debiased' [debiased weighted phase lag index (estimates squared wpli)]

% Compute connectivity
stat = ft_connectivityanalysis(cfg, data);

%%%%%%%%%% LINE 581 OF FT_CONNECTIVITYANALYSIS.m %%%%%%%%%%
%case {'wpli' 'wpli_debiased'}
% weighted pli or debiased weighted phase lag index.
%optarg = {'feedback', cfg.feedback, 'dojack', dojack, 'debias', debiaswpli};
%[datout, varout, nrpt] = ft_connectivity_wpli(data.(inparam), optarg{:});