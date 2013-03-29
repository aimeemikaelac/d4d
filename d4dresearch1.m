function [towerIds histogram] = d4dresearch1(startHour, endHour, dataFilePath)
startCpuTime=cputime;
abidjanLatitude=5.33632;
abidjanLongitude=-4.02775;
locationTolerance = .11;
locationData=importdata('ANT_POS.TSV');
timeMin=3600*startHour;
timeMax=3600*endHour;
global DATA;
if ~exist('data', 'var')
%     POS_SAMPLE_0=importdata('POS_SAMPLE_0.TSV','\t');
    DATA=textscan(fopen(dataFilePath),'%d %s %s %d');
end
global senders;
global receivers;
global dateString;
global timeString;
senders = DATA{1,1};
dateString = DATA{1,2};
timeString = DATA{1,3};
receivers = DATA{1,4};

%%generate scatterplot and  determine which towers are in the range 
%%of the boundaries defined for Abidjan
towersLongitudes=locationData(:,2);
towersLatitudes=locationData(:,3);
voronoiX = [];
voronoiY = [];
towerlist = [];
handle = figure;
for i = 1:length(towersLongitudes)
    if(abs(towersLongitudes(i)-abidjanLongitude)<locationTolerance&&abs(towersLatitudes(i)-abidjanLatitude)<locationTolerance)
        scatter(towersLongitudes(i), towersLatitudes(i))
        voronoiX = [towersLongitudes(i); voronoiX];
        voronoiY = [towersLatitudes(i); voronoiY];
        towerlist = [towerlist; i];
        hold on
    end
end
if ~exist('towerGraph.jpg', 'file')
    print(handle, '-djpeg', 'towerGraph.jpg');
end
close all;

%%using the towers calculated peviously, determine the number of calls to
%%occur at each between the starting and ending hours
historicData = [towerlist, zeros(length(towerlist))];

for i = 1:length(senders)
    currentTimeString = char(timeString(i));
    a=textscan(currentTimeString, '%d:%d:%d');
    hours=cell2mat(a(1));
    minutes=cell2mat(a(2));
    seconds=cell2mat(a(3));
    timeSeconds=3600*hours+60*minutes+seconds;
    if(timeSeconds<=timeMax&&timeSeconds>=timeMin)
        currentSender = senders(i);
        currentReceiver = receivers(i);
        sendIndex = find(towerlist==currentSender);
        receiveIndex = find(towerlist==currentReceiver);
        if(~isempty(sendIndex))
            historicData(sendIndex, 2)=historicData(sendIndex, 2)+1;
        end
        if(~isempty(receiveIndex))
            historicData(receiveIndex, 2)=historicData(receiveIndex, 2)+1;
        end
    end
end

%%generate the vornoi diagram
handle = figure;
voronoi(voronoiX, voronoiY)
if ~exist('towerVoronoi.jpg', 'file')
    print(handle, '-djpeg', 'towerVoronoi.jpg');
end
close all;

%%create the heatmap based on data calculated above for the number of calls
%%for each cell tower
handle = figure;
[ xi yi ] = meshgrid( -4.15:.001:-3.9, 5.2:.001:5.45 );
sizex=size(xi);
sizey=size(yi);
xi = reshape(xi, 1, sizex(1)*sizex(2));
yi = reshape(yi, 1, sizey(1)*sizey(2));
%v1 = voronoiX(end:-1:1);
%v2 = voronoiY(end:-1:1);
zi = idw(voronoiX.', voronoiY.', historicData(:,2).', xi, yi);
sizez=size(zi);
zi = reshape(zi, sizex(1), sizey(1));
colormap('hot');
yi = yi(end:-1:1);
imagesc(xi, yi, zi);
colorbar();
dataFileName = dataFilePath(1:length(dataFilePath)-4);
fileName = strcat('heatmap_From', sprintf('%d', startHour), 'to', sprintf('%d', endHour), 'from_', dataFileName, '.jpg');
print(handle, '-djpeg', fileName);



%%calculate elapsed time
endCpuTime=cputime;
elapsedCpuTime=endCpuTime-startCpuTime;
disp('elapsed cpu time: ')
if elapsedCpuTime < 60
    str=sprintf(' %0.3f', elapsedCpuTime);
    disp(strcat(str, ' s'))
else
    a1 = floor(elapsedCpuTime/60);
    str1=sprintf('%0.0f',a1);
    a2 = mod(elapsedCpuTime, 60);
    str2=sprintf('%0.2f',a2);
    disp(strcat(str1, ' m ', str2, ' s'))
end

%output list of towers in region and number of calls per tower in time
%period
towerIds = towerlist;
histogram = historicData;
if ~exist('abidjanTowers.txt','file')
    dlmwrite('abidjanTowers.txt', towerIds);
end
fileName2 = strcat('callHistoryPerTower_From', sprintf('%d', startHour), 'to', sprintf('%d', endHour), 'from_', dataFileName, '.txt');
cd results
dlmwrite(fileName2, [historicData(:,1), historicData(:,2)], '\t');
cd ..