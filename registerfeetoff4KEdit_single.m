function [] = registerfeetoff4KEdit_single(varargin);

handles = guidata(gcf);


% if isempty(handles.path4Kfile_single) == 1;
%     set(handles.registerfeetoff4KEdit_single, 'String', '');
%     return;
% end;

valEC = get(handles.registerfeetoff4KEdit_single, 'String');
valEC = str2num(valEC);

if isempty(valEC) == 1;
    set(handles.registerfeetoff4KEdit_single, 'String', '');
    return;
end


if floor(valEC) ~= valEC;
    set(handles.registerfeetoff4KEdit_single, 'String', '');
    return;
end;

if valEC < 1;
    set(handles.registerfeetoff4KEdit_single, 'String', '');
    return;
end;

if isempty(handles.path4Kfile_single) == 0;
    if valEC > handles.VidInfo4K.NbFrames;
        set(handles.registerfeetoff4KEdit_single, 'String', '');
        return;
    end;
end;

handles.feefoff4KVal_single = valEC;

guidata(handles.hf_w1_welcome, handles);

