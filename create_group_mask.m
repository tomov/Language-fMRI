% create group-level mask as AND of single-subject volmasks; run only once
% TODO are subjects co-registered / aligned?


EXPT = lang_expt;

mask = [];
for s = 1:length(EXPT.subject)

    subjmask = niftiread(fullfile(EXPT.subject(s).datadir, 'volmask.nii'));
    subjmask = logical(subjmask);

    if isempty(mask)
        mask = subjmask;
    else
        mask = mask & subjmask;
    end

    % remove NaN voxels
    load(fullfile(EXPT.subject(s).datadir, 'examplesGLM.mat'), 'examples_sentences');
    B = examples_sentences;
    mask(subjmask) = mask(subjmask) & ~any(isnan(B), 1)';
end

niftiwrite(double(mask), fullfile(EXPT.dir, 'mask.nii'));
