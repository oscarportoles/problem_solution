function [ALLEEG, EEG] = eeglab_open_dataset(ALLEEG, file_name, path, begin)

if nargin < 4
    begin = 0;
end
participants = dir(path);
for i = 1:length(participants)
    part = participants(i).name;
    if length(part) - length(file_name) > 0
        if begin == 1
            word = part(1:length(file_name));
        else
            word = part(length(part)-length(file_name)+1:end);
        end
        if strcmp(word, file_name)
            EEG = pop_loadset('filename',part,'filepath',path);
            EEG.setname = part(1:length(part)-4);
            [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
        end

    end

end

return