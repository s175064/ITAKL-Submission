clear all;
cd '/project/radiology/ANSIR_lab/shared/s175064_workspace/HS_multicontrast_final/psd_fmri/';
out = '/project/radiology/ANSIR_lab/shared/s175064_workspace/HS_multicontrast_final/psd_fmri/masks';
mask_path = '/project/radiology/ANSIR_lab/shared/s175064_workspace/HS_multicontrast_final/psd_fmri/masks/MNI152_T1_2mm_brain_mask.nii';
brain_mask = spm_read_vols(spm_vol(wfu_uncompress_nifti(mask_path)));
all_flist = cellstr(wfu_bpm_read_flist('/project/radiology/ANSIR_lab/shared/s175064_workspace/HS_multicontrast_final/psd_fmri/flists/all.flist'));
mask = ones(91, 109, 91);
for a=1:length(all_flist)
    gm_path = fullfile(all_flist{a}, '/func/wc1art_mean_FUNC.nii');
    gm_hdr = spm_vol(wfu_uncompress_nifti(gm_path));
    gm_img = spm_read_vols(gm_hdr);
    
    wm_path = fullfile(all_flist{a}, '/func/wc2art_mean_FUNC.nii');
    wm_hdr = spm_vol(wfu_uncompress_nifti(wm_path));
    wm_img = spm_read_vols(wm_hdr);
    
    csf_path = fullfile(all_flist{a}, '/func/wc3art_mean_FUNC.nii');
    csf_hdr = spm_vol(wfu_uncompress_nifti(wm_path));
    csf_img = spm_read_vols(wm_hdr);
    
    brain_img = zeros(91, 109, 91); 
    brain_img(gm_img > 0.05) = 1; 
    brain_img(wm_img > 0.05) = 1; 
    brain_img(csf_img > 0.05) = 1;
    
    mask = mask .* brain_img;
end;

mask= imfill(mask,'holes');
se = strel('disk',1);
mask = imerode(mask, se); 

hdr = spm_vol(wfu_uncompress_nifti('/project/radiology/ANSIR_lab/shared/s175064_workspace/subcon_BOLD/01KIDS_YT009_20140711/func/wart_mean_FUNC.nii'));
hdr.fname = [out, '/least_common_denominator_mask.nii'];
wfu_writeimage(hdr, mask);  

wfu_uncompress_nifti('cleanup');
