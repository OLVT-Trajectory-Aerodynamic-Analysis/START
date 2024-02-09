function fixed = StandardTime(csv, timecol)
    % usage: fixed = standardTime(timecol)
    %
    % Standardizes data to a common time step of 0.1 seconds while also 
    % deleting any duplicate rows. Data for newly created times is calculated
    % using linear interpolation from the closest times before and after.
    %
    %% Input:
    %  csv:     Name of the csv file containing the initial data
    %  timecol: Column number that time values are stored in
    %
    %% Output:
    %  fixed:   Matrix with timesteps of 0.1 seconds
    %
    %% Contributors:
    %  @author Austin Zary
    %  @created 10/03/2023
    %  @last edited 02/09/2024
    %
    %% Parsing Input:
    broken = readmatrix(csv);
    %test = readtable(csv); Might need to do this to preserve strings
    
    [m,n] = size(broken);
    
    midway = broken(1,:);
    
    j = 2;
    
    %% Deleting Duplicates data points
    for i=2:m
        if (broken((i-1),timecol) ~= broken(i,timecol)) % checks if the current time is the same as the previous one
            midway(j,:) = broken(i,:);      % fills in data for a new timestep
            j = j + 1;
        end
    end
    
    %% Fixing data to 0.1 time increments
    
    % Initializing fixed data set and setting a reference time vector
    time = round((broken(1,timecol):0.1:broken(m,timecol)),1);
    if time(1) < broken(1,timecol)
        time = time(2:end);
    end
    fixed = zeros(length(time),n);
    
    % Linear Interpolation for new data points
    for col = 1:n
        if ~isnan(midway(1,col)) && col ~= timecol
            fixed(:,col) = interp1(midway(:,timecol),midway(:,col),time)';
        elseif col == timecol
            fixed(:,col) = time;
        else
            fixed(:,col) = NaN(length(time),1);
        end
    end
    
    %% Edge cases to consider and test/add logic for
    %{
    
    1. Can first and last time entries return index out of bonds exceptions
    when doing closestrow +/- 1
    
    %}
    end