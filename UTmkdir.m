function UTmkdir(directory)

flag=filesep;
flags=strfind(directory,flag);
for i=2:length(flags)
    if(~exist(directory(1:flags(i)),'dir'))
        mkdir(directory(1:flags(i)))
        
        if(strcmp(flag,'\'))
            direct=directory(1:flags(1));
            for j=1:length(flags(1:i))-1
                append=[flag,directory(flags(j)+1:flags(j+1))];
                direct(end+1:end+length(append))=append;
            end
            fprintf(['Made ',[direct,flag],' directory\n'])
        else
            fprintf(['Made ',directory(1:flags(i)),' directory\n'])
        end
            
    end
end