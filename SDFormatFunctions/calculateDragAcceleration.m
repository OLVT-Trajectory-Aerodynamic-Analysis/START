% This function deals with the struct.performance.dragAcceleration part od
% the SD format

% Contributors
% @author Michael Plano
% @author Hady Solimany
% @created 11/2023
% 

function [dragAcc] = calculateDragAcceleration(struct)
    try
        %Grab acceleration vector
        aVector = [struct.acceleration.Xacceleration, struct.acceleration.Yacceleration struct.acceleration.Zacceleration];  
    
        %Gravity vector is the last acceleration vector, because that is when 
        % the rocket is on the ground
        g = [struct.acceleration.Xacceleration(end) 
                struct.acceleration.Yacceleration(end)
                struct.acceleration.Zacceleration(end)];
    
        % Assume acceleration is only made up of gravity and dragend
        dragAcc = vecnorm(aVector - g', 2, 2);  
    catch
        dragAcc = zeros(size(struct.time));
        dragAcc(1) = 1e10;
    end

end