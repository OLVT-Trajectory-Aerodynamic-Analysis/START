function struct = TelemetrumCSVToStd(csv)
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
    
    struct.time = fixed(:,5);                           % [s] 
    
    struct.position.magnitude = [];
    struct.position.altitude = fixed(:,10);             % [m]
    struct.position.Xposition = [];
    struct.position.Yposition = [];
    struct.position.Zposition = fixed(:,11);            % [m]
    
    struct.velocity.magnitude = fixed(:,12);            % [m/s]
    struct.velocity.Xvelocity = []; 
    struct.velocity.Yvelocity = [];
    struct.velocity.Zvelocity = [];
    
    struct.acceleration.magnitude = fixed(:,8);         % [m/s^2]
    struct.acceleration.Xacceleration = fixed(:,17);    % [m/s^2]
    struct.acceleration.Yacceleration = fixed(:,18);    % [m/s^2]
    struct.acceleration.Zacceleration = fixed(:,19);    % [m/s^2]
    
    struct.gyro.roll = fixed(:,20);                     % []
    struct.gyro.pitch = fixed(:,21);                    % []
    struct.gyro.yaw = fixed(:,22);                      % []
    struct.gyro.tilt = fixed(:,26);                     % []
    
    struct.atmosphere.pressure = fixed(:,9);            % [Pa]
    struct.atmosphere.temperature = fixed(:,13);        % [C]
    struct.atmosphere.density = [];
    end