%%
output = [];
output = nan(1,3);
j = 1;
for i=1:length(wtr.depths);
    [times, aggSet] = timeseriesaggregator(wtr.dates,wtr.data(:,i),1440,'avg');
    output(j:(j+length(times)-1), 1) = times;
    output(j:(j+length(times)-1), 3) = aggSet;
    output(j:(j+length(times)-1), 2) = wtr.depths(i);
    j = j+length(times);
end

output = gPivot(output);

for i=2:size(output,2)
    plot(output(2:end,1),output(2:end,i))
    hold all;
end

gFileSave('Sparkling.daily.wtr',output(2:end,1), output(2:end,2:end), 'wtr', wtr.depths)

%%
wnd = gFileOpen('Sparkling.wnd',true);

[times, data] = timeseriesaggregator(wnd.dates, wnd.data, 1440, 'avg');
gFileSave('Sparkling.daily.wnd', times', data', 'wnd');