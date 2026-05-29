function [] = helpButton_otherScreen(varargin);




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
handles2.txtTitle_otherScreen = uicontrol('parent', hdef, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', ...
    'position', [0, 565, 1000, 30], 'HorizontalAlignment', 'center', ...
    'BackgroundColor', [0.1 0.1 0.1], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font2, 'String', 'How to process a 4K file ?');
set(handles2.txtTitle_otherScreen, 'fontunits', 'normalized', 'units', 'normalized');

%---Create line on the top
lineTop = axes('parent', hdef, 'Visible', 'on', 'units', 'pixels', 'Position', [0, 560, 1000, 1], 'color', [1 1 1], ...
    'Xcolor', [1 1 1], 'XTick', [], 'Ycolor', [1 1 1], 'YTick', []);
set(lineTop, 'units', 'normalized');


%---Option 1:
handles2.Phase1Title_otherScreen = uicontrol('parent', hdef, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', ...
    'position', [20, 530, 950, 20], 'HorizontalAlignment', 'left', ...
    'BackgroundColor', [0.1 0.1 0.1], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font4+1, 'String', 'Step 1:  Load the video file');
set(handles2.Phase1Title_otherScreen, 'fontunits', 'normalized', 'units', 'normalized');

txt = 'Select a video file that needs to be modified or corrected (can be FullHD too)';
handles2.txtstep1a_otherScreen = uicontrol('parent', hdef, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', ...
    'position', [40, 495, 950, 20], 'HorizontalAlignment', 'left', ...
    'BackgroundColor', [0.1 0.1 0.1], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'Fontsize', font1, 'String', txt);
set(handles2.txtstep1a_otherScreen, 'fontunits', 'normalized', 'units', 'normalized');


txt = 'Option 1:  Trim the video file';
handles2.txtstep1_otherScreen = uicontrol('parent', hdef, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', ...
    'position', [20, 455, 950, 20], 'HorizontalAlignment', 'left', ...
    'BackgroundColor', [0.1 0.1 0.1], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font4+1, 'String', txt);
set(handles2.txtstep1_otherScreen, 'fontunits', 'normalized', 'units', 'normalized');

txt = 'Move the video until approximately reaching the beginning of the race and click on "Cut In"    or     directly enter the frame number in the box';
handles2.txtstep1a_otherScreen = uicontrol('parent', hdef, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', ...
    'position', [40, 420, 950, 20], 'HorizontalAlignment', 'left', ...
    'BackgroundColor', [0.1 0.1 0.1], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'Fontsize', font1, 'String', txt);
set(handles2.txtstep1a_otherScreen, 'fontunits', 'normalized', 'units', 'normalized');

txt = 'Move the video until approximately reaching the end of the race and click on "Cut Out"    or     directly enter the frame number in the box';
handles2.txtstep1a_otherScreen = uicontrol('parent', hdef, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', ...
    'position', [40, 395, 950, 20], 'HorizontalAlignment', 'left', ...
    'BackgroundColor', [0.1 0.1 0.1], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'Fontsize', font1, 'String', txt);
set(handles2.txtstep1a_otherScreen, 'fontunits', 'normalized', 'units', 'normalized');

txt = '(not frame accuracy)';
handles2.txtstep1b_otherScreen = uicontrol('parent', hdef, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', ...
    'position', [40, 375, 950, 20], 'HorizontalAlignment', 'left', ...
    'BackgroundColor', [0.1 0.1 0.1], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'Fontsize', font1, 'String', txt);
set(handles2.txtstep1b_otherScreen, 'fontunits', 'normalized', 'units', 'normalized');



txt = 'Advanced Settings';
handles2.txtstep2_otherScreen = uicontrol('parent', hdef, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', ...
    'position', [20, 335, 950, 20], 'HorizontalAlignment', 'left', ...
    'BackgroundColor', [0.1 0.1 0.1], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font4+1, 'String', txt);
set(handles2.txtstep2_otherScreen, 'fontunits', 'normalized', 'units', 'normalized');

txt = 'Option 2: Adjust the brightness and contrast if needed';
handles2.txtstep2b_otherScreen = uicontrol('parent', hdef, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', ...
    'position', [20, 300, 950, 20], 'HorizontalAlignment', 'left', ...
    'BackgroundColor', [0.1 0.1 0.1], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font4+1, 'String', txt);
set(handles2.txtstep2b_otherScreen, 'fontunits', 'normalized', 'units', 'normalized');

txt = 'Adjust the value and click on "Apply" to see the effects on the image (or restore to bring the original image back)';
handles2.txtstep2c_otherScreen = uicontrol('parent', hdef, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', ...
    'position', [40, 265, 950, 20], 'HorizontalAlignment', 'left', ...
    'BackgroundColor', [0.1 0.1 0.1], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'Fontsize', font1, 'String', txt);
set(handles2.txtstep2c_otherScreen, 'fontunits', 'normalized', 'units', 'normalized');


txt = 'Option 3: Apply fish eye correction parameters if needed';
handles2.txtstep3a_otherScreen = uicontrol('parent', hdef, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', ...
    'position', [20, 225, 950, 20], 'HorizontalAlignment', 'left', ...
    'BackgroundColor', [0.1 0.1 0.1], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font4+1, 'String', txt);
set(handles2.txtstep3a_otherScreen, 'fontunits', 'normalized', 'units', 'normalized');

txt = 'Click on "Load" to select a fish eye correction file';
handles2.txtstep3b_otherScreen = uicontrol('parent', hdef, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', ...
    'position', [40, 190, 950, 20], 'HorizontalAlignment', 'left', ...
    'BackgroundColor', [0.1 0.1 0.1], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'Fontsize', font1, 'String', txt);
set(handles2.txtstep3b_otherScreen, 'fontunits', 'normalized', 'units', 'normalized');

txt = 'Click on "Define" to define your GOPRO12 settings and automatically load the adequate fish eye parameters';
handles2.txtstep3c_otherScreen = uicontrol('parent', hdef, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', ...
    'position', [40, 165, 950, 20], 'HorizontalAlignment', 'left', ...
    'BackgroundColor', [0.1 0.1 0.1], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'Fontsize', font1, 'String', txt);
set(handles2.txtstep3c_otherScreen, 'fontunits', 'normalized', 'units', 'normalized');

txt = 'Select the image cropping option (valid pixels only or all pixels). In every cases, the image will be resize to a 16/9 & 4K format';
handles2.txtstep3d_otherScreen = uicontrol('parent', hdef, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', ...
    'position', [40, 140, 950, 20], 'HorizontalAlignment', 'left', ...
    'BackgroundColor', [0.1 0.1 0.1], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'Fontsize', font1, 'String', txt);
set(handles2.txtstep3d_otherScreen, 'fontunits', 'normalized', 'units', 'normalized');

txt = 'Click on "Apply" to see the effects on the image (or restore to bring the original image back)';
handles2.txtstep3e_otherScreen = uicontrol('parent', hdef, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', ...
    'position', [40, 115, 950, 20], 'HorizontalAlignment', 'left', ...
    'BackgroundColor', [0.1 0.1 0.1], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'Fontsize', font1, 'String', txt);
set(handles2.txtstep3e_otherScreen, 'fontunits', 'normalized', 'units', 'normalized');


txt = 'Step 2:  Export the new video file';
handles2.txtstep4_otherScreen = uicontrol('parent', hdef, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', ...
    'position', [20, 80, 950, 20], 'HorizontalAlignment', 'left', ...
    'BackgroundColor', [0.1 0.1 0.1], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font4+1, 'String', txt);
set(handles2.txtstep4_otherScreen, 'fontunits', 'normalized', 'units', 'normalized');


txt = 'Select a bitrate value (quality) - The current ZCAM records at 250MBits/s';
handles2.txtstep4a_otherScreen = uicontrol('parent', hdef, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', ...
    'position', [40, 55, 950, 20], 'HorizontalAlignment', 'left', ...
    'BackgroundColor', [0.1 0.1 0.1], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'Fontsize', font1, 'String', txt);
set(handles2.txtstep4a_otherScreen, 'fontunits', 'normalized', 'units', 'normalized');

txt = 'Selecting a bitrate value will re-encode the video to make it compatible with SP2';
handles2.txtstep4b_otherScreen = uicontrol('parent', hdef, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', ...
    'position', [40, 30, 950, 20], 'HorizontalAlignment', 'left', ...
    'BackgroundColor', [0.1 0.1 0.1], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'Fontsize', font1, 'String', txt);
set(handles2.txtstep4b_otherScreen, 'fontunits', 'normalized', 'units', 'normalized');

txt = 'Remux is an option available only to trim the video. Remuxing is much faster but the video format remains identical';
handles2.txtstep4c_otherScreen = uicontrol('parent', hdef, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', ...
    'position', [40, 5, 950, 20], 'HorizontalAlignment', 'left', ...
    'BackgroundColor', [0.1 0.1 0.1], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'Fontsize', font1, 'String', txt);
set(handles2.txtstep4c_otherScreen, 'fontunits', 'normalized', 'units', 'normalized');


fh = findobj(0,'type','figure');
set(0, 'CurrentFigure', fh(1).Number);
    
