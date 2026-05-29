function [] = helpButton_other1(varargin);




if ispc == 1;
    font1 = 11;
    font2 = 16;
    font3 = 10;
    font4 = 12;
elseif ismac == 1;
    font1 = 13;
    font2 = 19;
    font3 = 13;
    font4 = 15;
end;

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

window_size = floor([(resolution(1)-1000)./2 (resolution(2)-400)./2 1000 600]);
window_size(1) = window_size(1) + offsetLeft;
window_size(2) = window_size(2) + offsetBottom;

hdef = figure('units', 'pixels', 'position', window_size, ...
    'Color', [0.1 0.1 0.1], 'resize', 'on', 'NumberTitle', 'off', 'name', 'Help - Entry list management', ...
    'menubar', 'none', 'toolbar', 'none', 'windowstyle', 'normal');
if ispc == 1;
    MDIR = getenv('USERPROFILE');
    jFrame=get(handle(hdef), 'javaframe');
    jicon = javax.swing.ImageIcon([MDIR '\SP2Viewer\SpartaViewer_IconSoftware.png']);
    jFrame.setFigureIcon(jicon);
    clc;
end;


%---Title
handles2.txtTitle_other1 = uicontrol('parent', hdef, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', ...
    'position', [0, 565, 1000, 30], 'HorizontalAlignment', 'center', ...
    'BackgroundColor', [0.1 0.1 0.1], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font2, 'String', 'Variety of tools to manage SP2 panning and 4K videos');
set(handles2.txtTitle_other1, 'fontunits', 'normalized', 'units', 'normalized');

%---Create line on the top
lineTop = axes('parent', hdef, 'Visible', 'on', 'units', 'pixels', 'Position', [0, 560, 1000, 1], 'color', [1 1 1], ...
    'Xcolor', [1 1 1], 'XTick', [], 'Ycolor', [1 1 1], 'YTick', []);
set(lineTop, 'units', 'normalized');


%---Option 1:
handles2.Option1Title_other1 = uicontrol('parent', hdef, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', ...
    'position', [20, 530, 900, 20], 'HorizontalAlignment', 'left', ...
    'BackgroundColor', [0.1 0.1 0.1], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font4+1, 'String', 'Option 1:  Re-sync panning');
set(handles2.Option1Title_other1, 'fontunits', 'normalized', 'units', 'normalized');

txt = 'Re-synchronise the panning video files when the remote control didnt trigger the camera properly';
handles2.txtstep1a_other1 = uicontrol('parent', hdef, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', ...
    'position', [40, 500, 800, 20], 'HorizontalAlignment', 'left', ...
    'BackgroundColor', [0.1 0.1 0.1], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'Fontsize', font1, 'String', txt);
set(handles2.txtstep1a_other1, 'fontunits', 'normalized', 'units', 'normalized');


%---Option 2:
handles2.Option2Title_other1 = uicontrol('parent', hdef, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', ...
    'position', [20, 450, 300, 20], 'HorizontalAlignment', 'left', ...
    'BackgroundColor', [0.1 0.1 0.1], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font4+1, 'String', 'Option 2:  Convert 4K');
set(handles2.Option2Title_other1, 'fontunits', 'normalized', 'units', 'normalized');

txt = 'Convert and/or modify a 4K file to make it compatible for SP2';
handles2.txtstep1b_other1 = uicontrol('parent', hdef, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', ...
    'position', [40, 420, 800, 20], 'HorizontalAlignment', 'left', ...
    'BackgroundColor', [0.1 0.1 0.1], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'Fontsize', font1, 'String', txt);
set(handles2.txtstep1b_other1, 'fontunits', 'normalized', 'units', 'normalized');


%---Other tools:
handles2.Option3Title_other1 = uicontrol('parent', hdef, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', ...
    'position', [20, 370, 800, 20], 'HorizontalAlignment', 'left', ...
    'BackgroundColor', [0.1 0.1 0.1], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font4+1, 'String', 'Option 3:  Trim Relay');
set(handles2.Option3Title_other1, 'fontunits', 'normalized', 'units', 'normalized');

txt = 'Trim and re-synchronise each leg of a relay race';
handles2.txtstep1c_other1 = uicontrol('parent', hdef, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', ...
    'position', [40, 340, 800, 20], 'HorizontalAlignment', 'left', ...
    'BackgroundColor', [0.1 0.1 0.1], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'Fontsize', font1, 'String', txt);
set(handles2.txtstep1c_other1, 'fontunits', 'normalized', 'units', 'normalized');








fh = findobj(0,'type','figure');
set(0, 'CurrentFigure', fh(1).Number);
    
