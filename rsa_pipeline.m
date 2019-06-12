% Language fMRI Project - RSA Script 
% Contributors: rhao@college, mtomov@g 
% Last updated by Rebecca on 6/11/19 

clear rhos h p ci stats

%% Configuration
model = 'parallel-english-to-french-model-4layer-brnn-pred-layer4-avg'; % Model you are testing against 

region_name = 'LAngG'; % Region you are analyzing 
% region_name = 'Hippocampus_L'; 
% region_name = 'Insula_L'; 
% region_name = 'LMidPostTemp';
% region_name = 'LPostTemp';
% region_name = 'LMidAntTemp';
% region_name = 'LIFG';
% region_name = 'LAntTemp';
% region_name = 'LIFGorb'; 
% region_name = 'LMFG'; 

% Some choices: 'LAngG', 'Hippocampus_L', 'Hippocampus_R', 'Insula_L', 'Insula_R',
% 'LMidPostTemp', 'LPostTemp', 'LMidAntTemp', 'LIFG', 'LAntTemp', 'LIFGorb', 'LAngG', 'LMFG'}
datadir = '/research/examplesGLM'; % Where the fMRI data lives on your computer 

%% Load model data into feature matrix
load(model); 
for i=1:240
    feature(i,:)=eval(['sentence', num2str(i), ';']); 
end

%% Get a brain area 
% TODO make this better. Currently assumes your region_name is correct, you
% should probably check the printed idx 
labels = load([datadir '/subj1/examplesGLM.mat'], 'labels_aal', 'labels_langloc');
if isempty(find(strcmp(labels.labels_langloc, region_name)))
    isLangArea = false;
    useLabels = labels.labels_aal;
elseif isempty(find(strcmp(labels.labels_aal, region_name)))
    isLangArea = true;
    useLabels = labels.labels_langloc;
end 
idx = find(strcmp(useLabels, region_name)) % Map region name to number 

%% Compute model and neural RDMs
for s=[1 2 3 4 5 7 8 9 10 11] % Subjects. All: [1 2 3 4 5 7 8 9 10 11]
    % Load relevant data. See a exampleGLM.mat for all possible 
    load([datadir '/subj' num2str(s) '/examplesGLM.mat'], 'sentencesPresent', 'volmask', 'vollangloc', 'volaal', 'examples_sentences');
    
    % Compute the model RDM for the specified model 
    model_RDM = pdist(feature(logical(sentencesPresent), :), 'cosine');
    
    % Create region mask 
    if isLangArea
        region_mask = vollangloc == idx; 
    else
        region_mask = volaal == idx;
    end 
    % TODO: for each voxel 
    mask = region_mask; % TODO: look at create_spherical_mask_helper to create a searchlight mask (currently just using the region_mask)
    mask = mask(volmask); % Convert 3D -> 1D mask 
    badvoxels = any(isnan(examples_sentences), 1);
    mask = mask & (~badvoxels');
    
    % Compute neural RDM for searchlight 
    neural_RDM = pdist(examples_sentences(:, mask));
    
    % Do RSA between this neural RDM and the model RDM, and save stats 
    % TODO: edit rhos format to support the searchlight regions! 
    [rho, p] = corr(model_RDM', neural_RDM', 'type', 'spearman'); % Need to be cols, so transpose' 
    rhos(s) = rho;
    % TODO: end searchlight for loop 
end

%% Compute t-test for rhos
% TODO: make sure still computing the correct stats if you edit rhos above
rhos(6) = [] % delete col for subject 6 (doesnt exist)
rhos = atanh(rhos) % Fischer transform 
[h, p, ci, stats] = ttest(rhos);
fprintf('average rho=%f, t(%d)=%f, p=%f\n', mean(rhos), stats.df, stats.tstat, p); 
newstring = sprintf('average rho=%f, t(%d)=%f, p=%f\n', mean(rhos), stats.df, stats.tstat, p); 

% TODO create null distribution for actual comparisons 