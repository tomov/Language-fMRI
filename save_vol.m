function info = save_vol(vol, filename)

    % usage: save_vol(vollangloc, 'temp/test.nii');
    %        bspmview('temp/test.nii');

    [~, V, Y] = ccnl_load_mask('mask_from_uncertainty_study.nii');
    Y(:) = 0;
    %Y(1:size(vol,1), 1:size(vol,2), 1:size(vol,3)) = vol;
    Y(:) = imresize3(vol, size(Y), 'nearest');
    V.fname = filename; % !!!!!!!!!!!!!!! important!!!!!!
    spm_write_vol(V, Y);

    info = niftiinfo(filename);
    %{
    niftiwrite(V, filename);
    info = niftiinfo(filename);
    info.PixelDimensions = [2 2 2];
    info.MultiplicativeScaling = 1;
    info.SpatialDimension = 0;
    info.SpaceUnits = 'Millimeter';
    info.Transform = affine3d([-2 0 0 0; 0 2 0 0; 0 0 2 0; 78 -112 -60 1]);
    info.TransformName = 'Sform';
    info.Qfactor = -1;

    info.raw.pixdim = [-1 2 2 2 0 0 0 0];
    info.raw.scl_slope = -1;
    info.raw.xyzt_units = 10;
    info.raw.qform_code = 2;
    info.raw.sform_code = 2;
    info.raw.quatern_c = 1;
    info.raw.qoffset_x = 78;
    info.raw.qoffset_y = -112;
    info.raw.qoffset_z = -60;
    info.raw.srow_x = [-2 0 0 78];
    info.raw.srow_y = [0 2 0 -112];
    info.raw.srow_z = [0 0 2 -60];
    info.raw.scl_slope = 1;
    info.raw.descrip = 'spm_spm:resultant analysis mask';

    niftiwrite(V, filename, info);
    %}
