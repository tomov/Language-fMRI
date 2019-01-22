% test RSA for ROIs
% see also test_searchlight.m


EXPT = lang_expt;
% TODO Rebecca play around with language areas
region_names = {'LAngG', 'Hippocampus_L', 'Hippocampus_R', 'Insula_L', 'Insula_R'};
rsa_idx = 1;

%[Behavioral, control] = ccnl_behavioral_rdms(EXPT, rsa_idx);
Neural = roi_rdms(EXPT, rsa_idx, region_names)


%% copy-pasted from ccnl_rsa_searchlight

% compute second-order correlations (similarity match)
[Rho, H, T, P, all_subject_rhos] = ccnl_match_rdms(Neural, Behavioral, control);

% save output 
save('temp.mat', 'region_names', 'Rho', 'H', 'T', 'P', 'all_subject_rhos', 'rsa_idx', '-v7.3');

% TODO Rebecca generate null distribution by shuffling features in lang_create_rsa.m to compute "actual" p-value
