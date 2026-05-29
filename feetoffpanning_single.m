function [] = feetoffpanning_single(varargin);

handles2 = guidata(gcf);

if ispc == 1;
    MDIR = getenv('USERPROFILE');
end;

val = get(handles2.feetoffpanningedit_main, 'String');

li = strfind(val, ',');
if isempty(li) == 0;
    set(handles2.feetoffpanningedit_main, 'String', num2str(handles2.feefoffpanningVal));
    return;
end;

li = strfind(val, ';');
if isempty(li) == 0;
    set(handles2.feetoffpanningedit_main, 'String', num2str(handles2.feefoffpanningVal));
    return;
end;

li = strfind(val, ' ');
if isempty(li) == 0;
    set(handles2.feetoffpanningedit_main, 'String', num2str(handles2.feefoffpanningVal));
    return;
end;

valnum = str2num(val);

if isempty(valnum) == 1;
    set(handles2.feetoffpanningedit_main, 'String', num2str(handles2.feefoffpanningVal));
    return;
end;

if valnum < 0;
    errorwindow = errordlg('Enter a value >= 0', 'Error');
    if ispc == 1;
        jFrame = get(handle(errorwindow), 'javaframe');
        jicon = javax.swing.ImageIcon([MDIR '\SP2VideoManager\SpartaManager_IconSoftware.png']);
        jFrame.setFigureIcon(jicon);
        clc;
    end;
    set(handles2.feetoffpanningedit_main, 'String', num2str(handles2.feefoffpanningVal));
    return;
end;

set(handles2.status_main, 'String', '');
drawnow;

handles2.feefoffpanningVal = valnum;
guidata(handles2.hf_w2_welcome, handles2);

