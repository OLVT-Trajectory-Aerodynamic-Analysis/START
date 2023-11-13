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
    fixed = zeros(1,n);
    time = round((broken(1,timecol):0.1:broken(m,timecol)),1);
    
    c = 1;
    
    for t=broken(1,timecol):0.1:broken(m,timecol)
    
        closest = interp1(midway(:,timecol),midway(:,timecol),t,'nearest');
        closestrow = find(midway(:,timecol) == closest);
    
    
        if closest == time(c) %% Exact time match
            fixed(c,:) = midway(closestrow,:);
    
        elseif closest > time(c) %% Closest reference is past current time
            for a = 1:n
                if isnan(midway(closestrow,a)) || isnan(midway(closestrow-1,a))
                    fixed(c,a) = midway(closestrow,a);
                elseif a == timecol
                    fixed(c,a) = t;
                else
                    fixed(c,a) = midway(closestrow-1,a) + ...
                        (t-midway(closestrow-1,timecol)) ...
                        * (midway(closestrow,a) - midway(closestrow-1,a)) ...
                        / (midway(closestrow,timecol) - midway(closestrow-1,timecol));
                end
            end
    
    
        else %% Closesst Reference is before current time
            for a = 1:n
                if isnan(midway(closestrow,a)) || isnan(midway(closestrow+1,a))
                    fixed(c,a) = midway(closestrow,a);
                elseif a == timecol
                    fixed(c,a) = t;
                else  
                    fixed(c,a) = midway(closestrow,a) + ...
                        (t-midway(closestrow,timecol)) ...
                        * (midway(closestrow+1,a) - midway(closestrow,a)) ...
                        / (midway(closestrow+1,timecol) - midway(closestrow,timecol));
                end
            end
        end
    
        c = c + 1;
    end
    
    %% Edge cases to consider and test/add logic for
    %{
    
    1. Can first and last time entries return index out of bonds exceptions
    when doing closestrow +/- 1
    
    %}
    end