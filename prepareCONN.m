%-----------------------------------------------------------------------
% Job saved on 28-May-2021 18:25:26 by cfg_util (rev $Rev: 6942 $)
% spm SPM - SPM12 (7219)
% cfg_basicio BasicIO - Unknown
%-----------------------------------------------------------------------
clear all;
%%%%% Local system throws errors for CONN coregistration of volumes and reslicing so these steps run outside of CONN toolbox
unix(['module swap fsl/4.1.8 fsl/6.0.4']);
wfu_envmodule('swap fsl/6.0.4');
main_dir = '/project/radiology/ANSIR_lab/shared/s175064_workspace/HS_multicontrast_final/psd_fmri/images/';
cd(main_dir);
outdir = '/project/radiology/ANSIR_lab/shared/s175064_workspace/HS_multicontrast_final/psd_fmri/images/';
unix(['mkdir ', outdir]);
options.displayFiles = false;
options.displayDirectories = false;
recurseDepth = false;
% list directory paths where unprocessed files are stored
flist = cellstr(wfu_bpm_read_flist('/project/radiology/ANSIR_lab/shared/s175064_workspace/HS_multicontrast_final/psd_fmri/prepost.flist'));
for a=1:length(flist)
    path = [fileparts(flist{a})];
    path = path(1:(length(path)-4))
    sub_id = strsplit(path, '/');
    sub_id = sub_id{8};
    disp(sub_id);
    padded = sprintf('%03d', a);
    folder_path = fullfile([main_dir, padded, sub_id]); 
    unix(['mkdir ', padded, sub_id]);
    % searches within out directory to find the fmri files
    bold_search_path_orig = wfu_find_files('epfid2d16.*nii$', path, recurseDepth, options);
    img = spm_vol(bold_search_path_orig{1}); 
    if length(img) ~= 190; 
        bold_search_path = bold_search_path_orig{2};
    else
        bold_search_path = bold_search_path_orig{1}; 
    end
    disp(bold_search_path);
    % searches within out directory to find the structural files
    struc_search_path = wfu_find_files('tfl3d116.*nii$', path, recurseDepth, options);
    struc_search_path = struc_search_path{1};

    unix(['cp -f ', bold_search_path, ' ', folder_path, '/FUNC.nii'])
    unix(['cp -f ', struc_search_path, ' ', folder_path, '/STRUC_neck.nii'])
    unix(['fslreorient2std ', folder_path, '/STRUC_neck ', folder_path, '/roSTRUC_neck']);
    unix(['fslreorient2std ', folder_path, '/FUNC ', folder_path, '/roFUNC']);
    unix(['robustfov -i ', folder_path, '/roSTRUC_neck -r ', folder_path, '/roSTRUC']);
    unix(['gunzip ', folder_path, '/roFUNC.nii.gz']);
    unix(['gunzip ', folder_path, '/roSTRUC.nii.gz']);
    
    padded = sprintf('%03d', a);
    func_file = char([main_dir, '/', padded, sub_id, '/roFUNC.nii,1']);
    struc_file = char([main_dir, '/', padded, sub_id, '/roSTRUC.nii,1']);
    root_file = char([main_dir, '/', padded, sub_id, '/roFUNC.nii,']);
    hdr_img = spm_vol(root_file);
    a = hdr_img.dim;
    slice_num = a(3);
    disp(sub_id);
    disp(slice_num);
    
    matlabbatch{1}.spm.spatial.realign.estwrite.data = {
                                                        {char([root_file, '1'])
                                                         char([root_file, '2'])
                                                         char([root_file, '3'])
                                                         char([root_file, '4'])
                                                         char([root_file, '5'])
                                                         char([root_file, '6'])
                                                         char([root_file, '7'])
                                                         char([root_file, '8'])
                                                         char([root_file, '9'])
                                                         char([root_file, '10'])
                                                         char([root_file, '11'])
                                                         char([root_file, '12'])
                                                         char([root_file, '13'])
                                                         char([root_file, '14'])
                                                         char([root_file, '15'])
                                                         char([root_file, '16'])
                                                         char([root_file, '17'])
                                                         char([root_file, '18'])
                                                         char([root_file, '19'])
                                                         char([root_file, '20'])
                                                         char([root_file, '21'])
                                                         char([root_file, '22'])
                                                         char([root_file, '23'])
                                                         char([root_file, '24'])
                                                         char([root_file, '25'])
                                                         char([root_file, '26'])
                                                         char([root_file, '27'])
                                                         char([root_file, '28'])
                                                         char([root_file, '29'])
                                                         char([root_file, '30'])
                                                         char([root_file, '31'])
                                                         char([root_file, '32'])
                                                         char([root_file, '33'])
                                                         char([root_file, '34'])
                                                         char([root_file, '35'])
                                                         char([root_file, '36'])
                                                         char([root_file, '37'])
                                                         char([root_file, '38'])
                                                         char([root_file, '39'])
                                                         char([root_file, '40'])
                                                         char([root_file, '41'])
                                                         char([root_file, '42'])
                                                         char([root_file, '43'])
                                                         char([root_file, '44'])
                                                         char([root_file, '45'])
                                                         char([root_file, '46'])
                                                         char([root_file, '47'])
                                                         char([root_file, '48'])
                                                         char([root_file, '49'])
                                                         char([root_file, '50'])
                                                         char([root_file, '51'])
                                                         char([root_file, '52'])
                                                         char([root_file, '53'])
                                                         char([root_file, '54'])
                                                         char([root_file, '55'])
                                                         char([root_file, '56'])
                                                         char([root_file, '57'])
                                                         char([root_file, '58'])
                                                         char([root_file, '59'])
                                                         char([root_file, '60'])
                                                         char([root_file, '61'])
                                                         char([root_file, '62'])
                                                         char([root_file, '63'])
                                                         char([root_file, '64'])
                                                         char([root_file, '65'])
                                                         char([root_file, '66'])
                                                         char([root_file, '67'])
                                                         char([root_file, '68'])
                                                         char([root_file, '69'])
                                                         char([root_file, '70'])
                                                         char([root_file, '71'])
                                                         char([root_file, '72'])
                                                         char([root_file, '73'])
                                                         char([root_file, '74'])
                                                         char([root_file, '75'])
                                                         char([root_file, '76'])
                                                         char([root_file, '77'])
                                                         char([root_file, '78'])
                                                         char([root_file, '79'])
                                                         char([root_file, '80'])
                                                         char([root_file, '81'])
                                                         char([root_file, '82'])
                                                         char([root_file, '83'])
                                                         char([root_file, '84'])
                                                         char([root_file, '85'])
                                                         char([root_file, '86'])
                                                         char([root_file, '87'])
                                                         char([root_file, '88'])
                                                         char([root_file, '89'])
                                                         char([root_file, '90'])
                                                         char([root_file, '91'])
                                                         char([root_file, '92'])
                                                         char([root_file, '93'])
                                                         char([root_file, '94'])
                                                         char([root_file, '95'])
                                                         char([root_file, '96'])
                                                         char([root_file, '97'])
                                                         char([root_file, '98'])
                                                         char([root_file, '99'])
                                                         char([root_file, '100'])
                                                         char([root_file, '101'])
                                                         char([root_file, '102'])
                                                         char([root_file, '103'])
                                                         char([root_file, '104'])
                                                         char([root_file, '105'])
                                                         char([root_file, '106'])
                                                         char([root_file, '107'])
                                                         char([root_file, '108'])
                                                         char([root_file, '109'])
                                                         char([root_file, '110'])
                                                         char([root_file, '111'])
                                                         char([root_file, '112'])
                                                         char([root_file, '113'])
                                                         char([root_file, '114'])
                                                         char([root_file, '115'])
                                                         char([root_file, '116'])
                                                         char([root_file, '117'])
                                                         char([root_file, '118'])
                                                         char([root_file, '119'])
                                                         char([root_file, '120'])
                                                         char([root_file, '121'])
                                                         char([root_file, '122'])
                                                         char([root_file, '123'])
                                                         char([root_file, '124'])
                                                         char([root_file, '125'])
                                                         char([root_file, '126'])
                                                         char([root_file, '127'])
                                                         char([root_file, '128'])
                                                         char([root_file, '129'])
                                                         char([root_file, '130'])
                                                         char([root_file, '131'])
                                                         char([root_file, '132'])
                                                         char([root_file, '133'])
                                                         char([root_file, '134'])
                                                         char([root_file, '135'])
                                                         char([root_file, '136'])
                                                         char([root_file, '137'])
                                                         char([root_file, '138'])
                                                         char([root_file, '139'])
                                                         char([root_file, '140'])
                                                         char([root_file, '141'])
                                                         char([root_file, '142'])
                                                         char([root_file, '143'])
                                                         char([root_file, '144'])
                                                         char([root_file, '145'])
                                                         char([root_file, '146'])
                                                         char([root_file, '147'])
                                                         char([root_file, '148'])
                                                         char([root_file, '149'])
                                                         char([root_file, '150'])
                                                         char([root_file, '151'])
                                                         char([root_file, '152'])
                                                         char([root_file, '153'])
                                                         char([root_file, '154'])
                                                         char([root_file, '155'])
                                                         char([root_file, '156'])
                                                         char([root_file, '157'])
                                                         char([root_file, '158'])
                                                         char([root_file, '159'])
                                                         char([root_file, '160'])
                                                         char([root_file, '161'])
                                                         char([root_file, '162'])
                                                         char([root_file, '163'])
                                                         char([root_file, '164'])
                                                         char([root_file, '165'])
                                                         char([root_file, '166'])
                                                         char([root_file, '167'])
                                                         char([root_file, '168'])
                                                         char([root_file, '169'])
                                                         char([root_file, '170'])
                                                         char([root_file, '171'])
                                                         char([root_file, '172'])
                                                         char([root_file, '173'])
                                                         char([root_file, '174'])
                                                         char([root_file, '175'])
                                                         char([root_file, '176'])
                                                         char([root_file, '177'])
                                                         char([root_file, '178'])
                                                         char([root_file, '179'])
                                                         char([root_file, '180'])
                                                         char([root_file, '181'])
                                                         char([root_file, '182'])
                                                         char([root_file, '183'])
                                                         char([root_file, '184'])
                                                         char([root_file, '185'])
                                                         char([root_file, '186'])
                                                         char([root_file, '187'])
                                                         char([root_file, '188'])
                                                         char([root_file, '189'])
                                                         char([root_file, '190'])
                                                    };
                                                    }';
%%
    matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.quality = 0.9;
    matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.sep = 4;
    matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.fwhm = 5;
    matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.rtm = 1;
    matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.interp = 2;
    matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.wrap = [0 0 0];
    matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.weight = '';
    matlabbatch{1}.spm.spatial.realign.estwrite.roptions.which = [2 1];
    matlabbatch{1}.spm.spatial.realign.estwrite.roptions.interp = 4;
    matlabbatch{1}.spm.spatial.realign.estwrite.roptions.wrap = [0 0 0];
    matlabbatch{1}.spm.spatial.realign.estwrite.roptions.mask = 1;
    matlabbatch{1}.spm.spatial.realign.estwrite.roptions.prefix = 'r';
    matlabbatch{2}.spm.temporal.st.scans{1}(1) = cfg_dep;
    matlabbatch{2}.spm.temporal.st.scans{1}(1).tname = 'Session';
    matlabbatch{2}.spm.temporal.st.scans{1}(1).tgt_spec{1}(1).name = 'filter';
    matlabbatch{2}.spm.temporal.st.scans{1}(1).tgt_spec{1}(1).value = 'image';
    matlabbatch{2}.spm.temporal.st.scans{1}(1).tgt_spec{1}(2).name = 'strtype';
    matlabbatch{2}.spm.temporal.st.scans{1}(1).tgt_spec{1}(2).value = 'e';
    matlabbatch{2}.spm.temporal.st.scans{1}(1).sname = 'Realign: Estimate & Reslice: Resliced Images (Sess 1)';
    matlabbatch{2}.spm.temporal.st.scans{1}(1).src_exbranch = substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1});
    matlabbatch{2}.spm.temporal.st.scans{1}(1).src_output = substruct('.','sess', '()',{1}, '.','rfiles');
    matlabbatch{2}.spm.temporal.st.nslices = slice_num; 
    matlabbatch{2}.spm.temporal.st.tr = 2;
    TA = (2 - (2/slice_num));
    matlabbatch{2}.spm.temporal.st.ta = TA; 
    matlabbatch{2}.spm.temporal.st.so = [1:slice_num]; 
    matlabbatch{2}.spm.temporal.st.refslice = 1;
    matlabbatch{2}.spm.temporal.st.prefix = 'a';
    spm_jobman('run', matlabbatch);
    
    %organize all the files that were generated so each to access in conn toolbox
    %the preprocessed BOLD will be placed into the "func" folder
    %the preprocessed T1 will be placed into the "anat" folder
    disp(sub_id);
    struc_path = fullfile([main_dir, padded, sub_id, '/roSTRUC.nii']);
    func_path = fullfile([main_dir, padded, sub_id, '/arroFUNC.nii']);
    mkdir([outdir, padded, sub_id]);
    mkdir([outdir, padded, sub_id, '/anat']);
    mkdir([outdir, padded, sub_id, '/func']);
    unix(['cp ', struc_path, ' ', outdir, padded, sub_id, '/anat/T1.nii']);
    unix(['cp ', func_path, ' ', outdir, padded, sub_id, '/func/FUNC.nii']);
    %file is necessary to run art repair in CONN
    % the txt file for 6 dof realignments will be placed into the "func" folder where it is later used for art repair 
    unix(['cp ', main_dir, padded, sub_id, '/rp_roFUNC.txt ', outdir, padded, sub_id, '/func/rp_FUNC.txt']);  
end
