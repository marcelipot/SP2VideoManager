function [] = trimOutScreenPush_screen(varargin);

handles = guidata(gcf);


if isempty(handles.pathSceenfile_screen) == 1;
    return;
end;

valEC = handles.VidInfoScreen.FrameEC;
if valEC == 1;
    handles.trimOutVal_screen = [];
else;    
    handles.trimOutVal_screen = valEC;
end;
set(handles.trimOutScreenEdit_screen, 'String', num2str(valEC));

if isempty(handles.trimOutVal_screen) == 0;
    if valEC <= handles.trimInVal_screen;
        handles.trimOutVal_screen = [];
        set(handles.trimOutScreenEdit_screen, 'String', '');

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



guidata(handles.hf_w1_welcome, handles);

