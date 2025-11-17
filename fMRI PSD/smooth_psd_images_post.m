clear all;
cd '/project/radiology/ANSIR_lab/shared/s175064_workspace/HS_multicontrast_final/psd_fmri/';
out = '/project/radiology/ANSIR_lab/shared/s175064_workspace/HS_multicontrast_final/psd_fmri/';
% all psd images (preseason and postseason) were written to each subjects pre directory
pre_flist = cellstr(wfu_bpm_read_flist('/project/radiology/ANSIR_lab/shared/s175064_workspace/HS_multicontrast_final/psd_fmri/flists/pre_func.flist'));
for a=1:length(pre_flist)
    post_path = fullfile(pre_flist{a}, '/0.01_0.1_mean_norm_post.nii');
    sub_id = strsplit(post_path, '/');
    sub_id = sub_id{10};
    disp(sub_id);
    matlabbatch{1}.spm.spatial.smooth.data = {[post_path, ',1']};
    matlabbatch{1}.spm.spatial.smooth.fwhm = [8 8 8];
    matlabbatch{1}.spm.spatial.smooth.dtype = 0;
    matlabbatch{1}.spm.spatial.smooth.im = 0;
    matlabbatch{1}.spm.spatial.smooth.prefix = 's';
    spm_jobman('run', matlabbatch);
    
end

wfu_uncompress_nifti('cleanup');
