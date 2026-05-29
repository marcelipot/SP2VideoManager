function [] = editrefresh_conv(varargin);

handles = guidata(gcf);

if handles.refreshPlay == 1;
    set(handles.playrefresh_conv, 'units', 'pixels');
    pos = get(handles.playrefresh_conv, 'position');
    set(handles.playrefresh_conv, 'cdata', imresize(handles.icones.play_offb, [pos(3) pos(4)]));
    set(handles.playrefresh_conv, 'units', 'normalized');

    handles.refreshPlay = 0;
    stop([handles.TimerScanFolder handles.TimerUpdatePanning handles.TimerUpdate4K]);
end;
if ispc == 1;
    MDIR = getenv('USERPROFILE');
end;

val = get(handles.editrefresh_conv, 'String');

li = strfind(val, ',');
if isempty(li) == 0;
    set(handles.editrefresh_conv, 'String', num2str(handles.refreshTime));
    return;
end;

li = strfind(val, ';');
if isempty(li) == 0;
    set(handles.editrefresh_conv, 'String', num2str(handles.refreshTime));
    return;
end;

li = strfind(val, ' ');
if isempty(li) == 0;
    set(handles.editrefresh_conv, 'String', num2str(handles.refreshTime));
    return;
end;

valnum = str2num(val);

if isempty(valnum) == 1;
    set(handles.editrefresh_conv, 'String', num2str(handles.refreshTime));
    return;
end;

if valnum < 5;
    errorwindow = errordlg('Enter a value > 5', 'Error');
    if ispc == 1;
        jFrame = get(handle(errorwindow), 'javaframe');
        jicon = javax.swing.ImageIcon([MDIR '\SP2VideoManager\SpartaManager_IconSoftware.png']);
        jFrame.setFigureIcon(jicon);
        clc;
    end;
    set(handles.editrefresh_conv, 'String', num2str(handles.refreshTime));
    return;
end;

if valnum >= 600;
    errorwindow = errordlg('Enter a value <= 600', 'Error');
    if ispc == 1;
        jFrame = get(handle(errorwindow), 'javaframe');
        jicon = javax.swing.ImageIcon([MDIR '\SP2VideoManager\SpartaManager_IconSoftware.png']);
        jFrame.setFigureIcon(jicon);
        clc;
    end;
    set(handles.editrefresh_conv, 'String', num2str(handles.refreshTime));
    return;
end;

handles.refreshTime = valnum;
guidata(handles.hf_w1_welcome, handles);

