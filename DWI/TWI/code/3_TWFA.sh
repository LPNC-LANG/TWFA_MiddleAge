#################################################################
# 4 TWI maps
#################################################################

cd /path/to/output/whole_brain

ls ./tck_in_template_space | grep ^sub- > subjList.txt
sed -i -e 's/_tract_in_template_space.tck//g' subjList.txt

for sub in `cat subjList.txt`; do
  # SIFT2 weights are the same if generated in subject space or in template space after having applied FOD-computed warps
  tckmap tck_in_template_space/${sub}*.tck -info -tck_weights_in /path/to/preprocessed_data/${sub}/dwi/sift_1M_up.txt -stat_tck gaussian -fwhm_tck 25 -template ../../data/template/wmfod_norm_up_template.mif -contrast scalar_map -image ../transformed_template/${sub}_FA_template.nii.gz -stat_vox mean TW_FA/${sub}_TW_FA_Gaussian25.nii.gz
done


# Concatenate volumes along axes 3 (4th dim)
for sub in `cat subjList.txt`; do
	cd TW_FA
	echo "
	##########################################################################################
	############################## Now concatenating subject ${sub} Tracts ###################
	##########################################################################################
	";
	mrcat ${sub}* ${sub}_TW_FA_Gaussian25.nii -force 
	cd ..
done
