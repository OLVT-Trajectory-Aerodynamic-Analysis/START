function struct = RasCSVToStd(csv)
    % usage: dataStructure = csvToStruct(csv)
    %
    % Converts data from a RASAeroII csv file to a standardized data structure
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
    fixed = StandardTime(csv,1);
    
    %% Operational Code:
    struct.time = fixed(:,1);
    
    struct.position.magnitude = sqrt((fixed(:,23)).^2 + (fixed(:,24).^2)) * 0.3048; % [m]
    %struct.position.altitude = null;
    %struct.position.Xposition = null;
    %struct.position.Yposition = null;
    struct.position.Zposition = fixed(:,23) * 0.3048; % [m]
    
    struct.velocity.magnitude = sqrt((fixed(:,19)).^2 + (fixed(:,20)).^2) * 0.3048; % [m/s]
    %struct.velocity.Xvelocity = null;
    %struct.velocity.Yvelocity = null;
    struct.velocity.Zvelocity = fixed(:,19) * 0.3048; % [m/s]
    
    struct.acceleration.magnitude = sqrt((fixed(:,16)).^2 + (fixed(:,17)).^2) * 0.3048; % [m/s2]
    %struct.acceleration.Xacceleration = null;
    %struct.acceleration.Yacceleration = null;
    struct.acceleration.Zacceleration = fixed(:,16) * 0.3048; % [m/s2]
    
    %struct.gyro.roll = null;
    %struct.gyro.pitch = null;
    %struct.gyro.yaw = null;
    struct.gyro.tilt = fixed(:,21); % []
    
    %struct.atmosphere.pressure = null;
    %struct.atmosphere.temperature = null;
    %struct.atmosphere.density = null;
    end