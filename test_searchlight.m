% test running the RSA searchlight
% see also https://github.com/tomov/Exploration-Data-Analysis/blob/master/ccnl_rsa_searchlight.sh

EXPT = lang_expt();
ccnl_rsa_searchlight(EXPT, 1, 1:5)

delete ../rsaOutput/rsa1/searchlight_1-5_NLLTRURNYA.mat; % delete it so it gets recomputed from scratch
ccnl_rsa_view(EXPT, 1, 1);
