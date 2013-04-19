load 'nokiaDailyTravel.csv'
distances = nokiaDailyTravel(:,5);
minDistance = min(distances);
alpha = 1.2;
h = plplot(distances, minDistance, alpha);