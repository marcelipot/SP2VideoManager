function [] = registerfeetoffPanningPush_single(varargin);

handles = guidata(gcf);


if isempty(handles.pathPanningfile_single) == 1;
    return;
end;


if handles.activeVideo_single == 2;
    %panning video active
    return;
end;

handles.feefoffpanningVal_single = handles.VidInfoPanning.FrameEC;
set(handles.registerfeetoffPanningEdit_single, 'String', num2str(handles.feefoffpanningVal_single));


guidata(handles.hf_w1_welcome, handles);

