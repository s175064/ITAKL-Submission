clear all;
cd '/project/radiology/ANSIR_lab/shared/s175064_workspace/HS_multicontrast_final/psd_fmri/';
out = '/project/radiology/ANSIR_lab/shared/s175064_workspace/HS_multicontrast_final/psd_fmri/psd_diff';
pre_flist = cellstr(wfu_bpm_read_flist('/project/radiology/ANSIR_lab/shared/s175064_workspace/HS_multicontrast_final/psd_fmri/flists/pre_func.flist'));
%post_flist = cellstr(wfu_bpm_read_flist('/project/radiology/ANSIR_lab/shared/s175064_workspace/HS_voxelwise_DTI/psd_fmri/post.flist'));
flist_length = length(pre_flist);
mask = '/project/radiology/ANSIR_lab/shared/s175064_workspace/HS_voxelwise_DTI/psd_fmri/masks/MNI152_T1_2mm_brain_mask.nii'
mask = spm_read_vols(spm_vol(wfu_uncompress_nifti(mask)));
for a=1:length(pre_flist)
    pre_path = fullfile(pre_flist{a}, '/s0.01_0.1_mean_norm_pre.nii');
    sub_id = strsplit(pre_path, '/');
    sub_id = sub_id{10};
    disp(sub_id);
    post_path = fullfile(pre_flist{a}, '/s0.01_0.1_mean_norm_post.nii');

    pre_hdr_img = spm_vol(wfu_uncompress_nifti(pre_path));
    post_hdr_img = spm_vol(wfu_uncompress_nifti(post_path));
    pre_img = spm_read_vols(pre_hdr_img);
    pre_img(isnan(pre_img)) = 0; 
    post_img = spm_read_vols(post_hdr_img);
    post_img(isnan(post_img)) = 0; 
   
    delta = ((post_img - pre_img) ./ pre_img) * 100;
    delta = delta .* mask; 
    num = sprintf( '%03d', a);
    hdr = spm_vol(wfu_uncompress_nifti('/project/radiology/ANSIR_lab/shared/s175064_workspace/subcon_BOLD/01KIDS_YT009_20140711/func/wart_mean_FUNC.nii'));
    hdr.fname = [out, '/', sub_id, '_meannorm_delta.nii'];
    disp(hdr.fname);
    wfu_writeimage(hdr, delta);
end

wfu_uncompress_nifti('cleanup');