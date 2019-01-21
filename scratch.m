init

load(fullfile(expdir, 'subj1', 'examplesGLM.mat'));

%view_mask(volmask);
view_mask({volmask, volmask_original});

% check co-registration? are subjects aligned n stuff? 
%view_mask({fullfile(EXPT.subject(1).datadir, 'volmask.nii'), fullfile(fullfile(EXPT.subject(10).datadir, 'volmask.nii'))})

% test RSA
% rsa = lang_create_rsa(1, 1)
