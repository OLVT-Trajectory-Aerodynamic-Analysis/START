% This is the command center of the project. This function is like the
% center of the spider web, everything is called from here. First the data
% is converted from the rawData format to the SDFormat. Next the manager
% determines which plotting functions to call, and does that

% Contributors
% @author Michael Plano
% @author Hady Solimany
% @created 09/25/2023
% 

% @param sourceList is the list of sources in the source datatype. This
%   means that it is in the struct format
% @param config is all of the configurable parameters that might be needed
%   for the system. They are listed below
%   There are currently no config variables.
% 

function [] = manager(sourceList, rasAeroIILaunchSite, config, rocket)
    %% Initialize Variables
    numSources = length(sourceList);
    processedData = {};

    %% Deal with rocket parameters
    %Idk another function here. It needs to get thrust-time curve, and do a
    %bunch of stuff with that I think. For now ill just do this
    rocket.sustainerMotorBurnTime = 2;

    %% Get raw data into SD format
    for sourceNum = 1:numSources
        processedData{sourceNum} = createSDFormat(sourceList(sourceNum), rasAeroIILaunchSite, rocket);
    end

    %%  Kalman filer
    filteredData = filterData(processedData);

    %% Call plotting functions
    addpath(genpath(pwd)) % adds all subfolders of Current Folder into MATLAB Path

    % To output just the main things (altitude, tilt, vel, accel, atm,
    % MaxQ), use plotFlights. It iterates through all the sensors and
    % overlays their data.
    % Assuming SourceList Austin's filtered structure:
    plotFlights(filteredData, config, rocket)
end