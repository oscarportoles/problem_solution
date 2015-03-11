%ERP analysis
clear all
eeglab

open_path = 'C:\\GC data\\LightsOnOffAnalysis\\P8\\';
save_path = 'C:\\GC data\\LightsOnOffAnalysis\\P8\\';

%1 - Open Filtered data
[ALLEEG, EEG] = eeglab_open_dataset(ALLEEG, '_fil.set', open_path);
participants = length(ALLEEG);

%2 - Substract latency
latency_ms = 14 + 18;
for i = 1:participants
    EEG = ALLEEG(i);
    EEG = eeglab_substracLatency(EEG,latency_ms);
    EEG.setname = [EEG.setname(1:length(EEG.setname)-5) '_lat'];
    [ALLEEG, EEG] = pop_newset(ALLEEG, EEG, i, 'overwrite', 'on');
end

%3 - Segment data
epoch_time = [-0.2 1];
events = {{'p1__', 'p2__'}, {'p3__', 'p4__'}};

for i = 1:participants
    for j=1:length(events)
        EEG = ALLEEG(i);
        if j==1
            light = 'on';
        else
            light = 'off';
        end
        new_dataset_name = [EEG.setname '_ep_' light];
        [ALLEEG, EEG] = eeglab_extract_epochs(ALLEEG, EEG,new_dataset_name, events{j}, epoch_time);
        [ALLEEG, EEG] = pop_newset(ALLEEG, EEG, i, 'overwrite', 'on');
        disp(['participant: ' EEG.setname 'number of epochs: ' num2str(EEG.trials)]);
    end
end

%4 - baseline correction
baseline_time = [-200 0];
for i=1:participants
    EEG = ALLEEG(i);
    EEG = pop_rmbase( EEG, baseline_time);
    EEG.setname = [EEG.setname '_bs'];
    [ALLEEG, EEG] = pop_newset(ALLEEG, EEG, i, 'overwrite', 'on');
end

% SAVE DATA
for i= 1:participants
    EEG = ALLEEG(i);
    [ALLEEG, EEG] = eeglab_save_dataset(ALLEEG, EEG, EEG.setname, save_path);
end