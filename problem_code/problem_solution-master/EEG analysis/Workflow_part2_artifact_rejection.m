
%SECOND PART - ARTIFACT REJECTION AND RE-REFERENCING


%5 - Trial rejection and interpolation

%Reject trials marked as invalid


for i = 1:participants
    part = str2num(ALLEEG(i).setname(4:5));
    if isempty(part)
        part = str2num(ALLEEG(i).setname(2));
    end
    %-------
    %The ac_rej_row will be a vector containing 1 in the trials that should
    %be rejected and the ones 
    
    EEG = ALLEEG(i);
    
    EEG = pop_rejepoch( EEG, ac_rej_row ,0);
    [ALLEEG EEG] = pop_newset(ALLEEG, EEG, i, 'overwrite', 'on');
end

%Interpolation of bad channels and trials
for i = 1:participants
    
    [EEGrej, EEGint] = eeglab_Interpolation(EEG);
    [ALLEEG, EEG] = pop_newset(ALLEEG, EEGint, i, 'overwrite', 'on');
    [ALLEEG, EEG] = eeglab_save_dataset(ALLEEG, EEG, EEG.setname, save_path);
end


%6 - Re-referencing
exclude_channels = [127	126	17	15	14	9	8	2	1	125	122	121	120	119	114	113	107	99	94	88	81	73	68	63	56	49	44	43	48	38	33	128	32	26	25	22	21];
for i=1:participants
    EEG = ALLEEG(i);
    EEG = pop_reref( EEG, [],'refloc',struct('labels',{'Cz'},'Y',{0},'X',{5.4492e-16},'Z',{8.8992},'sph_theta',{0},'sph_phi',{90},'sph_radius',{8.8992},'theta',{0},'radius',{0},'type',{''},'ref',{''},'urchan',{132},'datachan',{0}),'exclude',exclude_channels );
    EEG.setname = [EEG.setname '_ref'];
    [ALLEEG, EEG] = pop_newset(ALLEEG, EEG, i, 'overwrite', 'on');
    [ALLEEG, EEG] = eeglab_save_dataset(ALLEEG, EEG, EEG.setname, save_path);
end