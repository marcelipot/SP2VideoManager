function [] = fisheye4K_main(varargin);

handles = guidata(gcf);

if handles.refreshPlay == 1;
    axes(handles.playrefresh_main); imshow(handles.icones.play_offb);
    handles.refreshPlay = 0;
    stop([handles.TimerScanFolder handles.TimerUpdatePanning handles.TimerUpdate4K]);
end;
if ispc == 1;
    MDIR = getenv('USERPROFILE');
end;

if get(handles.removalfisheye_main, 'Value') == 1;
    handles.fisheye4K = 1;
    set(handles.loadfisheye_main, 'enable', 'on', 'value', handles.Currenfisheye4K);

else;
    handles.fisheye4K = 0;
    set(handles.loadfisheye_main, 'enable', 'off', 'value', 1);
end;

guidata(handles.hf_w1_welcome, handles);
    
