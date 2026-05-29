function [] = registerfeetoff4KPush_single(varargin);

handles = guidata(gcf);


if isempty(handles.path4Kfile_single) == 1;
    return;
end;

if handles.activeVideo_single == 1;
    %panning video active
    return;
end;

handles.feefoff4KVal_single = handles.VidInfo4K.FrameEC;
set(handles.registerfeetoff4KEdit_single, 'String', num2str(handles.feefoff4KVal_single));


guidata(handles.hf_w1_welcome, handles);

