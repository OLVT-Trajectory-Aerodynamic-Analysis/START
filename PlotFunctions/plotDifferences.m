function [] = plotDifferences(processedData, configs, rocket)
%% Create uniform time vectors

for i=1:length(processedData)

    if processedData{1, i}.dataTitle == "RasAeroII Data"
      RAS_time=processedData{1, i}.time;
      RAS_velocity=processedData{1,i}.velocity.magnitude;
    elseif processedData{1, i}.dataTitle== "Telemega Data"
      TELE_time=processedData{1, i}.time;
      TELE_velocity=processedData{1,i}.velocity.magnitude;
    elseif processedData{1, i}.dataTitle=="BlueRaven Data"
      Raven_time=processedData{1,i}.time;
      Raven_velocity=processedData{1,i}.velocity.magnitude;

    end
end

% Determine the start and end times for the uniform time vector

%RAS and Blue Raven
start_time = min(min(RAS_time), min(Raven_time));
end_time = max(max(RAS_time), max(Raven_time));

% Create a uniform time vector from the earliest start to the latest end with a step of 0.1
uniform_time = (start_time:0.1:end_time)';

% Initialize vectors to hold aligned velocities
Ras_velocity_aligned = zeros(length(uniform_time), 1);
raven_velocity_aligned = zeros(length(uniform_time), 1);

% Align RAS data velocities
for i = 1:length(RAS_time)
    % Find the index in the uniform time vector that matches the simulation time
    index = find(uniform_time == RAS_time(i));
    if ~isempty(index)
        Ras_velocity_aligned(index) = RAS_velocity(i);
    end
end

% Align Blue Raven data velocities
for i = 1:length(Raven_time)
    % Find the index in the uniform time vector that matches the raven time
    index = find(uniform_time == Raven_time(i));
    if ~isempty(index)
        raven_velocity_aligned(index) = Raven_velocity(i);
    end
end

% Calculate the difference in velocities
RAS_vs_Raven_velo = Ras_velocity_aligned - raven_velocity_aligned;
RAS_Raven_ratio_velo = Ras_velocity_aligned ./ raven_velocity_aligned;


%% Graph stuff


    set(0, 'DefaultAxesFontSize', 15);
    set(0, 'DefaultAxesFontName', 'Times New Roman');
    set(0,'DefaultFigureWindowStyle','docked')
    titleSz = 30;
    lineWidth = 2;
    
    
    % Graph Positions
    fig1 = figure();
    fig1.Name = "Velocity Difference";
   
    plot(uniform_time, RAS_vs_Raven_velo, 'LineWidth', lineWidth, 'DisplayName', "Ras - Raven")
    hold on
    plot(uniform_time, RAS_Raven_ratio_velo, 'LineWidth', lineWidth, 'DisplayName', "Ras / Raven")

    plotXlines(configs.plotDataSources,  rocket, fig1)
    trimAxis(configs.plotDataSources, processedData{1, 1})
    title("RAS vs. Blue Raven Velocity Mag.", 'FontName', 'Times New Roman', 'FontSize', titleSz)
    xlabel('Time [s]'); ylabel('Velocity Mag. [m/s]')
    legend('Location', 'best')
    grid on
    grid minor

    
end