function plotFlights(sourceList)
% This function creates plots of the main data (altitude, tilt, vel,
% accel, atm), the data collected from each sensor is overlayed into one plot 

% Initialize the Figures
set(0,'DefaultFigureWindowStyle','docked')
figure('Name','Position','NumberTitle','off')
hold on; grid on
figure('Name','Vel','NumberTitle','off')
hold on; grid on
figure('Name','Accel','NumberTitle','off')
hold on; grid on
figure('Name','Gyro','NumberTitle','off')
hold on; grid on
figure('Name','Atmosphere','NumberTitle','off')
hold on; grid on
figure('Name','MaxQ','NumberTitle','off')
hold on; grid on
legendList = {};

for i = 1:length(sourceList)
    % Initialize the dataset
    data = sourceList(i);
    t = data.time;
    legendList(i) = {"dataset " + num2str(i)};
    %% Positions 
    %Altitude
    alt = data.position.altitude;
    figure(1)
    plot(t,alt)
    title('Altitude')
    xlabel('Time [s]'); ylabel('Altitude [ft]')
    %% Velocities
    vMag = data.velocity.magnitude;
    %Velocity plot
    figure(2)
    plot(t,vMag)
    title('Velocity')
    xlabel('Time [s]'); ylabel('Velocity [?]')
    %% Acceleration
    aMag = data.acceleration.magnitude;
    %Acceleration plot
    figure(3)
    plot(t,vMag)
    title('Acceleration')
    xlabel('Time [s]'); ylabel('Acceleration [?]')
    %% Gyro [needs edit]
    tilt = data.gyro.tilt;
    %Gyro plots
    figure(4)
    plot(t,tilt)
    title('Tilt')
    xlabel('Time (s)'); ylabel('angle [?]')
    %% Atmosphere
    atmP = data.atmosphere.pressure;
    atmT = data.atmosphere.temperature;
    atmD = data.atmosphere.density;
    %Atmosphere plots: Thinking of putting all 3 of these into 1 window
    figure(5)
    subplot(2,2,1)
    plot(atmP,alt)
    title('Pressure')
    xlabel('Pressure [?]'); ylabel('Altitude [ft]')
    
    subplot(2,2,2)
    plot(atmT,alt)
    title('Temperature')
    xlabel('Temperature [?]'); ylabel('Altitude [ft]')
    
    subplot(2,2,3)
    plot(atmD,alt)
    title('Density')
    xlabel('Density [?]'); ylabel('Altitude [ft]')
    %% Max Q (Idk where to put this)
    figure(6)
    dynamicPressure = (atmD.*(vMag.^2))/2;
    
    subplot(1,2,1)
    plot(t,dynamicPressure)
    title('MaxQ v Time')
    xlabel('Time [s]'); ylabel('Dynamic Pressure [?]')
    
    subplot(1,2,2)
    plot(alt,dynamicPressure)
    title('MaxQ v Altitude')
    xlabel('Dynamic Pressure [?]'); ylabel('Altitude [ft]'); 
end
figure(1)
legend(legendList)
figure(2)
legend(legendList)
figure(3)
legend(legendList)
figure(4)
legend(legendList)
figure(5)
legend(legendList)
figure(6)
legend(legendList)

end
