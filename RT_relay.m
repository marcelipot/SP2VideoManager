function [] = RT_relay(varargin);

handles2 = guidata(gcf);

if ispc == 1;
    MDIR = getenv('USERPROFILE');
end;

val = get(handles2.RTedit_main, 'String');

li = strfind(val, ',');
if isempty(li) == 0;
    set(handles2.RTedit_main, 'String', num2str(handles2.RT));
    return;
end;

li = strfind(val, ';');
if isempty(li) == 0;
    set(handles2.RTedit_main, 'String', num2str(handles2.RT));
    return;
end;

li = strfind(val, ' ');
if isempty(li) == 0;
    set(handles2.RTedit_main, 'String', num2str(handles2.RT));
    return;
end;

valnum = str2num(val);

if isempty(valnum) == 1;
    set(handles2.RTedit_main, 'String', num2str(handles2.RT));
    return;
end;

set(handles2.status_main, 'String', '');
drawnow;

handles2.RT = valnum;
guidata(handles2.hf_w2_welcome, handles2);

