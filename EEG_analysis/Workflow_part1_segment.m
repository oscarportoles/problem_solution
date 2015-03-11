% %ERP analysis
% clc
% clear all
% eeglab
% 
% open_path = 'C:\a_problem_project\EEG_data\\';
% save_path = 'C:\a_problem_project\EEG_data\\';
% 
% %1 - Open Filtered data
% [ALLEEG, EEG] = eeglab_open_dataset(ALLEEG, '.set', open_path);
% participants = length(ALLEEG);
% 
% %2 - Substract latency
% latency_ms = 14 + 18;
% for i = 1:participants
%     EEG = ALLEEG(i);
%     EEG = eeglab_substracLatency(EEG,latency_ms);
%     EEG.setname = [EEG.setname '_lat'];
%     [ALLEEG, EEG] = pop_newset(ALLEEG, EEG, i, 'overwrite', 'on');
% end
% 
%3 - Load editing template info
template_path = 'C:\\a_problem_project\\templates';
template_filename = '\\editing_template_KK.xlsx';
values_filename = 'values_editing_template_KK.txt';
sheets = {'S5', 'S6', 'S7', 'S8', 'S12', 'S13', 'S15', 'S26', ...
          'S27', 'S28', 'S29', 'S30', 'S31', 'S37', 'S42', 'S44', ...
          'S46', 'S49', 'S50'};

[accepted_rejected_total, bad_channel_total] = load_editing_template(template_path, template_filename, sheets, values_filename);
% 
% for i=1:participants
%     EEG=ALLEEG(i);
%     part_num = str2num(EEG.setname(2:3));
%     if isempty(part_num)
%         part_num = str2num(EEG.setname(2));
%     end
%     acc_rej_column = accepted_rejected_total(2:end,accepted_rejected_total(1,:) == part_num);
%     for j=1:size(bad_channel_total,2)
%         if bad_channel_total{1, j} == part_num
%             column = j;
%             break;
%         end
%     end
%     bad_ch_column = bad_channel_total(2:end,column);
%     for j=1:length(EEG.event)
%         EEG.event(j).accepted = acc_rej_column(j);
%         EEG.event(j).chinterp = bad_ch_column{j};
%     end
% end
% clear accepted_rejected_total bad_channel_total part_num column bad_ch_column
% 
% %4 - Segment data
% epoch_time = [-0.25 1.05];     % Next sub-segments take a shorter window (see pop_epoch) 
% events = {'p1__', 'p2__','p3__', 'p4__', 'p0__'};
% 
% for i = 1:participants
% %     for j=1:length(events)
% %         EEG = ALLEEG(i);
% %         if j==1
% %             light = 'on';
% %         else
% %             light = 'off';
% %         end
%     new_dataset_name = [EEG.setname '_ep_' light];
%     [ALLEEG, EEG] = eeglab_extract_epochs(ALLEEG, EEG,new_dataset_name, events, epoch_time);
%     %[ALLEEG, EEG] = pop_newset(ALLEEG, EEG, i, 'overwrite', 'off');
%     disp(['participant: ' EEG.setname 'number of epochs: ' num2str(EEG.trials)]);
%     %end
% end

% %5 - baseline correction
% baseline_time = [-250 0];
% for i=1:participants
%     EEG = ALLEEG(i);
%     EEG = pop_rmbase( EEG, baseline_time);
%     EEG.setname = [EEG.setname '_bs'];
%     [ALLEEG, EEG] = pop_newset(ALLEEG, EEG, i, 'overwrite', 'on');
% end
% 
% SAVE DATA
% for i= 1:participants
%     EEG = ALLEEG(i);
%     [ALLEEG, EEG] = eeglab_save_dataset(ALLEEG, EEG, EEG.setname, save_path);
% end

