% create .nii mask file for each subject; run only once
%

EXPT = lang_expt;

for s = 1:length(EXPT.subject)

    load(fullfile(EXPT.subject(s).datadir, 'examplesGLM.mat'));

    niftiwrite(double(volmask), fullfile(EXPT.subject(s).datadir, 'volmask.nii'));
    niftiwrite(double(volmask_original), fullfile(EXPT.subject(s).datadir, 'volmask_original.nii'));
end
