function [] = registerfeetoffPanningEdit_single(varargin);

handles = guidata(gcf);


if isempty(handles.pathPanningfile_single) == 1;
    set(handles.registerfeetoffPanningEdit_single, 'String', '');
    return;
end;


valEC = get(handles.registerfeetoffPanningEdit_single, 'String');
valEC = str2num(valEC);

if isempty(valEC) == 1;
    set(handles.registerfeetoffPanningEdit_single, 'String', '');
    return;
end

if floor(valEC) ~= valEC;
    set(handles.registerfeetoffPanningEdit_single, 'String', '');
    return;
end;

if valEC < 1;
    set(handles.registerfeetoffPanningEdit_single, 'String', '');
    return;
end;

if valEC > handles.VidInfoPanning.NbFrames;
    set(handles.registerfeetoffPanningEdit_single, 'String', '');
    return;
end;

handles.feefoffPanningVal_single = valEC;

guidata(handles.hf_w1_welcome, handles);

