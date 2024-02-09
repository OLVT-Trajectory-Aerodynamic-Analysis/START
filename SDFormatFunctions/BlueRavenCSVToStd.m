function struct = BlueRavenLowCSVToStd(inputFileNames, title)
    % usage: dataStructure = csvToStruct(csv)
    %
    % Converts data from a Blue Raven csv file to a standardized data structure
    %
    %% Input:
    %  inputFileNames:     A vector containing the two Blue Raven csv files
    %
    %% Output:
    %  struct:  A standardized data structure
    %
    %% Contributors:
    %  @author Sasha Carrico
    %  @created 10/03/2024
    
    %% Separating files
    LowRate = inputFileNames(2);
    HighRate = inputFileNames(1);
    
    fixedLow = StandardTime(LowRate,5);
    fixedHigh= StandardTime(HighRate,5);

    %% Dealing With Time Conflicts (Probably better ways to implement)
    LowFirstTime = fixedLow(1,5);
    LowLastTime = fixedLow(end,5);
    HighFirstTime = fixedHigh(1,5);
    HighLastTime = fixedHigh(end,5);

    % Matches the starting time index
    if LowFirstTime < HighFirstTime
        index = find(fixedLow(:,5)==HighFirstTime);
        fixedLow = fixedLow(index:end,:);
    else
        index = find(fixedHigh(:,5)==LowFirstTime);
        fixedHigh = fixedHigh(index:end,:);
    end

    % Matches the ending time index
    if LowLastTime > HighLastTime
        index = find(fixedLow(:,5)==HighLastTime);
        fixedLow = fixedLow(1:index,:);
    else
        index = find(fixedHigh(:,5)==LowLastTime);
        fixedHigh = fixedHigh(1:index,:);
    end


    %% Operational Code:
    struct.dataType = "BlueRaven";
    struct.dataTitle = title;
    
    struct.time = fixedLow(:,5);                           % [s] 
    
    struct.position.magnitude = [];
    struct.position.altitude = fixedLow(:,9);             % [m]
    struct.position.Xposition = [];
    struct.position.Yposition = [];
    struct.position.Zposition = fixedLow(:,10);            % [m]
    
    struct.velocity.magnitude = sqrt(fixedLow(:,16).^2+fixedLow(:,17).^2+fixedLow(:,18).^2);            % [m/s]
    struct.velocity.Xvelocity = []; 
    struct.velocity.Yvelocity = [];
    struct.velocity.Zvelocity = fixedLow(:,16);
    
    struct.acceleration.Xacceleration = fixedHigh(:,10);    % [m/s^2]
    struct.acceleration.Yacceleration = fixedHigh(:,11);    % [m/s^2]
    struct.acceleration.Zacceleration = fixedHigh(:,12);    % [m/s^2]
    struct.acceleration.magnitude = sqrt(fixedHigh(:,10).^2+fixedHigh(:,11).^2+fixedHigh(:,12).^2);         % [m/s^2]

    struct.gyro.roll = fixedHigh(:,7);                     % [degrees]
    struct.gyro.pitch = fixedHigh(:,8);                    % [degrees]
    struct.gyro.yaw = fixedHigh(:,9);                      % [degrees]
    struct.gyro.tilt = [361, 361];                     % [degrees]
    
    struct.atmosphere.pressure = fixedLow(:,8)*101325;            % [Pa]
    struct.atmosphere.temperature = ((fixedLow(:,7)-32)*5/9) + 273.15;        % [K]
    struct.atmosphere.density = ...
        struct.atmosphere.pressure ./ (287.1 * struct.atmosphere.temperature);

    struct.performance.dragAcc = calculateDragAcceleration(struct);
    end