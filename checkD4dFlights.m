flightData1 = textscan(fopen('dailyFlights.csv'),'%f %f %f %f %f %f %f %f %f %f %f', 'Delimiter', ',', 'EmptyValue',0);
flightData = [];
locationData=importdata('ANT_POS.TSV');
for i=1:11
    flightData=[flightData, flightData1{i}];
end

errorIndices = zeros(800000,1);
totalErrors = 0;

for i=1:length(flightData(:,1))
    i
    currentRow = flightData(i,:);
    user = currentRow(1);
    if user ==0
        continue
    end
    year = currentRow(2);
    month = currentRow(3);
    day = currentRow(4);
    distance = currentRow(5);
    tower1 = currentRow(6);
    tower2 = currentRow(7);
    latitude1 = currentRow(8);
    longitude1 = currentRow(9);
    latitude2 = currentRow(10);
    longitude2 = currentRow(11);
    
    distanceFromCoordinates = haversine([latitude1, longitude1; latitude2, longitude2]);
    if (distance - distanceFromCoordinates >0) || tower1 == tower2 || tower1 < 1 || tower2 < 1
        totalErrors = totalErrors+1;
        errorIndices(totalErrors) = i;
        continue
    end
    
    [tower1Lat, tower1Long] = findCoordinatesForTowers([user, tower1], locationData);
    [tower2Lat, tower2Long] = findCoordinatesForTowers([user, tower2], locationData);
    
    distanceFromTowers = haversine([tower1Lat(1), tower1Long(1); tower2Lat(1), tower2Long(1)]);
    if (distanceFromTowers - distanceFromCoordinates > 0)
        totalErrors = totalErrors+1;
        errorIndices(totalErrors) = i;
    end
end
    
    
    
    
    
    
    
    
    
    
    
    
    
    