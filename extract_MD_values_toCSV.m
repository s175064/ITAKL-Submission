clear all;
wfu_uncompress_nifti('cleanup');
cd '/project/radiology/ANSIR_lab/shared/s175064_workspace/HS_multicontrast_final/MD';
out = '/project/radiology/ANSIR_lab/shared/s175064_workspace/HS_multicontrast_final/MD/Results';
delta_flist = cellstr(wfu_bpm_read_flist('/project/radiology/ANSIR_lab/shared/s175064_workspace/HS_multicontrast_final/MD/flists/deltaAll.flist'));
mask = '/project/radiology/ANSIR_lab/shared/s175064_workspace/HS_multicontrast_final/MD/Results/Pos/md_up_0.0125_100vox.nii';
outFile=fullfile(out, ['md_avg.csv']);
fid = fopen(outFile, 'w');
fprintf(fid, 'MD_Avg\n');

mask_img = spm_read_vols(spm_vol(mask));
mask_img(isnan(mask_img)) = 0;


for a=1:length(delta_flist)
    disp(a);
    path = delta_flist{a};
    img = spm_read_vols(spm_vol(wfu_uncompress_nifti(path))); 
    img(isnan(img)) = 0;
    
    average = mean(img(mask_img>0));
    disp(average);
    fprintf(fid, '%f\n', average); 
end

wfu_uncompress_nifti('cleanup');