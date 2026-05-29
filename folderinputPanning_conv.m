function [] = folderinputPanning_conv(varargin);


handles = guidata(gcf);


if handles.refreshPlay == 1;
    set(handles.playrefresh_conv, 'units', 'pixels');
    pos = get(handles.playrefresh_conv, 'position');
    set(handles.playrefresh_conv, 'cdata', imresize(handles.icones.play_offb, [pos(3) pos(4)]));
    set(handles.playrefresh_conv, 'units', 'normalized');
    
    handles.refreshPlay = 0;
    stop([handles.TimerScanFolder handles.TimerUpdatePanning handles.TimerUpdatePanning]);
end;

path = uigetdir('Panning videos input folder', handles.defaultpathinputPanning);
pathfold = path;
if path == 0;
    return;
end;

if ispc == 1;
    MDIR = getenv('USERPROFILE');
elseif ismac == 1;
    MDIR = '/Applications';
end;


liOneDrive = strfind(lower(path), 'onedrive');
liDropbox = strfind(lower(path), 'dropbox');
% if ismac == 1;
%     if specialChar_MDIR == 1;
%         testFileInput = ['"' MDIR '/SP2VideoManager/frame720.jpg"'];
%     else;
%         testFileInput = [MDIR '/SP2VideoManager/frame720.jpg'];
%     end;
% elseif ispc == 1;
%     if specialChar_MDIR == 1;
%         testFileInput = ['"' MDIR '\SP2VideoManager\frame720.jpg"'];
%     else;
%         testFileInput = [MDIR '\SP2VideoManager\frame720.jpg'];
%     end;
% end;
% if ismac == 1;
%     if specialChar_path == 1;
%         testFileOutput = ['"' path '/frame720.jpg"'];
%     else;
%         testFileOutput = [path '/frame720.jpg'];
%     end;
% elseif ispc == 1;
%     if specialChar_path == 1;
%         testFileOutput = ['"' path '\frame720.jpg"'];
%     else;
%         testFileOutput = [path '\frame720.jpg'];
%     end;
% end;

if ismac == 1;
    testFileInput = [MDIR '/SP2VideoManager/frame720.jpg'];
elseif ispc == 1;
    testFileInput = [MDIR '\SP2VideoManager\frame720.jpg'];
end;
if ismac == 1;
    testFileOutput = [path '/frame720.jpg'];
elseif ispc == 1;
    testFileOutput = [path '\frame720.jpg'];
end;

if isempty(liOneDrive) == 0;

    if ispc == 1;
        command = ['del /f "' testFileOutput '"'];
    else;
        command = ['rm "' testFileOutput '"'];
    end;
    [status, cmdout] = system(command);

    %test OneDrive
    if ispc == 1;
        command = ['copy "' testFileInput '" "' testFileOutput '"'];
    else;
        command = ['cp "' testFileInput '" "' testFileOutput '"'];
    end;
    [statusOnline, cmdoutOnline] = system(command);

    if statusOnline == 0;
        if ispc == 1;
            command = ['del /f "' testFileOutput '"'];
        else;
            command = ['rm "' testFileOutput '"'];
        end;
        [status, cmdout] = system(command);
    end;
else;
    statusOnline = 0;
end;

if isempty(liDropbox) == 0;
    %test DropBox
    if ispc == 1;
        command = ['del /f "' testFileOutput '"'];
    else;
        command = ['rm "' testFileOutput '"']; 
    end;
    [status, cmdout] = system(command);

    if ispc == 1;
        command = ['copy "' testFileInput '" "' testFileOutput '"'];
    else;
        command = ['cp "' testFileInput '" "' testFileOutput '"'];
    end;
    [statusOnline, cmdoutOnline] = system(command);

    if statusOnline == 0;
        if ispc == 1;
            command = ['del /f "' testFileOutput '"'];
        else;
            command = ['rm "' testFileOutput '"'];
        end;
        [status, cmdout] = system(command);
    end;
else;
    statusOnline = 0;
end;

if statusOnline == 1;
    if ispc == 1;
        errorwindow = errordlg('Permission denied, cannot access this OneDrive/Dropbox folder. Please move your file into a local folder', 'Error');
        jFrame = get(handle(errorwindow), 'javaframe');
        jicon = javax.swing.ImageIcon([MDIR '\SP2VideoManager\SpartaManager_IconSoftware.png']);
        jFrame.setFigureIcon(jicon);
        clc;
        return;
    elseif ismac == 1;
        errordlg('Permission denied, cannot access this OneDrive/Dropbox folder. Please move your file into a local folder', 'Error');
        return;
    end;
end;

handles.defaultpathinputPanning = path;
disppath = path;
set(handles.pathinputPanning_conv, 'String', disppath, 'tooltip', path);
posExtent = get(handles.pathinputPanning_conv, 'Extent');
posReal = get(handles.pathinputPanning_conv, 'Position');
if posExtent(3) >= posReal(3);
    if ispc == 1;
        li = strfind(disppath, '\');
    elseif ismac == 1
        li = strfind(disppath, '/');
    end;
    if isempty(li) == 1;

    else;
        if length(li) >= 3;
            disppath = [disppath(1:li(2)) ' ... ' disppath(li(end):end)];
        else;
            disppath = disppath(li(end):end);
        end;
    end;
end;
set(handles.pathinputPanning_conv, 'String', disppath);
drawnow;

disppath = path;
set(handles.pathinputPanning_conv, 'String', disppath, 'tooltip', path);
posExtent = get(handles.pathinputPanning_conv, 'Extent');
posReal = get(handles.pathinputPanning_conv, 'Position');
if posExtent(3) >= posReal(3);
    if ispc == 1;
        li = strfind(disppath, '\');
    elseif ismac == 1
        li = strfind(disppath, '/');
    end;
    if isempty(li) == 1;

    else;
        if length(li) >= 3;
            disppath = [disppath(1:li(1)) ' ... ' disppath(li(end):end)];
        else;
            disppath = disppath(li(end):end);
        end;
    end;
end;
set(handles.pathinputPanning_conv, 'String', disppath);

handles.inputfolderPanning = path;

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

if pathfold ~= 0;
    handles.InputPanningLocation = 'Disk';
    countprocessTXT = ['Processing   :   ...'];
    set(handles.fileprocess_conv, 'String', countprocessTXT);
end;

guidata(handles.hf_w1_welcome, handles);

