# bildmeg
meg analysis (structural + brainstorm)

## Participants
20 ASD (1 without structural data; 1 with dental spacer; 1 was too far away from the scanner (3280); 4 with noisy data (3292, 3302, 3315, 3317))
17 TD (1 with dental crowns, 2 with noisy data (3092, 3224), 1 with weird spikes (3302))
5 ASD-History (1 with noisy data (bch14),)

## Experiment Design
|Stimuli    |Block1         |Block2         |Block3  |
|:---------:|:-------------:|:-------------:|:------:|
|BA(V1)     |1000-111-b1    |1000-114-b6    |1000-115|
|DA(V1)     |200-212-b2     |100-213-b3     |100-214 |
|BA(V2)     |100-123-b5     |200-122-b4     |100-124 |

## MEG analysis notes
1. Epoching (-100, 500)
2. Peak-to-peak artifact rejection: 6000 fT/cm as the first pass (but maybe looking for bad channels?) moving forward: amplitude > 2000 fT/cm; gradient > 3500 fT/cm/sample (Moseley et al., 2014)?
3. generate subject mean (arithmatic mean) for condition contrast
..* Rare Syllable: 213-114
..* Freq Syllable: 212-111
..* Rare Voice: 123-111
..* Freq Voice: 122-114
..* Syllable vs. Voice: 214-124
4. `load_scouts_per_zq.m`: Test group by condition interaction tp-by-tp (0-500ms) in all 36 fronto-temporal regions. Look for scouts with 6 continuous time points with tp-wise p-values lower than 0.05 (monte-carlo simulation)
5. `extract_avg_time.m`: Filter the data, bin time points (50ms window width, 6 bins) and extract average amplitude for each group, each condition and each bin -> save as an csv file.
6. verify the interaction between group and condition in the MMF time window (150-300) and P300 time window (300-450).

## Future analysis directions
1. time-frequency analysis - theta band?
2. neural decoding - spatial and temporal decoders in each participant for rare vs frequent deviants.
3. analyzing the # of standards before the deviants: how expectation is adjusted to local statistical environment.