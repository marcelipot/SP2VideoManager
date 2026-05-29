function [] = edittrimPanning_conv(varargin);

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

if handles.checkboxPanning == 1;
    val = get(handles.edittrimPanning_conv, 'String');
    
    li = strfind(val, ',');
    if isempty(li) == 0;
        set(handles.edittrimPanning_conv, 'String', num2str(handles.trimPanning));
        return;
    end;
    
    li = strfind(val, ';');
    if isempty(li) == 0;
        set(handles.edittrimPanning_conv, 'String', num2str(handles.trimPanning));
        return;
    end;
    
    li = strfind(val, ' ');
    if isempty(li) == 0;
        set(handles.edittrimPanning_conv, 'String', num2str(handles.trimPanning));
        return;
    end;
    
    valnum = str2num(val);
    
    if isempty(valnum) == 1;
        set(handles.edittrimPanning_conv, 'String', num2str(handles.trimPanning));
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
        set(handles.edittrimPanning_conv, 'String', num2str(handles.trimPanning));
        return;
    end;
    
%     if valnum >= 50;
%         errorwindow = errordlg('Enter a value < 50', 'Error');
%         if ispc == 1;
%             jFrame = get(handle(errorwindow), 'javaframe');
%             jicon = javax.swing.ImageIcon([MDIR '\SP2VideoManager\SpartaManager_IconSoftware.png']);
%             jFrame.setFigureIcon(jicon);
%             clc;
%         end;
%         set(handles.edittrimPanning_main, 'String', num2str(handles.trimPanning));
%         return;
%     end;
    
    handles.trimPanning = valnum;
    
    handles.addPanning = 0;
    set(handles.editaddPanning_conv, 'String', '0');
    
    guidata(handles.hf_w1_welcome, handles);
    
else;
    set(handles.edittrimPanning_conv, 'String', '');
end;