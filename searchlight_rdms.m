function [Neural, cor] = searchlight_rdms(EXPT, rsa_idx, inds, subjects)

    % Compute the searchlight neural RDMs.
    % copy of ccnl_searchlight_rdms.m from https://github.com/sjgershm/ccnl-fmri
    %   

    if ~exist('subjects', 'var')
        subjects = 1:length(EXPT.subject);
    end

    % create rsa folder if none exists
    %if ~isdir(EXPT.rsadir); mkdir(EXPT.rsadir); end
    %rsadir = fullfile(EXPT.rsadir,['rsa',num2str(rsa_idx)]);
    %if ~isdir(rsadir); mkdir(rsadir); end

    % group-level mask 
    % use it ONLY to get sphere centers
    mask = fullfile(EXPT.dir, 'mask.nii');
    rsa = EXPT.create_rsa(rsa_idx, 1);
    radius = rsa.radius;

    % load mask
    [mask_format, mask, Vmask] = get_mask_format_helper(mask);
    assert(strcmp(mask_format, 'mask'), 'Improper mask');

    % get all voxel coordinates
    [x,y,z] = ind2sub(size(mask), find(mask));
    min_x = min(x);
    max_x = max(x);
    min_y = min(y);
    max_y = max(y);
    min_z = min(z);
    max_z = max(z);

    % get voxels we care about
    inds = inds(inds <= length(x));
    x = x(inds);
    y = y(inds);
    z = z(inds);
    cor = [x y z];

    % for each subject
    for s = 1:length(subjects)
        subj = subjects(s);

        rsa = EXPT.create_rsa(rsa_idx, subj);

        % load subject-specific mask
        % use it to compute actual RDMs
        subjmask = rsa.mask;
        radius = rsa.radius;
        [subjmask_format, subjmask, Vsubjmask] = get_mask_format_helper(subjmask);
        assert(strcmp(subjmask_format, 'mask'), 'Improper mask');

        load(fullfile(EXPT.subject(subj).datadir, 'examplesGLM.mat'), 'examples_sentences');
        B = examples_sentences;

        % this is the original ; we already have the betas precomputed tho
        %
        %betas_filename = fullfile(rsadir, sprintf('betas_%d.mat', subj));
        %disp(betas_filename);

        %% load (cached) betas
        %if ~exist(betas_filename, 'file')
        %    tic
        %    disp('loading betas from .nii files...');

        %    % load betas 
        %    modeldir = fullfile(EXPT.modeldir,['model',num2str(rsa.glmodel)],['subj',num2str(subj)]);
        %    load(fullfile(modeldir,'SPM.mat'));
        %    which = contains(SPM.xX.name, rsa.event); % betas for given event
        %    which(which) = rsa.which_betas; % of those, only betas for given trials
        %    cdir = pwd;
        %    cd(modeldir); % b/c SPM.Vbeta are relative to modeldir
        %    B = spm_data_read(SPM.Vbeta(which), find(mask));
        %    cd(cdir);

        %    % save file in "lock-free" fashion
        %    % b/c parallel jobs might be doing the same
        %    tmp_filename = [betas_filename, random_string()];
        %    save(tmp_filename, 'B', '-v7.3');
        %    movefile(tmp_filename, betas_filename); % TODO assumes this is instantaneous

        %    toc
        %else
        %    tic
        %    disp('loading cached betas from .mat file...');
        %    load(betas_filename);
        %    toc
        %end

        tic
        disp('computing RDMs...');

        % for each voxel
        for i = 1:length(x)
            % create searchlight mask
            sphere_mask = create_spherical_mask_helper(subjmask, x(i), y(i), z(i), radius, min_x, max_x, min_y, max_y, min_z, max_z, Vsubjmask);
            sphere_mask = sphere_mask & subjmask; % exclude out-of-brain voxels

            sphere_mask(subjmask) = sphere_mask(subjmask) & ~any(isnan(B), 1)'; % exclude nan voxels

            % compute RDM
            if sum(sphere_mask(:)) == 0
                % sometimes (rarely) they're all NaNs
                Neural(i).subj(s).RDM = [];
            else
                Neural(i).subj(s).RDM = squareRDMs(pdist(B(:, find(sphere_mask(subjmask))), 'cosine'));
            end
            assert(sum(any(isnan(Neural(i).subj(s).RDM))) == 0, 'Found NaNs in RDM -- should never happen');
          
            % metadata
            Neural(i).subj(s).id = subj;
            Neural(i).cor = [x(i) y(i) z(i)];
            Neural(i).mni = cor2mni(Neural(i).cor, Vsubjmask.mat);
            Neural(i).name = ['sphere_', sprintf('%d_%d_%d', Neural(i).mni), '_', rsa.event];
            Neural(i).subj(s).name = Neural(i).name;
            Neural(i).radius = radius;
            Neural(i).event = rsa.event;
            Neural(i).idx = inds(i);
            Neural(i).num_voxels = sum(sphere_mask(:));
        end

        toc
    end

end


