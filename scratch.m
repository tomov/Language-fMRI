include

load(fullfile(expdir, 'subj1', 'examplesGLM.mat'));

%view_mask(volmask);
%view_mask({volmask, volmask_original});
% view_mask(fullfile(EXPT.dir, 'mask.nii'))

%% check co-registration? are subjects aligned n stuff? 
%view_mask({fullfile(EXPT.subject(1).datadir, 'volmask.nii'), fullfile(fullfile(EXPT.subject(10).datadir, 'volmask.nii'))})

%% test RSA
% rsa = lang_create_rsa(1, 1)
%[Behavioral, control] = ccnl_behavioral_rdms(EXPT, 1);
%Neural = searchlight_rdms(EXPT, 1, 1:13);
%showRDMs(Behavioral(1).subj);
%showRDMs(Neural(1).subj);

