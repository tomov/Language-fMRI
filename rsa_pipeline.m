% Language fMRI Project - RSA Script 
% Contributors: rhao@college, mtomov@g 
% Last updated by Rebecca on 4/8/19 

% TODO create null distribution for comparisons 

%% Configuration 
clear 
model = 'small-english-to-spanish-pred-layer1-avg'; % Model you are testing against 
datadir = '/research/examplesGLM'; % Where the fMRI data lives on your computer 

%% Load model data into feature matrix 
load(model); 
for i=1:240
    feature(i,:)=eval(['sentence', num2str(i), ';']); 
end

%% Get an area 
idx = 7 %find(strcmp(labels_langloc, region_name)); % Map region name to number 
% TODO needs to load from examplesGLM first to get labels_langloc 

%% Compute model and neural RDMs 
% all subjects: [1 2 3 4 5 7 8 9 10 11]
for s=[1 2 3] % Subjects 
    load([datadir '/subj' num2str(s) '/examplesGLM.mat'], 'sentencesPresent', 'volmask', 'vollangloc', 'examples_sentences'); 
    model_RDM = pdist(feature(logical(sentencesPresent), :), 'cosine'); 
    mask = vollangloc == idx; % Create region mask 
    % TODO add searchlight for loop here, create_spherical_mask_helper is
    % likely helpful 
    mask = mask(volmask); % Convert 3D -> 1D mask 
    badvoxels = any(isnan(examples_sentences), 1); 
    mask = mask & (~badvoxels'); 
    neural_RDM = pdist(examples_sentences(:, mask));
    [rho, p] = corr(model_RDM', neural_RDM', 'type', 'spearman'); % Need to be cols, so transpose' 
    rhos(s) = rho; 
end

%% Compute t-test for rhos 
rhos = atanh(rhos); % Fischer transform 
[h, p, ci, stats] = ttest(rhos); 
fprintf('average rho=%f, t(%d)=%f, p=%f\n', mean(rhos), stats.df, stats.tstat, p); 
