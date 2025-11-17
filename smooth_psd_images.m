clear all;
cd '/project/radiology/ANSIR_lab/shared/s175064_workspace/HS_multicontrast_final/psd_fmri/';
out = '/project/radiology/ANSIR_lab/shared/s175064_workspace/HS_multicontrast_final/psd_fmri/';
pre_flist = cellstr(wfu_bpm_read_flist('/project/radiology/ANSIR_lab/shared/s175064_workspace/HS_multicontrast_final/psd_fmri/flists/pre_func.flist'));
%post_flist = cellstr(wfu_bpm_read_flist('/project/radiology/ANSIR_lab/shared/s175064_workspace/HS_multicontrast_final/psd_fmri/flists/post_func.flist'));
for a=1:length(pre_flist)
    pre_path = fullfile(pre_flist{a}, '/0.01_0.1_mean_norm_post.nii');
    sub_id = strsplit(pre_path, '/');
    sub_id = sub_id{10};
    disp(sub_id);
    matlabbatch{1}.spm.spatial.smooth.data = {[pre_path, ',1']};
    matlabbatch{1}.spm.spatial.smooth.fwhm = [8 8 8];
    matlabbatch{1}.spm.spatial.smooth.dtype = 0;
    matlabbatch{1}.spm.spatial.smooth.im = 0;
    matlabbatch{1}.spm.spatial.smooth.prefix = 's';
    spm_jobman('run', matlabbatch);
    
    %matlabbatch{1}.spm.spatial.smooth.data = {[post_path, ',1']};
    %matlabbatch{1}.spm.spatial.smooth.fwhm = [8 8 8];
    %matlabbatch{1}.spm.spatial.smooth.dtype = 0;
    %matlabbatch{1}.spm.spatial.smooth.im = 0;
    %matlabbatch{1}.spm.spatial.smooth.prefix = 's';
 
    
    %pre_path = fullfile(pre_flist{a}, '/sz_map_pre.nii');
    %post_path = fullfile(post_flist{a}, '/sz_map_post.nii');
    %pre_hdr_img = spm_vol(wfu_uncompress_nifti(pre_path));
    %post_hdr_img = spm_vol(wfu_uncompress_nifti(post_path));
    %pre_img = spm_read_vols(pre_hdr_img);
    %pre_img(isnan(pre_img)) = 0; 
    %post_img = spm_read_vols(post_hdr_img);
    %post_img(isnan(post_img)) = 0; 
   
    %delta = (post - pre) ./ pre;
    
    %hdr = spm_vol(wfu_uncompress_nifti('/project/radiology/ANSIR_lab/shared/s175064_workspace/subcon_BOLD/01KIDS_YT009_20140711/func/wart_mean_FUNC.nii'));
    %hdr.fname = [out, '/', sub_id, '/sz_delta.nii'];
    %wfu_writeimage(hdr, delta);
end

wfu_uncompress_nifti('cleanup');