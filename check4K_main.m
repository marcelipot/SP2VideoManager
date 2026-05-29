function [] = check4K_main(varargin);

handles = guidata(gcf);

if handles.refreshPlay == 1;
    axes(handles.playrefresh_main); imshow(handles.icones.play_offb);
    handles.refreshPlay = 0;
    stop([handles.TimerScanFolder handles.TimerUpdatePanning handles.TimerUpdate4K]);
end;
if ispc == 1;
    MDIR = getenv('USERPROFILE');
end;

if get(handles.Video4K_check_main, 'Value') == 1;
    handles.checkbox4K = 1;
    
    set(handles.edittrim4K_main, 'String', num2str(handles.trim4K));
    set(handles.editadd4K_main, 'String', num2str(handles.add4K));
    
    if handles.inputfolder4K == 0;
        set(handles.pathinput4K_main, 'String', '');
    else;
        disppath = handles.inputfolder4K;
        set(handles.pathinput4K_main, 'String', disppath);
        posExtent = get(handles.pathinput4K_main, 'Extent');
        posReal = get(handles.pathinput4K_main, 'Position');
        if posExtent(3) >= posReal(3);
            li = strfind(disppath, '/');
            if isempty(li) == 1;
                
            else;
                if length(li) >= 3;
                    disppath = [disppath(1:li(2)) ' ... ' disppath(li(end):end)];
                else;
                    disppath = disppath(li(end):end);
                end;
            end;
            set(handles.pathinput4K_main, 'String', disppath);
        end;
        set(handles.pathinput4K_main, 'Tooltip', handles.inputfolder4K);
    end;
    
    if handles.outputfolder4K == 0;
        set(handles.pathoutput4K_main, 'String', '');
    else;
        disppath = handles.outputfolder4K;
        set(handles.pathoutput4K_main, 'String', disppath);
        posExtent = get(handles.pathoutput4K_main, 'Extent');
        posReal = get(handles.pathoutput4K_main, 'Position');
        if posExtent(3) >= posReal(3);
            li = strfind(disppath, '/');
            if isempty(li) == 1;
                
            else;
                if length(li) >= 3;
                    disppath = [disppath(1:li(2)) ' ... ' disppath(li(end):end)];
                else;
                    disppath = disppath(li(end):end);
                end;
            end;
            set(handles.pathoutput4K_main, 'String', disppath);
        end;
        set(handles.pathoutput4K_main, 'Tooltip', handles.outputfolder4K);
    end;
    
    try;
        if ismac == 1;
            load /Applications/SP2VideoManager/listVideo4KFiles.mat;
        elseif ispc == 1;
            load([MDIR '\SPEVideoManager\listVideo4KFiles.mat']);
        end;
    catch;
        listVideo4KFiles = [];
    end;
    if isempty(listVideo4KFiles) == 1;
        set(handles.table4K_main, 'Visible', 'off');
    else;
        set(handles.table4K_main, 'Visible', 'on');
    end;
    
    set(handles.Remux4K_check_main, 'enable', 'on', 'value', handles.checkboxRemux4K);
    set(handles.screen4K_button_main, 'enable', 'on');
    set(handles.popCompression4K_main, 'enable', 'on');
    set(handles.removalfisheye_main, 'enable', 'on', 'value', handles.fisheye4K);
    if handles.fisheye4K == 1;
        set(handles.loadfisheye_main, 'enable', 'on', 'value', handles.Currenfisheye4K);
    else;
        set(handles.loadfisheye_main, 'enable', 'off', 'value', handles.Currenfisheye4K);
    end;
    if isempty(get(handles.table4K_main, 'data')) == 0;
        set(handles.table4K_main, 'Visible', 'on');
    end;

else;
    handles.checkbox4K = 0;
    
    set(handles.edittrim4K_main, 'String', '');
    set(handles.editadd4K_main, 'String', '');
    set(handles.pathinput4K_main, 'String', '', 'Tooltip', '');
    set(handles.pathoutput4K_main, 'String', '', 'Tooltip', '');
    set(handles.table4K_main, 'Visible', 'off');
    set(handles.Remux4K_check_main, 'enable', 'off', 'value', 0, 'enable', 'off');
    set(handles.screen4K_button_main, 'enable', 'off', 'enable', 'off');
    set(handles.popCompression4K_main, 'enable', 'off');
    set(handles.removalfisheye_main, 'enable', 'off', 'value', 0, 'enable', 'off');
    if handles.fisheye4K == 1;
        set(handles.loadfisheye_main, 'enable', 'on', 'value', handles.Currenfisheye4K);
    else;
        set(handles.loadfisheye_main, 'enable', 'off', 'value', handles.Currenfisheye4K);
    end;
end;

guidata(handles.hf_w1_welcome, handles);
    
