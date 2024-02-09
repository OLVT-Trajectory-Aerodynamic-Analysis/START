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
% The title string is what it will be labeled as in and legend
%
% For example 
% [~, sourceList] = createSourceObject("rawData/exampleFile", "easyMini", "EasyMini Data", sourceList);
% [~, sourceList] = createSourceObject("rawData/exampleFile2", "RASAeroII", "RAS 0AoA", sourceList);
%

function [] = main()
    disp("Running ...")
    %% Most users shouldn't touch this
    addpath(genpath(pwd)) % adds all subfolders of Current Folder into MATLAB Path
    % Initialize Variables
    sourceList = [];
    configs = struct;
    
    %% Input Sources
        
  
     [~, sourceList] = createSourceObject( ...
        "rawData/Skipper1D/RasAeroII_Skipper1D_0mph", ...
        "RASAeroII", ...
        "RasAeroII - No Wind", ...
        sourceList);
     [~, sourceList] = createSourceObject( ...
        "rawData/Skipper1D/RasAeroII_Skipper1D_5mph", ...
        "RASAeroII", ...
        "RasAeroII - 5 mph Wind", ...
        sourceList);
    
    [~, sourceList] = createSourceObject( ...
        "rawData/Skipper1D/RasAeroII_Skipper1D_10mph", ...
        "RASAeroII", ...
        "RasAeroII - 10 mph Wind", ...
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
    rocket.separationDelay = 0.7;
    rocket.ignitionDelay = 2.5;

    %% Define Configurable Parameters
    configs.plotDataSources = struct;

    % If you want all data sources
    configs.plotDataSources.Plot = 1;
    configs.plotDataSources.SingleFigure = false; % Not Recommended, slow and not updated
    configs.plotDataSources.rocketPhaseLines = true;
    configs.plotDataSources.onlyViewAscent = true;

    % If you want only filtered raw Data
    configs.plotFilteredData.Plot = 0;
    configs.plotFilteredData.SingleFigure = false; % Not Recommended, slow and not updated
    configs.plotFilteredData.rocketPhaseLines = true;
    configs.plotFilteredData.onlyViewAscent = true;

    %% Call manager functions
    manager(sourceList, rasAeroIILaunchSite, configs, rocket)
    disp("Complete!!")
end




