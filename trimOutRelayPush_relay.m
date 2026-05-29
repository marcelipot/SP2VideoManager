function [] = trimOutRelayPush_relay(varargin);

handles = guidata(gcf);


if isempty(handles.pathRelayfile_relay) == 1;
    return;
end;

valEC = handles.VidInfoRelay.FrameEC;
if valEC == 1;
    handles.trimOutVal_relay = [];
else;    
    handles.trimOutVal_relay = valEC;
end;
set(handles.trimOutRelayEdit_relay, 'String', num2str(valEC));

guidata(handles.hf_w1_welcome, handles);

