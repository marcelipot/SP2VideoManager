function [] = checkPanning_main(varargin);

handles = guidata(gcf);

if handles.refreshPlay == 1;
    axes(handles.playrefresh_main); imshow(handles.icones.play_offb);
    handles.refreshPlay = 0;
    stop([handles.TimerScanFolder handles.TimerUpdatePanning handles.TimerUpdate4K]);
end;
if ispc == 1;
    MDIR = getenv('USERPROFILE');
end;

if get(handles.PanningVideo_check_main, 'Value') == 1;
    handles.checkboxPanning = 1;
    
    set(handles.edittrimPanning_main, 'String', num2str(handles.trimPanning));
    set(handles.editaddPanning_main, 'String', num2str(handles.addPanning));
    
    if handles.inputfolderPanning == 0;
        set(handles.pathinputPanning_main, 'String', '');
    else;
        disppath = handles.inputfolderPanning;
        set(handles.pathinputPanning_main, 'String', disppath);
        posExtent = get(handles.pathinputPanning_main, 'Extent');
        posReal = get(handles.pathinputPanning_main, 'Position');
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
            set(handles.pathinputPanning_main, 'String', disppath);
        end;
        set(handles.pathinputPanning_main, 'tooltip', handles.inputfolderPanning);
    end;
    
    if handles.outputfolderPanning == 0;
        set(handles.pathoutputPanning_main, 'String', '');
    else;
        disppath = handles.outputfolderPanning;
        set(handles.pathoutputPanning_main, 'String', disppath);
        posExtent = get(handles.pathoutputPanning_main, 'Extent');
        posReal = get(handles.pathoutputPanning_main, 'Position');
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
            set(handles.pathoutputPanning_main, 'String', disppath);
        end;
        set(handles.pathoutputPanning_main, 'tooltip', handles.outputfolderPanning);
    end;
    
    try;
        if ismac == 1;
            load /Applications/SP2VideoManager/listVideoPanningFiles.mat;
        elseif ispc == 1;
            load([MDIR '\SPEVideoManager\listVideoPanningFiles.mat']);
        end;
    catch;
        listVideoPanningFiles = [];
    end;
    if isempty(listVideoPanningFiles) == 1;
        set(handles.tablePanning_main, 'Visible', 'off');
    else;
        set(handles.tablePanning_main, 'Visible', 'on');
    end;
    
    set(handles.RemuxPanning_check_main, 'enable', 'on', 'value', handles.checkboxRemuxPanning);
    set(handles.relayPanning_button_main, 'enable', 'on');
    set(handles.popCompressionPanning_main, 'enable', 'on');
    if isempty(get(handles.tablePanning_main, 'data')) == 0;
        set(handles.tablePanning_main, 'Visible', 'on');
    end;
else;
    handles.checkboxPanning = 0;
    
    set(handles.edittrimPanning_main, 'String', '');
    set(handles.editaddPanning_main, 'String', '');
    set(handles.pathinputPanning_main, 'String', '', 'tooltip', '');
    set(handles.pathoutputPanning_main, 'String', '', 'tooltip', '');
    set(handles.tablePanning_main, 'Visible', 'off');
    set(handles.RemuxPanning_check_main, 'enable', 'off', 'value', 0);
    set(handles.relayPanning_button_main, 'enable', 'off');
    set(handles.popCompressionPanning_main, 'enable', 'off');
end;
    
guidata(handles.hf_w1_welcome, handles);

