clear all; 
% read in dataframe of all angles
angles = readtable('/project/radiology/ANSIR_lab/shared/s175064_workspace/HS_multicontrast_final/angles.csv');
% get the min and max el and az angles of each bin
el_mins = angles.min_el;
el_maxes = angles.max_el;
az_mins = angles.min_az;
az_maxes = angles.max_az;
% get the frequency of each binned region
nums = angles.Num; 
final = zeros(182, 218, 182); 
for i=1:9 %9 is the number of bins that are left after Jenk's Natural Breaks
    disp(i); 
    az_min = az_mins(i); 
    az_max = az_maxes(i); 
    el_min = el_mins(i); 
    el_max = el_maxes(i);
    az_map = get_azimuth_func(az_min, az_max, 182, 218, 112, 93, 200); 
    el_map = get_elevation_func(el_min, el_max, 218, 182, 93, 112, 200);
    % get intersection of azimuth and elevation
    combo = az_map .* el_map; 
    final(combo==1) = nums(i); 
end
hdr = spm_vol('/project/radiology/ANSIR_lab/shared/s175064_workspace/HS_multicontrast_final/scalp.nii');
mask = spm_read_vols(hdr);
final = imrotate3(final, 0, [0 1 0], 'nearest', 'crop');
% draw the binned regions onto the MNI scalp
final = final .* mask; 
hdr.fname = '/project/radiology/ANSIR_lab/shared/s175064_workspace/HS_multicontrast_final/finalRWE_LinJenks.nii';
wfu_writeimage(hdr, final);
