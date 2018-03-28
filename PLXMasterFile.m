% default options are in parenthesis after the comment
tic; % start timer
PATH = 'C:\\Users\\allema\\Desktop\\KilosortPLX\\'; % edit this to be the path to your Kilosort folder
dataPATH = strcat(PATH, 'RawData\\'); % path to your raw data folder
rawdatafolder = dir(dataPATH);
FILE = 0;
% errorpath = strcat(PATH, 'ErrorFiles\\'); % path to error files folder,where files will go if they cause errors(un-comment try/catch statements at lines 9, 41-44) 
for i=1:length(rawdatafolder)
    if getfield(rawdatafolder(i),'isdir') ~= 1
%          try                                % un-comment if some files are causing errors, keep commented if all/most files are causing errors
            PLXnameAlone = getfield(rawdatafolder(i),'name');
            fprintf('Current file is: ')
            fprintf(PLXnameAlone)

            %PLXnameAlone = input('Please enter the name of the PLEXON file to be sorted (in single quotes with suffix): ');
            [ops] = PLXStandardConfig(PLXnameAlone,PATH,dataPATH);

            fprintf('Time %3.0fs. Initializing GPU ...\n', toc)
            %
            if ops.GPU     
                gpuDevice(1); % initialize GPU (will erase any existing GPU arrays)
            end

            [rez, DATA, uproj] = PLXpreprocessData(ops); % preprocess data and extract spikes for initialization
            rez                = fitTemplates(rez, DATA, uproj);  % fit templates iteratively
            rez                = fullMPMU(rez, DATA);% extract final spike times (overlapping extraction)

            % AutoMerge. rez2Phy will use for clusters the new 5th column of st3 if you run this)
            %     rez = merge_posthoc2(rez);

            % save matlab results file
            save(fullfile(ops.root,  'rez.mat'), 'rez', '-v7.3');

            % save python results file for Phy
            rezToPhy(rez, ops.outputPath);

            % remove temporary file
            delete(ops.fproc);
            %%

%             copyfile('PostKilosortMasterFile.m',ops.outputPath);
%          catch
%              copyfile(ops.PLXname,errorpath);
%              continue
%          end
        FILE = FILE +1;
        elapsedtime(FILE,1) = toc;
    end
end
save('runtimes.mat','elapsedtime')