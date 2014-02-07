function [dates,data,headers] = gFileOpen(fileName,advanced)
%GFILEOPEN Parses the common GLEON format for high resolution data
%
%USAGE: [dates, data, header] = gFileOpen(fileName) opens the file
%       specified and returns the date/times, data, and header
%
%   INPUT:
%       fileName - Name of file to be read.
%       advanced - (Optional) If true, outputs the data as a structure with
%                  fields, data, dates, and depths. If false or not
%                  included, outputs dates, data and header individually
%
%   OUTPUT:
%       dates   - Vertical Date/time vector in matlab datenum format
%       data    - Matrix of data. Must be same height as dates and same
%                 width as depths, or one if no depth indicated
%       header  - The data header. Structure depends on if advanced output
%                 is selected or not.
%
%
%   EXAMPLE:
%
%       [dates, data, header] = gFileOpen('Mendota.wtr');
%       plot(dates, data);
%   

    nanText = {};

    fid = fopen(fileName);

    headers = fgetl(fid);
    format = '%s';
    for i=2:length(regexp(headers,'\t','split'));
        format = [format '%f'];
    end
    
    d = textscan(fid,format,'delimiter','\t','TreatAsEmpty',nanText);
    fclose(fid);
    
    
    data = horzcat(d{2:end});
    dates = datenum(d{1},'yyyy-mm-dd HH:MM');

    if(nargin == 2 && advanced == true)

        
        %Parse the headers into numerical values
        toks = regexp(strtrim(headers),'\s','split');
        toks = strtrim(toks);
        %drop 'DateTime'
        toks = toks(2:end);
        
        if(length(toks) == 1)
            toks = regexp(toks,'_','split');
            if(length(toks)==1)
                depths = [];
            else
                depths = str2double(toks{1}{2});
            end
        else
            toks = regexp(toks,'_','split');
            depths = nan(1,length(toks)); 
            for k=1:length(toks)
                depths(k) = str2double(toks{k}(2));
            end
        end
        out.dates = dates;
        out.data = data;
        out.depths = depths;
        dates = out;
    end
    
end