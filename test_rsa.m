% test RSA for ROIs
% see also test_searchlight.m


EXPT = lang_expt;

%[Behavioral, control] = ccnl_behavioral_rdms(EXPT, 1);


Neural = roi_rdms(EXPT, 1, {'Hippocampus_L', 'Hippocampus_R', 'Insula_L', 'Insula_R'})
