% % ABCD Train Workflow by SDB 2-June-2017
% 
% http://neuroimage.usc.edu/brainstorm/Tutorials/Scripting
% How to process an entire study
% This section proposes a standard workflow for processing a full group study with Brainstorm. It contains the same steps of analysis as the introduction tutorials, but separating what can be done automatically from what should be done manually. This workflow can be adapted to most ERP studies (stimulus-based).
% 
% Prototype: Start by processing one or two subjects completely interactively (exactly like in the introduction tutorials). Use the few pilot subjects that you have for your study to prototype the analysis pipeline and check manually all the intermediate stages. Take notes of what you're doing along the way, so that you can later write a script that reproduces the same operations.
%
% Anatomical fiducials: Set NAS/LPA/RPA and compute the MNI transformation for each subject.
    % Segmentation: Run FreeSurfer/BrainSuite to get surfaces and atlases for all the subjects.
        % Tracy does these; find output on openmind and copy to local machine.
        
    % File > Batch MRI fiducials: This menu prompts for the selection of the fiducials for all the subjects and saves a file fiducials.m in each segmentation folder. You will not have to redo this even if you have to start over your analysis from the beginning.
        % DONE 5/31/17 for 1702, 1703, 1704, 1705, 1708, 1714, 1716, 1721.
        
    % Script: Write a loop that calls the process "Import anatomy folder" for all the subjects.
        % import_anatomy_folder.m
        
    % Alternatives: Create and import the subjects one by one and set the fiducials at the import time. Or use the default anatomy for all the subjects (or use warped templates).
%
% Script #1: Pre-processing: Loop on the subjects and the acquisition runs.
    % Create link to raw files: Link the subject and noise recordings to the database.
    % Event markers: Read and group triggers from digital and analog channel, fix stimulation delays
    % Evaluation: Power spectrum density of the recordings to evaluate their quality.
    % Pre-processing: Notch filter, sinusoid removal, band-pass filter.
    % Evaluation: Power spectrum density of the recordings to make sure the filters worked well.
    % Cleanup: Delete the links to the original files (the filtered ones are copied in the database).
        % preprocess.m
        % add_events.m
    
    % Detect artifacts: Detect heartbeats, Detect eye blinks, Remove simultaneous.
    % Compute SSP: Heartbeats, Blinks (this selects the first component of each decomposition)
    % Compute ICA: If you have some artifacts you'd like to remove with ICA (no default selection).
    % Screenshots: Check the MRI/sensors registration, PSD before and after corrections, SSP.
    % Export the report: One report per subject, or one report for all the subjects, saved in HTML.
        % DO THIS MANUALLY.
        % Find a single channel that tracks blinks well.
            % ABCD_1703: MEG0121
        % Artifacts > Detect eye blinks
             
    % "If you have multiple acquisition runs, you may try to use all the artifacts from all the runs rather than 
    % processing the files one by one. For that, use the Process2 tab instead of Process1. Put the "Link to raw file" 
    % of all the runs on both sides, Files A (what is used to compute the SSP) and Files B (where the SSP are applied)."
        % Artifacts > SSP: Eye blinks
        % Load the raw file
        % Artifacts > Select active projectors
        % View topography
        % Choose which component to remove (usually 1).
            % ABCD_1703: 1

%
% Manual inspection #1:
    % Check the reports: Information messages (number of events, errors and warnings) and screen captures (registration problems, obvious noisy channels, incorrect SSP topographies).
    % Mark bad channels: Open the recordings, select the channels and mark them as bad. Or use the process "Set bad channels" to mark the same bad channels in multiple files.
    % Fix the SSP/ICA: For the suspicious runs: Open the file, adjust the list of blink and cardiac events, remove and recompute the SSP decompositions, manually select the components.
    % Detect other artifacts: Run the process on all the runs of all the subjects at once (select all the files in Process1 and run the process, or generate the equivalent script).
    % Mark bad segments: Review the artifacts detected in 1-7Hz and 40-240Hz, keep only the ones you really want to remove, then mark the event categories as bad. Review quickly the rest of the file and check that there are no other important artifacts.
    % Additional SSP: If you find one type of artifact that repeats (typically saccades and SQUID jumps), you can create additional SSP projectors, either with the process "SSP: Generic" or directly from a topography figure (right-click on the figure > Snapshot> Use as SSP projector).
        % As needed.
        
%
% Script #2: Subject-level analysis: Epoching, averaging, sources, time-frequency.
    % Importing: Process "Import MEG/EEG: Events" and "Pre-process > Remove DC offset".
    % Averaging: Average trials by run, average runs by subject (registration problem in MEG).
    % Noise covariance: Compute from empty room or resting recordings, copy to other folders.
    % Head model: Compute for each run, or compute once and copy if the runs are co-registered.
    % Sources: Compute for each run, average across runs and subjects in source space for MEG.
    % Time-frequency: Computation with Hilbert transform or Morlet wavelets, then normalize.
    % Screenshots: Check the quality of all the averages (time series, topographies, sources).
    % Export the report: One report per subject, or one report for all the subjects, saved in HTML.
        % import_average_source.m
    
%
% Manual inspection #2:
    % Check the reports: Check the number of epochs imported and averaged in each condition, check the screen capture of the averages (all the primary responses should be clearly visible).
    % Regions of interest: If not using predefined regions from an atlas, define the scouts on the anatomy of each subject (or on the template and then project them to the subjects).
%
% Script #3: Group analysis, ROI-based analysis, etc.
    % Averaging: Group averages for the sensor data, the sources and the time-frequency maps.
    % Statistics: Contrast between conditions or groups of subjects.
    % Regions of interest: Any operation that involve scouts.