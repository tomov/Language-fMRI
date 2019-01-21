function Neural = searchlight_rdms(EXPT, rsa_idx, region_names, subjects)

    % Compute the neural RDMs for given ROIs.
    % copy of searchlight_rdms.m
    %   

    if ~exist('subjects', 'var')
        subjects = 1:length(EXPT.subject);
    end


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

        load(fullfile(EXPT.subject(subj).datadir, 'examplesGLM.mat'), 'examples_sentences', 'volaal', 'labels_aal', 'vollangloc', 'labels_langloc');
        B = examples_sentences;


        tic
        disp('computing RDMs...');

        % for each voxel
        for i = 1:length(region_names)

            % try to find region name in AAL or in langloc
            idx = NaN;
            for j = 1:length(labels_aal)
                if strcmp(labels_aal{j}, region_names{i})
                    idx = j;
                    break;
                end
            end

            if ~isnan(idx)
                % create region mask
                region_mask = volaal == idx;
            else
                fprintf('did not find %s in AAL atlas; looking in language localizer...\n', region_names{i});
                % not in AAL => must be in langloc
                for j = 1:length(labels_langloc)
                    if strcmp(labels_langloc{j}, region_names{i})
                        idx = j;
                        break;
                    end
                end
                assert(~isnan(idx), sprintf('No region %s', region_names{i}));

                % create region mask
                region_mask = vollangloc == idx;
            end
           


            assert(sum(region_mask(:)) > 0);
            region_mask = region_mask & subjmask; % exclude out-of-brain voxels
            region_mask(subjmask) = region_mask(subjmask) & ~any(isnan(B), 1)'; % exclude nan voxels

            % compute RDM
            if sum(region_mask(:)) == 0
                % sometimes (rarely) they're all NaNs
                Neural(i).subj(s).RDM = [];
            else
                Neural(i).subj(s).RDM = squareRDMs(pdist(B(:, find(region_mask(subjmask))), 'cosine'));
            end
            assert(sum(any(isnan(Neural(i).subj(s).RDM))) == 0, 'Found NaNs in RDM -- should never happen');
          
            % metadata
            Neural(i).subj(s).id = subj;
            Neural(i).name = region_names{i};
            Neural(i).subj(s).name = Neural(i).name;
            Neural(i).radius = radius;
            Neural(i).event = rsa.event;
            Neural(i).num_voxels = sum(region_mask(:));
        end

        toc
    end

end


