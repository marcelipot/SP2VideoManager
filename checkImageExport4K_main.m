function [] = checkImageExport4K_main(varargin);

handles = guidata(gcf);

if handles.refreshPlay == 1;
    axes(handles.playrefresh_main); imshow(handles.icones.play_offb);
    handles.refreshPlay = 0;
    stop([handles.TimerScanFolder handles.TimerUpdatePanning handles.TimerUpdate4K]);
end;

if get(handles.ImageExport4K_check_main, 'Value') == 1;
    handles.checkboxExportImage4K = 1;
    set(handles.ImageQuality_pop_main, 'value', handles.ImageQuality, 'enable', 'on');
else;
    handles.checkboxExportImage4K = 0;
    set(handles.ImageQuality_pop_main, 'value', 1, 'enable', 'off');
end;

guidata(handles.hf_w1_welcome, handles);
    
