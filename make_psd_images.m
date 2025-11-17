clear all;
cd '/project/radiology/ANSIR_lab/shared/s175064_workspace/HS_multicontrast_final/psd_fmri/';
out = '/project/radiology/ANSIR_lab/shared/s175064_workspace/HS_multicontrast_final/psd_fmri/images/';
mask_path = '/project/radiology/ANSIR_lab/shared/s175064_workspace/HS_multicontrast_final/psd_fmri/masks/least_common_denominator_mask.nii';
brain_mask = spm_read_vols(spm_vol(wfu_uncompress_nifti(mask_path)));
pre_flist = cellstr(wfu_bpm_read_flist('/project/radiology/ANSIR_lab/shared/s175064_workspace/HS_multicontrast_final/psd_fmri/flists/pre_func.flist'));
post_flist = cellstr(wfu_bpm_read_flist('/project/radiology/ANSIR_lab/shared/s175064_workspace/HS_multicontrast_final/psd_fmri/flists/post_func.flist'));
flist_length = length(pre_flist);
for a=1:length(pre_flist)
    pre_path = fullfile(pre_flist{a}, '/func/wFUNC.nii');
    sub_id = strsplit(pre_path, '/');
    sub_id = sub_id{10};
    disp(sub_id);
    post_path = fullfile(post_flist{a}, '/func/wFUNC.nii');
    pre_hdr_img = spm_vol(wfu_uncompress_nifti(pre_path));
    post_hdr_img = spm_vol(wfu_uncompress_nifti(post_path));
    pre_img = spm_read_vols(pre_hdr_img);
    pre_img(isnan(pre_img)) = 0; 
    post_img = spm_read_vols(post_hdr_img);
    post_img(isnan(post_img)) = 0; 
    pre_new_img = zeros(91, 109, 91);
    post_new_img = zeros(91, 109, 91);
    for x=1:91
    disp((x/91));
        for y=1:109
            for z=1:91
                psd_img = (pre_img(x, y, z, 5:190));
                [pxx, f] = pwelch(psd_img(:), [], [], [], 0.5);
                pwr = bandpower(pxx, f, [0.01, 0.1], 'psd');
                pre_new_img(x, y, z) = pwr;
                psd_img = (post_img(x, y, z, 5:190));
                [pxx, f] = pwelch(psd_img(:), [], [], [], 0.5);
                pwr = bandpower(pxx, f, [0.01, 0.1], 'psd');
                post_new_img(x, y, z) = pwr;        
            end;
        end;
    end
    pre_new_img(brain_mask == 0) = 0;
    post_new_img(brain_mask == 0) = 0;
    
    hdr = spm_vol(wfu_uncompress_nifti('/project/radiology/ANSIR_lab/shared/s175064_workspace/subcon_BOLD/01KIDS_YT009_20140711/func/wart_mean_FUNC.nii'));
    hdr.fname = [out, '/', sub_id, '/0.01_0.1_pre.nii'];
    wfu_writeimage(hdr, pre_new_img);  
    
    hdr = spm_vol(wfu_uncompress_nifti('/project/radiology/ANSIR_lab/shared/s175064_workspace/subcon_BOLD/01KIDS_YT009_20140711/func/wart_mean_FUNC.nii'));
    hdr.fname = [out, '/', sub_id, '/0.01_0.1_post.nii'];
    wfu_writeimage(hdr, post_new_img);  
    
    pre_mean = zeros(91, 109, 91);
    pre_sd = zeros(91, 109, 91);
    pre_mean(:) = mean(pre_new_img(brain_mask==1)); 
    pre_sd(:) = std(pre_new_img(brain_mask==1));
    pre_z = (pre_new_img - pre_mean) ./ pre_sd;
    
    hdr = spm_vol(wfu_uncompress_nifti('/project/radiology/ANSIR_lab/shared/s175064_workspace/subcon_BOLD/01KIDS_YT009_20140711/func/wart_mean_FUNC.nii'));
    hdr.fname = [out, '/', sub_id, '/0.01_0.1_z_map_pre.nii'];
    wfu_writeimage(hdr, pre_z);  
    
    post_mean = zeros(91, 109, 91);
    post_sd = zeros(91, 109, 91);
    post_mean(:) = mean(post_new_img(brain_mask==1)); 
    post_sd(:) = std(post_new_img(brain_mask==1));
    post_z = (post_new_img - post_mean) ./ post_sd;
    
    hdr = spm_vol(wfu_uncompress_nifti('/project/radiology/ANSIR_lab/shared/s175064_workspace/subcon_BOLD/01KIDS_YT009_20140711/func/wart_mean_FUNC.nii'));
    hdr.fname = [out, '/', sub_id, '/0.01_0.1_z_map_post.nii'];
    wfu_writeimage(hdr, post_z);  
    
    pre_mean = zeros(91, 109, 91);
    pre_mean(:) = mean(pre_new_img(brain_mask==1)); 
    pre_mean_norm = pre_new_img ./ pre_mean;
    
    hdr = spm_vol(wfu_uncompress_nifti('/project/radiology/ANSIR_lab/shared/s175064_workspace/subcon_BOLD/01KIDS_YT009_20140711/func/wart_mean_FUNC.nii'));
    hdr.fname = [out, '/', sub_id, '/0.01_0.1_mean_norm_pre.nii'];
    wfu_writeimage(hdr, pre_mean_norm);  
    
    post_mean = zeros(91, 109, 91);
    post_mean(:) = mean(post_new_img(brain_mask==1)); 
    post_mean_norm = post_new_img ./ post_mean;
    
    hdr = spm_vol(wfu_uncompress_nifti('/project/radiology/ANSIR_lab/shared/s175064_workspace/subcon_BOLD/01KIDS_YT009_20140711/func/wart_mean_FUNC.nii'));
    hdr.fname = [out, '/', sub_id, '/0.01_0.1_mean_norm_post.nii'];
    wfu_writeimage(hdr, post_mean_norm);  
    
end;

wfu_uncompress_nifti('cleanup');