function currentDay = extractCurrentDay(posixDate)
time_reference = datenum(1970,1,1);
time = datevec(time_reference + posixDate/86400);
currentDay = time(3);