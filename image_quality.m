function [] = image_quality(varargin);

handles = guidata(gcf);

if handles.refreshPlay == 1;
    axes(handles.playrefresh_main); imshow(handles.icones.play_offb);
    handles.refreshPlay = 0;
    stop([handles.TimerScanFolder handles.TimerUpdatePanning handles.TimerUpdate4K]);
end;

if handles.checkbox4K == 1;
    val = get(handles.ImageQuality_pop_main, 'value');
    if val == 1;
        handles.ImageQuality = 6;
        set(handles.ImageQuality_pop_main, 'value', 6);
    else;
        handles.ImageQuality = val;
    end;
end;
guidata(handles.hf_w1_welcome, handles);