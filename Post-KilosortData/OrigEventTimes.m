function [event_timestamps] = EventTimes(PlexName,eCh,PostKiloDataPath)

addpath(genpath(PostKiloDataPath))
%addpath(genpath('C:\Users\allema\Desktop\KilosortPLX\RawData'))

event_timestamps = cell(1,eCh);
for i = 1:eCh
    [n, ts, sv] = plx_event_ts(PlexName, i, PostKiloDataPath);
    event_timestamps{i} = ts;
end