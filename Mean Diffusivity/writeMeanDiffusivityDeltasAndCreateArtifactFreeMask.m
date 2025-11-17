clear all;
wfu_uncompress_nifti('cleanup');
cd '/project/radiology/ANSIR_lab/shared/s175064_workspace/HS_multicontrast_final/MD';
root = '/project/radiology/ANSIR_lab/shared/s175064_workspace/HS_multicontrast_final/MD';
out = '/project/radiology/ANSIR_lab/shared/s175064_workspace/HS_multicontrast_final/MD/deltaImages';
% define filepaths of pre and post imaging (all iamging is sequentially sorted so each index corresponds to the correct player-season in both lists)
pre_flist = cellstr(wfu_bpm_read_flist('/project/radiology/ANSIR_lab/shared/s175064_workspace/HS_multicontrast_final/MD/flists/pre.flist'));
post_flist = cellstr(wfu_bpm_read_flist('/project/radiology/ANSIR_lab/shared/s175064_workspace/HS_multicontrast_final/MD/flists/post.flist'));
% define a brain mask to exclude voxels outside of brain
mask = '/project/radiology/ANSIR_lab/shared/s175064_workspace/HS_multicontrast_final/MD/Masks/dartelbin.nii';
gm_mask = '/project/radiology/ANSIR_lab/shared/s175064_workspace/HS_multicontrast_final/MD/Masks/whole_brain_gm_onlyneo.nii';
mask_img = spm_read_vols(spm_vol(mask)); 
gm_mask = spm_read_vols(spm_vol(gm_mask)); 
no_artifact = ones(121, 145, 121); 
no_artifact = no_artifact .* gm_mask; 
for a=1:length(pre_flist)
    padded = sprintf('%03d', a); % create a string with leading zeros so that filepaths remain alphanum sortable in order of flists above
    prePath = pre_flist{a};
    splitPath = strsplit(prePath, '/');
    subID = splitPath{8};
    disp(subID);
    prePath = [prePath, '/swrtensor_MD.nii.gz'];
    hdr_img = spm_vol(wfu_uncompress_nifti(prePath));
    pre_img = spm_read_vols(hdr_img);
    pre_img(isnan(pre_img)) = 0;
    % replace zero values with a near zero substituted so we can divide by zero when caluclating percent (This only affects non-brain regions)    
    pre_img(pre_img==0) = 0.000001;
    
    % create a binary image that excludes areas of susceptibilty artifact
    pre_bin = zeros(size(pre_img));
    pre_bin(pre_img > 0.3) = 1; 
    
    postPath = post_flist{a};
    postPath = [postPath, '/swrtensor_MD.nii.gz'];
    hdr_img = spm_vol(wfu_uncompress_nifti(postPath)); 
    post_img = spm_read_vols(hdr_img);
    post_img(isnan(post_img)) = 0;    
    post_img(post_img==0) = 0.000001;
    % create a binary image that excludes areas of susceptibilty artifact
    post_bin = zeros(size(post_img));
    post_bin(post_img > 0.3) = 1;
    
    % iteratively remove areas of susceptibility from gray matter mask
    no_artifact = no_artifact .* pre_bin .* post_bin;
    
    delta_img = (post_img - pre_img)./pre_img * 100;
    delta_img = delta_img .* mask_img;
    hdr = hdr_img;
    hdr.fname = [out, '/', padded, '_', subID, '.nii'];
    % writes delta image from that subject as a nifti
    wfu_writeimage(hdr, delta_img); 
end;

hdr = hdr_img;
hdr.fname = [root, '/Masks/no_artifact_mask.nii'];
% writes the mask with no DTI susceptibiltiy artifact as a nifti
wfu_writeimage(hdr, no_artifact); 
wfu_uncompress_nifti('cleanup');
