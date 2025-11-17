clear all;
wfu_uncompress_nifti('cleanup'); % get rid of files that are in tmp directory that will eat up storage
cd '/project/radiology/ANSIR_lab/shared/s175064_workspace/HS_multicontrast_final/MD';
out = '/project/radiology/ANSIR_lab/shared/s175064_workspace/HS_multicontrast_final/MD/Results'; % define output directory location
% list of delta map file paths to extract values from
delta_flist = cellstr(wfu_bpm_read_flist('/project/radiology/ANSIR_lab/shared/s175064_workspace/HS_multicontrast_final/MD/flists/deltaAll.flist'));
% define binary mask where averages are extracted
mask = '/project/radiology/ANSIR_lab/shared/s175064_workspace/HS_multicontrast_final/MD/Results/Pos/md_up_0.0125_100vox.nii';

outFile=fullfile(out, ['md_avg.csv']); % define csv file name
fid = fopen(outFile, 'w');

fprintf(fid, 'MD_Avg\n'); % define column header

mask_img = spm_read_vols(spm_vol(mask));
mask_img(isnan(mask_img)) = 0;

for a=1:length(delta_flist)
    disp(a);
    path = delta_flist{a};
    % read in the image as a matrix - wfu_uncompress_nifti unzips .nii.gz files
    img = spm_read_vols(spm_vol(wfu_uncompress_nifti(path))); 
    img(isnan(img)) = 0;
    
    average = mean(img(mask_img>0)); % get the average value across the mask from each subject
    disp(average);
    fprintf(fid, '%f\n', average); % write out the average value to the csv file
end

% redundant but again get rid of any files in the tmp directory that eat up storage
wfu_uncompress_nifti('cleanup');
