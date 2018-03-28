Output_path = cd;
PlexName = extractAfter(Output_path, 'Outputs-');
PlexName = char(PlexName);
savename = strcat('Data-',PlexName,'.mat');
PlexPath = strcat('..\RawData\',PlexName);                                  % edit this to be the path to your raw data file
PostKiloDataPath = 'C:\Users\allema\Desktop\KilosortPLX\Post-KilosortData'; % edit this if you moved your Post-kilosort scripts folder
addpath(genpath(PostKiloDataPath))

st = readNPY('spike_times.npy'); % these are in samples, not seconds
clu = readNPY('spike_clusters.npy');

[tscounts, wfcounts, evcounts, slowcounts] = plx_info(PlexPath,1);
%nCh = input('Enter the number of channels: ');
[x,eCh] = size(evcounts);
nCh = 2;                                                                    % edit this to be the number of channels in your file

[spiketrain] = create_spiketrain(st,clu,PostKiloDataPath);
[event_timestamps] = EventTimes(PlexPath,evcounts,eCh,PostKiloDataPath);
[averageWF] = waveformdata(nCh,st,clu,PostKiloDataPath);

clearvars -except spiketrain event_timestamps averageWF savename
%clearvars -except spiketrain averageWF savename
save(savename)