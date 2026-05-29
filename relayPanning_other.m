function [] = relayPanning_main(varargin);



resolution = get(0, 'MonitorPositions');
set(gcf, 'units', 'pixel');
figPos = get(gcf, 'Position');
set(gcf, 'units', 'normalized');

screenValid = 0;
for screenEC = 1:length(resolution(:,1));
    screenLim1 = resolution(screenEC,1);
    screenLim2 = screenLim1+resolution(screenEC,3)-1;

    if figPos(1) >= screenLim1 & figPos(1) <= screenLim2;
        screenValid = screenEC;
    end;
end;
if screenValid == 0;
    screenValid = 1;
end;
offsetLeft = resolution(screenValid,1);
offsetBottom = resolution(screenValid,2);
resolution = resolution(screenValid,3:4);

window_size = floor([(resolution(1)-500)./2 (resolution(2)-100)./2 500 160]);
window_size(1) = window_size(1) + offsetLeft;
window_size(2) = window_size(2) + offsetBottom;

handles2.hf_w2_welcome = figure('visible', 'on', 'menubar', 'none', 'toolbar', 'none', ...
    'windowstyle', 'normal', 'color', [0.1 0.1 0.1], 'units', 'pixels', 'position', window_size);
%'CloseRequestFcn', 'handles2 = guidata(gcf); uiresume(handles2.hf_w2_welcome)'

set(handles2.hf_w2_welcome, 'Name', 'Relay synchronisation', 'NumberTitle', 'off');
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

handles2.fileprocess = [];
handles2.selecttxt_main = uicontrol('parent', handles2.hf_w2_welcome, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', ...
    'String', 'Select a panning file:', 'position', [10, window_size(4)-38, 150, 30], ...
    'BackgroundColor', [0.1 0.1 0.1], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font1, 'HorizontalAlignment', 'center');

handles2.filename_main = uicontrol('parent', handles2.hf_w2_welcome, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', ...
    'String', 'No file loaded', 'position', [290, window_size(4)-42, window_size(3) - 291, 30], ...
    'BackgroundColor', [0.1 0.1 0.1], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font2, 'HorizontalAlignment', 'left');

handles2.pushSelect_main = uicontrol('parent', handles2.hf_w2_welcome, 'Style', 'Push', 'Visible', 'on', 'units', 'pixels', ...
    'position', [170, window_size(4)-30, 100, 25], 'String', 'Import', 'callback', @pushSelect_relay, ...
    'BackgroundColor', [0.1 0.1 0.1], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font1, 'HorizontalAlignment', 'center');
set(handles2.pushSelect_main, 'fontunits', 'normalized');


handles2.feefoffpanningVal = [];
handles2.feetoffpanningtxt_main = uicontrol('parent', handles2.hf_w2_welcome, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', ...
    'String', 'Feet-off frame:', 'position', [5, window_size(4)-75, 150, 30], ...
    'BackgroundColor', [0.1 0.1 0.1], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font1, 'HorizontalAlignment', 'left');
set(handles2.feetoffpanningtxt_main, 'fontunits', 'normalized');

handles2.feetoffpanningedit_main = uicontrol('parent', handles2.hf_w2_welcome, 'Style', 'Edit', 'Visible', 'on', 'units', 'pixels', 'position', [110, window_size(4)-68, 50, 25], ...
    'BackgroundColor', [0.2 0.2 0.2], 'ForegroundColor', [1 1 1], 'callback', @feetoffpanning_relay, 'String', num2str(handles2.feefoffpanningVal), ...
    'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font1, 'HorizontalAlignment', 'Center');
set(handles2.feetoffpanningedit_main, 'fontunits', 'normalized');


handles2.RT = [];
handles2.RTtxt_main = uicontrol('parent', handles2.hf_w2_welcome, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', ...
    'String', 'RT (s):', 'position', [185, window_size(4)-75, 70, 30], ...
    'BackgroundColor', [0.1 0.1 0.1], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font1, 'HorizontalAlignment', 'left');
set(handles2.RTtxt_main, 'fontunits', 'normalized');

handles2.RTedit_main = uicontrol('parent', handles2.hf_w2_welcome, 'Style', 'Edit', 'Visible', 'on', 'units', 'pixels', 'position', [240, window_size(4)-68, 60, 25], ...
    'BackgroundColor', [0.2 0.2 0.2], 'ForegroundColor', [1 1 1], 'callback', @RT_relay, 'String', num2str(handles2.RT), ...
    'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font1, 'HorizontalAlignment', 'Center');
set(handles2.RTedit_main, 'fontunits', 'normalized');


handles2.Duration = [];
handles2.Durationtxt_main = uicontrol('parent', handles2.hf_w2_welcome, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', ...
    'String', 'File Length (s):', 'position', [320, window_size(4)-75, 120, 30], ...
    'BackgroundColor', [0.1 0.1 0.1], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font1, 'HorizontalAlignment', 'left');
set(handles2.Durationtxt_main, 'fontunits', 'normalized');

handles2.Durationedit_main = uicontrol('parent', handles2.hf_w2_welcome, 'Style', 'Edit', 'Visible', 'on', 'units', 'pixels', 'position', [430, window_size(4)-68, 60, 25], ...
    'BackgroundColor', [0.2 0.2 0.2], 'ForegroundColor', [1 1 1], 'callback', @duration_relay, 'String', num2str(handles2.Duration), ...
    'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font1, 'HorizontalAlignment', 'Center');
set(handles2.Durationedit_main, 'fontunits', 'normalized');


handles2.txtCompression_main = uicontrol('parent', handles2.hf_w2_welcome, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', ...
    'position', [100, window_size(4)-113, 150, 30], 'HorizontalAlignment', 'left', ...
    'BackgroundColor', [0.1 0.1 0.1], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', 'FontAngle', 'Italic', ...
    'FontWeight', 'Bold', 'Fontsize', font1, ...
    'String', 'Bitrate (Mbits/s):');
set(handles2.txtCompression_main, 'fontunits', 'normalized');

if ismac == 1;
    handles2.popCompression_main = uicontrol('parent', handles2.hf_w2_welcome, 'Style', 'Popupmenu', 'Visible', 'on', ...
        'units', 'pixels', 'position', [240, window_size(4)-110, 150, 30], ...
        'String', 'Not available', 'ForegroundColor', [0 0 0], 'BackgroundColor', [1 1 1], ...
        'FontName', 'Book Antiqua', 'FontWeight', 'Bold', 'Fontsize', font1, 'Callback', @compressionlevel_relay);
elseif ispc == 1;
    handles2.popCompression_main = uicontrol('parent', handles2.hf_w2_welcome, 'Style', 'Popupmenu', 'Visible', 'on', ...
        'units', 'pixels', 'position', [240, window_size(4)-110, 150, 30], ...
        'String', 'Not available', 'ForegroundColor', [1 1 1], 'BackgroundColor', [0 0 0], ...
        'FontName', 'Book Antiqua', 'FontWeight', 'Bold', 'Fontsize', font1, 'Callback', @compressionlevel_relay);
end;
set(handles2.popCompression_main, 'fontunits', 'normalized');



handles2.pushCancel_main = uicontrol('parent', handles2.hf_w2_welcome, 'Style', 'Push', 'Visible', 'on', 'units', 'pixels', ...
    'position', [150, window_size(4)-150, 80, 25], 'String', 'Cancel', 'callback', @cancelsynch_relay, ...
    'BackgroundColor', [0.1 0.1 0.1], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font1, 'HorizontalAlignment', 'center');
set(handles2.pushCancel_main, 'fontunits', 'normalized');

handles2.pushStart_main = uicontrol('parent', handles2.hf_w2_welcome, 'Style', 'Push', 'Visible', 'on', 'units', 'pixels', ...
    'position', [290, window_size(4)-150, 80, 25], 'String', 'Trim', 'callback', @starttrim_relay, ...
    'BackgroundColor', [0.1 0.1 0.1], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font1, 'HorizontalAlignment', 'center');
set(handles2.pushStart_main, 'fontunits', 'normalized');

handles2.status_main = uicontrol('parent', handles2.hf_w2_welcome, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', ...
    'String', '', 'position', [10, window_size(4)-170, 100, 30], ...
    'BackgroundColor', [0.1 0.1 0.1], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font2, 'HorizontalAlignment', 'left');
set(handles2.status_main, 'fontunits', 'normalized');


drawnow;
guidata(handles2.hf_w2_welcome, handles2);
uiwait(handles2.hf_w2_welcome);

