folders = dir('nokia_data');
userDailyFlights=zeros(800000,11);
flightIndex = 0;
index = 1;
startTime = cputime;
locationData=importdata('ANT_POS.TSV');
fileNames = ['POS_SAMPLE_0.TSV'; 'POS_SAMPLE_1.TSV'; 'POS_SAMPLE_2.TSV'; 'POS_SAMPLE_3.TSV'; 'POS_SAMPLE_4.TSV'; 'POS_SAMPLE_5.TSV'; 'POS_SAMPLE_6.TSV'; 'POS_SAMPLE_7.TSV'; 'POS_SAMPLE_8.TSV'; 'POS_SAMPLE_9.TSV'];
for fileIndex = 1:length(fileNames(:,1))
%     index
    
    file=fileNames(fileIndex, :)
    currentData = textscan(fopen(file),'%f %s %f', 'Delimiter', '\t', 'EmptyValue',0);
    userCdrs=[cell2mat(currentData(1)), cell2mat(currentData(3))];
    userTimes=currentData{2};
%     userTimes=[];
%     for a=1:length(currentData{2})
%         userTimes = [userTimes; userTimesCell{a}];
%     end
    clear userTimesCell
    clear currentData
    currentStart=1;
    currentEnd=length(userCdrs);
    [lastYear lastMonth lastDay]=extractDateFromString(userTimes{1});
%         cpuTime
    for i=1:length(userCdrs)
%         i
%         if i==173
%             i
%         end
        currentRange = [];
        [currentYear currentMonth currentDay]=extractDateFromString(userTimes{i});
        if currentDay ~= lastDay || i==length(userCdrs)
            lastDay=currentDay;
            if i==length(userCdrs)
                currentEnd=i;
            else
                currentEnd = i-1;
            end
%                 if userData(i-1,2) == 1254596003
%                     userData(i-1,2)
%                 end
            currentRange=userCdrs(currentStart:currentEnd,:);
            [latitudes longitudes] = findCoordinatesForTowers(currentRange, locationData);
%                 latitudes=userData(currentStart:currentEnd,7);
%                 longitudes=userData(currentStart:currentEnd,6);
            currentHull=[];
            if(userCdrs(i,1)==2)
%                 userCdrs(i,1)
            end
            try
                currentHull = convhull(latitudes,longitudes);
                
                maxDistance = 0;
                currentMinLat=0;
                currentMinLong=0;
                currentMaxLat=0;
                currentMaxLong=0;
                maxFirstTower=0;
                maxSecondTower=0;
                for j=1:length(currentHull)
%                     currentFirstTower = currentRange(currentHull(j),2);
                    currentFirstPoint=[latitudes(currentHull(j)), longitudes(currentHull(j))];
                    for k=1:length(currentHull)
%                         currentSecondTower = currentRange(currentHull(k), 2);
                        currentSecondPoint=[latitudes(currentHull(k)), longitudes(currentHull(k))];
                        currentDistance=haversine([currentFirstPoint(1), currentFirstPoint(2); currentSecondPoint(1), currentSecondPoint(2)]);
                        if currentDistance>maxDistance
                            maxFirstTower = currentRange(currentHull(j),2);
                            maxSecondTower = currentRange(currentHull(k),2);
                            maxDistance=currentDistance;
                            currentMinLat=currentFirstPoint(1);
                            currentMinLong=currentFirstPoint(2);
                            currentMaxLat=currentSecondPoint(1);
                            currentMaxLong=currentSecondPoint(2);
                        end
                    end
                end
                [y m d]=extractDateFromString(userTimes{i-1});
                if length(latitudes) > 1 && maxFirstTower ~= maxSecondTower && maxFirstTower > 0 && maxSecondTower > 0
                    if index > length(userDailyFlights)
                        additional = zeros(length(UserDailyFLights,11));
                        userDailyFlights=[userDailyFlights; additional];
                        clear additional
                    end
                    userDailyFlights(index,:)=[userCdrs(i-1,1), y, m, d, maxDistance, maxFirstTower, maxSecondTower, currentMinLat, currentMinLong, currentMaxLat, currentMaxLong];
                    index = index+1;
                end
                currentStart=i; 
                
%                 lastMonth=currentMonth;
            catch err
                uniqueTowers = unique(currentRange(:,2));
                if length(uniqueTowers) == 2 && uniqueTowers(1) > 0 && uniqueTowers(2) > 0
                    newInput = [zeros(length(uniqueTowers),1), uniqueTowers];
                    [latitudes, longitudes] = findCoordinatesForTowers( newInput, locationData);
                    currentDistance = haversine([latitudes(1), longitudes(1); latitudes(2), longitudes(2)]);
                    [y m d]=extractDateFromString(userTimes{i-1});
                    userDailyFlights(index,:)=[userCdrs(i-1,1), y, m, d, currentDistance, uniqueTowers(1), uniqueTowers(2), latitudes(1), longitudes(1), latitudes(2), longitudes(2)];
                    index=index+1;
                end
%                 disp('non-unique data in range')
%                 [y m d]=extractDateFromString(userTimes{i});
%                 userDailyFlights=[userDailyFlights; userCdrs(i-1,1), y, m, d, 0, 0, 0, 0, 0];
                currentStart=i;
                continue
            end
            
        end
        
    end
    cputime-startTime
    startTime = cputime-startTime;
end
dlmwrite('dailyFlights.csv', userDailyFlights, 'precision', 20)

cputime-startTime

% x=firstDayPoints(:,1);
% y=firstDayPoints(:,2);
% hull = convhull(x, y);
% plot(x(hull), y(hull), 'r-', x, y, 'b+')
