%Segment

function [ALLEEG, EEG] = eeglab_extract_epochs(ALLEEG, EEG,new_dateset_name,event_name,epochTime)

%Extracts epochs and remove baseline
EEG = eeg_checkset( EEG );
EEG = pop_epoch( EEG,   event_name  , epochTime, 'newname', new_dateset_name, 'epochinfo', 'yes');
EEG = eeg_checkset( EEG );
for i = 1:length(EEG.event)
    EEG.event(i).originalepoch = EEG.event(i).epoch;
end

end