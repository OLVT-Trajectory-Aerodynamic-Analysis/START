function struct = TelemetrumCSVToStd(csv, title)
    % usage: dataStructure = csvToStruct(csv)
    %
    % Converts data from a Telemetrum csv file to a standardized data structure
    %
    %% Input:
    %  csv:     The name of the csv file containing the initial data
    %
    %% Output:
    %  struct:  A standardized data structure
    %
    %% Contributors:
    %  @author Austin Zary
    %  @created 10/03/2023
    % 
    %% Parsing Input:
    fixed = StandardTime(csv,5);
    
    %% Operational Code:
    struct.dataType = "Telemetrum";
    struct.dataTitle = title;
    a=0; % Set to 2 for Skipper 1C
    struct.time = fixed(:,5);                           % [s] 
    
    struct.position.magnitude = [];
    struct.position.altitude = fixed(:,10+a);             % [m]
    struct.position.Xposition = [];
    struct.position.Yposition = [];
    struct.position.Zposition = fixed(:,11+a);            % [m]
    
    struct.velocity.magnitude = fixed(:,12+a);            % [m/s]
    struct.velocity.Xvelocity = []; 
    struct.velocity.Yvelocity = [];
    struct.velocity.Zvelocity = [];
    
    struct.acceleration.Xacceleration = fixed(:,17+a);    % [m/s^2]
    struct.acceleration.Yacceleration = fixed(:,18+a);    % [m/s^2]
    struct.acceleration.Zacceleration = fixed(:,19+a);    % [m/s^2]
    struct.acceleration.magnitude = fixed(:,8+a);         % [m/s^2]

    struct.gyro.roll = fixed(:,20+a);                     % [degrees]
    struct.gyro.pitch = fixed(:,21+a);                    % [degrees]
    struct.gyro.yaw = fixed(:,22+a);                      % [degrees]
    struct.gyro.tilt = fixed(:,26+a);                     % [degrees]
    
    struct.atmosphere.pressure = fixed(:,9+a);            % [Pa]
    struct.atmosphere.temperature = fixed(:,13+a) + 273.15;        % [K]
    struct.atmosphere.density = ...
        struct.atmosphere.pressure ./ (287.1 * struct.atmosphere.temperature);

    struct.performance.dragAcc = calculateDragAcceleration(struct);
    end