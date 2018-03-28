function [event_timestamps] = EventTimes(PlexName,evcounts,eCh,PostKiloDataPath)

addpath(genpath(PostKiloDataPath))
%addpath(genpath('C:\Users\allema\Desktop\KilosortPLX\RawData'))

[u,evchans] = plx_event_chanmap(PlexName);
event_timestamps = cell(1,eCh);
for i = 1:eCh
    if ( evcounts(i) > 0 )
            evch = evchans(i);
            if ( evch == 257 )
				[nevs{i}, ts{i}, svStrobed] = plx_event_ts(PlexName, evch, PostKiloDataPath); 
			else
				[nevs{i}, ts{i}, svdummy] = plx_event_ts(PlexName, evch, PostKiloDataPath);
            end
    end
    %[n{i}, ts{i}, sv] = plx_event_ts(PlexName, i, PostKiloDataPath);
end
event_timestamps = ts(~cellfun('isempty',ts));
for ev = 1:length(event_timestamps)
    event_timestamps{ev} = event_timestamps{ev}*1000;
end
