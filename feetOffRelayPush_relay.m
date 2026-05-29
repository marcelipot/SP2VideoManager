function [] = feetOffRelayPush_relay(varargin);

handles = guidata(gcf);


if isempty(handles.pathRelayfile_relay) == 1;
    return;
end;

handles.feetoffVal_relay = handles.VidInfoRelay.FrameEC;
set(handles.feetOffRelayEdit_relay, 'String', num2str(handles.feetoffVal_relay));


guidata(handles.hf_w1_welcome, handles);

