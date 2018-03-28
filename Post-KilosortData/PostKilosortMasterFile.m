% PostKilosortMasterFile.m
% extracts data from post-phy kilosorted files
% OUTPUTS:
    % spiketrain: cell containing time of each spike of each unit in milliseconds
    % event_timestamps: cell containing times of each event in milliseconds
    % averageWF: cell containing the average amplitude of each unit in a window of 102 seconds (millivolts)
    % waveforms: what averageWF is averaging (millivolts)
    % channel: a list giving the channel that each sequential unit was taken from


KiloPath = 'C:\Users\allema\Desktop\KilosortPLX\';                          % path to kilosort folder
Kilodir = dir(KiloPath);                                                    % create structure giving info about the contents of Kilosort folder
PostKiloDataPath = cd;                                                      % save current folder path
Output_path = strcat(PostKiloDataPath,'\Data\');                            % where you want this data to be saved
for f = 1:length(Kilodir)                                                   % go through each item in kilosort folder
    if getfield(Kilodir(f),'isdir') == 1                                    % if item is a directory
        foldername = getfield(Kilodir(f),'name');                           % get name of folder
        if contains(foldername,'Outputs-')                                  % if the folder name has "Outputs-" in it 
            folderpath = strcat(KiloPath,foldername);                       % path to folder with kilosort outputs/phy files
            addpath(genpath(folderpath))                                    % add ^ to path
            PlexName = extractAfter(foldername, 'Outputs-');                % name of folder without Outputs at the beginning
            lengthPlexName = strlength(PlexName)-10;                        % finds size of file with date at end
            PlexName = extractBefore(PlexName,lengthPlexName);              % extracts name of raw data file (takes out date)
            PlexName = char(PlexName);                                      % converts to character
            savename = strcat('Data-',PlexName,'.mat');                     % name of file to be saved later
            PlexPath = strcat(KiloPath,'RawData\',PlexName);                % path to raw data file

            st = readNPY('spike_times.npy');                                % reads spike times npy file (these are in samples, not seconds)
            clu = readNPY('spike_clusters.npy');                            % reads spike clusters npy file--info about if cluster is good/bad/mua

%             [tscounts, wfcounts, evcounts, slowcounts] = plx_info(PlexPath,1); % gets info about data file
%             [x,eCh] = size(evcounts);                                       % finds number of event channels
            nCh = 8;                                                        % EDIT THIS to be the total number of channels recorded (1-9)

            [spiketrain] = create_spiketrain(st,clu,PostKiloDataPath);      % gets spiketrain (see top)
%             [event_timestamps] = EventTimes(PlexPath,evcounts,eCh,PostKiloDataPath); % gets event_timestamps
            [averageWF,waveforms,channel] = waveformdata(nCh,st,clu,PostKiloDataPath); % gets averageWF, waveforms, channel


            cd(Output_path)
%             save(savename,'spiketrain','event_timestamps','averageWF','waveforms','channel')
            save(savename,'spiketrain','averageWF','waveforms','channel')
            cd(PostKiloDataPath)
        end
    end
end