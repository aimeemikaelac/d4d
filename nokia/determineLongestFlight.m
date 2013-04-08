function userLongestFlights = determineLongestFlight(history, flights)
longestFlight = 0;
currentDay = extractCurrentDay(history(1,2));
% currentTime = history(1,2);
% wroteData = false;
for i=1:length(history)
    i
    firstDay = extractCurrentDay(history(i,2));
    currentTime = history(i,2);
    
    
    for j=1:length(history)
        secondDay = extractCurrentDay(history(j,2));
        if history(j,2) < currentTime && secondDay ~= firstDay
            continue
        end
        if firstDay == secondDay
%             wroteDate = false;
            currentFlight = haversine([history(i,3), history(i,4); history(j,3), history(j,4)]);
            if currentFlight > longestFlight
                longestFlight = currentFlight;
            end
        else
            break
        end
        
    end
    
    if currentDay ~= firstDay || i == length(history)
        currentDay = firstDay;
        if i>1
            flights = [flights; history(i-1,1), history(i-1,2), longestFlight];
        else
            flights = [flights; history(i,1), history(i,2), longestFlight];
        end
%         wroteData = true; 
    end
end
userLongestFlights = flights;