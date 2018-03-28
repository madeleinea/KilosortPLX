function ops = convertPLEXONToRawBinary(ops,do_write)

if(nargin<2)
    do_write=true;
end

fname       = ops.fbinary;
UTmkdir(fname);
if(do_write)
    fidout      = fopen(fname, 'w');
    if(fidout==-1)
        error(['Could not open file: ',fname])
    end
end


%
nFiles=length(ops.root);
fprintf('Concatenating PLEXON data to a single binary file.')
tic

filename = ops.PLXname;
[tscounts, wfcounts, evcounts, slowcounts] = plx_info(filename,1);
% get the a/d data into a cell array also.
% This is complicated by channel numbering.
% The number of samples for analog channel 0 is stored at slowcounts(1).
% Note that analog ch numbering starts at 0, not 1 in the data, but the
% 'allad' cell array is indexed by ich+1

[u,nslowchannels] = size( slowcounts );                                    

if ( nslowchannels > 0 )
    % preallocate for speed
    rawData = cell(1,nslowchannels);
    channels_with_data=find(slowcounts>0);
    channels_with_data=channels_with_data-1; %subtract 1 because channel counting starts for 0
    nchannels = ops.Nchan;
    %assume the first n channels are the spike data
    channels_with_data=channels_with_data(1:nchannels);     
    for ich = 1:length(channels_with_data)
        [adfreq, n, ts, fn, adv] = plx_ad_v(filename,channels_with_data(ich));
        if ich==1
            rawData=zeros(length(adv),length(channels_with_data),'int16');
        end
        try
        %preallocate on the first round
        rawData(:,ich) = int16(adv*1e3);
        catch
            pause
        end
    end
end


written_count=fwrite(fidout, rawData', 'int16'); %line that writes data to binary file

if(do_write)
    fclose(fidout);
end
toc
