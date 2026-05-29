function [] = playrefresh_conv(varargin);



handles = guidata(gcf);

if ispc == 1;
    MDIR = getenv('USERPROFILE');
end;

if handles.refreshPlay == 0;
    %Start timers: Display Pause;
    set(handles.playrefresh_conv, 'units', 'pixels');
    pos = get(handles.playrefresh_conv, 'position');
    set(handles.playrefresh_conv, 'cdata', imresize(handles.icones.pause_offb, [pos(3) pos(4)]));
    set(handles.playrefresh_conv, 'units', 'normalized');
    
    %Do checks
    if handles.inputfolderPanning == 0;
        
        set(handles.playrefresh_conv, 'units', 'pixels');
        pos = get(handles.playrefresh_conv, 'position');
        set(handles.playrefresh_conv, 'cdata', imresize(handles.icones.play_offb, [pos(3) pos(4)]));
        set(handles.playrefresh_conv, 'units', 'normalized');

        errorwindow = errordlg('Select an input folder', 'Error');
        if ispc == 1;
            jFrame = get(handle(errorwindow), 'javaframe');
            jicon = javax.swing.ImageIcon([MDIR '\SP2VideoManager\SpartaManager_IconSoftware.png']);
            jFrame.setFigureIcon(jicon);
            clc;
        end;
        return;
    else;

        %check the folder exist
        if isdir(handles.inputfolderPanning) == 0;
            set(handles.playrefresh_conv, 'units', 'pixels');
            pos = get(handles.playrefresh_conv, 'position');
            set(handles.playrefresh_conv, 'cdata', imresize(handles.icones.play_offb, [pos(3) pos(4)]));
            set(handles.playrefresh_conv, 'units', 'normalized');

            errorwindow = errordlg('Panning videos input folder deleted', 'Error');
            if ispc == 1;
                jFrame = get(handle(errorwindow), 'javaframe');
                jicon = javax.swing.ImageIcon([MDIR '\SP2VideoManager\SpartaManager_IconSoftware.png']);
                jFrame.setFigureIcon(jicon);
                clc;
            end;
            return;
        end;
    end;
    
    if handles.outputfolderPanning == 0;
        set(handles.playrefresh_conv, 'units', 'pixels');
        pos = get(handles.playrefresh_conv, 'position');
        set(handles.playrefresh_conv, 'cdata', imresize(handles.icones.play_offb, [pos(3) pos(4)]));
        set(handles.playrefresh_conv, 'units', 'normalized');

        errorwindow = errordlg('Select an output folder', 'Error');
        if ispc == 1;
            jFrame = get(handle(errorwindow), 'javaframe');
            jicon = javax.swing.ImageIcon([MDIR '\SP2VideoManager\SpartaManager_IconSoftware.png']);
            jFrame.setFigureIcon(jicon);
            clc;
        end;
        return;
    else;
        %check the folder exist
        if isdir(handles.outputfolderPanning) == 0;
            set(handles.playrefresh_conv, 'units', 'pixels');
            pos = get(handles.playrefresh_conv, 'position');
            set(handles.playrefresh_conv, 'cdata', imresize(handles.icones.play_offb, [pos(3) pos(4)]));
            set(handles.playrefresh_conv, 'units', 'normalized');

            errorwindow = errordlg('Panning videos output folder deleted', 'Error');
            if ispc == 1;
                jFrame = get(handle(errorwindow), 'javaframe');
                jicon = javax.swing.ImageIcon([MDIR '\SP2VideoManager\SpartaManager_IconSoftware.png']);
                jFrame.setFigureIcon(jicon);
                clc;
            end;
            return;
        end;
    end;
    handles.refreshPlay = 1;
    

    %clear folder
    if ismac == 1;
        if isdir('/Applications/SP2VideoManager/Temp') == 0;
            command = ['mkdir /Applications/SP2VideoManager/Temp'];
            [status, cmdout] = system(command);
        end;
        command = ['rm /Applications/SP2VideoManager/Temp/*'];
        [status, cmdout] = system(command);
        
    elseif ispc == 1;
        if isdir([MDIR '\SP2VideoManager\Temp']) == 0;
            command = ['mkdir ' MDIR '\SP2VideoManager\Temp'];
            [status, cmdout] = system(command);
        end;
        command = ['del /Q ' MDIR '\SP2VideoManager\Temp\*'];
        [status, cmdout] = system(command);
    end;
    
    handles.TimerScanFolder = timer('TimerFcn', @TimerScanFolderRun_conv, 'StartDelay', 0, 'Period', handles.refreshTime, 'Name', 'TimerScan', ...
        'ExecutionMode', 'fixedRate', 'BusyMode', 'drop', 'StopFcn', @TimerScanFolderStop_conv);
    
    handles.TimerUpdatePanning = timer('TimerFcn', @TimerUpdatePanningRun_conv, 'StartDelay', 5, 'Period', handles.refreshTime, 'Name', 'TimerPanning', ...
        'ExecutionMode', 'fixedRate', 'BusyMode', 'drop', 'StopFcn', @TimerUpdatePanningStop_conv);
        
    guidata(handles.hf_w1_welcome, handles);
    start([handles.TimerScanFolder handles.TimerUpdatePanning]);
    
else;
    %Pause timers: Display Play;
    set(handles.playrefresh_conv, 'units', 'pixels');
    pos = get(handles.playrefresh_conv, 'position');
    set(handles.playrefresh_conv, 'cdata', imresize(handles.icones.play_offb, [pos(3) pos(4)]));
    set(handles.playrefresh_conv, 'units', 'normalized');

    handles.refreshPlay = 0;
    stop([handles.TimerScanFolder handles.TimerUpdatePanning]);
end;



guidata(handles.hf_w1_welcome, handles);

