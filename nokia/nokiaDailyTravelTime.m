folders = dir('nokia_data');
userDailyFlights=[];
index = 1;
for folder = folders'
    index
    index=index+1;
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
                if userData(i-1,2) == 1254596003
                    userData(i-1,2)
                end
                currentRange=userData(currentStart:currentEnd,:);
                latitudes=userData(currentStart:currentEnd,7);
                longitudes=userData(currentStart:currentEnd,6);
                currentHull=[];
                try
                    currentHull = convhull(latitudes,longitudes);
                catch err
                    disp('non-unique data in range')
                end
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
                userDailyFlights=[userDailyFlights; userData(i-1,1),extractCurrentYear(userData(i-1,2)),extractCurrentMonth(userData(i-1,2)), extractCurrentDay(userData(i-1,2)), userData(i-1,2), maxDistance, currentMinLat, currentMinLon, currentMaxLat, currentMaxLon];
                currentStart=i; 
                lastDay=currentDay;
            end
        end
%         cpuTime
    end
end




% x=firstDayPoints(:,1);
% y=firstDayPoints(:,2);
% hull = convhull(x, y);
% plot(x(hull), y(hull), 'r-', x, y, 'b+')
