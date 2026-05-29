resolution = get(0,'screensize');
resolution = resolution(3:4);

pos = [(resolution(1)-500)./2 (resolution(2)-100)./2 500 190];
handles2.hf_w2_welcome = figure('visible', 'on', 'menubar', 'none', 'toolbar', 'none', ...
    'windowstyle', 'normal', 'color', [0.1 0.1 0.1], 'units', 'pixels', 'position', pos);
%'CloseRequestFcn', 'handles2 = guidata(gcf); uiresume(handles2.hf_w2_welcome)'

set(handles2.hf_w2_welcome, 'Name', 'Network Settings', 'NumberTitle', 'off');
if ispc == 1;
    MDIR = getenv('USERPROFILE');
    jFrame=get(handle(handles2.hf_w2_welcome), 'javaframe');
    jicon=javax.swing.ImageIcon([MDIR '\SP2Viewer\SpartaViewer_IconSoftware.png']);
    jFrame.setFigureIcon(jicon);
    clc;
end;

if ismac == 1;
    MDIR = '/Applications/SP2VideoManager';
    user_name = char(java.lang.System.getProperty('user.name'));
    handles2.defaultpath = ['/Users/',user_name,'/Desktop'];
    handles2.lastPath_single = handles2.defaultpath;
elseif ispc == 1;
    handles2.defaultpath = winqueryreg('HKEY_CURRENT_USER', 'Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders', 'Desktop');
    handles2.lastPath_single = handles2.defaultpath;
end;

if ismac == 1;
    font1 = 12;
    font2 = 9;
elseif ispc == 1;
    font1 = 11;
    font2 = 8;
end;

handles2.knownnetworktxt_main = uicontrol('parent', handles2.hf_w2_welcome, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', ...
    'String', 'Known Networks :', 'position', [20, pos(4)-40, 150, 30], ...
    'BackgroundColor', [0.1 0.1 0.1], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font1, 'HorizontalAlignment', 'left');

if ismac == 1;
    
    listDrop = {};
    for i = 1:length(handles.IPlist(:,1));
        listDrop{i,1} = ['smb://' handles.IPlist{i,2} ' (' handles.IPlist{i,1} ')'];
        
        if str2num(handles.IPlist{i,5}) == 1;
            val = i;
        end;
    end;
    handles2.knownnetworklist_main = uicontrol('parent', handles2.hf_w2_welcome, 'Style', 'Popupmenu', 'Visible', 'on', ...
        'units', 'pixels', 'position', [165, pos(4)-38, 300, 30], 'Value', val, ...
        'String', listDrop, 'ForegroundColor', [0 0 0], 'BackgroundColor', [1 1 1], ...
        'FontName', 'Book Antiqua', 'FontWeight', 'Bold', 'Fontsize', font2, 'Callback', @networklist_IP);

elseif ispc == 1;
    
    listDrop = {};
    for i = 1:length(handles.IPlist(:,1));
        listDrop{i,1} = ['\\' handles.IPlist{i,2} ' (' handles.IPlist{i,1} ')'];
        
        if str2num(handles.IPlist{i,5}) == 1;
            val = i;
        end;
    end;
    handles2.knownnetworklist_main = uicontrol('parent', handles2.hf_w2_welcome, 'Style', 'Popupmenu', 'Visible', 'on', ...
        'units', 'pixels', 'position', [165, pos(4)-38, 300, 30], 'Value', val, ...
        'String', listDrop, 'ForegroundColor', [1 1 1], 'BackgroundColor', [0 0 0], ...
        'FontName', 'Book Antiqua', 'FontWeight', 'Bold', 'Fontsize', font2, 'Callback', @networklist_IP);
end;
handles2.listDrop = listDrop;
handles2.CurrentIP = val;


handles2.createnetworkcheck_main = uicontrol('parent', handles2.hf_w2_welcome, 'Style', 'checkbox', 'Visible', 'on', 'units', 'pixels', ...
    'String', 'Create a new network:', 'position', [20, pos(4)-70, 200, 30], 'Value', 0, ...
    'BackgroundColor', [0.1 0.1 0.1], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font1, 'HorizontalAlignment', 'left', 'Callback', @networknew_IP);

handles2.IPtitletxt_main = uicontrol('parent', handles2.hf_w2_welcome, 'Style', 'text', 'Visible', 'on', 'units', 'pixels', ...
    'String', 'IP address:', 'position', [10, pos(4)-90, 100, 20], ...
    'BackgroundColor', [0.1 0.1 0.1], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font1, 'HorizontalAlignment', 'left');

handles2.IPv1edit_main = uicontrol('parent', handles2.hf_w2_welcome, 'Style', 'Edit', 'Visible', 'on', ...
    'units', 'pixels', 'position', [20, pos(4)-110, 40, 20], 'BackgroundColor', [0.2 0.2 0.2], 'ForegroundColor', [1 1 1], ...
    'String', '', 'enable', 'off', ...
    'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font1, 'HorizontalAlignment', 'Center');

handles2.IPv1txt_main = uicontrol('parent', handles2.hf_w2_welcome, 'Style', 'text', 'Visible', 'on', 'units', 'pixels', ...
    'String', '.', 'position', [60, pos(4)-115, 10, 20], ...
    'BackgroundColor', [0.1 0.1 0.1], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font1, 'HorizontalAlignment', 'center');

handles2.IPv2edit_main = uicontrol('parent', handles2.hf_w2_welcome, 'Style', 'Edit', 'Visible', 'on', ...
    'units', 'pixels', 'position', [70, pos(4)-110, 40, 20], 'BackgroundColor', [0.2 0.2 0.2], 'ForegroundColor', [1 1 1], ...
    'String', '', 'enable', 'off', ...
    'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font1, 'HorizontalAlignment', 'Center');

handles2.IPv2txt_main = uicontrol('parent', handles2.hf_w2_welcome, 'Style', 'text', 'Visible', 'on', 'units', 'pixels', ...
    'String', '.', 'position', [110, pos(4)-115, 10, 20], ...
    'BackgroundColor', [0.1 0.1 0.1], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font1, 'HorizontalAlignment', 'center');

handles2.IPv3edit_main = uicontrol('parent', handles2.hf_w2_welcome, 'Style', 'Edit', 'Visible', 'on', ...
    'units', 'pixels', 'position', [120, pos(4)-110, 40, 20], 'BackgroundColor', [0.2 0.2 0.2], 'ForegroundColor', [1 1 1], ...
    'String', '', 'enable', 'off', ...
    'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font1, 'HorizontalAlignment', 'Center');


handles2.Usertitletxt_main = uicontrol('parent', handles2.hf_w2_welcome, 'Style', 'text', 'Visible', 'on', 'units', 'pixels', ...
    'String', 'Username:', 'position', [180, pos(4)-90, 100, 20], ...
    'BackgroundColor', [0.1 0.1 0.1], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font1, 'HorizontalAlignment', 'left');

handles2.Usernameedit_main = uicontrol('parent', handles2.hf_w2_welcome, 'Style', 'Edit', 'Visible', 'on', ...
    'units', 'pixels', 'position', [185, pos(4)-110, 140, 20], 'BackgroundColor', [0.2 0.2 0.2], 'ForegroundColor', [1 1 1], ...
    'String', '', 'enable', 'off', ...
    'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font1, 'HorizontalAlignment', 'Center');


handles2.Passwordtitletxt_main = uicontrol('parent', handles2.hf_w2_welcome, 'Style', 'text', 'Visible', 'on', 'units', 'pixels', ...
    'String', 'Password:', 'position', [340, pos(4)-90, 100, 20], ...
    'BackgroundColor', [0.1 0.1 0.1], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font1, 'HorizontalAlignment', 'left');

handles2.Passwordedit_main = uicontrol('parent', handles2.hf_w2_welcome, 'Style', 'Edit', 'Visible', 'on', ...
    'units', 'pixels', 'position', [355, pos(4)-110, 140, 20], 'BackgroundColor', [0.2 0.2 0.2], 'ForegroundColor', [1 1 1], ...
    'String', '', 'enable', 'off', 'enable', 'off', ...
    'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font1, 'HorizontalAlignment', 'Center');

handles2.Volumetitletxt_main = uicontrol('parent', handles2.hf_w2_welcome, 'Style', 'text', 'Visible', 'on', 'units', 'pixels', ...
    'String', 'Volume:', 'position', [135, pos(4)-140, 80, 20], ...
    'BackgroundColor', [0.1 0.1 0.1], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font1, 'HorizontalAlignment', 'left');

handles2.Volumeedit_main = uicontrol('parent', handles2.hf_w2_welcome, 'Style', 'Edit', 'Visible', 'on', ...
    'units', 'pixels', 'position', [195, pos(4)-140, 140, 20], 'BackgroundColor', [0.2 0.2 0.2], 'ForegroundColor', [1 1 1], ...
    'String', '', 'enable', 'off', 'enable', 'off', ...
    'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font1, 'HorizontalAlignment', 'Center');



handles2.pushConfirm_main = uicontrol('parent', handles2.hf_w2_welcome, 'Style', 'Push', 'Visible', 'on', 'units', 'pixels', ...
    'position', [275, pos(4)-180, 100, 25], 'String', 'Confirm', 'callback', @pushConfirm_IP, ...
    'BackgroundColor', [0.1 0.1 0.1], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font1, 'HorizontalAlignment', 'center');

handles2.pushCancel_main = uicontrol('parent', handles2.hf_w2_welcome, 'Style', 'Push', 'Visible', 'on', 'units', 'pixels', ...
    'position', [125, pos(4)-180, 100, 25], 'String', 'Cancel', 'callback', @pushCancel_IP, ...
    'BackgroundColor', [0.1 0.1 0.1], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font1, 'HorizontalAlignment', 'center');


handles2.proceedIP = 1;
drawnow;
guidata(handles2.hf_w2_welcome, handles2);
uiwait(handles2.hf_w2_welcome);

handles2 = guidata(gcf);
try;
    proceedIP = handles2.proceedIP;
    if get(handles2.createnetworkcheck_main, 'value') == 1;
        for i = 1:length(handles2.IPlist(:,1));
            handles2.IPlist(i,5) = '0';
        end;
        handles2.IPlist{length(handles2.IPlist(:,1))+1, 1} = IPaddress;
        handles2.IPlist{length(handles2.IPlist(:,1))+1, 2} = volume;
        handles2.IPlist{length(handles2.IPlist(:,1))+1, 3} = username;
        handles2.IPlist{length(handles2.IPlist(:,1))+1, 4} = password;
        handles2.IPlist{length(handles2.IPlist(:,1))+1, 5} = '1';
    else;
        for i = 1:length(handles2.IPlist(:,1));
            if i == handles2.CurrentIP;
                handles2.IPlist{i,5} = '1';
            else;
                handles2.IPlist{i,5} = '0';
            end;
        end;
    end;
    IPlist = handles2.IPlist;
    
    if ispc == 1;
        MDIR = getenv('USERPROFILE');
        save([MDIR '\SP2VideoManager\IPList.mat'], 'IPlist');
        
    elseif ismac == 1;
        save('/Applications/SP2VideoManager/IPList.mat', 'IPlist');

    end;

    close(gcf);
catch;
    proceedIP = 0;
    close(gcf);
end;


