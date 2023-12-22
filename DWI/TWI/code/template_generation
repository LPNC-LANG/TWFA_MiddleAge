#!/bin/bash
# This code runs with MRtrix3

##########################################################################################################
# 1 Generation of a population template and subject-specific WM FOD map's coregistration to template space
##########################################################################################################

# Create symbolic link to access preprocessed data (fod and mask input data not made available on github)
for sub in `cat template_sample.txt`; do
	echo "${sub}";
	ln -sr /path/to/preprocessed_data/sub-${sub}/dwi/wmfod_norm_up.mif ./data/template/fod_input/${sub}.mif
	ln -sr /path/to/preprocessed_data/sub-${sub}/dwi/mask_up.mif ./data/template/mask_input/${sub}.mif
done 

# Generate population template
population_template data/template/fod_input -mask_dir data/template/mask_input data/template/wmfod_norm_up_template.mif -voxel_size 1.5
