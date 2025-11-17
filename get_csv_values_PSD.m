clear all;
wfu_uncompress_nifti('cleanup');
cd '/project/radiology/ANSIR_lab/shared/s175064_workspace/HS_multicontrast_final/psd_fmri';
out = '/project/radiology/ANSIR_lab/shared/s175064_workspace/HS_multicontrast_final/psd_fmri';
delta_flist = cellstr(wfu_bpm_read_flist('/project/radiology/ANSIR_lab/shared/s175064_workspace/HS_multicontrast_final/psd_fmri/flists/delta.flist'));
mask1 = '/project/radiology/ANSIR_lab/shared/s175064_workspace/HS_multicontrast_final/psd_fmri/Results/Neg/psd_down_0.0125_100vox.nii';

outFile=fullfile(out, ['neg_psd_all.csv']);
fid = fopen(outFile, 'w');
fprintf(fid, 'PSD_Avg\n');

mask_img = spm_read_vols(spm_vol(mask1));
mask_img(isnan(mask_img)) = 0;

for a=1:length(delta_flist)
    disp(a);
    path = delta_flist{a};
    img = spm_read_vols(spm_vol(wfu_uncompress_nifti(path))); 
    img(isnan(img)) = 0;
    
    average = mean(img(mask_img>0));
    disp(average);
    fprintf(fid, '%f\n', average); 
end;

wfu_uncompress_nifti('cleanup');