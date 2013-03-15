abidjanLatitude=5.33632;
abidjanLongitude=-4.02775;
locationTolerance = .11;
locationData=importdata('ANT_POS.TSV');
timeMin=0;%3600*(12+8);
timeMax=24*3600;%3600*(12+9);
if ~exist('POS_SAMPLE_0', 'var')
    global POS_SAMPLE_0;
%     POS_SAMPLE_0=importdata('POS_SAMPLE_0.TSV','\t');
    POS_SAMPLE_0=textscan(fopen('POS_SAMPLE_0.TSV'),'%d %s %s %d');
end
global senders;
global receivers;
global dateString;
global timeString;
senders = POS_SAMPLE_0{1,1};
dateString = POS_SAMPLE_0{1,2};
timeString = POS_SAMPLE_0{1,3};
receivers = POS_SAMPLE_0{1,4};

towersLongitudes=locationData(:,2);
towersLatitudes=locationData(:,3);
voronoiX = [];
voronoiY = [];
towerlist = [];
for i = 1:length(towersLongitudes)
    if(abs(towersLongitudes(i)-abidjanLongitude)<locationTolerance&&abs(towersLatitudes(i)-abidjanLatitude)<locationTolerance)
        subplot(2,2,1)
        scatter(towersLongitudes(i), towersLatitudes(i))
        voronoiX = [towersLongitudes(i); voronoiX];
        voronoiY = [towersLatitudes(i); voronoiY];
        towerlist = [towerlist; i];
        hold on
    end
end
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
    




subplot(2,2,2)
voronoi(voronoiX, voronoiY)
subplot(2,2,3)
[ xi yi ] = meshgrid( -4.15:.01:-3.9, 5.2:.01:5.45 );
sizex=size(xi);
sizey=size(yi);
xi = reshape(xi, 1, sizex(1)*sizex(2));
yi = reshape(yi, 1, sizey(1)*sizey(2));
zi = idw(voronoiX, voronoiY, historicData(:,2), xi, yi);
sizez=size(zi);
zi = reshape(zi, sizex(1), sizey(1));
colormap('hot');
imagesc(xi, yi, zi);
colorbar();