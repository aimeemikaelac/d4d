folders = dir('nokia_data');
userDailyFlights=zeros(6000,10);
index = 1;
for folder = folders'
    name = folder.name;
    if ~isempty(str2num(name)) && ~strcmp(folder.name, '001')
        currentFileName = strcat('nokia_data\',folder.name,'\gps.csv');
        currentData = textscan(fopen(currentFileName),'%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f', 'headerLines', 1, 'Delimiter', '\t', 'EmptyValue',0);
        userData=[];
        for i = 1:16
            userData=[userData,cell2mat(currentData(i))];
        end
        currentStart=1;
        currentEnd=length(userData);
        lastDay=extractCurrentDay(userData(1,2));
%         cpuTime
        for i=1:length(userData)
            
            currentDay=extractCurrentDay(userData(i,2));
            if currentDay ~= lastDay || i==length(userData)
                if i==length(userData)
                    currentEnd=i;
                else
                    currentEnd = i-1;
                end
%                 if userData(i-1,2) == 1254596003
%                     userData(i-1,2)
%                 end
                currentRange=userData(currentStart:currentEnd,:);
                latitudes=userData(currentStart:currentEnd,7);
                longitudes=userData(currentStart:currentEnd,6);
                currentHull=[];
                if index > length(userDailyFlights)
                    additional = zeros(length(userDailyFlights),11);
                    userDailyFlights=[userDailyFlights; additional];
                    clear additional
                end
                try
                    currentHull = convhull(latitudes,longitudes);
                    maxDistance = 0;
                    currentMinLat=0;
                    currentMinLong=0;
                    currentMaxLat=0;
                    currentMaxLon=0;
                    for j=1:length(currentHull)
                        currentFirstPoint=currentRange(currentHull(j),:);
                        for k=1:length(currentHull)
                            currentSecondPoint=currentRange(currentHull(k),:);
                            currentDistance=haversine([currentFirstPoint(7), currentFirstPoint(6); currentSecondPoint(7), currentSecondPoint(6)]);
                            if currentDistance>maxDistance
                                maxDistance=currentDistance;
                                currentMinLat=currentFirstPoint(7);
                                currentMinLon=currentFirstPoint(6);
                                currentMaxLat=currentSecondPoint(7);
                                currentMaxLon=currentSecondPoint(6);
                            end
                        end
                    end
                    if currentMinLat > 0 && currentMinLong > 0 && currentMaxLat > 0 && currentMaxLong > 0 && maxDistance >0
                        userDailyFlights(index,:)=[userData(i-1,1),extractCurrentYear(userData(i-1,2)),extractCurrentMonth(userData(i-1,2)), extractCurrentDay(userData(i-1,2)), userData(i-1,2), maxDistance, currentMinLat, currentMinLon, currentMaxLat, currentMaxLon];
                    else
                        userDailyFlights(index,:)=[userData(i-1,1),extractCurrentYear(userData(i-1,2)),extractCurrentMonth(userData(i-1,2)), extractCurrentDay(userData(i-1,2)), userData(i-1,2), 0, 0, 0, 0, 0];
                    end
                    index=index+1;
                    currentStart=i; 
                    lastDay=currentDay;
                catch err
                    uniqueLat=unique(latitudes);
                    if length(latitudes) > 2
                        latitude1=latitudes(1);
                        longitude1=longitudes(1);
                        latitude2=0;
                        longitude2=0;
                        for lats = 2:length(latitudes)
                            if abs(latitudes(lats) - latitude1) > 0
                                latitude2 = latitudes(lats);
                                longitude2 = longitudes(lats);
                                break
                            end
                        end
                        currentDistance = haversine([latitude1, longitude1; latitude2, longitude2]);
                        userDailyFlights(index,:)=[userData(i-1,1),extractCurrentYear(userData(i-1,2)),extractCurrentMonth(userData(i-1,2)), extractCurrentDay(userData(i-1,2)), userData(i-1,2), currentDistance, latitude1, longitude1, latitude2, longitude2];
                    else
                        userDailyFlights(index,:)=[userData(i-1,1),extractCurrentYear(userData(i-1,2)),extractCurrentMonth(userData(i-1,2)), extractCurrentDay(userData(i-1,2)), userData(i-1,2), 0, 0, 0, 0, 0];
                    end
                    index=index+1;
%                     disp('non-unique data in range')
                    currentStart = i;
                    lastDay = currentDay;
                end
                
            end
        end
%         cpuTime
    end
end

dlmwrite('nokiaDailyTravel.csv', userDailyFlights, 'precision', 20)


% x=firstDayPoints(:,1);
% y=firstDayPoints(:,2);
% hull = convhull(x, y);
% plot(x(hull), y(hull), 'r-', x, y, 'b+')
