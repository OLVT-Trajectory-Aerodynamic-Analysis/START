% This function is in charge of creating a source data type. This allows
% data to be passed easily between functions. The function also adds the
% source to the list of sources already inputted previously

% Contributors
% @author Michael Plano
% @created 09/25/2023
%

% @param filepath is the location of the data on your local machine
% @param dataType tells the system what kind of data it is. The options are
%   currently either "simulatedData" or "rawData"
% @param sourceType is the type of format the data is in, this most likely
%   depends on where the source was recived from. The options are "EZMini",
%   "Telemetrum", "AIM", "RASAeroII", "ASTOS"
% @param sourceList is a list of sources that the current source needs to
%   be added to
% @returns source is the new source datatype in struct form
% @returns sourceList which is the list of sources with the current source
%   added to it
%

function [source, sourceList] = createSourceObject(filepath, dataType, sourceTitle, sourceList)
    source = struct;

    %Add checks here to all of these things

    % Is stringm is valid filepath
    source.filepath = filepath;

    % Is String, Is it either rawData or simulatedData
    source.dataType = dataType;

    % Is String, Is it an acceptable type?
    source.sourceTitle = sourceTitle;

    sourceList = [sourceList, source];
end