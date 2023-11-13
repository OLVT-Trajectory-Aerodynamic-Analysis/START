% Orbital Launch Vehicle Team (OLVT)

% Contributors
% @author Trajectory and Aerodynamic Analysis Subteam
% @created 09/25/2023

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This is the main file for the Data Postprocessing Project. In this
% project users will be able to analyze data collected from launches. Users
% will be expected to input one or multiple sources of data surrounding the
% launch. Users will also have the option of inputting predicted data. For
% more details, please check the README file
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Sources will be inputted using the createSourceObject method. Each source 
% will have be inputted using its path location, source type, and its title.
% Finally, the createSourceObject will include a parameter for where the 
% lists should be stored.
%
% The title string is what it will be labeled as in and legenr
%
% For example 
% [~, sourceList] = createSourceObject("rawData/exampleFile", "easyMini", "EasyMini Data", sourceList);
% [~, sourceList] = createSourceObject("rawData/exampleFile2", "RASAeroII", "RAS 0AoA", sourceList);
%

function [] = main()
    close all
    addpath(genpath(pwd)) % adds all subfolders of Current Folder into MATLAB Path
    % Initialize Variables
    sourceList = [];
    configs = struct;
    
    %% Input Sources
    %[~, sourceList] = createSourceObject("rawData/Skipper1C/EasyMini", "EasyMini", "rawData", sourceList);
    
    [~, sourceList] = createSourceObject( ...
        "rawData/Skipper1C/Telemetrum-2023-10-15-serial-10923-flight-0003-via-7175", ...
        "Telemetrum", ...
        "Telemetrum Data", ...
        sourceList);

    [~, sourceList] = createSourceObject( ...
        "rawData/Skipper1C/RasAeroII_Skipper1C_0AoA", ...
        "RASAeroII", ...
        "RAS 0AoA", ...
        sourceList);

    [~, sourceList] = createSourceObject( ...
        "rawData/Skipper1C/RasAeroII_Skipper1C_5AoA", ...
        "RASAeroII", ...
        "RAS 5AoA", ...
        sourceList);

    %% Ras Aero II Launch Site Configurations
    rasAeroIILaunchSite = struct;
    rasAeroIILaunchSite.elevation_ft = 423;
    rasAeroIILaunchSite.temperature_F = 60;
    rasAeroIILaunchSite.pressure_inhg = "null";
    rasAeroIILaunchSite.windSpeed_mph = 10;
    rasAeroIILaunchSite.launchRailLength_ft = 20;
    rasAeroIILaunchSite.launchAngle = 5;

    %% Rocket Body Parameters
    rocket = struct;
    rocket.sustainerUnloadedWeight = 10; % (kg)
    rocket.totalUnloadedMass = -1;       % (kg)
    rocket.sustainerMotor = "J460T";
    rocket.boosterMotor = "null";

    %% Define Configurable Parameters
    configs.plotData = 0;
    configs.plotSimulatedData = 1;
    configs.plotFlightData = 1;
    configs.plotOverlayingFigures = 1; 
    configs.plotDifferences = 1;

    %% Call manager functions
    manager(sourceList, rasAeroIILaunchSite, configs, rocket)
end




