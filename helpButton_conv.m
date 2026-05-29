function [] = helpButton_conv(varargin);




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
handles2.txtTitle_entry = uicontrol('parent', hdef, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', ...
    'position', [0, 565, 1000, 30], 'HorizontalAlignment', 'center', ...
    'BackgroundColor', [0.1 0.1 0.1], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font2, 'String', 'How to manage the video files ?');
set(handles2.txtTitle_entry, 'fontunits', 'normalized', 'units', 'normalized');

%---Create line on the top
lineTop = axes('parent', hdef, 'Visible', 'on', 'units', 'pixels', 'Position', [0, 560, 1000, 1], 'color', [1 1 1], ...
    'Xcolor', [1 1 1], 'XTick', [], 'Ycolor', [1 1 1], 'YTick', []);
set(lineTop, 'units', 'normalized');


%---Option 1:
handles2.Option1Title_entry = uicontrol('parent', hdef, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', ...
    'position', [20, 530, 300, 20], 'HorizontalAlignment', 'left', ...
    'BackgroundColor', [0.1 0.1 0.1], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font4+1, 'String', 'Setting up the transfer:');
set(handles2.Option1Title_entry, 'fontunits', 'normalized', 'units', 'normalized');

txt = 'Step 1:  Select the input folder where the panning videos will be located (cannot be a OneDrive or Dropbox shared folder)';
handles2.txtstep1pdf_entry = uicontrol('parent', hdef, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', ...
    'position', [40, 495, 800, 20], 'HorizontalAlignment', 'left', ...
    'BackgroundColor', [0.1 0.1 0.1], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'Fontsize', font1, 'String', txt);
set(handles2.txtstep1pdf_entry, 'fontunits', 'normalized', 'units', 'normalized');

txt = 'Step 2:  Select the output folder where the panning videos will be transferred to (cannot be a OneDrive or Dropbox shared folder)';
handles2.txtstep2pdf_entry = uicontrol('parent', hdef, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', ...
    'position', [40, 470, 800, 20], 'HorizontalAlignment', 'left', ...
    'BackgroundColor', [0.1 0.1 0.1], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'Fontsize', font1, 'String', txt);
set(handles2.txtstep2pdf_entry, 'fontunits', 'normalized', 'units', 'normalized');

txt = 'Step 3:  Indicate how many frames need to be added or trimed off the files (enter 0 if none)';
handles2.txtstep3pdf_entry = uicontrol('parent', hdef, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', ...
    'position', [40, 445, 800, 20], 'HorizontalAlignment', 'left', ...
    'BackgroundColor', [0.1 0.1 0.1], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'Fontsize', font1, 'String', txt);
set(handles2.txtstep3pdf_entry, 'fontunits', 'normalized', 'units', 'normalized');

txt = 'Step 4:  Select a bitrate value (the higher the better the quality but the heavier the output file will be)';
handles2.txtstep4pdf_entry = uicontrol('parent', hdef, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', ...
    'position', [40, 420, 800, 20], 'HorizontalAlignment', 'left', ...
    'BackgroundColor', [0.1 0.1 0.1], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'Fontsize', font1, 'String', txt);
set(handles2.txtstep4pdf_entry, 'fontunits', 'normalized', 'units', 'normalized');

txt = 'Step 5:  Indicate how often would you like the software to scan the input folder to identify the new videos and refresh';
handles2.txtstep5pdf_entry = uicontrol('parent', hdef, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', ...
    'position', [40, 395, 800, 20], 'HorizontalAlignment', 'left', ...
    'BackgroundColor', [0.1 0.1 0.1], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'Fontsize', font1, 'String', txt);
set(handles2.txtstep5pdf_entry, 'fontunits', 'normalized', 'units', 'normalized');

txt = 'Step 6:  Click on the play icon to start/pause the process';
handles2.txtstep6pdf_entry = uicontrol('parent', hdef, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', ...
    'position', [40, 370, 800, 20], 'HorizontalAlignment', 'left', ...
    'BackgroundColor', [0.1 0.1 0.1], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'Fontsize', font1, 'String', txt);
set(handles2.txtstep6pdf_entry, 'fontunits', 'normalized', 'units', 'normalized');



fh = findobj(0,'type','figure');
set(0, 'CurrentFigure', fh(1).Number);
    
