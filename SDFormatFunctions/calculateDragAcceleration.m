function [dragAcc] = calculateDragAcceleration(struct)
    
    %Grab acceleration vector
    aVector = [struct.acceleration.Xacceleration, struct.acceleration.Yacceleration struct.acceleration.Zacceleration];  

    %Gravity vector is the last acceleration vector, because that is when 
    % the rocket is on the ground
    g = [struct.acceleration.Xacceleration(end) 
            struct.acceleration.Yacceleration(end)
            struct.acceleration.Zacceleration(end)];

    % Assume acceleration is only made up of gravity and dragend
    dragAcc = vecnorm(aVector - g', 2, 2);                          

end