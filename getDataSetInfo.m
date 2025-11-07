function dataSet = getDataSetInfo(directories)

%Find subject IDs
d = dir(directories.dataDir);

% find and delete files/positions that are not related to a datafile
for iDel = 1:size(d,1)
    if ~startsWith(d(iDel).name,'sub')
        delIds(iDel)=iDel;
    end
end
d(delIds)=[];

for n = 1:size(d,1)
    dataSet.fileNames(n,:) =  d(n).name;
    ID = extract(d(n).name,digitsPattern);
    dataSet.IDs(n,:) = str2num(string(ID));
end

dataSet.nParticipants = size(dataSet.IDs,1);
end