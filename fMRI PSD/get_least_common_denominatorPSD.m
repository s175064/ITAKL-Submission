clear all;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% Make fMRI mask that only contains regions found across all participants %%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cd '/project/radiology/ANSIR_lab/shared/s175064_workspace/HS_multicontrast_final/psd_fmri/';
out = '/project/radiology/ANSIR_lab/shared/s175064_workspace/HS_multicontrast_final/psd_fmri/masks';
mask_path = '/project/radiology/ANSIR_lab/shared/s175064_workspace/HS_multicontrast_final/psd_fmri/masks/MNI152_T1_2mm_brain_mask.nii';
brain_mask = spm_read_vols(spm_vol(wfu_uncompress_nifti(mask_path)));
all_flist = cellstr(wfu_bpm_read_flist('/project/radiology/ANSIR_lab/shared/s175064_workspace/HS_multicontrast_final/psd_fmri/flists/all.flist'));
mask = ones(91, 109, 91);
for a=1:length(all_flist)
    
    % use gray matter, white matter, and csf segs to define complete brain
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

% use a standard header file that can be modified to write out final mask image
hdr = spm_vol(wfu_uncompress_nifti('/project/radiology/ANSIR_lab/shared/s175064_workspace/test/wart_mean_FUNC.nii'));
hdr.fname = [out, '/least_common_denominator_mask.nii'];
wfu_writeimage(hdr, mask);  

wfu_uncompress_nifti('cleanup');
