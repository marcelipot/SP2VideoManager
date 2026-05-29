function [] = trimOutRelayEdit_relay(varargin);

handles = guidata(gcf);


if isempty(handles.pathRelayfile_relay) == 1;
    set(handles.trimOutRelayEdit_relay, 'String', '');
    handles.trimOutVal_relay = [];
    guidata(handles.hf_w1_welcome, handles);
    return;
end;

valEC = get(handles.trimOutRelayEdit_relay, 'String');
valEC = str2num(valEC);

if isempty(valEC) == 1;
    set(handles.trimOutRelayEdit_relay, 'String', '');
    handles.trimOutVal_relay = [];
    guidata(handles.hf_w1_welcome, handles);
    return;
end


if floor(valEC) ~= valEC;
    set(handles.trimOutRelayEdit_relay, 'String', '');
    handles.trimOutVal_relay = [];
    guidata(handles.hf_w1_welcome, handles);

    if ismac == 1;
        errorwindow = errordlg('Trim Out frame needs to be a full integer number', 'Error');
    elseif ispc == 1;
        MDIR = getenv('USERPROFILE');
        errorwindow = errordlg('Trim Out frame needs to be a full integer number', 'Error');
        jFrame = get(handle(errorwindow), 'javaframe');
        jicon = javax.swing.ImageIcon([MDIR '\SP2VideoManager\SpartaManager_IconSoftware.png']);
        jFrame.setFigureIcon(jicon);
        clc;
    end;
    return;
end;

if valEC < 1;
    set(handles.trimOutRelayEdit_relay, 'String', '');
    handles.trimOutVal_relay = [];
    guidata(handles.hf_w1_welcome, handles);

    if ismac == 1;
        errorwindow = errordlg('Trim Out frame cannot negative or equal to 0', 'Error');
    elseif ispc == 1;
        MDIR = getenv('USERPROFILE');
        errorwindow = errordlg('Trim Out frame cannot negative or equal to 0', 'Error');
        jFrame = get(handle(errorwindow), 'javaframe');
        jicon = javax.swing.ImageIcon([MDIR '\SP2VideoManager\SpartaManager_IconSoftware.png']);
        jFrame.setFigureIcon(jicon);
        clc;
    end;
    return;
end;

if valEC > handles.VidInfoRelay.NbFrames;
    set(handles.trimOutRelayEdit_relay, 'String', '');
    handles.trimOutVal_relay = [];
    guidata(handles.hf_w1_welcome, handles);

    if ismac == 1;
        errorwindow = errordlg(['Trim Out frame cannot superior or equal to ' num2str(handles.VidInfoRelay.NbFrames)], 'Error');
    elseif ispc == 1;
        MDIR = getenv('USERPROFILE');
        errorwindow = errordlg(['Trim Out frame cannot superior or equal to ' num2str(handles.VidInfoRelay.NbFrames)], 'Error');
        jFrame = get(handle(errorwindow), 'javaframe');
        jicon = javax.swing.ImageIcon([MDIR '\SP2VideoManager\SpartaManager_IconSoftware.png']);
        jFrame.setFigureIcon(jicon);
        clc;
    end;
    return;
end;

if isempty(handles.trimInVal_screen) == 0;
    if handles.trimOutVal_screen <= handles.trimInVal_screen;
        set(handles.trimOutRelayEdit_relay, 'String', '');
        handles.trimOutVal_relay = [];
        guidata(handles.hf_w1_welcome, handles);

        if ismac == 1;
            errorwindow = errordlg('Trim Out frame cannot be inferior or equal to Trim In frame', 'Error');
        elseif ispc == 1;
            MDIR = getenv('USERPROFILE');
            errorwindow = errordlg('Trim Out frame cannot be inferior or equal to Trim In frame', 'Error');
            jFrame = get(handle(errorwindow), 'javaframe');
            jicon = javax.swing.ImageIcon([MDIR '\SP2VideoManager\SpartaManager_IconSoftware.png']);
            jFrame.setFigureIcon(jicon);
            clc;
        end;
        return;
    end;
end;

if valEC == handles.VidInfoRelay.NbFrames;
    handles.trimOutVal_relay = [];
else;
    handles.trimOutVal_relay = valEC;
end;
guidata(handles.hf_w1_welcome, handles);

