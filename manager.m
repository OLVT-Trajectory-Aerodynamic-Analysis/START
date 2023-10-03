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
    data = 9; %input data variable here (not as string lol);
    %% Call plotting functions
    disp(config)
    
    if configs.plotData == 1 %Do you want ANY graphs?
        if configs.plotSimulatedData == 1 %Plot RAS
            plotRAS(data,config) 
        end
        if configs.plotFlightData == 1 %Plot Processed Sensor Data
            if configs.plotIndividualSensors == 1 % Plot before fusing all datas
                %do after PAT
            end
            plotFlight(data,config)
        end

        if configs.plotOverlayingFigures == 1 % simul vs actual
            plotIndiv(data)
        end
        if configs.plotDifferences == 1 %diff ras 
            plotIndiv(data)
        end

    end
         %do you want any plots?

        
    

end