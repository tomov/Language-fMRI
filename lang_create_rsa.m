function rsa = lang_create_rsa(rsa_idx, subj)

    % fake create RSA 
    % see exploration_create_rsa.m from https://github.com/tomov/Exploration-Data-Analysis


    fprintf('rsa %d, subj %d\n', rsa_idx, subj);

    EXPT = lang_expt;
    load(fullfile(EXPT.subject(subj).datadir, 'examplesGLM.mat'));

    % RSAs
    %
    switch rsa_idx

        % demo RSA -- difference in sentence length 
        %
        case 1
            rsa.event = 'N/A';
            rsa.glmodel = NaN;
            rsa.radius = 10; % in voxels; TODO what's the resolution?
            rsa.mask = fullfile(EXPT.subject(subj).datadir, 'volmask.nii'); % subject-specific masks
            rsa.which_betas = logical([]);


            rsa.model(1).name = 'length_diff';
            rsa.model(1).features = cellfun(@(str) length(str), sentences);
            rsa.model(1).distance_measure = @(x1, x2) abs(x1 - x2);
            rsa.model(1).is_control = false;


        otherwise
            assert(false, 'invalid rsa_idx -- should be one of the above');

    end % end of switch statement
