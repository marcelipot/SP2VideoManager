function [] = refresh4Kbatch_conv(varargin);


handles = guidata(gcf);

if ispc == 1;
    MDIR = getenv('USERPROFILE');
elseif ismac == 1;
    MDIR = '/Applications';
end;

countprocess = 0;
if ischar(handles.inputfolderPanning) == 1 & ischar(handles.outputfolderPanning) == 1;

    listDir = dir(handles.inputfolderPanning);
    listDir = listDir(~[listDir.isdir]);
    [~,idx] = sort([listDir.datenum]);
    listDir = listDir(idx);
    
    listVideoPanningFiles = {};
    iter = 1;
    for i = 1:length(listDir);
        fileEC = listDir(i);
        lidot = findstr(fileEC.name, '.');
        if isempty(lidot) == 1;
            fileECext = 'None';
        else;
            fileECext = fileEC.name(lidot(end):end);
        end;
        if strcmpi(fileECext, '.mp4') == 1 | strcmpi(fileECext, '.MP4') == 1 | strcmpi(fileECext, '.MXF') == 1;
            listVideoPanningFiles{iter,1} = fileEC.name;
            iter = iter + 1;
        end;
    end;

    listDir = dir(handles.outputfolderPanning);
    listProcessedPanning = {};
    iter = 1;
    for i = 1:length(listDir);
        fileEC = listDir(i);
        lidot = findstr(fileEC.name, '.');
        if isempty(lidot) == 1;
            fileECext = 'None';
        else;
            fileECext = fileEC.name(lidot(end):end);
        end;

        if strcmpi(fileECext, '.mp4') == 1 | strcmpi(fileECext, '.MP4') == 1 | strcmpi(fileECext, '.MXF') == 1;
            fileEC = fileEC.name;
            lidot = strfind(fileEC, '_copy');
            if isempty(lidot) == 0;
                lidot = lidot(end);
                fileECNew = [fileEC(1:lidot-1) fileEC(lidot+5:end)];
            else;
                fileECNew = fileEC;
            end;
            listProcessedPanning{iter,1} = fileECNew;
            iter = iter + 1;
        end;
    end;
    handles.ProcessedPanning = listProcessedPanning;

    if isempty(listVideoPanningFiles) == 0;
        if isempty(handles.ProcessedPanning) == 0;
            for i = 1:length(listVideoPanningFiles);

                fileOut = listVideoPanningFiles{i,1};
                if isempty(find(strcmpi(handles.ProcessedPanning, fileOut) == 1)) == 0;
                    listVideoPanningFiles{i,2} = 'Done';
                else;
                    listVideoPanningFilesOLD = handles.listVideoPanningFiles;
                    litarget = find(strcmpi(listVideoPanningFilesOLD, fileOut) == 1);
                    if isempty(litarget) == 0;
                        litarget = litarget(1);
                        if strcmpi(listVideoPanningFilesOLD{litarget,2}, 'Processing');
                            listVideoPanningFiles{i,2} = 'Processing';
                        else;
                            listVideoPanningFiles{i,2} = 'Waiting';
                        end;
                    else;
                        listVideoPanningFiles{i,2} = 'Waiting';
                    end;
                end;
            end;
        else;
            for i = 1:length(listVideoPanningFiles);
                listVideoPanningFiles{i,2} = 'Waiting';
            end;
        end;

        set(handles.tablePanning_conv, 'data', listVideoPanningFiles);
        if isempty(listVideoPanningFiles) == 0;
            listVideoPanningFilesDisp = listVideoPanningFiles;
            table_extent = get(handles.tablePanning_conv, 'Extent');
            table_position = get(handles.tablePanning_conv, 'Position');
            if table_extent(4) > table_position(4) == 1;
                %Increasing size
                while table_extent(4) > table_position(4);
                    table_position(2) = table_position(2) - 0.01;
                    table_position(4) = table_position(4) + 0.01;
                end;
                table_position(2) = table_position(2) - 0.01;
                table_position(4) = table_position(4) + 0.01;
                set(handles.tablePanning_conv, 'Position', table_position);
                drawnow;
            elseif table_extent(4) < table_position(4);
                %Decreasing size
                while table_extent(4) < table_position(4);
                    table_position(2) = table_position(2) + 0.01;
                    table_position(4) = table_position(4) - 0.01;
                end;
                table_position(2) = table_position(2) - 0.01;
                table_position(4) = table_position(4) + 0.01;
                set(handles.tablePanning_conv, 'Position', table_position);
                drawnow;
            end;
        end;

        countprocess = 0;
        for i = 1:length(listVideoPanningFiles(:,2));
            if strcmpi(listVideoPanningFiles{i,2}, 'Waiting');
                countprocess = countprocess + 1;
            end;
        end;
    else;
        countprocess = 0;
        dummy{1,1} = 'No Video available';
        dummy{1,2} = '';
        set(handles.tablePanning_conv, 'data', dummy);
        
        table_extent = get(handles.tablePanning_conv, 'Extent');
        table_position = get(handles.tablePanning_conv, 'Position');
        if table_extent(4) > table_position(4) == 1;
            %Increasing size
            while table_extent(4) > table_position(4);
                table_position(2) = table_position(2) - 0.01;
                table_position(4) = table_position(4) + 0.01;
            end;
            table_position(2) = table_position(2) - 0.01;
            table_position(4) = table_position(4) + 0.01;
            set(handles.tablePanning_conv, 'Position', table_position);
            drawnow;
        elseif table_extent(4) < table_position(4);
            %Decreasing size
            while table_extent(4) < table_position(4);
                table_position(2) = table_position(2) + 0.01;
                table_position(4) = table_position(4) - 0.01;
            end;
            table_position(2) = table_position(2) - 0.01;
            table_position(4) = table_position(4) + 0.01;
            set(handles.tablePanning_conv, 'Position', table_position);
            drawnow;
        end;
    end;

    drawnow;
    if ismac == 1;
        save('/Applications/SP2VideoManager/listVideoPanningFiles.mat', 'listVideoPanningFiles');
    elseif ispc == 1;
        save([MDIR '\SP2VideoManager\listVideoPanningFiles.mat'], 'listVideoPanningFiles');
    end;
end;

% if pathfold ~= 0;
%     handles.InputPanningLocation = 'Disk';
%     countprocessTXT = ['Processing   :   ...'];
%     set(handles.fileprocess_conv, 'String', countprocessTXT);
% end;


guidata(handles.hf_w1_welcome, handles);



