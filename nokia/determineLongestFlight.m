function userLongestFlights = determineLongestFlight(history, flights, numDays)
longestFlight = 0;
currentDay = extractCurrentDay(history(1,2));
dayStartIndex=1;
dayEndIndex=length(history);
% currentTime = history(1,2);
% wroteData = false;
userFlights = zeros(numDays, 3);
dayIndex=1;
firstLong = 0;
firstLat = 0;
for i=1:length(history)
%     i
    firstDay = extractCurrentDay(history(i,2));
    currentTime = history(i,2);
    
    
    for j=dayStartIndex:dayEndIndex
        currentLat = history(i,4);
        currentLong = history(i,3);
        secondDay = extractCurrentDay(history(j,2));
        if history(j,2) < currentTime && secondDay ~= firstDay
            continue
        end
        if firstDay == secondDay
%             wroteDate = false;
            current2Lat = history(j,4);
            current2Long = history(j,3);
            if firstLat == 0 && firstLong == 0
                firstLat = currentLat;
                firstLong = currentLong;
            else            
                currentFlight = haversine([history(i,3), history(i,4); history(j,3), history(j,4)]);
                if currentFlight > longestFlight
                    longestFlight = currentFlight;
                end
        else
            dayEndIndex=j;
            break
        end
        
    end
    
    if currentDay ~= firstDay || i == length(history)
        dayStartIndex=i;
        dayEndIndex=length(history);
        currentDay = firstDay;
%         if i>1
%             flights = [flights; history(i-1,1), history(i-1,2), longestFlight];
%         else
%             flights = [flights; history(i,1), history(i,2), longestFlight];
%         end
%         wroteData = true; 
        userFlights(dayIndex) = [history(i-1,1), history(i-1,2), longestFlight];
        dayIndex=dayIndex+1;
    end
end
userLongestFlights = [flights; userFlights];