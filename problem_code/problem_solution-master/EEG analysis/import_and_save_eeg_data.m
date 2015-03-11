clear all
eeglab


open_path = 'G:\2 - Gaze contingency\Data\EEG files_all_events\\';
save_path = 'G:\2 - Gaze contingency\Data\EEG files_all_events\\';
EGI_location_file = 'C:\\Users\\edz\\Documents\\MATLAB\\eeglab13_0_1b\\myfunctions\\EGI location files\\GSN-HydroCel-129.sfp';
participants = dir(open_path);
reference_electrode = 132; %Cz
ALLEEG = eeglab_import_egi_dataset(ALLEEG, open_path,EGI_location_file, reference_electrode);


for i = 1:length(ALLEEG)

    EEG = ALLEEG(i);
    participant = EEG.setname(1:5);
    [ALLEEG, EEG] = eeglab_save_dataset(ALLEEG, EEG, participant, save_path);
        
end
eeglab redraw