% override the ccnl-fmri function with a customized local one

function [Neural, cor] = ccnl_searchlight_rdms(EXPT, rsa_idx, inds, subjects)

    [Neural, cor] = searchlight_rdms(EXPT, rsa_idx, inds, subjects)

end
