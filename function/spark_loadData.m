function tseries = spark_loadData(files_in, mask_in)
%SPARK_LOADDATA Load fMRI data and the associated mask. 
% Input: 
%   - files_in; path to the fMRI data
%   - mask_in: path to the mask file (if empty use all the fMRI voxel)
% Output: 
%   - tseries: time-series as n_times x n_voxel matrix for the voxel inside
% the mask. 


    fprintf('Reading fMRI data... \n');
    [~,~,ext] = fileparts(files_in);
    if any(strcmp(ext,{'.nii','.nii.gz','.mnc'}))
        [hdr,vol] = niak_read_vol(files_in); % read fMRI data

        % Load Brain mask
        fprintf('Reading brain mask... \n');
        [hdr_mask,mask] = niak_read_vol(mask_in); % read brain mask

        % Convert to tseries
        tseries = niak_vol2tseries(vol,mask>0);

    elseif any(strcmp(ext,{'.gii'}))
        tseries = gifti(files_in);
        tseries = tseries.cdata;
    else
        disp('Unrecorgnized file format -- TODO better error');
    end

end

