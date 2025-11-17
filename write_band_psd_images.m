clear all;
% alpha, beta, gamma1, gamma2, delta, theta were run using this script. For each band, the code was modified so directories and image names matched the correct band
cd '/project/radiology/ANSIR_lab/shared/s175064_workspace/HS_multicontrast_final/MEG/';
out = '/project/radiology/ANSIR_lab/shared/s175064_workspace/HS_multicontrast_final/MEG/delta_images/gamma2';
pre_flist = cellstr(wfu_bpm_read_flist('/project/radiology/ANSIR_lab/shared/s175064_workspace/HS_multicontrast_final/MEG/flists/pre.flist'));
post_flist = cellstr(wfu_bpm_read_flist('/project/radiology/ANSIR_lab/shared/s175064_workspace/HS_multicontrast_final/MEG/flists/post.flist'))
flist_length = length(pre_flist);
mask = '/project/radiology/ANSIR_lab/shared/s175064_workspace/HS_multicontrast_final/MD/Masks/dartelbin.nii';
mask = spm_read_vols(spm_vol(wfu_uncompress_nifti(mask)));
s1 = 'brainstorm_hs';
s2 = 'normed_images';
for a=1:length(pre_flist)
    pre_path = fullfile(pre_flist{a}, '/swrelative_PSD_gamma2.nii.gz');
    pre_path = strrep(pre_path, s1, s2);
    sub_id = strsplit(pre_path, '/');
    sub_id = sub_id{10};
    disp(sub_id);
    post_path = fullfile(post_flist{a}, '/swrelative_PSD_gamma2.nii.gz');
    post_path = strrep(post_path, s1, s2);

    pre_hdr_img = spm_vol(wfu_uncompress_nifti(pre_path));
    post_hdr_img = spm_vol(wfu_uncompress_nifti(post_path));
    pre_img = spm_read_vols(pre_hdr_img);
    pre_img(isnan(pre_img)) = 0; 
    post_img = spm_read_vols(post_hdr_img);
    post_img(isnan(post_img)) = 0; 
   
    delta = ((post_img - pre_img) ./ pre_img) * 100;
    delta = delta .* mask; 
    num = sprintf( '%03d', a);
    hdr = spm_vol(wfu_uncompress_nifti('/project/radiology/ANSIR_lab/shared/s175064_workspace/HS_multicontrast_final/MEG/normed_images/test/swrelative_PSD_delta.nii.gz'));
    hdr.fname = [out, '/', num, sub_id, 'delta_gamma2.nii'];
    disp(hdr.fname);
    wfu_writeimage(hdr, delta);
end

wfu_uncompress_nifti('cleanup');
