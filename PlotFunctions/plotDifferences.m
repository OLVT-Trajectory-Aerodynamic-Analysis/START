function [] = plotDifferences(processedData, config, rocket)
    set(0, 'DefaultAxesFontSize', 15);
    set(0, 'DefaultAxesFontName', 'Times New Roman');
    set(0,'DefaultFigureWindowStyle','docked')
    titleSz = 30;
    lineWidth = 2;
    
    
    %% Graph Positions
%     fig1 = figure();
%     fig1.Name = "Height";
%     for i = 1:length(sourceList)
%         time = sourceList{1, i}.time;
%         altitude = sourceList{1, i}.position.Zposition;
%         plot(time, altitude, 'DisplayName', sourceList{1, i}.dataTitle, 'LineWidth', lineWidth)
%         hold on
%     end
%     plotXlines(configs.plotDataSources,  rocket, fig1)
%     trimAxis(configs.plotDataSources, sourceList{1, 1})
%     title("Height AGL", 'FontName', 'Times New Roman', 'FontSize', titleSz)
%     xlabel('Time [s]'); ylabel('Height AGL [m]')
%     legend('Location', 'best')
%     grid on
%     grid minor
%     hold off


end