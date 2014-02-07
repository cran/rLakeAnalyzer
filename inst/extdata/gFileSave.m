function gFileSave(fileName, dates, data, variable, depths, overwrite)
%GFILESAVE Save timeseries data in the GLEON file format
%
%USAGE: gFileSave('mendota.doobs', dateVec, dataVec, 'doobs') saves 
%       supplied dataVec and dateVec in file with name 'mendota.doobs' and 
%       variable type 'doobs'.
%
%   INPUT:
%       fileName - Name of file to be saved. Must include file extension
%       dates    - Vertical Date/time vector in matlab datenum format
%       data     - Matrix of data. Must be same height as dates and same
%                  width as depths, or one if no depth indicated
%       variable - Variable type abbreviation. 'wtr' for water temperature.
%                  'wnddir' for wind direction, etc.
%       depths   - Vector of depths in numeric format. Must be same width
%                  as data.
%       overwrite- Input indicating if existing file should be overwritten.
%                  Supply string 'overwrite' if overwrite requested.
%
%   EXAMPLE:
%       data = [1 2; 3 4; 5 6];
%       dates = datenum('2008-01-01','yyyy-mm-dd') + (0:2)';
%       depths = [0 1];
%       gFileSave('mendota.wtr', dates, data, 'wtr', depths);
%   


    if(nargin < 4)
        error('Must supply fileName, date vector, data, and variable name');
    elseif(nargin == 4)
        depths = NaN;
        overwrite = '';
    elseif(nargin == 5)
        overwrite = '';
    elseif(nargin > 6)
        error('Unknown parameter supplied. Maximum of 6 expected.');
    end

    % Build the tab delimited header
    headers = 'DateTime';
    dataFormat = '%s';
    for i=1:length(depths)
        dataFormat = strcat(dataFormat,'\t%0.5g');
        if(isnan(depths(i)))
            headers = sprintf('%s\t%s',headers,variable);
        else
            headers = sprintf('%s\t%s_%s',headers,variable,num2str(depths(i)));
        end
    end
    headers = strcat(headers,'\n');
    dataFormat = strcat(dataFormat,'\n');

    %Check to see if user requested file overwrite
    if(strcmpi(overwrite,'overwrite'))
        fid = fopen(fileName,'W+');
    else
        if(exist(fileName,'file')) %If no overwrite and file exists, error
            error('File exists and overwrite no specified!');
        end
        fid = fopen(fileName,'W');
    end

    %Use ISO date/time format
    dates = datestr(dates,'yyyy-mm-dd HH:MM:SS');

    %Print header to file
    fprintf(fid,headers);

    %Print data to file
    for i=1:size(data,1)
        fprintf(fid,dataFormat,dates(i,:),data(i,:));
    end
    fclose(fid);

end

