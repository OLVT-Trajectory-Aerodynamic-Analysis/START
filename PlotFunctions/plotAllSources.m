% This is the file that handles all of the ploitting functionality, for now
% at least
% 
% Contributors
% @author Michael Plano
% @author Hady Solimany
% @created 09/25/2023
% 

function plotAllSources(sourceList, config, rocket)
% This function creates plots of the main data (altitude, tilt, vel,
% accel, atm), the data collected from each sensor is overlayed into one plot 

set(0, 'DefaultAxesFontSize', 18);
set(0, 'DefaultAxesFontName', 'Times New Roman');
set(0,'DefaultFigureWindowStyle','docked')


%% Graph Positions
fig1 = figure(1);
fig1.Name = "Height";
for i = 1:length(sourceList)
    time = sourceList{1, i}.time;
    altitude = sourceList{1, i}.position.Zposition;
    plot(time, altitude, 'DisplayName', sourceList{1, i}.dataTitle)
    hold on
end
title('Height')
xlabel('Time [s]'); ylabel('Height above launchpad [m]')
legend('Location', 'best')
grid on
grid minor
hold off

%% Graph Velocities
fig2 = figure(2);
fig2.Name = "Velocity";
for i = 1:length(sourceList)
    time = sourceList{1, i}.time;
    vMag = sourceList{1, i}.velocity.magnitude;
    plot(time, vMag, 'DisplayName', sourceList{1, i}.dataTitle)
    hold on
end
title('Velocity')
xlabel('Time [s]'); ylabel('Velocity [m s^-1]')
legend('Location', 'best')
grid on
grid minor
hold off

%% Graph Acceleration
fig3 = figure(3);
fig3.Name = "Acceleration";
for i = 1:length(sourceList)
    time = sourceList{1, i}.time;
    aMag = sourceList{1, i}.acceleration.magnitude;
    plot(time, abs(aMag), 'DisplayName', sourceList{1, i}.dataTitle)
    hold on
end
title('Acceleration')
xlabel('Time [s]'); ylabel('Acceleration [m s^-2]')
legend('Location', 'best')
grid on
grid minor
hold off

%% Graph Gyro
fig4 = figure(4);
fig4.Name = "Tilt";
for i = 1:length(sourceList)
    time = sourceList{1, i}.time;
    tilt = sourceList{1, i}.gyro.tilt;
    if tilt(1) ~= 361
        %Gyro plots
        plot(time, tilt, 'DisplayName', sourceList{1, i}.dataTitle)
        hold on
        
    end
end
title('Tilt')
xlabel('Time (s)'); ylabel('angle [degrees]')
legend('Location', 'best')
grid on
grid minor
hold off
%% Graph Atmosphere

fig5 = figure(5);
fig5.Name = "Atmosphere";
tlayout1 = tiledlayout(3, 1, 'Parent', fig5);

% Pressure
ax = nexttile(tlayout1);
for i = 1:length(sourceList)
    time = sourceList{1, i}.time;
    atmP = sourceList{1, i}.atmosphere.pressure;

    plot(ax, time, atmP)
    hold on
end
xlabel('Time [s]'); ylabel('Pressure [Pa]')
grid on
hold off

ax2 = nexttile(tlayout1);

% Temperature
for i = 1:length(sourceList)
    time = sourceList{1, i}.time;
    atmT = sourceList{1, i}.atmosphere.temperature;

    plot(ax2, time, atmT)
    hold on
end
xlabel('Time [s]'); ylabel('Temperature [K]')
grid on
hold off

ax3 = nexttile(tlayout1);

% Density
for i = 1:length(sourceList)
    time = sourceList{1, i}.time;
    atmD = sourceList{1, i}.atmosphere.density;

    plot(ax3, time, atmD)
    hold on
end
xlabel('Time [s]'); ylabel('Density [kg m^-3]')
grid on
hold off


%% Max Q
fig6 = figure(6);
fig6.Name = "MaxQ";

tlayout2 = tiledlayout(1, 2, 'Parent', fig6);

ax1 = nexttile(tlayout2);
for i = 1:length(sourceList)
    time = sourceList{1, i}.time;
    vMag = sourceList{1, i}.velocity.magnitude;
    atmD = sourceList{1, i}.atmosphere.density;
    
    dynamicPressure = (atmD.*(vMag.^2))/2;
    plot(ax1, time, dynamicPressure)
    hold on
end
title('MaxQ v Time')
xlabel('Time [s]'); ylabel('Dynamic Pressure [Pa]')
grid on
hold off
    
ax2 = nexttile(tlayout2);
for i = 1:length(sourceList)
    altitude = sourceList{1, i}.position.altitude;
    vMag = sourceList{1, i}.velocity.magnitude;
    atmD = sourceList{1, i}.atmosphere.density;
    
    dynamicPressure = (atmD.*(vMag.^2))/2;
    plot(ax2, altitude, dynamicPressure)
    hold on
end
title('MaxQ v altitude')
xlabel('Altitude [m]'); ylabel('Dynamic Pressure [Pa]')
grid on
hold off


%% Drag plots
% Here we only want to plot drag during coast phase, so cut after burntime
% and after apogee


fig7 = figure(7);
fig7.Name = "Drag";
for i = 1:length(sourceList)
    if sourceList{1, i}.performance.dragAcc(1) ~= 1e10
        time = sourceList{1, i}.time;
        altitude = sourceList{1, i}.position.altitude;
        dragAccel = sourceList{1, i}.performance.dragAcc;
    
        [~, iMaxAlt] = max(altitude);
        iCoast = find(time > rocket.sustainerMotorBurnTime & time <= time(iMaxAlt));
    
        plot(time(iCoast), dragAccel(iCoast), 'DisplayName', sourceList{1, i}.dataTitle)
        hold on
    end
end
title('Drag Acceleration v Time')
xlabel('Time [s]'); ylabel('Drag Acceleration [m s^-2]')
legend('Location', 'best')
grid on
hold off
xlim([0 inf])

config = config;
end
