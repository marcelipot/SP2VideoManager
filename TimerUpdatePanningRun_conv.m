function [] = TimerUpdatePanningRun_conv(varargin);

 
handles = guidata(gcf);
if ispc == 1;
    MDIR = getenv('USERPROFILE');
elseif ismac == 1;
    MDIR = '/Applications';
end;


if strcmpi(handles.InputPanningLocation, 'NAS') == 1;
    if ispc == 1;
        
        listDir = dir(handles.inputfolderPanning);
        if isempty(listDir) == 1;
            
            set(handles.txtupdate_conv, 'String', 'Trying to connect');
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
end;

if ismac == 1;
    videoinputfolder = handles.inputfolderPanning;
elseif ispc == 1;
    videoinputfolder = handles.inputfolderPanning;
end;


if strcmpi(handles.OutputPanningLocation, 'NAS') == 1;
    if ispc == 1;
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
end;

if ismac == 1;
    videooutputfolder = handles.outputfolderPanning;
elseif ispc == 1;
    videooutputfolder = handles.outputfolderPanning;
end;

checkSpecialChar;

%delete Temp folder
if ismac == 1
    ffmpegfolder = [MDIR '/SP2VideoManager/ffmpeg/bin/ffmpeg'];
    if specialChar_MDIR == 1;
        ffmpegfolder = ['"' ffmpegfolder '"'];
    end;
elseif ispc == 1;
    ffmpegfolder = [MDIR '\SP2VideoManager\ffmpeg\bin\ffmpeg'];
    if specialChar_MDIR == 1;
        ffmpegfolder = ['"' ffmpegfolder '"'];
    end;
end;

if ismac == 1;
    tempfolder = [MDIR '/SP2VideoManager/Temp/'];
    if specialChar_MDIR == 1;
        command = ['rm "' MDIR '/SP2VideoManager/Temp/*"'];
    else;
        command = ['rm ' MDIR '/SP2VideoManager/Temp/*'];
    end;
    [status, cmdout] = system(command);

    load([MDIR '/SP2VideoManager/listVideoPanningFiles.mat']);

elseif ispc == 1;
    tempfolder = [MDIR '\SP2VideoManager\Temp\'];
    if specialChar_MDIR == 1;
        command = ['del /Q "' tempfolder '*"'];
    else;
        command = ['del /Q ' tempfolder '*'];
    end;
    [status, cmdout] = system(command);

    load([MDIR '\SP2VideoManager\listVideoPanningFiles.mat']);
end;        

if isempty(listVideoPanningFiles) == 1;
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
else;
    iterfile = 0;

    iswaiting = 0;
    file2process = [];
    for i = 1:length(listVideoPanningFiles(:,1));
        %find first video to process
        fileStatus = listVideoPanningFiles{i,2};
        if iswaiting == 0;
            if strcmpi(fileStatus, 'Waiting') == 1;
                file2process = i;
                iswaiting = 1;
            end;
        end;
    end;
    
    if iswaiting == 1;
        fileEC = listVideoPanningFiles{file2process,1};
        fileStatus = listVideoPanningFiles{file2process,2};
        if strcmpi(fileStatus, 'Waiting') == 1;
            %process the file
            %Check first if the file still exists
            fileprocess = listVideoPanningFiles{file2process,1};
            listDir = dir(handles.inputfolderPanning);
            fileExist = 0;
            for carac = 1:length(listDir);
                fileCheck = listDir(carac);
                NameEC = fileCheck.name;
                
                if strcmpi(NameEC, fileprocess) == 1;
                    fileExist = 1;
                end;
            end;
            if fileExist == 0;
                listVideoPanningFiles{file2process,2} = 'Deleted';
                
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
                set(handles.tablePanning_conv, 'data', listVideoPanningFilesDisp(1:end-1,:));
                drawnow;

                if ismac == 1;
                    save([MDIR '/SP2VideoManager/listVideoPanningFiles.mat'], 'listVideoPanningFiles');
                elseif ispc == 1;
                    save([MDIR '\SP2VideoManager\listVideoPanningFiles.mat'], 'listVideoPanningFiles');
                end;
            else;
                iterfile = iterfile + 1;
                
                totfile = get(handles.fileprocess_conv, 'String');
                li1 = strfind(totfile, '/');
                li2 = strfind(totfile, ':');
                totfile = totfile(li1+2:li2-3);
                countprocessTXT = ['Processing   :   ' listVideoPanningFiles{file2process,1}];
                set(handles.fileprocess_conv, 'String', countprocessTXT);
                
                listVideoPanningFiles{file2process,2} = 'Processing';
                
                if ismac == 1;
                    save('/Applications/SP2VideoManager/listVideoPanningFiles.mat', 'listVideoPanningFiles');
                elseif ispc == 1;
                    save([MDIR '\SP2VideoManager\listVideoPanningFiles.mat'], 'listVideoPanningFiles');
                end;

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

                bitrate = [num2str(handles.CurrenCompressionPanning) 'M'];
                maxrate = bitrate;
                bufrate = [num2str(floor((handles.CurrenCompressionPanning)./3)) 'M'];
                   
                if ismac == 1;
                    fileECNew = fileEC;
                elseif ispc == 1;
                    fileECNew = fileEC;
                end;
                lidot = strfind(fileECNew, '.');
                lidot = lidot(end);
                fileOut = [fileECNew(1:lidot-1) '_copy' fileECNew(lidot:end)];

                %%%%
                checkSpecialChar;
                
                fileoutExist = 0;
                listdir = dir(handles.outputfolderPanning);
                for filelist = 1:length(listdir);
                    fileCheck = listdir(filelist);
                    NameEC = fileCheck.name;
                    if strcmpi(NameEC, fileOut) == 1;
                        fileoutExist = 1;
                    end;
                end;
                
                if ismac == 1;
                    if fileoutExist == 1;
                        if specialChar_outputfolder == 1 | specialChar_fileOut == 1;
                            command = ['rm ' videooutputfolder '/' fileOut];
                        else;
                            command = ['rm "' videooutputfolder '/' fileOut '"'];
                        end;
                        [status, cmdout] = system(command);
                    end;
                elseif ispc == 1;
                    if fileoutExist == 1;
                        if specialChar_outputfolder == 1 | specialChar_fileOut == 1;
                            command = ['del /Q "' videooutputfolder '\' fileOut '"'];
                        else;
                            command = ['del /Q ' videooutputfolder '\' fileOut];
                        end;
                        [status, cmdout] = system(command);
                    end;
                end;

                if handles.trimPanning == 0 & handles.addPanning == 0;
                    %copy video
                    copy_Panning_conv;

                elseif handles.trimPanning == 0 & handles.addPanning ~= 0;
                    %Add frames
                    add_Panning_conv;

                elseif handles.trimPanning ~= 0 & handles.addPanning == 0;
                    %Trim frame
                    trim_Panning_conv;
                end;

                if status == 0;
                    listVideoPanningFiles{file2process,2} = 'Done';

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

                    drawnow limitrate;
                    if ismac == 1;
                        save('/Applications/SP2VideoManager/listVideoPanningFiles.mat', 'listVideoPanningFiles');
                    elseif ispc == 1;
                        save([MDIR '\SP2VideoManager\listVideoPanningFiles.mat'], 'listVideoPanningFiles');
                    end;

                else;

                    %clear temp
                    if ismac == 1;
                        if specialChar_MDIR == 1;
                            command = ['rm "' MDIR '/SP2VideoManager/Temp/"*'];
                        else;
                            command = ['rm ' MDIR '/SP2VideoManager/Temp/*'];
                        end;
                        [status, cmdout] = system(command);

                    elseif ispc == 1;
                        if specialChar_MDIR == 1;
                            command = ['del /Q "' MDIR '\SP2VideoManager\Temp\"*'];
                        else;
                            command = ['del /Q ' MDIR '\SP2VideoManager\Temp\*'];
                        end;
                        [status, cmdout] = system(command);
                    end;
                    
                    listVideoPanningFiles{file2process,2} = 'Waiting';
                    
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

                    if strcmpi(handles.InputPanningLocation, 'NAS') == 1;
                        if ispc == 1;
                            MDIR = getenv('USERPROFILE');
                            if isdir(handles.inputfolderPanning) == 0;
                                status = 1;

                                set(handles.txtupdate_conv, 'String', 'Trying to connect');
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
                                    if isdir(handles.inputfolderPanning) == 1;
                                        proceed = 0;
                                    end;
                                end;
                            end;

                        elseif ismac == 1;
                            if isdir(handles.inputfolderPanning) == 0;
                                status = 1;
                                
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
                                    if isdir(handles.inputfolderPanning) == 1;
                                        proceed = 0;
                                    end;
                                end;
                            end;
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
                    end;
                    if status == 0;
                        if handles.trimPanning == 0 & handles.addPanning == 0;
                            %copy video
                            copy_Panning_conv;

                        elseif handles.trimPanning == 0 & handles.addPanning ~= 0;
                            %Add frames
                            add_Panning_conv;

                        elseif handles.trimPanning ~= 0 & handles.addPanning == 0;
                            %Trim frame
                            trim_Panning_conv;
                        end;
                        
                        listVideoPanningFiles{file2process,2} = 'Done';

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

                        if ismac == 1;
                            save('/Applications/SP2VideoManager/listVideoPanningFiles.mat', 'listVideoPanningFiles');
                        elseif ispc == 1;
                            save([MDIR '\SP2VideoManager\listVideoPanningFiles.mat'], 'listVideoPanningFiles');
                        end;

                    else;
                        drawnow limitrate;
                        if ismac == 1;
                            save('/Applications/SP2VideoManager/listVideoPanningFiles.mat', 'listVideoPanningFiles');
                        elseif ispc == 1;
                            save([MDIR '\SP2VideoManager\listVideoPanningFiles.mat'], 'listVideoPanningFiles');
                        end;
                    end;
                end;
            end;
        end;
    end;
    
    totfile = get(handles.fileprocess_conv, 'String');
    li1 = strfind(totfile, '/');
    li2 = strfind(totfile, ':');
    totfile = totfile(li1+2:li2-3);
    countprocessTXT = ['Processing   :   ...'];
    set(handles.fileprocess_conv, 'String', countprocessTXT);
    
end;


