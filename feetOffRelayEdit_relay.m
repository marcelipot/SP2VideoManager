function [] = feetOffRelayEdit_relay(varargin);

handles = guidata(gcf);


if isempty(handles.pathRelayfile_relay) == 1;
    set(handles.feetOffRelayEdit_relay, 'String', '');
    return;
end;


valEC = get(handles.feetOffRelayEdit_relay, 'String');
valEC = str2num(valEC);

if isempty(valEC) == 1;
    set(handles.feetOffRelayEdit_relay, 'String', '');
    return;
end

if floor(valEC) ~= valEC;
    set(handles.feetOffRelayEdit_relay, 'String', '');
    return;
end;

if valEC < 1;
    set(handles.feetOffRelayEdit_relay, 'String', '');
    return;
end;

if valEC > handles.VidInfoRelay.NbFrames;
    set(handles.feetOffRelayEdit_relay, 'String', '');
    return;
end;

handles.feetoffVal_relay = valEC;

guidata(handles.hf_w1_welcome, handles);

