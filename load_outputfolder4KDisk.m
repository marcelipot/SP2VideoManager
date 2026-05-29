if handles.refreshPlay == 1;
    axes(handles.playrefresh_main); imshow(handles.icones.play_offb);
    handles.refreshPlay = 0;
    stop([handles.TimerScanFolder handles.TimerUpdatePanning handles.TimerUpdate4K]);
end;

path = uigetdir('4K videos unput folder', handles.defaultpathoutput4K);
pathfold = path;
if path == 0;
    return;
end;
handles.defaultpathoutput4K = path;

disppath = path;
set(handles.pathoutput4K_main, 'String', disppath, 'tooltip', path);
posExtent = get(handles.pathoutput4K_main, 'Extent');
posReal = get(handles.pathoutput4K_main, 'Position');
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
set(handles.pathoutput4K_main, 'String', disppath);
drawnow;

disppath = path;
set(handles.pathoutput4K_main, 'String', disppath, 'tooltip', path);
posExtent = get(handles.pathoutput4K_main, 'Extent');
posReal = get(handles.pathoutput4K_main, 'Position');
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
    set(handles.pathoutput4K_main, 'String', disppath);
end;

handles.outputfolder4K = path;

countprocess = 0;
if ischar(handles.inputfolder4K) == 1 & ischar(handles.outputfolder4K) == 1;
    listDir = dir(handles.inputfolder4K);
    listDir = dir(handles.inputfolder4K);
    listDir = listDir(~[listDir.isdir]);
    [~,idx] = sort([listDir.datenum]);
    listDir = listDir(idx);
    
    listVideo4KFiles = {};
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
            listVideo4KFiles{iter,1} = fileEC.name;
            iter = iter + 1;
        end;
    end;

    listDir = dir(handles.outputfolder4K);
    listProcessed4K = {};
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
            listProcessed4K{iter,1} = fileECNew;
            iter = iter + 1;
        end;
    end;
    handles.Processed4K = listProcessed4K;

    if isempty(listVideo4KFiles) == 0;
        if isempty(handles.Processed4K) == 0;
            for i = 1:length(listVideo4KFiles);

                fileOut = listVideo4KFiles{i,1};
                proceed = 1;
                while proceed == 1;
                    lispecial = strfind(fileOut, '-');
                    if isempty(lispecial) == 0;
                        fileOut2 = [fileOut(1:lispecial(1)-1) fileOut(lispecial(1)+1:end)];
                    else;
                        proceed = 0;
                        fileOut2 = fileOut;
                    end;
                    fileOut = fileOut2;
                end;

                proceed = 1;
                fileOutORI = fileOut;
                while proceed == 1;
                    lispecial = strfind(fileOut, ['''']);;
                    if isempty(lispecial) == 0;
                        fileOut2 = [fileOut(1:lispecial(1)-1) fileOut(lispecial(1)+1:end)];
                    else;
                        proceed = 0;
                        fileOut2 = fileOut;
                    end;
                    fileOut = fileOut2;
                end;

                if isempty(find(strcmpi(handles.Processed4K, fileOut) == 1)) == 0;
                    listVideo4KFiles{i,2} = 'Done';
                else;
                    listVideo4KFilesOLD = handles.listVideo4KFiles;
                    litarget = find(strcmpi(listVideo4KFilesOLD, fileOut) == 1);
                    if isempty(litarget) == 0;
                        litarget = litarget(1);
                        if strcmpi(listVideo4KFilesOLD{litarget,2}, 'Processing');
                            listVideo4KFiles{i,2} = 'Processing';
                        else;
                            listVideo4KFiles{i,2} = 'Waiting';
                        end;
                    else;
                        listVideo4KFiles{i,2} = 'Waiting';
                    end;
                end;
            end;
        else;
            for i = 1:length(listVideo4KFiles);
                listVideo4KFiles{i,2} = 'Waiting';
            end;
        end;

        set(handles.table4K_main, 'data', listVideo4KFiles);
        table_extent = get(handles.table4K_main, 'Extent');
        table_position = get(handles.table4K_main, 'Position');
        posLeft = table_position(1);
        posBottom = table_position(2)+table_position(4)-table_extent(4);
        posWidth = table_extent(3);
        posHeight = table_extent(4);

        set(gcf, 'units', 'pixels');
        posFig = get(gcf, 'position');
        set(gcf, 'units', 'normalized');

        if posBottom < (75./posFig(4));
            posBottom = (75./posFig(4));
            posHeight = table_position(4);

            posTopMax = get(handles.testPanning_button_main, 'position');
            posTopMax = posTopMax(2) - (10./posFig(4));
            posHeight = posTopMax - posBottom;
        end;               
        set(handles.table4K_main, 'Visible', 'on', 'Position', [posLeft posBottom posWidth posHeight]);

        countprocess = 0;
        for i = 1:length(listVideo4KFiles(:,2));
            if strcmpi(listVideo4KFiles{i,2}, 'Waiting');
                countprocess = countprocess + 1;
            end;
        end;
        
    else;
        countprocess = 0;
        dummy{1,1} = 'No Video available';
        dummy{1,2} = '';
        set(handles.table4K_main, 'data', dummy);
        table_extent = get(handles.table4K_main, 'Extent');
        table_position = get(handles.table4K_main, 'Position');
        set(handles.table4K_main, 'Visible', 'on', 'Position', [table_position(1) table_position(2)+table_position(4)-table_extent(4) table_extent(3) table_extent(4)]);
    end;

    drawnow;
    if ismac == 1;
        save('/Applications/SP2VideoManager/listVideo4KFiles.mat', 'listVideo4KFiles');
    elseif ispc == 1;
        save([MDIR '\SP2VideoManager\listVideo4KFiles.mat'], 'listVideo4KFiles');
    end;
end;