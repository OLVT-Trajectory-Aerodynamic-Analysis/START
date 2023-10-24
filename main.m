% Orbital Launch Vehicle Team (OLVT)
% Trajectory and Aerodynamic Analasit Sub-Team (T&AA)

% Contributors
% @author Michael Plano
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
% will have be inputted using its path location, source type, and either 
% rawData or simulated source. Finally, the createSourceObject will include
% a parameter for where the lists should be stored. Unless you know what
% your doing I suggest you leave that alone
%
% For example 
% [source1, sourceList] = createSourceObject("rawData/exampleFile", "easyMini", "rawData", sourceList);
% [source2, sourceList] = createSourceObject("rawData/exampleFile2", "RASAeroII", "simulatedData", sourceList);
%

function [] = main()
    % Initialize Variables
    sourceList = [];
    configs = struct;
    
    %% Input Sources
    %[~, sourceList] = createSourceObject("rawData/Skipper1B/AimData", "AIM", "rawData", sourceList);
    [~, sourceList] = createSourceObject("rawData/Skipper1B/EasyMini_2023-04-16-serial-10923-flight-0002.csv", "EasyMini", "rawData", sourceList);
    [~, sourceList] = createSourceObject("rawData/Skipper1B/RasAeroII_Skipper1B", "RASAeroII", "simulatedData", sourceList);

    %% Define Configurable Parameters
    configs.plotData = 0;
    configs.plotSimulatedData = 1;
    configs.plotFlightData = 1;
    configs.plotIndividualSensors = 0; % I don't think this is necessary/helpful
    configs.plotOverlayingFigures = 1; 
    configs.plotDifferences = 1;

    %% Call manager functions
    manager(sourceList, configs)
end




