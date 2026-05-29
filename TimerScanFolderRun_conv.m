function [] = TimerScanFolderRun_conv(varargin);


handles = guidata(gcf);
if ispc == 1;
    MDIR = getenv('USERPROFILE');
end;


if strcmpi(handles.InputPanningLocation, 'NAS') == 1;
    if ispc == 1;
        MDIR = getenv('USERPROFILE');
        
        listDir = dir(handles.inputfolderPanning);
        if isempty(listDir) == 1;
            set(handles.txtupdate_conv, 'String', 'Trying to connect');
            drawnow;
            load([MDIR '\SP2VideoManager\IPList.mat']);
            for i = 1:length(IPlist(:,1));
                if str2num(IPlist{i,5}) == 1;
                    IPaddress = IPlist{i,1};
                    volume = IPlist{i,2};
                    username = IPlist{i,3};
                    password = IPlist{i,4};
                end;
            end;
                
            proceed = 1;
            while proceed == 1;
                command = ['net use * \\' IPaddress '\' volume ' /u:' username ' ' password];
                [status, out] = system(command);
                
                listDir = dir(handles.inputfolderPanning);
                if isempty(listDir) == 0;
                    proceed = 0;
                end;
            end;
        end;

    elseif ismac == 1;
        
        listDir = dir(handles.inputfolderPanning);
        if isempty(listDir) == 1;
            command = 'umount /Applications/SP2VideoManager/Mount';
            [a, b] = system(command);
            
            set(handles.txtupdate_conv, 'String', 'Trying to connect');
            drawnow;
            load /Applications/SP2VideoManager/IPList.mat;
            for i = 1:length(IPlist(:,1));
                if str2num(IPlist{i,5}) == 1;
                    IPaddress = IPlist{i,1};
                    volume = IPlist{i,2};
                    username = IPlist{i,3};
                    password = IPlist{i,4};
                end;
            end;
            
            proceed = 1;
            while proceed == 1;
                command = ['mount_smbfs //' password ':' username '@' IPaddress '/' volume ' /Applications/SP2VideoManager/Mount'];
                [status, out] = system(command);
                
                listDir = dir(handles.inputfolderPanning);
                if isempty(listDir) == 0;
                    proceed = 0;
                end;
            end;
        end;
    end;
else;
    listDir = dir(handles.inputfolderPanning);
end;
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

if strcmpi(handles.OutputPanningLocation, 'NAS') == 1;
    if ispc == 1;
        MDIR = getenv('USERPROFILE');
        listDir = dir(handles.outputfolderPanning);
        if isempty(listDir) == 1;
            
            set(handles.txtupdate_conv, 'String', 'Trying to connect');
            drawnow;
            load([MDIR '\SP2VideoManager\IPList.mat']);
            for i = 1:length(IPlist(:,1));
                if str2num(IPlist{i,5}) == 1;
                    IPaddress = IPlist{i,1};
                    volume = IPlist{i,2};
                    username = IPlist{i,3};
                    password = IPlist{i,4};
                end;
            end;
            
            proceed = 1;
            while proceed == 1;
                command = ['net use * \\' IPaddress '\' volume ' /u:' username ' ' password];
                [status, out] = system(command);
                
                listDir = dir(handles.outputfolderPanning);
                if isempty(listDir) == 0;
                    proceed = 0;
                end;
            end;
        end;
        
    elseif ismac == 1;
        
        listDir = dir(handles.outputfolderPanning);
        if isempty(listDir) == 1;
            command = 'umount /Applications/SP2VideoManager/Mount';
            [a, b] = system(command);
        
            set(handles.txtupdate_conv, 'String', 'Trying to connect');
            drawnow;
            load /Applications/SP2VideoManager/IPList.mat;
            for i = 1:length(IPlist(:,1));
                if str2num(IPlist{i,5}) == 1;
                    IPaddress = IPlist{i,1};
                    volume = IPlist{i,2};
                    username = IPlist{i,3};
                    password = IPlist{i,4};
                end;
            end;
            
            proceed = 1;
            while proceed == 1;
                command = ['mount_smbfs //' password ':' username '@' IPaddress '/' volume ' /Applications/SP2VideoManager/Mount'];
                [status, out] = system(command);
                listDir = dir(handles.outputfolderPanning);
                
                if isempty(listDir) == 0;
                    proceed = 0;
                end;
            end;
        end;
    end;
else;
    listDir = dir(handles.outputfolderPanning);
end;


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
        for i = 1:length(listVideoPanningFiles(:,1));
            
            if isempty(find(strcmpi(handles.ProcessedPanning, listVideoPanningFiles{i,1}) == 1)) == 0;
                listVideoPanningFiles{i,2} = 'Done';
            else;
                listVideoPanningFilesOLD = handles.listVideoPanningFiles;
                fileOut = listVideoPanningFiles{i,1};
                
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
                    lispecial = strfind(fileOut, ['''']);
                    if isempty(lispecial) == 0;
                        fileOut2 = [fileOut(1:lispecial(1)-1) fileOut(lispecial(1)+1:end)];
                    else;
                        proceed = 0;
                        fileOut2 = fileOut;
                    end;
                    fileOut = fileOut2;
                end;
                
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
        for i = 1:length(listVideoPanningFiles(:,1));
            listVideoPanningFiles{i,2} = 'Waiting';
        end;
    end;

    set(handles.tablePanning_conv, 'data', listVideoPanningFiles);
    if isempty(listVideoPanningFiles) == 0;
        listVideoPanningFilesDisp = listVideoPanningFiles;
    
        set(handles.tablePanning_conv, 'data', listVideoPanningFilesDisp);
        table_extent = get(handles.tablePanning_conv, 'Extent');
        table_position = get(handles.tablePanning_conv, 'Position');
        while table_extent(4) < table_position(4);
            %up/down scroll bar
            listVideoPanningFilesDisp{end+1, 1} = [];
            set(handles.tablePanning_conv, 'data', listVideoPanningFilesDisp);
            drawnow;
        
            table_extent = get(handles.tablePanning_conv, 'Extent');
            table_position = get(handles.tablePanning_conv, 'Position');
        end;
        
        set(handles.tablePanning_conv, 'visible', 'on', 'data', listVideoPanningFilesDisp(1:end-1,:));
        drawnow;
    end;

    countprocess = 0;
    for i = 1:length(listVideoPanningFiles(:,2));
        if strcmpi(listVideoPanningFiles{i,2}, 'Waiting');
            countprocess = countprocess + 1;
        end;
    end;
    countprocessTXT = ['Processing   :   ...'];
    set(handles.fileprocess_conv, 'String', countprocessTXT);
    
else;
    countprocess = 0;
    dummy{1,1} = 'No Video available';
    dummy{1,2} = '';
    set(handles.tablePanning_conv, 'data', dummy);
    
    table_extent = get(handles.tablePanning_conv, 'Extent');
    table_position = get(handles.tablePanning_conv, 'Position');
    while table_extent(4) < table_position(4);
        %up/down scroll bar
        dummy{end+1, 1} = [];
        set(handles.tablePanning_conv, 'data', dummy);
        drawnow;
        
        table_extent = get(handles.tablePanning_conv, 'Extent');
        table_position = get(handles.tablePanning_conv, 'Position');
    end;
    set(handles.tablePanning_conv, 'visible', 'on', 'data', dummy(1:end-1,:));
    drawnow;
end;


drawnow;
if ismac == 1;
    save('/Applications/SP2VideoManager/listVideoPanningFiles.mat', 'listVideoPanningFiles');
elseif ispc == 1;
    save([MDIR '\SP2VideoManager\listVideoPanningFiles.mat'], 'listVideoPanningFiles');
end;
 

%add time function
currentTime = datetime('now');
currentTime = char(currentTime + seconds(handles.refreshTime));
li = strfind(currentTime, ' ');
currentTime = currentTime(li+1:end);
li = strfind(currentTime, ':');
currentTime = ['Next update at :    ' currentTime(1:li(1)-1) ' : ' currentTime(li(1)+1:li(2)-1) ' : ' currentTime(li(2)+1:end)];
set(handles.txtupdate_conv, 'String', currentTime);
