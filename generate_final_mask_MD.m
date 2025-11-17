%-----------------------------------------------------------------------
% Job saved on 28-May-2021 18:25:26 by cfg_util (rev $Rev: 6942 $)
% spm SPM - SPM12 (7219)
% cfg_basicio BasicIO - Unknown
%----------------------------------------------------------------------
combined_flist = cellstr(wfu_bpm_read_flist('/project/radiology/ANSIR_lab/shared/s175064_workspace/HS_multicontrast_final/MD/flists/combined.flist'));
outdir = '/project/radiology/ANSIR_lab/shared/s175064_workspace/HS_multicontrast_final/MD/Masks/'
cortical_mask = '/project/radiology/ANSIR_lab/shared/s175064_workspace/HS_multicontrast_final/MD/Masks/whole_brain_gm_onlyneo.nii'
one = zeros(121, 145, 121); 
one(one==0) = 1; 
for a=1:length(combined_flist)
    disp(a);
    imgPath = [combined_flist{a}, '/swrtensor_MD.nii.gz'];
    hdr_img = spm_vol(wfu_uncompress_nifti(imgPath)); 
    img = spm_read_vols(hdr_img);
    img(isnan(img)) = 0;  
    img(img <0.30) = 0;
    img(img >= 0.30) = 1;
    one = one .* img; 
end;
hdr_mask = spm_vol(wfu_uncompress_nifti(cortical_mask)); 
mask_img = spm_read_vols(hdr_mask);
mask_img(isnan(mask_img)) = 0;  
one = one .* mask_img;

hdr = hdr_img;
hdr.fname = [outdir, 'final_mask_no_artifact.nii'];
wfu_writeimage(hdr, one);
disp('Done');