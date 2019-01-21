init

load(fullfile(expdir, 'subj1', 'examplesGLM.mat'));

%view_mask(volmask);
view_mask({volmask, volmask_original});
