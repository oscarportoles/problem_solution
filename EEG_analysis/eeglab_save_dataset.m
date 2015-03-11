%%
%**************************************************************************
% Saves the dataset in eeglab data format.
% Inputs
%   - dataset_name: 
%   - folder_path
%   - EEG
%   - file_name (optional)
%*************************************************************************

function [ALLEEG, EEG] = eeglab_save_dataset(ALLEEG, EEG, data_name, folder_path, file_name)    
    if nargin < 5
        file_name = data_name;
    end
    
    EEG = pop_saveset( EEG, 'filename',strcat(file_name,'.set'),'filepath',folder_path);
    EEG = eeg_checkset( EEG );
    [ALLEEG EEG CURRENTSET] = eeg_store(ALLEEG, EEG);
 
end