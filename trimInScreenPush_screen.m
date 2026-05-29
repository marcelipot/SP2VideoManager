function [] = trimInScreenPush_screen(varargin);

handles = guidata(gcf);


if isempty(handles.pathSceenfile_screen) == 1;
    return;
end;

valEC = handles.VidInfoScreen.FrameEC;
if valEC == 1;
    handles.trimInVal_screen = [];
else;    
    handles.trimInVal_screen = valEC;
end;
set(handles.trimInScreenEdit_screen, 'String', num2str(valEC));

if isempty(handles.trimOutVal_screen) == 0;
    if valEC >= handles.trimOutVal_screen;
        handles.trimInVal_screen = [];
        set(handles.trimInScreenEdit_screen, 'String', '');

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



guidata(handles.hf_w1_welcome, handles);

