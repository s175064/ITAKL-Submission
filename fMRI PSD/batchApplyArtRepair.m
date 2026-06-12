clear all;
cd '/project/radiology/ANSIR_lab/shared/s175064_workspace/HS_multicontrast_final/psd2';
out = '/project/radiology/ANSIR_lab/shared/s175064_workspace/HS_multicontrast_final/psd2/images/';
all_flist = cellstr(wfu_bpm_read_flist('/project/radiology/ANSIR_lab/shared/s175064_workspace/HS_multicontrast_final/psd2/flists/all.flist'));
flist_length = length(all_flist);
for a=1:length(all_flist)
    path = fullfile(all_flist{a}, '/func/FUNC.nii');
    sub_id = strsplit(path, '/');
    sub_id = sub_id{10};
    disp(sub_id);
    realign_file = fullfile(all_flist{a}, '/func/rp_FUNC.txt');

% 2. Get header information for all volumes
% spm_vol returns an array of structures, one for each volume
    V = spm_vol(path);

% 3. Create the list of volume-specific paths
    num_vols = numel(V);
    vols = cell(num_vols, 1);
    for i = 1:num_vols
        vols{i} = sprintf('%s,%d', path, i);
    end;
    art_global(char(vols), realign_file, 1, 1);
end;    