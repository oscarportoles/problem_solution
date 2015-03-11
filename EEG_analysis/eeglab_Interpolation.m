function [EEGint] = eeglab_Interpolation(EEG)

%2 - Compute artifact rejection with the threshold
EEG = pop_eegthresh(EEG,1,[1:128] ,EEG.rejectParameters.rejthreshold.lowerlimit,EEG.rejectParameters.rejthreshold.upperlimit,EEG.rejectParameters.rejthreshold.startTime,EEG.rejectParameters.rejthreshold.endTime,0,0);
EEG = eeg_checkset( EEG );

%3 - Compute percentage of bad channels during the recording -->
% when it's been marked as bad (25-40%) of the trials
EEG.rejectdata.channelQuality(1:length(EEG.reject.rejthreshE(:,1)),1) = 0;
for i = 1:length(EEG.reject.rejthreshE(:,1))
    EEG.rejectdata.channelQuality(i,1) = length(EEG.reject.rejthreshE(i,EEG.reject.rejthreshE(i,:) == 1))/length(EEG.reject.rejthreshE(i,:))*100;
end

n = 1;
badChannels = 0;
for i = 1:length(EEG.rejectdata.channelQuality)
  if EEG.rejectdata.channelQuality(i) > EEG.rejectParameters.badChannelThreshold
    EEG.rejectdata.badChannel(1,n) = i;
    n = n+1;
    badChannels = 1;
  end
end


%Hide bad channels for the computation of bad trials

trialRejection = EEG.reject.rejthreshE;
if badChannels == 1
    for i = 1:length(EEG.rejectdata.badChannel)
       trialRejection(EEG.rejectdata.badChannel(i),:) = 0;

    end
end


%6 - Mark a trial as bad if more than ?% of the channels as marked as bad
%(not taking into account bad channels)

EEG.rejectdata.trialQuality(1:length(trialRejection(1,:)),1) = 0;
for i = 1:length(trialRejection(1,:))
    EEG.rejectdata.trialQuality(i,1) = length(trialRejection(trialRejection(:,i) == 1,i))/length(trialRejection(:,i))*100;
end
n = 1;

badTrials = 0;
for i = 1:length(EEG.rejectdata.trialQuality)
  if EEG.rejectdata.trialQuality(i) > EEG.rejectParameters.badTrialThreshold
    EEG.rejectdata.badTrial(n,1) = i;
    n = n+1;
    badTrials = 1;
  end
end

%7 - Reject those trials
if badTrials == 1
    EEGrej = pop_rejepoch( EEG, EEG.rejectdata.badTrial ,0);
else
    EEGrej = EEG;
end

%Compute again the artifact rejection with the same threshold - (channel
%number will have changed)
EEGrej = pop_eegthresh(EEGrej,1,[1:128] ,EEG.rejectParameters.rejthreshold.lowerlimit,EEG.rejectParameters.rejthreshold.upperlimit,EEG.rejectParameters.rejthreshold.startTime,EEG.rejectParameters.rejthreshold.endTime,0,0);


%8 - Interpolate channel/trial for the rest of the bad channels (bad
%channels are also interpolated although afterwards will be interpolated
%for the whole recording.


EEGrej.rejectdata.interpChannel = EEGrej.reject. rejthreshE;
EEGint = EEGrej;

for trial = 1:length(EEGrej.rejectdata.interpChannel(1,:))
    n=1;
    Channels = 0;
    for j=1:length(EEGrej.rejectdata.interpChannel(:,1))
        if EEGrej.rejectdata.interpChannel(j,trial) == 1
            channels (1,n) = j;
            n = n+1;
            Channels = 1;
        end
    end
    
    if Channels == 1;
       disp(strcat('Interpolating trial ',' ',num2str(trial)));
       EEGint = eeg_interp_trial(EEGint, channels, 'spherical',trial);
    end
    clearvars channels
end

%4 - Interpolate bad channels for the whole recording

if badChannels == 1
    EEGint = pop_interp(EEGint, EEGint.rejectdata.badChannel, 'spherical');
else
    EEGint.rejectdata.badChannel = [];
end


end