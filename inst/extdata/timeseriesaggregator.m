function [times, aggSet, samples] = timeseriesaggregator(timeStamp, dataSet, aggSpan, aggType)
%timeseriesaggregator aggregates data based on user specifications
%
%[times, aggSet, samples] 
%   = timeseriesaggregator(timeStamp, dataSet, aggSpan, aggType)
%
%INPUTS:
%
%   timeStamp:  vector of matlab compatible datenums
%   dataSet:  vector of data values
%   aggSpan:  aggregation length in minutes, default is 60
%   aggType:  string indicating the aggregation type
%
%   Allowable aggType inputs:
%       'avg':  mean
%       'min':  minimum
%       'max':  maximum
%       'std':  standard deviation
%       'sum':  sum
%
%OUTPUTS:
%
%   times:  the new vector of times after aggregation
%   aggSet:  the new vector of data values after aggregation
%   samples:  the number of samples per aggregation

%% Set Defaults if not specified by the user
if nargin<4
    aggType = 'AVG';
end
if nargin<3
    aggSpan = 60;
end
aggType = upper(aggType);

%% Figure out where the first usable time is
k = 1;
startTime = timeStamp(k);
% if mod((round((timeStamp(1)-floor(timeStamp(1)))*60*24)),aggSpan)==0
%     startTime = timeStamp(k);
% else 
%     startTime = timeStamp(1)+1/(60*24);
%     while ~(mod((round((startTime-floor(startTime))*60*24)),aggSpan)==0)
%         startTime = startTime + startTime+1/(60*24);
%         if(~isempty(find(startTime==timeStamp,1)))
%             k = find(startTime==timeStamp);
%         end
%     end
% end 
if mod((round((timeStamp(length(timeStamp))-floor(timeStamp(length(timeStamp))))*60*24)),aggSpan)==0
    lastDate = timeStamp(length(timeStamp));
else
    lastDate = timeStamp(length(timeStamp));
    while ~(mod((round((lastDate-floor(lastDate))*60*24)),aggSpan)==0)
        lastDate = lastDate+1/(60*24);
    end
end

%% Create a vector of the new times to be used
finish = k;
start = 1;
times = startTime:aggSpan/(60*24):lastDate;

%% initialize the vectors into which the new values will be placed
aggSet = zeros(1,length(times));
samples = zeros(1,length(times));

%% loop through the new vector of times aggregating on the specified interval
for n = 1:length(times)
    while (finish<length(timeStamp))&&(timeStamp(finish)<=times(n))
        finish = finish+1;
    end
        switch aggType
            case 'AVG'
                tmp = dataSet(start:finish);
                aggSet(1,n) = mean(tmp(~isnan(tmp)));
            case 'STD'
                aggSet(1,n) = std(dataSet(start:finish));
            case 'MIN'
                aggSet(1,n) = min(dataSet(start:finish));
            case 'MAX'
                aggSet(1,n) = max(dataSet(start:finish));
            case 'SUM'
                aggSet(1,n) = sum(dataSet(start:finish));
            case 'TRIM'
                aggSet(1,n) = trimmean(dataSet(start:finish),20);
        end
        samples(1,n) = length(dataSet(start:finish-1));
        start = finish;
end
%% Get rid of NaN's
times = times(~isnan(aggSet));
aggSet = aggSet(~isnan(aggSet));

%% Plot the aggregated data set
% figure
% plot(times,aggSet)
% datetick('x','mm/dd')
