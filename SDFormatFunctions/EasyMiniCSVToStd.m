function struct = EasyMiniCSVToStd(csv, title)
    % usage: dataStructure = csvToStruct(csv)
    %
    % Converts data from a EasyMini csv file to a standardized data structure
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
    fixed = StandardTime(csv,4);
    
    %% Operational Code:
    struct.dataType = "EasyMini";
    struct.dataTitle = title;

    struct.time = fixed(:,4);                           % [s] 
    
    %struct.position.magnitude = null;
    struct.position.altitude = fixed(:,9);             % [m]
    %struct.position.Xposition = null;
    %struct.position.Yposition = null;
    struct.position.Zposition = fixed(:,10);            % [m]
    
    struct.velocity.magnitude = fixed(:,11);            % [m/s]
    %struct.velocity.Xvelocity = null; 
    %struct.velocity.Yvelocity = null;
    %struct.velocity.Zvelocity = null;
    
    struct.acceleration.magnitude = fixed(:,7);         % [m/s^2]
%     struct.acceleration.Xacceleration = fixed(:,17);    % [m/s^2]
%     struct.acceleration.Yacceleration = fixed(:,18);    % [m/s^2]
%     struct.acceleration.Zacceleration = fixed(:,19);    % [m/s^2]
    
    struct.gyro.tilt = zeros(size(fixed(:,4)));
    struct.gyro.tilt(1) = 361;

    struct.atmosphere.pressure = fixed(:,8);            % [Pa]
    struct.atmosphere.temperature = fixed(:,12)+273.15; % [C]
    struct.atmosphere.density = struct.atmosphere.pressure/...
                                    ((struct.atmosphere.temperature) * 287.05);

    struct.performance.dragAcc = calculateDragAcceleration(struct);
    end