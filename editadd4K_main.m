function [] = editadd4K_main(varargin);

handles = guidata(gcf);

if handles.refreshPlay == 1;
    axes(handles.playrefresh_main); imshow(handles.icones.play_offb);
    handles.refreshPlay = 0;
    stop([handles.TimerScanFolder handles.TimerUpdatePanning handles.TimerUpdate4K]);
end;
if ispc == 1;
    MDIR = getenv('USERPROFILE');
end;

if handles.checkbox4K == 1;
    val = get(handles.editadd4K_main, 'String');
    
    li = strfind(val, ',');
    if isempty(li) == 0;
        set(handles.editadd4K_main, 'String', num2str(handles.add4K));
        return;
    end;
    
    li = strfind(val, ';');
    if isempty(li) == 0;
        set(handles.editadd4K_main, 'String', num2str(handles.add4K));
        return;
    end;
    
    li = strfind(val, ' ');
    if isempty(li) == 0;
        set(handles.editadd4K_main, 'String', num2str(handles.add4K));
        return;
    end;
    
    valnum = str2num(val);
    
    if isempty(valnum) == 1;
        set(handles.editadd4K_main, 'String', num2str(handles.add4K));
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
        set(handles.editadd4K_main, 'String', num2str(handles.add4K));
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
%         set(handles.editadd4K_main, 'String', num2str(handles.add4K));
%         return;
%     end;
    
    handles.add4K = valnum;
    
    handles.trim4K = 0;
    set(handles.edittrim4K_main, 'String', '0');
    
    guidata(handles.hf_w1_welcome, handles);
    
else;
    set(handles.editadd4K_main, 'String', '');
end;
