% This is the file that handles all of the ploitting functionality, for now
% at least
% 
% Contributors
% @author Michael Plano
% @author Hady Solimany
% @created 09/25/2023
% 

function plotAllSources(sourceList, configs, rocket)
% This function creates plots of the main data (altitude, tilt, vel,
% accel, atm), the data collected from each sensor is overlayed into one plot 

set(0, 'DefaultAxesFontSize', 15);
set(0, 'DefaultAxesFontName', 'Times New Roman');
set(0,'DefaultFigureWindowStyle','docked')
titleSz = 30;
lineWidth = 2;


%% Graph Positions
fig1 = figure();
fig1.Name = "Height";
for i = 1:length(sourceList)
    time = sourceList{1, i}.time;
    altitude = sourceList{1, i}.position.Zposition;
    plot(time, altitude, 'DisplayName', sourceList{1, i}.dataTitle, 'LineWidth', lineWidth)
    hold on
end
plotXlines(configs.plotDataSources,  rocket, fig1)
trimAxis(configs.plotDataSources, sourceList{1, 1})
title("Height AGL", 'FontName', 'Times New Roman', 'FontSize', titleSz)
xlabel('Time [s]'); ylabel('Height AGL [m]')
legend('Location', 'best')
grid on
grid minor
hold off

%% Graph Velocities
fig2 = figure();
fig2.Name = "Velocity";
for i = 1:length(sourceList)
    time = sourceList{1, i}.time;
    vMag = sourceList{1, i}.velocity.magnitude;
    plot(time, vMag, 'DisplayName', sourceList{1, i}.dataTitle, 'LineWidth', lineWidth)
    hold on
end
plotXlines(configs.plotDataSources,  rocket, fig1)
trimAxis(configs.plotDataSources, sourceList{1, 1})
title('Velocity', 'FontName', 'Times New Roman', 'FontSize', titleSz)
xlabel('Time [s]'); ylabel('Velocity [m s^-1]')
legend('Location', 'best')
grid on
grid minor
hold off

%% Graph Acceleration
fig3 = figure();
fig3.Name = "Acceleration";
for i = 1:length(sourceList)
    time = sourceList{1, i}.time;
    aMag = sourceList{1, i}.acceleration.magnitude;
    plot(time, abs(aMag), 'DisplayName', sourceList{1, i}.dataTitle, 'LineWidth', lineWidth)
    hold on
end
plotXlines(configs.plotDataSources,  rocket, fig1)
trimAxis(configs.plotDataSources, sourceList{1, 1})
title('Acceleration', 'FontName', 'Times New Roman', 'FontSize', titleSz)
xlabel('Time [s]'); ylabel('Acceleration [m s^-2]')
legend('Location', 'best')
grid on
grid minor
hold off

%% Graph Gyro
fig4 = figure();
fig4.Name = "Tilt";
for i = 1:length(sourceList)
    time = sourceList{1, i}.time;
    tilt = sourceList{1, i}.gyro.tilt;
    if tilt(1) ~= 361
        %Gyro plots
        plot(time, tilt, 'DisplayName', sourceList{1, i}.dataTitle, 'LineWidth', lineWidth)
        hold on   
    end
end
plotXlines(configs.plotDataSources,  rocket, fig1)
trimAxis(configs.plotDataSources, sourceList{1, 1})
ylim([-5, 185])
title('Tilt', 'FontName', 'Times New Roman', 'FontSize', titleSz)
xlabel('Time (s)'); ylabel('angle [degrees]')
legend('Location', 'best')
grid on
grid minor
hold off
%% Graph Atmosphere

fig5 = figure();
fig5.Name = "Atmosphere";
tlayout1 = tiledlayout(3, 1, 'Parent', fig5);

% Pressure
ax = nexttile(tlayout1);
for i = 1:length(sourceList)
    time = sourceList{1, i}.time;
    atmP = sourceList{1, i}.atmosphere.pressure;

    plot(ax, time, atmP, 'LineWidth', lineWidth)
    hold on
end
xlabel('Time [s]'); ylabel('Pressure [Pa]')
title("Pressure", 'FontName', 'Times New Roman', 'FontSize', titleSz)
grid on
hold off

ax2 = nexttile(tlayout1);

% Temperature
for i = 1:length(sourceList)
    time = sourceList{1, i}.time;
    atmT = sourceList{1, i}.atmosphere.temperature;

    plot(ax2, time, atmT, 'LineWidth', lineWidth)
    hold on
end
xlabel('Time [s]'); ylabel('Temperature [K]')
title("Temperature", 'FontName', 'Times New Roman', 'FontSize', titleSz)
grid on
hold off

ax3 = nexttile(tlayout1);

% Density
for i = 1:length(sourceList)
    time = sourceList{1, i}.time;
    atmD = sourceList{1, i}.atmosphere.density;

    plot(ax3, time, atmD, 'LineWidth', lineWidth)
    hold on
end
xlabel('Time [s]'); ylabel('Density [kg m^-3]')
title("Density", 'FontName', 'Times New Roman', 'FontSize', titleSz)
grid on
hold off


%% Max Q
fig6 = figure();
fig6.Name = "MaxQ";

tlayout2 = tiledlayout(1, 2, 'Parent', fig6);

ax1 = nexttile(tlayout2);
for i = 1:length(sourceList)
    time = sourceList{1, i}.time;
    vMag = sourceList{1, i}.velocity.magnitude;
    atmD = sourceList{1, i}.atmosphere.density;
    
    dynamicPressure = (atmD.*(vMag.^2))/2;
    plot(ax1, time, dynamicPressure, 'LineWidth', lineWidth)
    hold on
end
title('MaxQ v Time', 'FontName', 'Times New Roman', 'FontSize', titleSz)
xlabel('Time [s]'); ylabel('Dynamic Pressure [Pa]')
grid on
hold off
    
ax2 = nexttile(tlayout2);
for i = 1:length(sourceList)
    altitude = sourceList{1, i}.position.altitude;
    vMag = sourceList{1, i}.velocity.magnitude;
    atmD = sourceList{1, i}.atmosphere.density;
    
    dynamicPressure = (atmD.*(vMag.^2))/2;
    plot(ax2, altitude, dynamicPressure, 'LineWidth', lineWidth)
    hold on
end
title('MaxQ v altitude', 'FontName', 'Times New Roman', 'FontSize', titleSz)
xlabel('Altitude [m]'); ylabel('Dynamic Pressure [Pa]')
grid on
hold off


%% Drag plots
% Here we only want to plot drag during coast phase, so cut after burntime
% and after apogee


fig7 = figure();
fig7.Name = "Drag";
for i = 1:length(sourceList)
    if sourceList{1, i}.performance.dragAcc(1) ~= 1e10
        time = sourceList{1, i}.time;
        altitude = sourceList{1, i}.position.altitude;
        dragAccel = sourceList{1, i}.performance.dragAcc;
    
        [~, iMaxAlt] = max(altitude);
        iCoast = find(time > rocket.sustainerMotorBurnTime & time <= time(iMaxAlt));
    
        plot(time(iCoast), dragAccel(iCoast), 'DisplayName', sourceList{1, i}.dataTitle, 'LineWidth', lineWidth)
        hold on
    end
end
title('Drag Acceleration', 'FontName', 'Times New Roman', 'FontSize', titleSz)
xlabel('Time [s]'); ylabel('Drag Acceleration [m s^-2]')
legend('Location', 'best')
grid on
hold off
xlim([0 inf])

end
