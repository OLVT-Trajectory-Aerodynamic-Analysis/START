% This is the file that handles all of the ploitting functionality, for now
% at least
% 
% Contributors
% @author Michael Plano
% @author Hady Solimany
% @created 09/25/2023
% 

function Copy_of_plotFlights(sourceList, config, rocket)
% This function creates plots of the main data (altitude, tilt, vel,
% accel, atm), the data collected from each sensor is overlayed into one plot 

% Initialize the Figures
fig1 = figure('WindowStyle', 'docked');
set(fig1, 'Name', 'Skipper1C Data')

tabgroup = uitabgroup(fig1);

tab1 = uitab(tabgroup, 'Title', 'Height');
tab2 = uitab(tabgroup, 'Title', 'Velocity');
tab3 = uitab(tabgroup, 'Title', 'Acceleration');
tab4 = uitab(tabgroup, 'Title', 'Tilt');
tab5 = uitab(tabgroup, 'Title', 'Atmosphere');
tab6 = uitab(tabgroup, 'Title', 'MaxQ');
tab7 = uitab(tabgroup, 'Title', 'Drag Acceleration');

%% Create legendList
legendList = strings(1, length(sourceList) );
for i = 1:length(sourceList)
    legendList(1, i) = sourceList{1, i}.dataTitle;
end



%% Graph Positions
ax = axes('Parent', tab1);
for i = 1:length(sourceList)
    time = sourceList{1, i}.time;
    altitude = sourceList{1, i}.position.Zposition;
    plot(ax, time, altitude)
    hold on
end
title('Height')
xlabel('Time [s]'); ylabel('Height above launchpad [m]')
legend(legendList)
grid on
grid minor
hold off

%% Graph Velocities
ax = axes('Parent', tab2);
for i = 1:length(sourceList)
    time = sourceList{1, i}.time;
    vMag = sourceList{1, i}.velocity.magnitude;
    plot(ax, time, vMag)
    hold on
end
title('Velocity')
xlabel('Time [s]'); ylabel('Velocity [m s^-1]')
legend(legendList)
grid on
grid minor
hold off

%% Graph Acceleration
ax = axes('Parent', tab3);
for i = 1:length(sourceList)
    time = sourceList{1, i}.time;
    aMag = sourceList{1, i}.acceleration.magnitude;
    plot(ax, time, abs(aMag))
    hold on
end
title('Acceleration')
xlabel('Time [s]'); ylabel('Acceleration [m s^-2]')
legend(legendList)
grid on
grid minor
hold off

%% Graph Gyro
ax = axes('Parent', tab4);
for i = 1:length(sourceList)
    time = sourceList{1, i}.time;
    tilt = sourceList{1, i}.gyro.tilt;
    if tilt(1) ~= 361
        %Gyro plots
        plot(ax, time, tilt)
        hold on
        
    end
end
title('Tilt')
xlabel('Time (s)'); ylabel('angle [degrees]')
legend(legendList)
grid on
grid minor
hold off
%% Graph Atmosphere
tlayout1 = tiledlayout(3, 1, 'Parent', tab5);

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

leg = legend(legendList, 'Orientation', 'Horizontal');
leg.Layout.Tile = 'north';


%% Max Q
tlayout2 = tiledlayout(1, 2, 'Parent', tab6);

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

leg = legend(legendList, 'Orientation', 'Horizontal');
leg.Layout.Tile = 'north';

%% Drag plots
% Here we only want to plot drag during coast phase, so cut after burntime
% and after apogee


ax = axes('Parent', tab7);
for i = 1:length(sourceList)
    if sourceList{1, i}.performance.dragAcc(1) ~= 1e10
        time = sourceList{1, i}.time;
        altitude = sourceList{1, i}.position.altitude;
        dragAccel = sourceList{1, i}.performance.dragAcc;
    
        [~, iMaxAlt] = max(altitude);
        iCoast = find(time > rocket.sustainerMotorBurnTime & time <= time(iMaxAlt));
    
        plot(ax, time(iCoast), dragAccel(iCoast))
        hold on
    end
end
title('Drag Acceleration v Time')
xlabel('Time [s]'); ylabel('Drag Acceleration [m s^-2]')
grid on
hold off
xlim([0 inf])

legend(legendList)


config = config;
end
