function [] = RTEditRelay_relay(varargin);

handles = guidata(gcf);


if isempty(handles.pathRelayfile_relay) == 1;
    set(handles.RTEditRelay_relay, 'String', '');
    handles.RTVal_relay = [];
    guidata(handles.hf_w1_welcome, handles);
    return;
end;

valEC = get(handles.RTEditRelay_relay, 'String');
valEC = str2num(valEC);

if isempty(valEC) == 1;
    set(handles.RTEditRelay_relay, 'String', '');
    handles.RTVal_relay = [];
    guidata(handles.hf_w1_welcome, handles);
    return;
end

handles.RTVal_relay = roundn(valEC,-2);
set(handles.RTEditRelay_relay, 'String', num2str(handles.RTVal_relay));

guidata(handles.hf_w1_welcome, handles);

