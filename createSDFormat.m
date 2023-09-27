% This function is in charge of changing the data from its raw form to the
% SDFormat. 
% 

% Contributors
% @author Michael Plano
% @created 9/25/2023

% @param data is the raw data. This data has to be in the source data type.
% @returns processedData is the data in the SD Format

% This is the current SDFormat. Note it is in struct format
% 
% data.filepath
% data.dataType
% data.sourceType
% 
% data.time
% data.state
% 
% data.position
% data.position.altitude
% data.position.magnitude (maybe)
% data.position.Xposition
% data.position.Yposition
% data.position.Zposition
% 
% data.velocity
% data.velocity.magnitude
% data.velocity.Xvelocity
% data.velocity.Yvelocity
% data.velocity.Zvelocity
% 
% data.acceleration
% data.acceleration.magnitude
% data.acceleration.Xacceleration
% data.acceleration.Yacceleration
% data.acceleration.Zacceleration
% 
% data.gyro
% data.gyro.roll
% data.gyro.pitch
% data.gyro.yaw
% data.gyro.tilt
% 
% data.atmosphere
% data.atmosphere.pressure
% data.atmosphere.temperature
% data.atmosphere.density

function [processedData] = createSDFormat(data)
    disp(data)
    processedData = 0;
end