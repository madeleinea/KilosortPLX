function [spiketrain] = create_spiketrain(spike_times,spike_clusters,PostKiloDataPath)

addpath(genpath(PostKiloDataPath))

fid = fopen('cluster_groups.csv');
cluster_groups = textscan(fid,'%s%s');
good = {'good'};

for i = 1:max(spike_clusters)+1
    for j = 1:length(cluster_groups{1})
        if isequal(cell2mat(cluster_groups{1}(j)),char(int2str(i-1))) % find cluster associated with unit
            if isequal(cluster_groups{2}(j),good) % see if cluster is classified as good
                spiketrain{i} = (double(spike_times(spike_clusters==i-1)))/40; % gives spike times for each unit in milliseconds (each number divided by the sample_rate value in params.py will give number in seconds)
            else
                continue
            end
        end
    end

end
spiketrain = spiketrain(~cellfun('isempty',spiketrain));

end
