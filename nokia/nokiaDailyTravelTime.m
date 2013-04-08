folders = dir('nokia_data');
userCellData = [];
for folder = folders'
    name = folder.name;
    if ~isempty(str2num(name)) && ~strcmp(folder.name, '001')
        currentFileName = strcat('nokia_data\',folder.name,'\gps.csv');
        currentdata = textscan(fopen(currentFileName),'%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f', 'headerLines', 1, 'Delimiter', ',');
        userCellData = [userCellData; currentdata];
    end
end
userGpsData=[];
for i = 1:16
    currentRow = userCellData(i,:);
    currentColumn = [];
    for j=1:length(userCellData)
        currentColumn=[currentColumn;cell2mat(userCellData(j,i))];
    end
    userGpsData=[userGpsData, currentColumn];
end
%userid, posix date, distance
userLongestFlights=[];
currentUser=0;
%userid, posix date, long, lat
userHistory=[];
for i=1:length(userGpsData)
    currentRow = userGpsData(i,:);
    if currentUser==0
        currentUser=currentRow(1);
    end
    if currentRow(1)~=currentUser
        userLongestFlights=determineLongestFlight(userHistory, userLongestFlights);
        userHistory=[];
        currentUser=currentRow(1);
    end
    if isempty(userGpsData)
        userHistory=[currentRow(1), currentRow(1), currentRow(6), currentRow(7)];
    else
        userHistory=[userHistory; currentRow(1), currentRow(1), currentRow(6), currentRow(7)];
    end
end
