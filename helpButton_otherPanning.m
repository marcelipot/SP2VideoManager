function [] = helpButton_otherPanning(varargin);




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
handles2.txtTitle_otherPanning = uicontrol('parent', hdef, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', ...
    'position', [0, 565, 1000, 30], 'HorizontalAlignment', 'center', ...
    'BackgroundColor', [0.1 0.1 0.1], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font2, 'String', 'How to re-synchronise a panning file ?');
set(handles2.txtTitle_otherPanning, 'fontunits', 'normalized', 'units', 'normalized');

%---Create line on the top
lineTop = axes('parent', hdef, 'Visible', 'on', 'units', 'pixels', 'Position', [0, 560, 1000, 1], 'color', [1 1 1], ...
    'Xcolor', [1 1 1], 'XTick', [], 'Ycolor', [1 1 1], 'YTick', []);
set(lineTop, 'units', 'normalized');


%---Option 1:
handles2.Phase1Title_otherPanning = uicontrol('parent', hdef, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', ...
    'position', [20, 530, 900, 20], 'HorizontalAlignment', 'left', ...
    'BackgroundColor', [0.1 0.1 0.1], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font4+1, 'String', 'Step 1:  Load the video files');
set(handles2.Phase1Title_otherPanning, 'fontunits', 'normalized', 'units', 'normalized');

txt = 'Select a the panning video file that needs to be re-synchronised';
handles2.txtstep1a_otherPanning = uicontrol('parent', hdef, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', ...
    'position', [40, 495, 950, 20], 'HorizontalAlignment', 'left', ...
    'BackgroundColor', [0.1 0.1 0.1], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'Fontsize', font1, 'String', txt);
set(handles2.txtstep1a_otherPanning, 'fontunits', 'normalized', 'units', 'normalized');

txt = 'Select the 4K video file for the same race';
handles2.txtstep1b_otherPanning = uicontrol('parent', hdef, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', ...
    'position', [40, 470, 950, 20], 'HorizontalAlignment', 'left', ...
    'BackgroundColor', [0.1 0.1 0.1], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'Fontsize', font1, 'String', txt);
set(handles2.txtstep1b_otherPanning, 'fontunits', 'normalized', 'units', 'normalized');

txt = 'Step 2:  Identify a reference point (feet off)';
handles2.txtstep2_otherPanning = uicontrol('parent', hdef, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', ...
    'position', [20, 430, 950, 20], 'HorizontalAlignment', 'left', ...
    'BackgroundColor', [0.1 0.1 0.1], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font4+1, 'String', txt);
set(handles2.txtstep2_otherPanning, 'fontunits', 'normalized', 'units', 'normalized');

txt = 'Move the panning video until reaching the reference point and click on "Register panning"     or     directly enter the frame number in the box';
handles2.txtstep2a_otherPanning = uicontrol('parent', hdef, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', ...
    'position', [40, 395, 950, 20], 'HorizontalAlignment', 'left', ...
    'BackgroundColor', [0.1 0.1 0.1], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'Fontsize', font1, 'String', txt);
set(handles2.txtstep2a_otherPanning, 'fontunits', 'normalized', 'units', 'normalized');

txt = 'Use the swtich video button in the bottom right corner to display the 4K/Panning video';
handles2.txtstep2b_otherPanning = uicontrol('parent', hdef, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', ...
    'position', [40, 370, 950, 20], 'HorizontalAlignment', 'left', ...
    'BackgroundColor', [0.1 0.1 0.1], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'Fontsize', font1, 'String', txt);
set(handles2.txtstep2b_otherPanning, 'fontunits', 'normalized', 'units', 'normalized');

txt = 'Move the 4K video until reaching the same reference point and click on "Register 4K"     or     directly enter the frame number in the box';
handles2.txtstep2c_otherPanning = uicontrol('parent', hdef, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', ...
    'position', [40, 345, 950, 20], 'HorizontalAlignment', 'left', ...
    'BackgroundColor', [0.1 0.1 0.1], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'Fontsize', font1, 'String', txt);
set(handles2.txtstep2c_otherPanning, 'fontunits', 'normalized', 'units', 'normalized');

txt = 'Step 3:  Process the video';
handles2.txtstep3_otherPanning = uicontrol('parent', hdef, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', ...
    'position', [20, 305, 950, 20], 'HorizontalAlignment', 'left', ...
    'BackgroundColor', [0.1 0.1 0.1], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font4+1, 'String', txt);
set(handles2.txtstep3_otherPanning, 'fontunits', 'normalized', 'units', 'normalized');

txt = 'Select a bitrate value (quality) - Current Canon cameras film at 35MBits/s';
handles2.txtstep3a_otherPanning = uicontrol('parent', hdef, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', ...
    'position', [40, 270, 950, 20], 'HorizontalAlignment', 'left', ...
    'BackgroundColor', [0.1 0.1 0.1], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'Fontsize', font1, 'String', txt);
set(handles2.txtstep3a_otherPanning, 'fontunits', 'normalized', 'units', 'normalized');

txt = 'Click on the Play icon to process the panning video. The re-synchronised panning video will be exported in the same folder with "_conv" added at the end of the filename';
handles2.txtstep3b_otherPanning = uicontrol('parent', hdef, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', ...
    'position', [40, 245, 950, 20], 'HorizontalAlignment', 'left', ...
    'BackgroundColor', [0.1 0.1 0.1], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'Fontsize', font1, 'String', txt);
set(handles2.txtstep3b_otherPanning, 'fontunits', 'normalized', 'units', 'normalized');


fh = findobj(0,'type','figure');
set(0, 'CurrentFigure', fh(1).Number);
    
