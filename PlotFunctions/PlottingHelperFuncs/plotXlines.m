% THis purpose of this function is to plot the verticle lines that display
% phases of the rocket on plots. It should be build to work on any plot
%
% @author Michael Plano
% @created 02/02/2024
function [] = plotXlines(configs, rocket, fig1)
    if (configs.rocketPhaseLines)
        %% Calculate the position of the label
        xLims = fig1.CurrentAxes.XLim;
        yLims = fig1.CurrentAxes.YLim;
    
        yPos = yLims(2) - abs((yLims(2) - yLims(1)))/100;
        xChange = abs((xLims(2) - xLims(1)))/100;
    
        %% Plot the line at Motor Burnout, Separation, and ignition
        hold on
        name1 = "Motor Burnout: " + num2str(rocket.sustainerMotorBurnTime) + " s";
        xline(rocket.sustainerMotorBurnTime, '--',...
            'Motor Burnout', 'Color', 'black', 'LineWidth', 3, 'DisplayName', name1)
        
%         hold on
%         name2 = "Stage Separation: " + num2str(rocket.sustainerMotorBurnTime + rocket.separationDelay) + " s";
%         xline(rocket.sustainerMotorBurnTime + rocket.separationDelay, '--',...
%             'Stage Separation', 'Color', 'black', 'LineWidth', 3, 'DisplayName', name2)
%        
%         hold on
%         name3 = "Sustainer Ignition: " + num2str(rocket.sustainerMotorBurnTime + rocket.separationDelay + rocket.ignitionDelay) + " s";
%         xline(rocket.sustainerMotorBurnTime + rocket.separationDelay + rocket.ignitionDelay, ':' ,...
%             'Sustainer Ignition', 'Color', 'black', 'LineWidth', 3, 'DisplayName', name3)

        hold on
        name4 = "Apogee: " + num2str(13.6) + " s";
        xline(13.6, '--',...
            'Apogee', 'Color', 'black', 'LineWidth', 3, 'DisplayName', name4)

        hold on
        name5 = "Drogue Deploy: " + num2str(14.9) + " s";
        xline(14.9, '--',...
            'Drogue Deploy', 'Color', 'black', 'LineWidth', 3, 'DisplayName', name5)

        hold on
        name6 = "Main Deploy: " + num2str(20.5) + " s";
        xline(20.5, '--',...
            'Main Deploy', 'Color', 'black', 'LineWidth', 3, 'DisplayName', name6)
    end
end