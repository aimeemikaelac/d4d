function [year month day] = extractDateFromString(string)
dateString = strtok(string, ' ');
[year rest] = strtok(dateString, '-');
[month rest] = strtok(rest, '-');
day = strtok(rest, '-');
year = str2num(year);
month = str2num(month);
day = str2num(day);