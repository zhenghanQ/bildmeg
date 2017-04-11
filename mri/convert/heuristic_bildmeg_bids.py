import os

def create_key(template, outtype=('nii.gz',), annotation_classes=None):
    if template is None or not template:
        raise ValueError('Template must be a valid format string')
    return (template, outtype, annotation_classes)

def infotodict(seqinfo):
    """Heuristic evaluator for determining which runs belong where

    allowed template fields - follow python string module:

    item: index within category
    subject: participant id
    seqitem: run number during scanning
    subindex: sub index within group
    """

    rs = create_key('func/sub-{subject}_task-rest_bold')
    dwi = create_key('dwi/sub-{subject}_dwi')
    t1 = create_key('anat/sub-{subject}_T1w')
    t2 = create_key('anat/sub-{subject}_T2w')
    info = {rs:[], dwi:[], t1:[], t2:[]}
    
    for s in seqinfo:
        x,y,sl,nt = (s[6], s[7], s[8], s[9])
        if (nt == 149) and ('ep2d_Resting' in s[12]):
            info[rs] = [s[2]]
        elif (nt == 40) and ('DIFFUSION' in s[12]):
            info[dwi].append(s[2])
        elif (sl == 176) and (nt ==1) and ('T1_MPRAGE' in s[12]):
            info[t1]=[s[2]]
        elif (nt == 454.0) and ('T2' in s[12]) and('NORM' in s[18]):
            info[t2].append(s[2])
        else:
            pass
    return info
