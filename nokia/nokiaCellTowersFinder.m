user2Gps=textscan(fopen('nokia_data\002\gps.csv'),'%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f', 'headerLines', 1, 'Delimiter', ',');
user5Gps=textscan(fopen('nokia_data\005\gps.csv'),'%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f', 'headerLines', 1, 'Delimiter', ',');
user7Gps=textscan(fopen('nokia_data\007\gps.csv'),'%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f', 'headerLines', 1, 'Delimiter', ',');
user9Gps=textscan(fopen('nokia_data\009\gps.csv'),'%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f', 'headerLines', 1, 'Delimiter', ',');
user17Gps=textscan(fopen('nokia_data\017\gps.csv'),'%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f', 'headerLines', 1, 'Delimiter', ',');
user23Gps=textscan(fopen('nokia_data\023\gps.csv'),'%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f', 'headerLines', 1, 'Delimiter', ',');
user26Gps=textscan(fopen('nokia_data\026\gps.csv'),'%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f', 'headerLines', 1, 'Delimiter', ',');
user34Gps=textscan(fopen('nokia_data\034\gps.csv'),'%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f', 'headerLines', 1, 'Delimiter', ',');
user42Gps=textscan(fopen('nokia_data\042\gps.csv'),'%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f', 'headerLines', 1, 'Delimiter', ',');
user10Gps=textscan(fopen('nokia_data\010\gps.csv'),'%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f', 'headerLines', 1, 'Delimiter', ',');

user2Log=textscan(fopen('nokia_data\calllog\calllog-002.csv'),'%f %f %f %*[^\n]', 'headerLines', 1, 'Delimiter', ',');
user5Log=textscan(fopen('nokia_data\calllog\calllog-005.csv'),'%f %f %f %*[^\n]', 'headerLines', 1, 'Delimiter', ',');
user7Log=textscan(fopen('nokia_data\calllog\calllog-007.csv'),'%f %f %f %*[^\n]', 'headerLines', 1, 'Delimiter', ',');
user9Log=textscan(fopen('nokia_data\calllog\calllog-009.csv'),'%f %f %f %*[^\n]', 'headerLines', 1, 'Delimiter', ',');
user10Log=textscan(fopen('nokia_data\calllog\calllog-010.csv'),'%f %f %f %*[^\n]', 'headerLines', 1, 'Delimiter', ',');
user17Log=textscan(fopen('nokia_data\calllog\calllog-017.csv'),'%f %f %f %*[^\n]', 'headerLines', 1, 'Delimiter', ',');
user23Log=textscan(fopen('nokia_data\calllog\calllog-023.csv'),'%f %f %f %*[^\n]', 'headerLines', 1, 'Delimiter', ',');
user26Log=textscan(fopen('nokia_data\calllog\calllog-026.csv'),'%f %f %f %*[^\n]', 'headerLines', 1, 'Delimiter', ',');
%user34Log=textscan(fopen('nokia_data\calllog\calllog-034.csv'),'%f %f %f', 'headerLines', 1, 'Delimiter', ',');
%user42Log=textscan(fopen('nokia_data\calllog\calllog-042.csv'),'%f %f %f', 'headerLines', 1, 'Delimiter', ',');


%importdata('nokia_data\010\gps.csv');
userGpsData=[];
userCallData=[];
for i=1:3
    currentCell=[user2Log{i};user5Log{i};user7Log{i};user9Log{i};user10Log{i};user17Log{i};user23Log{i};user26Log{i}];%;user34Log{i};user42Log{i}];
    userCallData=[userCallData, currentCell];
end
userCallData=[userCallData, zeros(length(userCallData),1)];
for i=1:16
    currentCell=[user2Gps{i};user5Gps{i};user7Gps{i};user9Gps{i};user10Gps{i};user17Gps{i};user23Gps{i};user34Gps{i};user42Gps{i}];
    userGpsData=[userGpsData, currentCell];
end
gsm=textscan(fopen('nokia_data\nokia_gsm_data\gsm-010.csv'),'%f %f %f %f %f %f %f %f %f', 'headerLines', 1, 'Delimiter', ',');
%importdata('nokia_data\nokia_gsm_data\gsm-010.csv');
gsmData=[gsm{1}, gsm{2}, gsm{3}, gsm{4}, gsm{5}, gsm{6}, gsm{7}, gsm{8}, gsm{9}];
%holds towerId, latitude, longitude, signalStrength
listOfTowers=zeros(1,4);
timeValues=gsmData(:,2);

%find lat/long of each id based on the gsm data that occurs at the time
%within 10 seconds of each gps data
for i=1:length(userGpsData)
    i
    currentUser=userGpsData(i,:);
    currentTime=currentUser(2);
    gsmIndex=find(abs(timeValues-currentTime)<10, 1, 'first');
    if(length(gsmIndex)>0)
        currentGsmData=gsmData(gsmIndex, :);
        %gsmTime = currentGsmData
        currentSignalStrength=currentGsmData(9);
        currentTowerId=currentGsmData(6);
        currentLatitude=currentUser(7);
        currentLongitude=currentUser(6);
        if(currentSignalStrength>90)
            towerListIndex=find(listOfTowers(:,1)==currentTowerId);
            if(length(towerListIndex>0))
                lastSignalStrength = listOfTowers(towerListIndex, 4);
                if(currentSignalStrength > lastSignalStrength)
                listOfTowers(towerListIndex, 2)=currentLatitude;
                listOfTowers(towerListIndex, 3)=currentLongitude;
                listOfTowers(towerListIndex, 4)=currentSignalStrength;
                end
            else
                if(listOfTowers(1,1)==0)
                    listOfTowers=[currentTowerId, currentLatitude, currentLongitude, currentSignalStrength];
                else
                    listOfTowers=[listOfTowers; currentTowerId, currentLatitude, currentLongitude, currentSignalStrength];
                end
            end
        end
    end
end
listOfTowers=sortrows(listOfTowers);
dlmwrite('nokiaCellTowerLocations_IdLatLongSignal.csv', listOfTowers, 'precision', 20);
%apply a cell id to each call record based on the gsm data that occurs
%near that time
for i=1:length(userCallData)
    i
    currentUser=userCallData(i,:);
    currentTime=currentUser(3);
    gsmIndex=find(abs(timeValues-currentTime)<30, 1, 'first');
    if(length(gsmIndex)>0)
        currentGsmData=gsmData(gsmIndex, :);
        %gsmTime = currentGsmData
        %currentSignalStrength=currentGsmData(9);
        currentTowerId=currentGsmData(6);
        currentUser(4)=currentTowerId;
        userCallData(i,4)=currentUser(4);
    end
end
lastCellId=userCallData(1,4);
%assume that the cell id remains constant until the next change
for i=2:length(userCallData)
    i
    if(userCallData(i,4)~=lastCellId & userCallData(i,4)~=0)
        lastCellId=userCallData(i,4);
    else
        userCallData(i,4)=lastCellId;
    end
end
dlmwrite('callLogWithCellId_UseridTzTimeCellid.csv', userCallData, 'precision', 20); 
        
        
        
        
        
        
        
        
        
        
        