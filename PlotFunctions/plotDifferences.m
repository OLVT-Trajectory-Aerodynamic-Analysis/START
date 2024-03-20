function [] = plotDifferences(processedData, configs, rocket)
%% Separate Data

% Initialize a struct to hold processed sensor data for easy access
sensorData = struct();

for i = 1:length(processedData)
    % Use the dataTitle as a valid field name by removing spaces and special characters,
    % or you could directly use it if your data titles are already valid MATLAB field names.
    % This example assumes dataTitle is a valid MATLAB field name.
   
    dataTitle = matlab.lang.makeValidName(processedData{1, i}.dataTitle);
    % Dynamically create fields in the sensorData struct using dataTitle
    sensorData.(dataTitle).time = processedData{1, i}.time;
    sensorData.(dataTitle).velocity = processedData{1,i}.velocity.magnitude;
    sensorData.(dataTitle).Zposition = processedData{1,i}.position.Zposition;
    sensorData.(dataTitle).altitude = processedData{1,i}.position.altitude;
    sensorData.(dataTitle).acceleration = processedData{1,i}.acceleration.magnitude;
end


%% Create uniform time vectors
% Determine the start and end times for the uniform time vector

% Initialize variables to store the global min and max times
globalMinTime = 0; % Set to Infinity initially
globalMaxTime = 0; % Set to Negative Infinity initially

% Iterate over each sensor in sensorData to update global min/max times
sensorNames = fieldnames(sensorData); % Get a list of all sensor names

for i = 1:length(sensorNames)
    sensorName = sensorNames{i};
    
    % Update globalMinTime and globalMaxTime
    currentMinTime = min(sensorData.(sensorName).time);
    currentMaxTime = max(sensorData.(sensorName).time);
    globalMinTime = min(globalMinTime, currentMinTime);
    globalMaxTime = max(globalMaxTime, currentMaxTime);
end


uniform_time = globalMinTime:0.1:globalMaxTime;

% uniform_time is now a time vector that spans from the earliest time
% in any of the sensors to the latest time in any of the sensors

%% Initialize vectors to hold aligned property values values

for i = 1:length(sensorNames)
    
sensorName = sensorNames{i};

sensorData.(sensorName).velocityAligned =zeros(length(uniform_time), 1);
sensorData.(sensorName).ZpositionAligned = zeros(length(uniform_time), 1);
sensorData.(sensorName).altitudeAligned = zeros(length(uniform_time), 1);
sensorData.(sensorName).accelerationAligned = zeros(length(uniform_time), 1);   

end

%% Align different data vectors

% Define tolerance for matching times
tolerance = 1e-5;


for i = 1:length(sensorNames)
    sensorName = sensorNames{i};
    
    % Extract the original time vector for the current sensor
    originalTime = sensorData.(sensorName).time;
    
    % Iterate over each property (velocity, Zposition, etc.) to align
    properties = fieldnames(sensorData.(sensorName)); % Get all properties of the sensor
    for j = 1:length(properties)
        propertyName = properties{j};
        
        % Skip aligning the 'time' property since we're using it as reference
        if strcmp(propertyName, 'time')
            continue;
        end
        
        % Initialize aligned vector with zeros
        alignedVector = zeros(length(uniform_time), 1);
        
        % Original data vector for the current property
        originalData = sensorData.(sensorName).(propertyName);
        
        % Align the data
        for k = 1:length(originalTime)
            [minValue, index] = min(abs(uniform_time - originalTime(k)));
            if minValue <= tolerance
                alignedVector(index) = originalData(k);
            end
        end
        % Only add the 'Aligned' suffix if not already present
        if ~contains(propertyName, 'Aligned')
            alignedPropertyName = strcat(propertyName, 'Aligned');
            sensorData.(sensorName).(alignedPropertyName) = alignedVector;
        end
        
    end
end

%%

% Assume configs.plotDifferences.target contains the target sensor's name
% Make the target sensor name a valid MATLAB field name
TargetName = matlab.lang.makeValidName(configs.plotDifferences.target);

% Initialize the Target struct
Target = struct();

% Find the target sensor and extract its properties

for i = 1:length(sensorNames)
    sensorName = sensorNames{i};
    if strcmp(sensorName, TargetName) % Use strcmp for string comparison
        % Dynamically extract all aligned properties
        properties = fieldnames(sensorData.(sensorName)); % Get all properties of the sensor
        for j = 1:length(properties)
            propertyName = properties{j};
            % Check if the property name ends with 'Aligned'
            if endsWith(propertyName, 'Aligned')
                % Extract and store aligned properties in the Target struct
                Target.(propertyName) = sensorData.(sensorName).(propertyName);
            end
        end
        break; % Exit loop once target sensor is found and processed
    end
end



%% Calculate the differences in aligned data
% Initialize Differences as a struct with fields for Subtraction and Ratio
Differences = struct('Subtraction', struct(), 'Ratio', struct());

for i = 1:length(sensorNames)
    sensorName = sensorNames{i};
    
    % Skip the target sensor
    if strcmp(sensorName, TargetName)
        continue
    else
        properties = fieldnames(sensorData.(sensorName)); % Get all properties of the sensor
        for j = 1:length(properties)
            propertyName = properties{j};
            
            % Process only properties that end with 'Aligned'
            if endsWith(propertyName, 'Aligned')
                % Calculate subtraction and ratio
                % Ensure the target sensor data is accessed correctly
                targetPropertyData = sensorData.(TargetName).(propertyName);
                currentSensorPropertyData = sensorData.(sensorName).(propertyName);
                
                Differences.Subtraction.(sensorName).(propertyName) = targetPropertyData - currentSensorPropertyData;
                Differences.Ratio.(sensorName).(propertyName) = targetPropertyData ./ currentSensorPropertyData;
            end
        end
    end
end

%% Graph stuff

% Preliminary setup
set(0, 'DefaultAxesFontSize', 15);
set(0, 'DefaultAxesFontName', 'Times New Roman');
set(0, 'DefaultFigureWindowStyle', 'docked');
titleSz = 30;
lineWidth = 2;

% Assuming TargetName contains the name of the target sensor
properties = fieldnames(Differences.Subtraction.(sensorNames{1})); % Assuming all sensors have the same properties

% Define a set of colors to cycle through
colors = lines(numel(sensorNames) - 1); % Assuming one sensor is the target

% Loop through properties
for j = 1:length(properties)
    propertyName = properties{j};
    readablePropertyName = strrep(propertyName, 'Aligned', ''); % Adjust property name for display

    % Create new figure for each property to compare all sensors against the target
    fig = figure();
    fig.Name = [readablePropertyName ' Differences and Ratios'];

    % Subplot for subtraction (difference)
    sp1 = subplot(1, 2, 1); % First subplot on the left
    ylabel(sp1, [readablePropertyName ' Difference']);
    title(sp1, [readablePropertyName ' Difference']);
    hold(sp1, 'on');

    % Subplot for ratio
    sp2 = subplot(1, 2, 2); % Second subplot on the right
    ylabel(sp2, [readablePropertyName ' Ratio']);
    title(sp2, [readablePropertyName ' Ratio']);
    hold(sp2, 'on');
    
    colorIdx = 1; % Initialize color index

    % Loop through sensors to plot their data against the target for the current property
    for i = 1:length(sensorNames)
        sensorName = sensorNames{i};

        % Skip plotting for the target sensor comparing to itself
        if strcmp(sensorName, TargetName)
            continue; % This skips the target sensor
        end
        
        % Access subtraction and ratio data for the current sensor and property
        subtractionData = Differences.Subtraction.(sensorName).(propertyName);
        ratioData = Differences.Ratio.(sensorName).(propertyName);

        % Plot subtraction in the left subplot
        plot(sp1, uniform_time, subtractionData, 'LineWidth', lineWidth, ...
             'DisplayName', TargetName + " - " + sensorName, 'Color', colors(colorIdx, :));

        % Plot ratio in the right subplot
        plot(sp2, uniform_time, ratioData, 'LineWidth', lineWidth, ...
             'DisplayName', TargetName + " / " + sensorName, 'Color', colors(colorIdx, :));

        colorIdx = mod(colorIdx, size(colors, 1)) + 1; % Increment and wrap around color index if necessary
    end

    % Finalize the subplots
    xlabel(sp1, 'Time [s]');
    legend(sp1, 'Location', 'best');
    grid(sp1, 'on');
    grid(sp1, 'minor');

    xlabel(sp2, 'Time [s]');
    legend(sp2, 'Location', 'best');
    grid(sp2, 'on');
    grid(sp2, 'minor');
    
    hold(sp1, 'off');
    hold(sp2, 'off');
end


    
end