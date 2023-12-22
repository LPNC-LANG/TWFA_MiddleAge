#!/bin/bash

#################################################################
# 1 Subject-specific WM FOD map's coregistration to template space
#################################################################
cd /path/to/preprocessed_data/
for_each sub* : mrregister -transformed output/transformed_template/IN_transformed.mif.gz -nl_warp_full output/warped_template/1_warp/IN_warp.mif.gz IN/dwi/wmfod_norm_up.mif -mask1 IN/dwi/mask_up.mif data/template/wmfod_norm_up_template.mif

#################################################################
# 2 Register tracks to template space with FOD-computed warps
#################################################################
cd /path/output/warped_template/1_warp <-- takes sub*_warp.mif.gz as input

for_each * : warpconvert PRE.mif.gz warpfull2deformation -template /path/to/data/template/wmfod_norm_up_template.mif ../2_warpfull2deformation/PRE_warp2fulldeformation.mif.gz
for_each * : warpinvert ../2_warpfull2deformation/PRE_warpfull2deformation.mif.gz ../3_warped_invert/PRE_warpfull2deformation_invert.mif.gz

cd /path/to/preprocessed_data/ <-- takes tractograms in subject space as input
for_each * : tcktransform IN/dwi/tracks_10M_up.tck /path/to/output/warped_template/3_warped_invert/PRE_warp_warp2fulldeformation_invert.mif.gz /path/to/output/whole_brain/PRE_tract_in_template_space.tck

#################################################################
# 3 Generate & Register tensor-based images to template space with FOD-computed warps
#################################################################

cd /path/to/preprocessed_data/
for_each -info sub* : dwi2tensor IN/dwi/*unbiased_upsampled.mif - \| tensor2metric - -fa - \| mrcalc - -abs /path/to/output/FA_map/IN_FA_map.mif.gz


cd /path/to/output/whole_brain
ls . | grep ^sub- > subjList.txt
sed -i -e 's/_tract_in_template_space.tck//g' subjList.txt

for sub in `cat subjList.txt`; do
 	mrtransform -template ../../data/template/wmfod_norm_up_template.mif -warp ../warped_template/2_warpfull2deformation/${sub}_warp_warp2fulldeformation.mif.gz ../FA_map/${sub}_FA_map.mif.gz ../transformed_template/${sub}_FA_template.nii.gz
done
