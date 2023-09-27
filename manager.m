% This is the command center of the project. This function is like the
% center of the spider web, everything is called from here. First the data
% is converted from the rawData format to the SDFormat. Next the manager
% determines which plotting functions to call, and does that

% Contributors
% @author Michael Plano
% @created 09/25/2023
% 

% @param sourceList is the list of sources in the source datatype. This
%   means that it is in the struct format
% @param config is all of the configurable parameters that might be needed
%   for the system. They are listed below
%   There are currently no config variables.
% 

function [] = manager(sourceList, config)
    %% Initialize Variables
    numSources = length(sourceList);
    processedData = zeros(1, numSources);

    %% Get raw data into SD format
    for sourceNum = 1:numSources
        processedData(sourceNum) = createSDFormat(sourceList(sourceNum));
    end
    
    %% Call plotting functions
    disp(config)
end