% SVM Decoding

%initialize
%clear all;
cd /Users/zqi/Documents/MIT/MEG/project_Zhenghan_autism
addpath(genpath('Functions'));
nSubjects = 1;
nTimes = 601; %baseline 100ms, poststim 500ms
SubjectNames = {'bildc3187', 'bildc3092', 'bildc3128', 'bildc3129', 'bildc3143', ...
   'bildc3144', 'bildc3149', 'bildc3181','bildc3182', 'bildc3193', ...
   'bildc3233', 'bildc3234', 'bildc3194', 'bildc3202', 'bildc3219', ...
   'bildc3235', 'bildc3237', 'bildc3266', 'bildc3267', 'bildc3268'}; 
% done 
Conditions = {'111','114','122','123','212','213'};
condpairs = [1,4;
    1 5;
    2 6;
    2 3];
TD = [1, 1, 0, 0, 1, 1, 0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 1, 1, 1, 1];
ASD = [0, 0, 1, 1, 0, 0, 1, 0, 0, 1, 1, 1, 1, 1, 0, 1, 0, 0, 0, 0];

% SubjectNames = {'bildc3093', 'bildc3292', 'bildc3224'}; 
% %rerun first block: 'bildc3093', 'bildc3292', 'bildc3224'
% Conditions = {'111','123','212'};
% condpairs = [1,2;
%    1 3];
%parameters
param.brainstorm_db = '/Users/zqi/Documents/MIT/MEG/brainstorm_db/MMN/data/';
param.data_type = 'MEG';
param.f_lowpass = 30;
param.num_permutations = 30; %100;
nperms = 30;
param.trial_bin_size = 20;

% block 1 standard vs small deviant; block 2 standard vs big deviant
%rng('default') % fix initialization of random number generator

%Run SVM analysis
for i = 1:length(SubjectNames)
    Accuracy = zeros(size(condpairs,1),nTimes);
    for pair = 1:size(condpairs,1)
        accuracy = zeros(length(nperms),nTimes);
        for z = 1:nperms
            z
            [accuracy(z,:),Time] = svm_contrast_conditions_perm(SubjectNames{i},Conditions(condpairs(pair,1)),Conditions(condpairs(pair,2)),param);
        end
        Accuracy(pair,:) = mean(accuracy,1);
    end
    %save(['Results/Accuracy_' SubjectNames{i}],'Accuracy','Time','param','nperms');
    save(['Results/Accuracy_30z_' SubjectNames{i}],'Accuracy','Time','param','nperms');
end   
save Accuracy_30lowpass Accuracy

%plot results
for i = 1:length(SubjectNames)
    %subjaccu = load(['Results/Accuracy_' SubjectNames{i} '.mat']);
    subjaccu = load(['Results/Accuracy_30z_' SubjectNames{i} '.mat']);
    for pair = 1:size(condpairs,1)
        figure; hold on; grid on;
        plot(Time,squeeze(subjaccu.Accuracy(pair,:)));
        set(gca,'fontsize',12);
        ylabel('Accuracy (%)','fontsize',14)
        xlabel('Time (sec)','fontsize',14)
        print(gcf,['Results/Accuracy_30z_' Conditions{condpairs(pair,1)} '_' Conditions{condpairs(pair,2)} '_' SubjectNames{i} '.png'],'-dpng','-r300');
    end
%plot average standard vs deviant
    AccuracyMMFall = (subjaccu.Accuracy(1,:) + subjaccu.Accuracy(2,:) + subjaccu.Accuracy(3,:) + subjaccu.Accuracy(4,:))/4;
    AccuracyMMF_voice = subjaccu.Accuracy(1,:) - subjaccu.Accuracy(4,:);
    AccuracyMMF_syllable = subjaccu.Accuracy(3,:) - subjaccu.Accuracy(2,:);
    AccuracyMMFall = squeeze(AccuracyMMFall);
    AccuracyMMF_voice= squeeze(AccuracyMMF_voice);
    AccuracyMMF_syllable= squeeze(AccuracyMMF_syllable);
    figure; hold on; grid on
    plot(Time,AccuracyMMF_voice);
    plot(Time,AccuracyMMF_syllable,'r');
    set(gca,'fontsize',12);
    ylabel('Accuracy (%)','fontsize',14);
    xlabel('Time (sec)','fontsize',14);
    print(gcf,['Results/Accuracy_30z_voiceblu_sylred_' SubjectNames{i} '.png'],'-dpng','-r300');
end
for i = 1:length(SubjectNames)
    %subjaccu = load(['Results/Accuracy_' SubjectNames{i} '.mat']);
    subjaccu = load(['Results/perm_20x20/Accuracy_' SubjectNames{i} '.mat']);
    for pair = 1:size(condpairs,1)
        %figure; hold on; grid on;
        %plot(Time,squeeze(subjaccu.Accuracy(pair,:)));
        set(gca,'fontsize',12);
        ylabel('Accuracy (%)','fontsize',14)
        xlabel('Time (sec)','fontsize',14)
        print(gcf,['Results/Accuracy_30z_' Conditions{condpairs(pair,1)} '_' Conditions{condpairs(pair,2)} '_' SubjectNames{i} '.png'],'-dpng','-r300');
    end
%plot average standard vs deviant
    AccuracyMMFall(i,:) = (subjaccu.Accuracy(1,:) + subjaccu.Accuracy(2,:) + subjaccu.Accuracy(3,:) + subjaccu.Accuracy(4,:))/4;
    AccuracyMMF_voicerare(i,:) = subjaccu.Accuracy(1,:);
    AccuracyMMF_voicefreq(i,:) = subjaccu.Accuracy(4,:);
    AccuracyMMF_syllablerare(i,:) = subjaccu.Accuracy(3,:);
    AccuracyMMF_syllablefreq(i,:) = subjaccu.Accuracy(2,:);
    AccuracyMMF_voice(i,:) = subjaccu.Accuracy(1,:) - subjaccu.Accuracy(4,:);
    AccuracyMMF_syllable(i,:) = subjaccu.Accuracy(3,:) - subjaccu.Accuracy(2,:);
    %figure; hold on; grid on
    %plot(Time,AccuracyMMF_voice);
    %plot(Time,AccuracyMMF_syllable,'r');
    %set(gca,'fontsize',12);
    %ylabel('Accuracy (%)','fontsize',14);
    %xlabel('Time (sec)','fontsize',14);
    %print(gcf,['Results/Accuracy_voiceblu_sylred_' SubjectNames{i} '.png'],'-dpng','-r300');
end
figure; hold on; grid on
plot(Time,mean(AccuracyMMF_voice));
plot(Time,mean(AccuracyMMF_syllable),'r');
set(gca,'fontsize',12);
ylabel('Accuracy (%)','fontsize',14);
xlabel('Time (sec)','fontsize',14);
print(gcf,['Results/Accuracy_voiceblu_sylred_' SubjectNames{i} '.png'],'-dpng','-r300');
figure; hold on; grid on
plot(Time,mean(AccuracyMMF_voicerare(TD==1,:)));
plot(Time,mean(AccuracyMMF_voicefreq),'r');
set(gca,'fontsize',12);
ylabel('Accuracy (%)','fontsize',14);
xlabel('Time (sec)','fontsize',14);
    
    
    