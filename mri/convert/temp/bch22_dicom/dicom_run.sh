#!/bin/bash
singularity exec -B /mindhive/xnat/dicom_storage/BILD/Kids:/dicomdir -B /om/user/zqi/projects/bildmeg/subject/:/output -B /om/user/zqi/projects/bildmeg/script/bildmeg/mri/convert/:/mnt -c /storage/gablab001/data/singularity-images/heudiconv/nipy/heudiconv heudiconv -d /dicomdir/%s/dicom/TrioTim*/*.dcm -c dcm2niix -o /output -f /mnt/heuristic_bildmeg_bids.py -s bch22 -b
