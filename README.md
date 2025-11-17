This repository contains all analysis code, preprocessing scripts, and figure-generation workflows used in the manuscript:
“Region-Specific Multimodal Brain Imaging Correlates of Repetitive Head Impact Exposure in Non-Concussed High School Football Players.”
The goal of this project is to reproducibly process multimodal MRI data, compute head-impact exposure metrics, and perform voxelwise
statistical analyses linking RWE-Lin to changes in mean diffusivity (MD) and resting-state fMRI power spectral density (fMRI-PSD).

Repository Structure: 
/Main
    /Biomechanics
        angles.csv
        generate_azel_map.m
        get_azimuth_func.m
        get_elevation_func.m
    /MEG
        write_delta_MEG_band_images.m
    /Mean Diffusivity
        get_CSV_values_MD.m
        writeMeanDiffusivityDeltasAndCreateArtifactFreeMask.m
    /Stats & Graphs
        ITAKL_Python_Code_Neuroimage.ipynb
        ITAKL_code.R
        hs_final_deidentified.csv
    /fMRI PSD
        get_least_common_denominatorPSD.m
        make_PSD_images.m
        prepareCONN.m
        smooth_psd_images_post.m
        smooth_psd_images_pre.m
        write_delta_psd_images.m
README.md
