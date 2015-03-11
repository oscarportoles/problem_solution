%%
%*************************************************
% Load EGI .raw file and change the location file to adjust the right
% layout of the data. 
% Default mode is layout with 129 electrodes and Cz as reference
% Input: 
%   - dataset_filename
%   - folder_path
%   - original_filename
%   - EGI_location_file
%   - reference_electrode
%*************************************************
function ALLEEG = eeglab_import_egi_dataset(ALLEEG, folder_path, EGI_location_file, reference_electrode)
    if nargin <= 2
        EGI_location_file = 'C:\\Users\\edz\\Documents\\MATLAB\\eeglab13_0_1b\\myfunctions\\EGI location files\\GSN-HydroCel-129.sfp';
    end
    if nargin <= 3
        reference_electrode = 132;
    end
    participants = dir(folder_path);
    
    for i = 3:length(participants)
        part = participants(i).name;
        fprintf('participant name %s \n', part)
        %try
            if strcmp(part(length(part)-2:end), 'raw')
                original_filename = part;

                %Load EEG participant data
                EEG = pop_readegi(strcat(folder_path,original_filename), [],[],'auto');
                EEG.setname=original_filename(1:end-4);
                EEG=pop_chanedit(EEG, 'load',{EGI_location_file 'filetype' 'autodetect'},'changefield',{reference_electrode 'datachan' 0});
                if nargin <= 5
                    EEG=pop_chanedit(EEG, 'setref',{'' 'Cz'});
                end
                EEG = eeg_checkset( EEG );
                if isempty(ALLEEG)
                    ALLEEG = EEG;
                else
                    [ALLEEG EEG CURRENTSET] = eeg_store(ALLEEG, EEG);
                end
                eeglab redraw
            end
        %catch
            %fprintf('error in participant %s \n', part)
            %continue
        %end
    end
end
