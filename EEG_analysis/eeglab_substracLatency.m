function EEG = eeglab_substracLatency(EEG,latencymSec)

%Moves the events to account for the latency of the stimulus onset
%
% Inputs:   EEG - EEG dataset
%           lantencySec - latency in ms (negative value if shifting back)
%           samplingRate - sampling ate 

latencySamples = round(latencymSec*EEG.srate/1000);

for i = 1:length(EEG.event)
    
   EEG.event(i).latency = EEG.event(i).latency + latencySamples; 
    
end

end