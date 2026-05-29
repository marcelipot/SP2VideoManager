function [] = checkRemuxPanning_main(varargin);

handles = guidata(gcf);

if handles.refreshPlay == 1;
    axes(handles.playrefresh_main); imshow(handles.icones.play_offb);
    handles.refreshPlay = 0;
    stop([handles.TimerScanFolder handles.TimerUpdatePanning handles.TimerUpdate4K]);
end;
if ispc == 1;
    MDIR = getenv('USERPROFILE');
end;

if get(handles.RemuxPanning_check_main, 'Value') == 1;
    handles.checkboxRemuxPanning = 1;
    warningwindow = warndlg('Remuxing can corrupt your video files. Please test your conversion.', 'Warning');
    if ispc == 1;
        jFrame = get(handle(warningwindow), 'javaframe');
        jicon = javax.swing.ImageIcon([MDIR '\SP2VideoManager\SpartaManager_IconSoftware.png']);
        jFrame.setFigureIcon(jicon);
        clc;
    end;
else;
    handles.checkboxRemuxPanning = 0;
end;

guidata(handles.hf_w1_welcome, handles);
    
            