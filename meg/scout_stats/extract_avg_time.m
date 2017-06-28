nSubjects = 20;
nTimes = 601; %baseline 100ms, poststim 500ms
SubjectNames = {'bildc3128', 'bildc3129', 'bildc3149', 'bildc3193', 'bildc3194', ...
    'bildc3202', 'bildc3229', 'bildc3233', 'bildc3234', 'bildc3235', ...
    'bildc3092', 'bildc3143', 'bildc3144', 'bildc3182', 'bildc3187', ...
    'bildc3219', 'bildc3237', 'bildc3266', 'bildc3267', 'bildc3268'}; 
Conditions = {'123-111', '212-111', '213-114','122-114'};
TD = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1];
ASD = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
nScouts = 36;
nResample = 1000;
alpha = 0.05;
tail = 'twotail';
cd /Users/zqi/Documents/MIT/MEG/brainstorm_db/MMN/data
plotflag = 0;
hf = filter_design('lowpass',20,100,1000,plotflag);

time = -0.1:0.001:0.5;
tbin{1} = find(time>=0.1 & time < 0.15);
tbin{2} = find(time>=0.15 & time < 0.2);
tbin{3} = find(time>=0.2 & time < 0.25);
tbin{4} = find(time>=0.25 & time < 0.3);
tbin{5} = find(time>=0.3 & time < 0.35);
tbin{6} = find(time>=0.35 & time < 0.4);

for pair = 1:length(Conditions)
    for scoutID = 17
        dataTD = []; %null data, 10subjects, 500 time points
        dataASD = [];
        for i = 1:length(SubjectNames)
            condID = Conditions{pair};
            subjID = SubjectNames{i};
            file = dir(['./' subjID '/' condID '/matrix*']);
            subjcond = load(['./' SubjectNames{i} '/' Conditions{pair} '/' file.name]);
            subjcondscout = subjcond.Value(scoutID,1:601);
            subjcondscout = filter_apply(subjcondscout,hf);
            subjcondbin = [];
            for t = 1:length(tbin)
                subjcondbin(t) = mean(subjcondscout(:,tbin{t}));
            end
            if TD(i)==1
                dataTD = [dataTD; subjcondbin];
            else
                dataASD = [dataASD;subjcondbin];
            end
        end
        scoutbin = [dataTD;dataASD];
        dlmwrite(['/Users/zqi/Documents/MIT/MEG/project_Zhenghan_autism/Results/scouts36/' condID '_' num2str(scoutID) '_TD_ASD.csv'],scoutbin,';');
    end
end

