clear all;

cd '/project/radiology/ANSIR_lab/shared/s175064_workspace/HS_multicontrast_final/psd2';
out = '/project/radiology/ANSIR_lab/shared/s175064_workspace/HS_multicontrast_final/psd2';
outFile=fullfile(out, '/tsnr_analysis.csv');
mask_path = '/project/radiology/ANSIR_lab/shared/s175064_workspace/HS_multicontrast_final/psd_fmri/masks/least_common_denominator_mask.nii';
fid = fopen(outFile, 'w');
fprintf(fid, 'orig_tsnr, art_tsnr\n');
reg_flist = cellstr(wfu_bpm_read_flist('/project/radiology/ANSIR_lab/shared/s175064_workspace/HS_multicontrast_final/psd_fmri/flists/all.flist'));
art_flist = cellstr(wfu_bpm_read_flist('/project/radiology/ANSIR_lab/shared/s175064_workspace/HS_multicontrast_final/psd2/flists/all.flist'));
mask_img = spm_read_vols(spm_vol(mask_path));

before = zeros(size(mask_img));
after = zeros(size(mask_img)); 
for a=1:length(reg_flist)
    disp(a)
    orig_path = [reg_flist{a}, '/func/wFUNC.nii'];
    art_path  = [art_flist{a}, '/func/wvFUNC.nii'];

    orig_img = spm_read_vols(spm_vol(orig_path));
    art_img = spm_read_vols(spm_vol(art_path));
    
    ori_mean = mean(orig_img, 4);
    ori_sd = std(orig_img, 0, 4);
    art_mean = mean(art_img, 4);
    art_sd = std(art_img, 0, 4);
    ori_mask2 = ori_sd > 0;
    ori_tsnr = zeros(size(ori_mean));
    ori_tsnr(ori_mask2) = ori_mean(ori_mask2) ./ ori_sd(ori_mask2);
    ori_tsnr(isnan(ori_tsnr)) = 0;
    ori_tsnr .* mask_img;
    before = before + ori_tsnr; 

    art_mask2 = art_sd > 0; 
    art_tsnr = zeros(size(art_mean)); 
    art_tsnr(art_mask2) = art_mean(art_mask2) ./ art_sd(art_mask2);
    art_tsnr(isnan(art_tsnr)) = 0;
    art_tsnr .* mask_img; 
    after = after + art_tsnr; 
    
    final_ori_tsnr = mean(ori_tsnr(mask_img==1));
    final_art_tsnr = mean(art_tsnr(mask_img==1));
    fprintf(fid, '%f\t%f\n', final_ori_tsnr, final_art_tsnr);
end;

before = before .* mask_img / length(reg_flist); 
after = after .* mask_img / length(reg_flist); 
hdr = spm_vol(mask_path); 
hdr.fname = '/project/radiology/ANSIR_lab/shared/s175064_workspace/HS_multicontrast_final/psd2/before.nii';
wfu_writeimage(hdr, before);
hdr.fname = '/project/radiology/ANSIR_lab/shared/s175064_workspace/HS_multicontrast_final/psd2/after.nii';
wfu_writeimage(hdr, after);

