function [] = trimInScreenEdit_screen(varargin);

handles = guidata(gcf);


if isempty(handles.pathSceenfile_screen) == 1;
    set(handles.trimInScreenEdit_screen, 'String', '');
    handles.trimInVal_screen = [];
    guidata(handles.hf_w1_welcome, handles);
    return;
end;

valEC = get(handles.trimInScreenEdit_screen, 'String');
valEC = str2num(valEC);

if isempty(valEC) == 1;
    set(handles.trimInScreenEdit_screen, 'String', '');
    handles.trimInVal_screen = [];
    guidata(handles.hf_w1_welcome, handles);
    return;
end


if floor(valEC) ~= valEC;
    set(handles.trimInScreenEdit_screen, 'String', '');
    handles.trimInVal_screen = [];
    guidata(handles.hf_w1_welcome, handles);

    if ismac == 1;
        errorwindow = errordlg('Trim In frame needs to be a full integer number', 'Error');
    elseif ispc == 1;
        MDIR = getenv('USERPROFILE');
        errorwindow = errordlg('Trim In frame needs to be a full integer number', 'Error');
        jFrame = get(handle(errorwindow), 'javaframe');
        jicon = javax.swing.ImageIcon([MDIR '\SP2VideoManager\SpartaManager_IconSoftware.png']);
        jFrame.setFigureIcon(jicon);
        clc;
    end;
    return;
end;

if valEC < 1;
    set(handles.trimInScreenEdit_screen, 'String', '');
    handles.trimInVal_screen = [];
    guidata(handles.hf_w1_welcome, handles);

    if ismac == 1;
        errorwindow = errordlg('Trim In frame cannot negative or equal to 0', 'Error');
    elseif ispc == 1;
        MDIR = getenv('USERPROFILE');
        errorwindow = errordlg('Trim In frame cannot negative or equal to 0', 'Error');
        jFrame = get(handle(errorwindow), 'javaframe');
        jicon = javax.swing.ImageIcon([MDIR '\SP2VideoManager\SpartaManager_IconSoftware.png']);
        jFrame.setFigureIcon(jicon);
        clc;
    end;
    return;
end;

if valEC >= handles.VidInfoScreen.NbFrames;
    set(handles.trimInScreenEdit_screen, 'String', '');
    handles.trimInVal_screen = [];
    guidata(handles.hf_w1_welcome, handles);

    if ismac == 1;
        errorwindow = errordlg(['Trim In frame cannot superior or equal to ' num2str(handles.VidInfoScreen.NbFrames)], 'Error');
    elseif ispc == 1;
        MDIR = getenv('USERPROFILE');
        errorwindow = errordlg(['Trim In frame cannot superior or equal to ' num2str(handles.VidInfoScreen.NbFrames)], 'Error');
        jFrame = get(handle(errorwindow), 'javaframe');
        jicon = javax.swing.ImageIcon([MDIR '\SP2VideoManager\SpartaManager_IconSoftware.png']);
        jFrame.setFigureIcon(jicon);
        clc;
    end;
    return;
end;

if isempty(handles.trimOutVal_screen) == 0;
    if handles.trimInVal_screen >= handles.trimOutVal_screen;
        set(handles.trimInScreenEdit_screen, 'String', '');
        handles.trimInVal_screen = [];
        guidata(handles.hf_w1_welcome, handles);

        if ismac == 1;
            errorwindow = errordlg('Trim In frame cannot be superior or equal to Trim Out frame', 'Error');
        elseif ispc == 1;
            MDIR = getenv('USERPROFILE');
            errorwindow = errordlg('Trim In frame cannot be superior or equal to Trim Out frame', 'Error');
            jFrame = get(handle(errorwindow), 'javaframe');
            jicon = javax.swing.ImageIcon([MDIR '\SP2VideoManager\SpartaManager_IconSoftware.png']);
            jFrame.setFigureIcon(jicon);
            clc;
        end;
        return;
    end;
end;

if valEC == 1;
    handles.trimInVal_screen = [];
else;
    handles.trimInVal_screen = valEC;
end;

guidata(handles.hf_w1_welcome, handles);

