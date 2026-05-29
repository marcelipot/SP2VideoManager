function [] = trimOutScreenEdit_screen(varargin);

handles = guidata(gcf);


if isempty(handles.pathSceenfile_screen) == 1;
    set(handles.trimOutScreenEdit_screen, 'String', '');
    handles.trimOutVal_screen = [];
    guidata(handles.hf_w1_welcome, handles);
    return;
end;

valEC = get(handles.trimOutScreenEdit_screen, 'String');
valEC = str2num(valEC);

if isempty(valEC) == 1;
    set(handles.trimOutScreenEdit_screen, 'String', '');
    handles.trimOutVal_screen = [];
    guidata(handles.hf_w1_welcome, handles);
    return;
end


if floor(valEC) ~= valEC;
    set(handles.trimOutScreenEdit_screen, 'String', '');
    handles.trimOutVal_screen = [];
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
    set(handles.trimOutScreenEdit_screen, 'String', '');
    handles.trimOutVal_screen = [];
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

if valEC > handles.VidInfoScreen.NbFrames;
    set(handles.trimOutScreenEdit_screen, 'String', '');
    handles.trimOutVal_screen = [];
    guidata(handles.hf_w1_welcome, handles);

    if ismac == 1;
        errorwindow = errordlg(['Trim Out frame cannot superior or equal to ' num2str(handles.VidInfoScreen.NbFrames)], 'Error');
    elseif ispc == 1;
        MDIR = getenv('USERPROFILE');
        errorwindow = errordlg(['Trim Out frame cannot superior or equal to ' num2str(handles.VidInfoScreen.NbFrames)], 'Error');
        jFrame = get(handle(errorwindow), 'javaframe');
        jicon = javax.swing.ImageIcon([MDIR '\SP2VideoManager\SpartaManager_IconSoftware.png']);
        jFrame.setFigureIcon(jicon);
        clc;
    end;
    return;
end;

if isempty(handles.trimInVal_screen) == 0;
    if handles.trimOutVal_screen <= handles.trimInVal_screen;
        set(handles.trimOutScreenEdit_screen, 'String', '');
        handles.trimOutVal_screen = [];
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

if valEC == handles.VidInfoScreen.NbFrames;
    handles.trimOutVal_screen = [];
else;
    handles.trimOutVal_screen = valEC;
end;
guidata(handles.hf_w1_welcome, handles);

