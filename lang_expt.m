function EXPT = lang_expt()

    % create fake EXPT structure so we can use ccnl_fmri routines
    % see e.g. exploration_expt.m from https://github.com/tomov/Exploration-Data-Analysis

    exptdir = '/Volumes/MomchilfMRI/examplesGLM/';

    subjdirs = {'subj1', 'subj2', 'subj3', 'subj4', 'subj5', ...
                'subj7', 'subj8', 'subj9', 'subj10', 'subj11'};
    N = length(subjdirs);

    for s = 1:N
        subjdir = fullfile(exptdir, subjdirs{s});
        EXPT.subject(s).datadir = subjdir;
    end

    EXPT.create_rsa = @lang_create_rsa;
