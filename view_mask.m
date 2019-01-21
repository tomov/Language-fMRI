function view_mask(mask)
    % view a mask passed as a 3D array, or cell array of 3D arrays
    %

    if ~iscell(mask)
        mask = {mask};
    end

    masks = mask; 
    filenames = {};
    for i = 1:length(masks)
        mask = double(masks{i});
        filename = sprintf('temp/tmp_%d.nii', i);
        niftiwrite(mask, filename);
        filenames = [filenames, {filename}];
    end
    spm_check_registration(char(filenames));
