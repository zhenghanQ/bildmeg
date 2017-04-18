% permutation test of scout time series

%initialize
%clear all;
addpath(genpath('Functions'));
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

for pair = 1:length(Conditions)
    for scoutID = 3
        dataTD = []; %null data, 10subjects, 500 time points
        dataASD = [];
        for i = 1:length(SubjectNames)
            condID = Conditions{pair};
            subjID = SubjectNames{i};
            file = dir(['./' subjID '/' condID '/matrix*']);
            subjcond = load(['./' SubjectNames{i} '/' Conditions{pair} '/' file.name]);
            subjcondscout = subjcond.Value(scoutID,1:601);
            if TD(i)==1
                dataTD = [dataTD; subjcondscout];
            else
                dataASD = [dataASD;subjcondscout];
            end
        end
        dataTD_f = filter_apply(dataTD,hf);
        dataASD_f = filter_apply(dataASD,hf);
        dlmwrite(['/Users/zqi/Documents/MIT/MEG/project_Zhenghan_autism/Results/scouts36/' condID '_' num2str(scoutID) '_TD.csv'],dataTD_f,';');
        dlmwrite(['/Users/zqi/Documents/MIT/MEG/project_Zhenghan_autism/Results/scouts36/' condID '_' num2str(scoutID) '_ASD.csv'],dataASD_f,';');
        [StatMap,StatMapPv,Perm,FDR,PermMatrix] = permutation_2sample(dataTD,dataASD,nResample,alpha,tail);
        save (['/Users/zqi/Documents/MIT/MEG/project_Zhenghan_autism/Results/scouts36/' condID '_' num2str(scoutID)],'subjID', 'condID', 'scoutID', 'StatMap', 'StatMapPv', 'Perm', 'FDR', 'PermMatrix');
        figure; hold on; grid on
        ylabel('pAm','fontsize',14)
        plot(mean(dataTD_f))
        plot(mean(dataASD_f),'r')
        set(gca,'fontsize',12);
        print(gcf,['/Users/zqi/Documents/MIT/MEG/project_Zhenghan_autism/Results/scouts36/' condID '_' num2str(scoutID) '.png'],'-dpng','-r300');
    end
end

Interaction1 = {'213-114', '212-111'};
Interaction2 = {'123-111','122-114'};
Interaction3 = {'123-111','212-111'};
Interaction4 = {'213-114','122-114'};
% comparing groups in children's overall auditory responses
% (deviants-standard) - haven't performed the analysis.
for scoutID = 1:36
    dataTD = []; %null data, 10subjects, 500 time points
    dataASD = [];
    dataTD_rare = [];
    dataTD_freq = [];
    dataASD_rare = [];
    dataASD_freq = [];
    for i = 1:length(SubjectNames)
        cond1 = Interaction1{1};
        cond2 = Interaction1{2};
        cond3 = Interaction2{1};
        cond4 = Interaction2{2};
        subjID = SubjectNames{i};
        file1 = dir(['./' subjID '/' cond1 '/matrix*']);
        subjcond1 = load(['./' SubjectNames{i} '/' cond1 '/' file1.name]);
        subjcondscout1 = subjcond1.Value(scoutID,1:601);
        file2 = dir(['./' subjID '/' cond2 '/matrix*']);
        subjcond2 = load(['./' SubjectNames{i} '/' cond2 '/' file2.name]);
        subjcondscout2 = subjcond2.Value(scoutID,1:601);
        file3 = dir(['./' subjID '/' cond3 '/matrix*']);
        subjcond3 = load(['./' SubjectNames{i} '/' cond3 '/' file3.name]);
        subjcondscout3 = subjcond3.Value(scoutID,1:601);
        file4 = dir(['./' subjID '/' cond4 '/matrix*']);
        subjcond4 = load(['./' SubjectNames{i} '/' cond4 '/' file4.name]);
        subjcondscout4 = subjcond4.Value(scoutID,1:601);
        sum = subjcondscout1 + subjcondscout2 + subjcondscout3 + subjcondscout4;
        if TD(i)==1
            dataTD = [dataTD; sum];
        else
            dataASD = [dataASD;sum];
        end
    end
    dataTD_f = filter_apply(dataTD,hf);
    dataTD_f_test = dataTD(:,101:601);
    dataASD_f = filter_apply(dataASD,hf);
    dataASD_f_test = dataASD(:,101:601);
    [StatMap,StatMapPv,Perm,FDR,PermMatrix] = permutation_2sample(dataTD_f_test,dataASD_f_test,nResample,alpha,tail);
    save (['/Users/zqi/Documents/MIT/MEG/project_Zhenghan_autism/Results/scouts36/' 'syl_' num2str(scoutID)],'subjID', 'scoutID', 'StatMap', 'StatMapPv', 'Perm', 'FDR', 'PermMatrix');
    
%     figure; hold on; grid on
%     ylabel('pAm','fontsize',25)
%     plot(mean(dataTD_f))
%     plot(mean(dataASD_f),'r')
%     set(gca,'fontsize',25);
%     print(gcf,['/Users/zqi/Documents/MIT/MEG/project_Zhenghan_autism/Results/scouts36/syl_' num2str(scoutID) '.png'],'-dpng','-r300');
% 
%     figure; hold on; grid on
%     ylabel('pAm','fontsize',14)
%     plot(mean(dataTD_rare),'k')
%     plot(mean(dataTD_freq),'b')
%     set(gca,'fontsize',12);
%     print(gcf,['/Users/zqi/Documents/MIT/MEG/project_Zhenghan_autism/Results/scouts36/syl_filter_TD_' num2str(scoutID) '.png'],'-dpng','-r300');
%     
%     figure; hold on; grid on
%     ylabel('pAm','fontsize',14)
%     plot(mean(dataASD_rare),'r')
%     plot(mean(dataASD_freq),'m')
%     set(gca,'fontsize',12);
%     print(gcf,['/Users/zqi/Documents/MIT/MEG/project_Zhenghan_autism/Results/scouts36/syl_filter_ASD_' num2str(scoutID) '.png'],'-dpng','-r300');
    
end

for scoutID = 1:36
    dataTD = []; %null data, 10subjects, 500 time points
    dataASD = [];
    dataTD_rare = [];
    dataTD_freq = [];
    dataASD_rare = [];
    dataASD_freq = [];
    for i = 1:length(SubjectNames)
        cond1 = Interaction1{1};
        cond2 = Interaction1{2};
        subjID = SubjectNames{i};
        file1 = dir(['./' subjID '/' cond1 '/matrix*']);
        subjcond1 = load(['./' SubjectNames{i} '/' cond1 '/' file1.name]);
        subjcondscout1 = subjcond1.Value(scoutID,1:601);
        file2 = dir(['./' subjID '/' cond2 '/matrix*']);
        subjcond2 = load(['./' SubjectNames{i} '/' cond2 '/' file2.name]);
        subjcondscout2 = subjcond2.Value(scoutID,1:601);
        diff = subjcondscout1 - subjcondscout2;
        %diff = abs(subjcondscout1) - abs(subjcondscout2);
        if TD(i)==1
            dataTD = [dataTD; diff];
            dataTD_rare = [dataTD_rare;subjcondscout1];
            dataTD_freq = [dataTD_freq;subjcondscout2];
        else
            dataASD = [dataASD;diff];
            dataASD_rare = [dataASD_rare;subjcondscout1];
            dataASD_freq = [dataASD_freq;subjcondscout2];
        end
    end
    dataTD_f = filter_apply(dataTD,hf);
    dataTD_f_test = dataTD(:,101:601);
    dataASD_f = filter_apply(dataASD,hf);
    dataASD_f_test = dataASD(:,101:601);
    dataTD_rare = filter_apply(dataTD_rare,hf);
    dataTD_freq = filter_apply(dataTD_freq,hf);
    dataASD_rare = filter_apply(dataASD_rare,hf);
    dataASD_freq = filter_apply(dataASD_freq,hf);
    [StatMap,StatMapPv,Perm,FDR,PermMatrix] = permutation_2sample(dataTD_f_test,dataASD_f_test,nResample,alpha,tail);
    save (['/Users/zqi/Documents/MIT/MEG/project_Zhenghan_autism/Results/scouts36/' 'syl_' num2str(scoutID)],'subjID', 'scoutID', 'StatMap', 'StatMapPv', 'Perm', 'FDR', 'PermMatrix');
    
%     figure; hold on; grid on
%     ylabel('pAm','fontsize',25)
%     plot(mean(dataTD_f))
%     plot(mean(dataASD_f),'r')
%     set(gca,'fontsize',25);
%     print(gcf,['/Users/zqi/Documents/MIT/MEG/project_Zhenghan_autism/Results/scouts36/syl_' num2str(scoutID) '.png'],'-dpng','-r300');
% 
%     figure; hold on; grid on
%     ylabel('pAm','fontsize',14)
%     plot(mean(dataTD_rare),'k')
%     plot(mean(dataTD_freq),'b')
%     set(gca,'fontsize',12);
%     print(gcf,['/Users/zqi/Documents/MIT/MEG/project_Zhenghan_autism/Results/scouts36/syl_filter_TD_' num2str(scoutID) '.png'],'-dpng','-r300');
%     
%     figure; hold on; grid on
%     ylabel('pAm','fontsize',14)
%     plot(mean(dataASD_rare),'r')
%     plot(mean(dataASD_freq),'m')
%     set(gca,'fontsize',12);
%     print(gcf,['/Users/zqi/Documents/MIT/MEG/project_Zhenghan_autism/Results/scouts36/syl_filter_ASD_' num2str(scoutID) '.png'],'-dpng','-r300');
    
end

for scoutID = 21
    dataTD = []; %null data, 10subjects, 500 time points
    dataASD = [];
    dataTD_rare = [];
    dataTD_freq = [];
    dataASD_rare = [];
    dataASD_freq = [];
    for i = 1:length(SubjectNames)
        cond1 = Interaction2{1};
        cond2 = Interaction2{2};
        subjID = SubjectNames{i};
        file1 = dir(['./' subjID '/' cond1 '/matrix*']);
        subjcond1 = load(['./' SubjectNames{i} '/' cond1 '/' file1.name]);
        subjcondscout1 = subjcond1.Value(scoutID,1:601);
        file2 = dir(['./' subjID '/' cond2 '/matrix*']);
        subjcond2 = load(['./' SubjectNames{i} '/' cond2 '/' file2.name]);
        subjcondscout2 = subjcond2.Value(scoutID,1:601);
        diff = subjcondscout1 - subjcondscout2;
        %diff = abs(subjcondscout1) - abs(subjcondscout2);
        if TD(i)==1
            dataTD = [dataTD; diff];
            dataTD_rare = [dataTD_rare;subjcondscout1];
            dataTD_freq = [dataTD_freq;subjcondscout2];
        else
            dataASD = [dataASD;diff];
            dataASD_rare = [dataASD_rare;subjcondscout1];
            dataASD_freq = [dataASD_freq;subjcondscout2];
        end
    end
    dataTD_f = filter_apply(dataTD,hf);
    dataTD_f_test = dataTD(:,101:601);
    dataASD_f = filter_apply(dataASD,hf);
    dataASD_f_test = dataASD(:,101:601);
    dataTD_rare = filter_apply(dataTD_rare,hf);
    dataTD_freq = filter_apply(dataTD_freq,hf);
    dataASD_rare = filter_apply(dataASD_rare,hf);
    dataASD_freq = filter_apply(dataASD_freq,hf);
    [StatMap,StatMapPv,Perm,FDR,PermMatrix] = permutation_2sample(dataTD_f_test,dataASD_f_test,nResample,alpha,tail);
    save (['/Users/zqi/Documents/MIT/MEG/project_Zhenghan_autism/Results/scouts36/' 'voice_' num2str(scoutID)],'subjID', 'scoutID', 'StatMap', 'StatMapPv', 'Perm', 'FDR', 'PermMatrix');
    
    figure; hold on; grid on
    ylabel('pAm','fontsize',25)
    plot(mean(dataTD_f))
    plot(mean(dataASD_f),'r')
    set(gca,'fontsize',25);
    print(gcf,['/Users/zqi/Documents/MIT/MEG/project_Zhenghan_autism/Results/scouts36/voice_' num2str(scoutID) '.png'],'-dpng','-r300');

    figure; hold on; grid on
    ylabel('pAm','fontsize',14)
    plot(mean(dataTD_rare),'k')
    plot(mean(dataTD_freq),'b')
    set(gca,'fontsize',12);
    print(gcf,['/Users/zqi/Documents/MIT/MEG/project_Zhenghan_autism/Results/scouts36/voice_filter_TD_' num2str(scoutID) '.png'],'-dpng','-r300');
    
    figure; hold on; grid on
    ylabel('pAm','fontsize',14)
    plot(mean(dataASD_rare),'r')
    plot(mean(dataASD_freq),'m')
    set(gca,'fontsize',12);
    print(gcf,['/Users/zqi/Documents/MIT/MEG/project_Zhenghan_autism/Results/scouts36/voice_filter_ASD_' num2str(scoutID) '.png'],'-dpng','-r300');
    
end

for scoutID = 13 %13 is G_temp_sup-Lateral-L; 25 is S_front_inf L; 33 is S_temporal_sup L
    dataTD = []; %null data, 10subjects, 500 time points
    dataASD = [];
    dataTD_rare = [];
    dataTD_freq = [];
    dataASD_rare = [];
    dataASD_freq = [];
    for i = 1:length(SubjectNames)
        cond1 = Interaction3{1};
        cond2 = Interaction3{2};
        subjID = SubjectNames{i};
        file1 = dir(['./' subjID '/' cond1 '/matrix*']);
        subjcond1 = load(['./' SubjectNames{i} '/' cond1 '/' file1.name]);
        subjcondscout1 = subjcond1.Value(scoutID,1:601);
        file2 = dir(['./' subjID '/' cond2 '/matrix*']);
        subjcond2 = load(['./' SubjectNames{i} '/' cond2 '/' file2.name]);
        subjcondscout2 = subjcond2.Value(scoutID,1:601);
        diff = subjcondscout1 - subjcondscout2;
        %diff = abs(subjcondscout1) - abs(subjcondscout2);
        if TD(i)==1
            dataTD = [dataTD; diff];
            dataTD_rare = [dataTD_rare;subjcondscout1];
            dataTD_freq = [dataTD_freq;subjcondscout2];
        else
            dataASD = [dataASD;diff];
            dataASD_rare = [dataASD_rare;subjcondscout1];
            dataASD_freq = [dataASD_freq;subjcondscout2];
        end
    end
    dataTD_f = filter_apply(dataTD,hf);
    dataTD_f_test = dataTD_f(:,100:601);
    dataASD_f = filter_apply(dataASD,hf);
    dataASD_f_test = dataASD_f(:,100:601);
    dataTD_rare = filter_apply(dataTD_rare,hf);
    dataTD_freq = filter_apply(dataTD_freq,hf);
    dataASD_rare = filter_apply(dataASD_rare,hf);
    dataASD_freq = filter_apply(dataASD_freq,hf);
    [StatMap,StatMapPv,Perm,FDR,PermMatrix] = permutation_2sample(dataTD_f_test,dataASD_f_test,nResample,alpha,tail);
    save (['/Users/zqi/Documents/MIT/MEG/project_Zhenghan_autism/Results/scouts36/' 'block1_filter_' num2str(scoutID)],'subjID', 'scoutID', 'StatMap', 'StatMapPv', 'Perm', 'FDR', 'PermMatrix');
    figure; hold on; grid on
    ylabel('pAm','fontsize',25)
    plot(mean(dataTD_f))
    plot(mean(dataASD_f),'r')
    set(gca,'fontsize',25);
    print(gcf,['/Users/zqi/Documents/MIT/MEG/project_Zhenghan_autism/Results/scouts36/block1_filter_' num2str(scoutID) '.png'],'-dpng','-r300');
    
    figure; hold on; grid on
    ylabel('pAm','fontsize',14)
    plot(mean(dataTD_rare),'k')
    plot(mean(dataTD_freq),'b')
    set(gca,'fontsize',12);
    print(gcf,['/Users/zqi/Documents/MIT/MEG/project_Zhenghan_autism/Results/scouts36/block1_filter_TD_' num2str(scoutID) '.png'],'-dpng','-r300');
    
    figure; hold on; grid on
    ylabel('pAm','fontsize',14)
    plot(mean(dataASD_rare),'r')
    plot(mean(dataASD_freq),'m')
    set(gca,'fontsize',12);
    print(gcf,['/Users/zqi/Documents/MIT/MEG/project_Zhenghan_autism/Results/scouts36/block1_filter_ASD_' num2str(scoutID) '.png'],'-dpng','-r300');
    
end

for scoutID = 13 %13 is G_temp_sup-Lateral-L; 25 is S_front_inf L
    dataTD = []; %null data, 10subjects, 500 time points
    dataASD = [];
    dataTD_rare = [];
    dataTD_freq = [];
    dataASD_rare = [];
    dataASD_freq = [];
    for i = 1:length(SubjectNames)
        cond1 = Interaction4{1};
        cond2 = Interaction4{2};
        subjID = SubjectNames{i};
        file1 = dir(['./' subjID '/' cond1 '/matrix*']);
        subjcond1 = load(['./' SubjectNames{i} '/' cond1 '/' file1.name]);
        subjcondscout1 = subjcond1.Value(scoutID,1:601);
        file2 = dir(['./' subjID '/' cond2 '/matrix*']);
        subjcond2 = load(['./' SubjectNames{i} '/' cond2 '/' file2.name]);
        subjcondscout2 = subjcond2.Value(scoutID,1:601);
        diff = subjcondscout1 - subjcondscout2;
        %diff = abs(subjcondscout1) - abs(subjcondscout2);
        if TD(i)==1
            dataTD = [dataTD; diff];
            dataTD_rare = [dataTD_rare;subjcondscout1];
            dataTD_freq = [dataTD_freq;subjcondscout2];
        else
            dataASD = [dataASD;diff];
            dataASD_rare = [dataASD_rare;subjcondscout1];
            dataASD_freq = [dataASD_freq;subjcondscout2];
        end
    end
    dataTD_f = filter_apply(dataTD,hf);
    dataTD_f_test = dataTD_f(:,100:501);
    dataASD_f = filter_apply(dataASD,hf);
    dataASD_f_test = dataASD_f(:,100:501);
    dataTD_rare = filter_apply(dataTD_rare,hf);
    dataTD_freq = filter_apply(dataTD_freq,hf);
    dataASD_rare = filter_apply(dataASD_rare,hf);
    dataASD_freq = filter_apply(dataASD_freq,hf);
    [StatMap,StatMapPv,Perm,FDR,PermMatrix] = permutation_2sample(dataTD_f_test,dataASD_f_test,nResample,alpha,tail);
    save (['/Users/zqi/Documents/MIT/MEG/project_Zhenghan_autism/Results/scouts36/' 'block2_filter_' num2str(scoutID)],'subjID', 'scoutID', 'StatMap', 'StatMapPv', 'Perm', 'FDR', 'PermMatrix');
    figure; hold on; grid on
    ylabel('pAm','fontsize',25)
    plot(mean(dataTD_f))
    plot(mean(dataASD_f),'r')
    set(gca,'fontsize',25);
    print(gcf,['/Users/zqi/Documents/MIT/MEG/project_Zhenghan_autism/Results/scouts36/block2_filter_' num2str(scoutID) '.png'],'-dpng','-r300');
    
    figure; hold on; grid on
    ylabel('pAm','fontsize',14)
    plot(mean(dataTD_rare),'k')
    plot(mean(dataTD_freq),'b')
    set(gca,'fontsize',12);
    print(gcf,['/Users/zqi/Documents/MIT/MEG/project_Zhenghan_autism/Results/scouts36/block2_filter_TD_' num2str(scoutID) '.png'],'-dpng','-r300');
    
    figure; hold on; grid on
    ylabel('pAm','fontsize',14)
    plot(mean(dataASD_rare),'r')
    plot(mean(dataASD_freq),'m')
    set(gca,'fontsize',12);
    print(gcf,['/Users/zqi/Documents/MIT/MEG/project_Zhenghan_autism/Results/scouts36/block2_filter_ASD_' num2str(scoutID) '.png'],'-dpng','-r300');
    
end 

for scoutID = 25
    dataTD = []; %null data, 10subjects, 500 time points
    dataASD = [];
    for i = 1:length(SubjectNames)
        cond1 = Interaction3{1};
        cond2 = Interaction3{2};  
        cond3 = Interaction4{1};
        cond4 = Interaction4{2};
        subjID = SubjectNames{i};
        file1 = dir(['./' subjID '/' cond1 '/matrix*']);
        subjcond1 = load(['./' SubjectNames{i} '/' cond1 '/' file1.name]);
        subjcondscout1 = subjcond1.Value(scoutID,1:601);
        file2 = dir(['./' subjID '/' cond2 '/matrix*']);
        subjcond2 = load(['./' SubjectNames{i} '/' cond2 '/' file2.name]);
        subjcondscout2 = subjcond2.Value(scoutID,1:601);
        diff_block1 = abs(subjcondscout1 - subjcondscout2);
        file3 = dir(['./' subjID '/' cond3 '/matrix*']);
        subjcond3 = load(['./' SubjectNames{i} '/' cond3 '/' file3.name]);
        subjcondscout3 = subjcond3.Value(scoutID,1:601);
        file4 = dir(['./' subjID '/' cond4 '/matrix*']);
        subjcond4 = load(['./' SubjectNames{i} '/' cond4 '/' file4.name]);
        subjcondscout4 = subjcond4.Value(scoutID,1:601);
        diff_block2 = abs(subjcondscout3 - subjcondscout4);
        diff = (diff_block1 + diff_block2) / 2;
        if TD(i)==1
            dataTD = [dataTD; diff];
        else
            dataASD = [dataASD;diff];
        end
    end
    dataTD_f = filter_apply(dataTD,hf);
    dataTD_f_test = dataTD_f(:,100:501);
    dataASD_f = filter_apply(dataASD,hf);
    dataASD_f_test = dataASD_f(:,100:501);
    [StatMap,StatMapPv,Perm,FDR,PermMatrix] = permutation_2sample(dataTD_f_test,dataASD_f_test,nResample,alpha,tail);
    save (['/Users/zqi/Documents/MIT/MEG/project_Zhenghan_autism/Results/scouts36/' 'block12_filter_' num2str(scoutID)],'subjID', 'scoutID', 'StatMap', 'StatMapPv', 'Perm', 'FDR', 'PermMatrix');
    figure; hold on; grid on
    ylabel('pAm','fontsize',14)
    plot(mean(dataTD_f))
    plot(mean(dataASD_f),'r')
    set(gca,'fontsize',12);
    print(gcf,['/Users/zqi/Documents/MIT/MEG/project_Zhenghan_autism/Results/scouts36/block12_filter_' num2str(scoutID) '.png'],'-dpng','-r300');
end

    

figure; hold on
plot(mean(dataTD_block1));
plot(mean(dataTD_block2),'r');

figure; hold on
plot(mean(dataASD_block1));
plot(mean(dataASD_block2),'r');


[StatMap,StatMapPv,Perm,FDR,PermMatrix] = permutation_1sample(-dataTD_block1+dataTD_block2,nResample,alpha,tail);
[StatMap,StatMapPv,Perm,FDR,PermMatrix] = permutation_1sample(dataASD_block1-dataASD_block2,nResample,alpha,tail);


