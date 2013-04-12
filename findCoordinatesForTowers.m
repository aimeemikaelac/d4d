function [latitudes longitudes] = findCoordinatesForTowers(towers, towerList)
latitudes = zeros(length(towers), 1);
longitudes = zeros(length(towers), 1);
for i=1:length(towers(:,1))
    currentTower = towers(i,2);
    indices = find(towerList(:,1) == currentTower);
    currentLong=0;
    currentLat=0;
    if ~isempty(indices)
        currentLong = towerList(indices(1),2);
        currentLat = towerList(indices(1),3);
    end
    latitudes(i) = currentLat;
    longitudes(i) = currentLong;
end
