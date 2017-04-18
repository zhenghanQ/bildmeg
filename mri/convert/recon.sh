#!/bin/bash

subjs=(sub-bch03 sub-bch14 sub-bch22 sub-bch23 sub-scsb228 sub-scsb315 sub-scsb316)

data_dir=/om/user/zqi/projects/bildmeg/subject

for sub in "${subjs[@]}";do
    if [ -d /mindhive/xnat/surfaces/BILD/Kids/${sub} ]; then
        echo '#!/bin/bash' > /om/user/zqi/projects/bildmeg/script/bildmeg/mri/convert/temp/${sub}_recon.sh
        echo '#SBATCH --mem=8G' >> /om/user/zqi/projects/bildmeg/script/bildmeg/mri/convert/temp/${sub}_recon.sh
        #echo "recon-all -s ${sub} -T2 ${data_dir}/${sub}/anat/${sub}_T2w.nii.gz -sd /mindhive/xnat/surfaces/BILD/Kids/ -T2pial -autorecon3" >> /om/user/zqi/projects/bildmeg/script/bildmeg/mri/convert/temp/${sub}_recon.sh
	echo "recon-all -s ${sub} -all -hippo-subfields -autorecon3 -no-isrunning" >> /om/user/zqi/projects/bildmeg/script/bildmeg/mri/convert/temp/${sub}_recon.sh
    fi
    if [ ! -d /mindhive/xnat/surfaces/BILD/Kids/${sub} ]; then
        echo '#!/bin/bash' > /om/user/zqi/projects/bildmeg/script/bildmeg/mri/convert/temp/${sub}_recon.sh
	echo '#SBATCH --mem=12G' >> /om/user/zqi/projects/bildmeg/script/bildmeg/mri/convert/temp/${sub}_recon.sh
	echo '#SBATCH --workdir=/om/user/zqi/projects/bildmeg/scripts/bildmeg/mri/temp'
	echo "recon-all -s ${sub} -i ${data_dir}/${sub}/anat/${sub}_T1w.nii.gz -hippo-subfields -all -sd /mindhive/xnat/surfaces/BILD/Kids/ -no-isrunning" >> /om/user/zqi/projects/bildmeg/script/bildmeg/mri/convert/temp/${sub}_recon.sh
    fi
    sbatch -t 23:00:00 --mem=20GB /om/user/zqi/projects/bildmeg/script/bildmeg/mri/convert/temp/${sub}_recon.sh
done
