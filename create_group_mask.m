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
end

niftiwrite(double(mask), fullfile(EXPT.dir, 'mask.nii'));
