function handles2 = advancedSettingConvertUI_stitching;


%---Load data and vars
handles = guidata(gcf);
VidInfoLeft = handles.VidInfoLeftStitching;
VidInfoRight = handles.VidInfoRightStitching;
VidInfo = handles.VidInfo;
savedOutputStichingNormal = handles.savedOutputStichingNormal;
savedOutputStichingTop = handles.savedOutputStichingTop;
handles2.savedOutputStichingNormal = savedOutputStichingNormal;
handles2.savedOutputStichingTop = savedOutputStichingTop;
filetosave = [];

handles2.defaultpath = handles.defaultpath;

icones = handles.icones;
if ismac == 1;
    font1 = 14;
    font2 = 13;
    font3 = 12;
    font4 = 9;
elseif ispc == 1;
    font1 = 13;                     
    font2 = 12;
    font3 = 11;
    font4 = 8;
end;

%---get screen info for UI position
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

window_size = floor([(resolution(1)-800)./2 (resolution(2)-400)./2 800 400]);
window_size(1) = window_size(1) + offsetLeft;
window_size(2) = window_size(2) + offsetBottom;
% resolution = get(0,'screensize');
% resolution = resolution(3:4);
% pos = [(resolution(1)-800)./2 (resolution(2)-400)./2 800 400];


%---Create main UI window
handles2.hf_w2_advancedStitching = figure('visible', 'on', 'menubar', 'none', 'toolbar', 'none', ...
    'windowstyle', 'normal', 'color', [0.2 0.2 0.2], 'units', 'pixels', 'position', window_size);
set(handles2.hf_w2_advancedStitching, 'Name', 'Advanced Image Settings', 'NumberTitle', 'off');

if ispc == 1;
    MDIR = getenv('USERPROFILE');
    jFrame=get(handle(handles2.hf_w2_advancedStitching), 'javaframe');
    jicon=javax.swing.ImageIcon([MDIR '\SP2VideoManager\SpartaManager_IconSoftware.png']);
    jFrame.setFigureIcon(jicon);
    clc;
end;

        

%---txt for infos
handles2.mainInfos_qual = uicontrol('parent', handles2.hf_w2_advancedStitching, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', ...
    'position', [5, 375, 600, 20], ...
    'String', '', 'BackgroundColor', [0.2 0.2 0.2], 'ForegroundColor', [0 1 0], ...
    'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font4+1, 'HorizontalAlignment', 'Left');
set(handles2.mainInfos_qual, 'fontunits', 'normalized', 'units', 'normalized');


%---Video Axes
handles2.mainVideo_qual = axes('parent', handles2.hf_w2_advancedStitching, 'units', 'pixels', ...
    'Position', [5, 35, 600, 338], 'color', [0 0 0], ...
    'Xcolor', [0 0 0], 'XTick', [], 'Ycolor', [0 0 0], 'YTick', []);
set(handles2.mainVideo_qual, 'units', 'normalized');

%---Load settings
if isempty(VidInfo) == 1;
    VidInfo.Rate = VidInfoLeft.Rate;
    VidInfo.isexportRateDefault = 1;
    VidInfo.FishEye = [];
    VidInfo.multithreadOption = 1;
    VidInfo.keepValid = 'Full';
    VidInfo.VidObjLeft = VidInfoLeft.VidObj;
    VidInfo.VidObjRight = VidInfoRight.VidObj;
    VidInfo.DurationLeft = VidInfoLeft.Duration;
    VidInfo.DurationRight = VidInfoRight.Duration;
    VidInfo.FrameECLeft = VidInfoLeft.FrameEC;
    VidInfo.FrameECRight = VidInfoRight.FrameEC;
    VidInfo.isexportRateDefault = 1;
    VidInfo.ImageEnhance.Contract = 0;
    VidInfo.ImageEnhance.Brightness = 0;
    VidInfo.exportRate = VidInfo.Rate;
    VidInfo.isexportRateDefault = 1;
    VidInfo.viewAngle = 'NormalView';

else;

end;


%---Display current frame
imgLeft = read(VidInfoLeft.VidObj, VidInfoLeft.FrameEC);
imgRight = read(VidInfoRight.VidObj, VidInfoRight.FrameEC);
VidInfoLeft.ActiveFrame = imgLeft;
VidInfoRight.ActiveFrame = imgRight;
imgPanorama = createStitchImg_stitching(imgLeft, imgRight, savedOutputStichingNormal, savedOutputStichingTop, VidInfo.viewAngle);
VidInfo.ActiveFrame = imgPanorama;
% figure;imshow(imgPanorama);

%---Apply enhancement
if VidInfo.ImageEnhance.Contract ~= 0;
    contrastamt = 1 + VidInfo.ImageEnhance.Contract./10;
    HSV = rgb2hsv(imgPanorama);
    HSV(:, :, 2) = HSV(:, :, 2) * contrastamt;
    HSV(HSV > 1) = 1;
    imgPanorama = hsv2rgb(HSV);
end;

if VidInfo.ImageEnhance.Brightness ~= 0;
    contrastamt = VidInfo.ImageEnhance.Brightness./10;
    if VidInfo.ImageEnhance.Brightness < 0;
        olhi = tan((contrastamt+1)*pi/4)*0.5 + 0.5;
        imgPanorama = imadjust(imgPanorama, [0 1], [1-olhi olhi], 1);
%         frame = imadjust(frame, [(VidInfo.ImageEnhance.Brightness./10) 0]);
    else;
        olhi = tan((1-contrastamt)*pi/4)*0.5 + 0.5;
        imgPanorama = imadjust(imgPanorama, [1-olhi olhi], [0 1], 1);
%         frame = imadjust(frame, [0 (VidInfo.ImageEnhance.Brightness./10)]);
    end;
end;


if roundn(VidInfoLeft.Rate,0) ~= roundn(VidInfoRight.Rate,0);
    if ispc == 1;
        MDIR = getenv('USERPROFILE');
        errorwindow = errordlg('Framerates shound be identical', 'Error');
        jFrame = get(handle(errorwindow), 'javaframe');
        jicon = javax.swing.ImageIcon([MDIR '\SP2VideoManager\SpartaManager_IconSoftware.png']);
        jFrame.setFigureIcon(jicon);
        clc;
    elseif ismac == 1;
        errordlg('Framerates shound be identical', 'Error');
    end;
    return;
end;

% VidInfo.refinePoints = zeros(4, 10);
% VidInfo.refineXY(1,1:10) = [0 0 15 0 25 0 35 0 50 0];
% VidInfo.refineXY(2,1:10) = [0 20 15 20 25 20 35 20 50 20];
% VidInfo.refineXY(3,1:10) = [0 0 0 5 0 10 0 15 0 20];
% VidInfo.refineXY(4,1:10) = [50 0 50 5 50 10 50 15 50 20];
handles2.VidInfo = VidInfo;


%---update the axes
if isfield(handles2, 'qualVideoimdisplayed') == 1;
    %field exist
    if isvalid(handles2.qualVideoimdisplayed) == 1;
        %exist and valid
        cla(handles2.mainVideo_qual, 'reset');
%         cla(handles2.mainVideo_qual);
%         set(handles2.qualVideoimdisplayed, 'cdata', frame);
        axes(handles2.mainVideo_qual);
        handles2.qualVideoimdisplayed = imshow(imgPanorama);
%         xlim(handles2.mainVideo_qual, VidInfo.xlimValCurrent);
%         ylim(handles2.mainVideo_qual, VidInfo.ylimValCurrent);
    else;
        %not valid: need to create it again

        cla(handles2.mainVideo_qual, 'reset');
        axes(handles2.mainVideo_qual);
        handles2.qualVideoimdisplayed = imshow(imgPanorama);
%         axes(handles2.mainVideo_qual);
%         handles2.qualVideoimdisplayed = imshow(frame);
%         xlim(handles2.mainVideo_qual, VidInfo.xlimValCurrent);
%         ylim(handles2.mainVideo_qual, VidInfo.ylimValCurrent);
    end;
else;
    %create field
    cla(handles2.mainVideo_qual, 'reset');
    axes(handles2.mainVideo_qual);
    handles2.qualVideoimdisplayed = imshow(imgPanorama);
%     xlim(handles2.mainVideo_qual, VidInfo.xlimValCurrent);
%     ylim(handles2.mainVideo_qual, VidInfo.ylimValCurrent);
end;
[tb,btns] = axtoolbar(handles2.mainVideo_qual, {'zoomin','zoomout','pan'});
handles2.tb = tb;
handles2.btns = btns;


%---Image correction panel
handles2.imagePanel_qual = uipanel('parent', handles2.hf_w2_advancedStitching, 'Visible', 'on', 'units', 'pixels', 'position', [610, 305, 185, 95], ...
    'BackgroundColor', [0.2 0.2 0.2], 'Title', 'Image enhancement', 'ForegroundColor', [1 1 1], ...
    'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font4+1);
set(handles2.imagePanel_qual, 'fontunits', 'normalized', 'units', 'normalized');

%---Image contrast
handles2.contrastTXT_qual = uicontrol('parent', handles2.imagePanel_qual, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', 'position', [10, 57, 110, 20], ...
    'String', 'Image contrast:', 'BackgroundColor', [0.2 0.2 0.2], 'ForegroundColor', [1 1 1], ...
    'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font4+1, 'HorizontalAlignment', 'Left');
set(handles2.contrastTXT_qual, 'fontunits', 'normalized', 'units', 'normalized');

contrast_listDrop = {'-9'; '-8'; '-7'; '-6'; '-5'; '-4'; '-3'; '-2'; '-1'; '0'; '+1'; '+2'; '+3'; '+4'; '+5'; '+6'; '+7'; '+8'; '+9'};
if VidInfo.ImageEnhance.Contract == 0;
    %no contrast selected yet
    valEC = 10;
else;
    lisearch = strcmpi(contrast_listDrop, num2str(VidInfo.ImageEnhance.Contract));
    likeepcontrast = find(lisearch == 1);
    if isempty(likeepcontrast) == 1;
        %Could not find the contrast
        valEC = 1;
    else;
        %contrast found
        valEC = likeepcontrast;
    end;
end;
if ismac == 1;
    handles2.dropdownContrast_qual = uicontrol('parent', handles2.imagePanel_qual, 'Style', 'Popupmenu', 'Visible', 'on', ...
        'units', 'pixels', 'position', [110, 58, 70, 20], 'Value', valEC, 'HorizontalAlignment', 'Center', ...
        'String', contrast_listDrop, 'ForegroundColor', [0 0 0], 'BackgroundColor', [1 1 1], ...
        'FontName', 'Book Antiqua', 'FontWeight', 'Normal', 'Fontsize', font4+1, ...
        'Callback', @dropdownContrast_stitching, 'enable', 'on');
elseif ispc == 1;
    handles2.dropdownContrast_qual = uicontrol('parent', handles2.imagePanel_qual, 'Style', 'Popupmenu', 'Visible', 'on', ...
        'units', 'pixels', 'position', [120, 58, 50, 20], 'Value', valEC, 'HorizontalAlignment', 'Center', ...
        'String', contrast_listDrop, 'ForegroundColor', [1 1 1], 'BackgroundColor', [0 0 0], ...
        'FontName', 'Book Antiqua', 'FontWeight', 'Normal', 'Fontsize', font4+1, ...
        'Callback', @dropdownContrast_stitching, 'enable', 'on');
end;
set(handles2.dropdownContrast_qual, 'fontunits', 'normalized', 'units', 'normalized');


%---Image brightness
handles2.brightnessTXT_qual = uicontrol('parent', handles2.imagePanel_qual, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', 'position', [10, 32, 110, 20], ...
    'String', 'Image brightness:', 'BackgroundColor', [0.2 0.2 0.2], 'ForegroundColor', [1 1 1], ...
    'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font4+1, 'HorizontalAlignment', 'Left');
set(handles2.brightnessTXT_qual, 'fontunits', 'normalized', 'units', 'normalized');

brightness_listDrop = {'-9'; '-8'; '-7'; '-6'; '-5'; '-4'; '-3'; '-2'; '-1'; '0'; '+1'; '+2'; '+3'; '+4'; '+5'; '+6'; '+7'; '+8'; '+9'};
if VidInfo.ImageEnhance.Brightness == 0;
    %no contrast selected yet
    valEC = 10;
else;
    lisearch = strcmpi(contrast_listDrop, num2str(VidInfo.ImageEnhance.Brightness));
    likeepbrightness = find(lisearch == 1);
    if isempty(likeepbrightness) == 1;
        %Could not find the brightness
        valEC = 1;
    else;
        %brightness found
        valEC = likeepbrightness;
    end;
end;
if ismac == 1;
    handles2.dropdownBrightness_qual = uicontrol('parent', handles2.imagePanel_qual, 'Style', 'Popupmenu', 'Visible', 'on', ...
        'units', 'pixels', 'position', [110, 35, 70, 20], 'Value', valEC, 'HorizontalAlignment', 'Center', ...
        'String', brightness_listDrop, 'ForegroundColor', [0 0 0], 'BackgroundColor', [1 1 1], ...
        'FontName', 'Book Antiqua', 'FontWeight', 'Normal', 'Fontsize', font4+1, ...
        'Callback', @dropdownBrightness_stitching, 'enable', 'on');
elseif ispc == 1;
    handles2.dropdownBrightness_qual = uicontrol('parent', handles2.imagePanel_qual, 'Style', 'Popupmenu', 'Visible', 'on', ...
        'units', 'pixels', 'position', [120, 35, 50, 20], 'Value', valEC, 'HorizontalAlignment', 'Center', ...
        'String', brightness_listDrop, 'ForegroundColor', [1 1 1], 'BackgroundColor', [0 0 0], ...
        'FontName', 'Book Antiqua', 'FontWeight', 'Normal', 'Fontsize', font4+1, ...
        'Callback', @dropdownBrightness_stitching, 'enable', 'on');
end;
set(handles2.dropdownBrightness_qual, 'fontunits', 'normalized', 'units', 'normalized');


%---Apply and restore
handles2.apply1_qual = uicontrol('parent',handles2.imagePanel_qual, 'Style', 'pushbutton', 'Visible', 'on', 'units', 'pixels', ...
    'position', [10, 5, 80, 20], 'callback', @applyImageEnhanceUI_stitching, 'cdata', [], 'String', 'Apply', ...
    'BackgroundColor', [0 0 0], 'ForegroundColor', [1 1 1], ...
    'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font4+1, 'enable', 'on');
set(handles2.apply1_qual, 'fontunits', 'normalized', 'units', 'normalized');

handles2.restore1_qual = uicontrol('parent',handles2.imagePanel_qual, 'Style', 'pushbutton', 'Visible', 'on', 'units', 'pixels', ...
    'position', [95, 5, 80, 20], 'callback', @restoreImageEnhanceUI_stitching, 'cdata', [], 'String', 'Restore', ...
    'BackgroundColor', [0 0 0], 'ForegroundColor', [1 1 1], ...
    'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font4+1, 'enable', 'on');
set(handles2.restore1_qual, 'fontunits', 'normalized', 'units', 'normalized');




%---Framerate panel
handles2.frameratePanel_qual = uipanel('parent', handles2.hf_w2_advancedStitching, 'Visible', 'on', 'units', 'pixels', 'position', [610, 225, 185, 80], ...
    'BackgroundColor', [0.2 0.2 0.2], 'Title', 'Frame Rate Management', 'ForegroundColor', [1 1 1], ...
    'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font4+1);
set(handles2.frameratePanel_qual, 'fontunits', 'normalized', 'units', 'normalized');

txtframerateORI = ['From: ' num2str(VidInfo.Rate) ' images/s'];
handles2.frameratefromTXT_qual = uicontrol('parent', handles2.frameratePanel_qual, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', 'position', [5, 48, 175, 20], ...
    'String', txtframerateORI, 'BackgroundColor', [0.2 0.2 0.2], 'ForegroundColor', [1 1 1], ...
    'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font4, 'HorizontalAlignment', 'center');
set(handles2.frameratefromTXT_qual, 'fontunits', 'normalized', 'units', 'normalized');

handles2.axeImage_qual = axes('parent', handles2.frameratePanel_qual, 'units', 'pixels', ...
    'Position', [77, 30, 25, 25], 'color', [0.2 0.2 0.2], ...
    'Xcolor', [0.2 0.2 0.2], 'XTick', [], 'Ycolor', [0.2 0.2 0.2], 'YTick', []);
set(handles2.axeImage_qual, 'units', 'normalized');
imshow(imresize(handles.icones.download_offb, [25 25]));

txtframerateORI = ['To: '];
handles2.frameratetoTXT_qual = uicontrol('parent', handles2.frameratePanel_qual, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', 'position', [5, 4, 20, 20], ...
    'String', txtframerateORI, 'BackgroundColor', [0.2 0.2 0.2], 'ForegroundColor', [1 1 1], ...
    'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font4, 'HorizontalAlignment', 'center');
set(handles2.frameratetoTXT_qual, 'fontunits', 'normalized', 'units', 'normalized');

if VidInfo.isexportRateDefault == 1;
    valEC = 1;
else;
    if VidInfo.exportRate == 25;
        valEC = 3;
    elseif VidInfo.exportRate == 50;
        valEC = 2;
    end;
end;
framerate_listDrop = {'Copy original'; '50 frames/s'; '25 frames/s'};
if ismac == 1;
    handles2.frameratetoDrop_qual = uicontrol('parent', handles2.frameratePanel_qual, 'Style', 'Popupmenu', 'Visible', 'on', ...
        'units', 'pixels', 'position', [25, 8, 155, 20], 'Value', valEC, 'HorizontalAlignment', 'Center', ...
        'String', framerate_listDrop, 'ForegroundColor', [0 0 0], 'BackgroundColor', [1 1 1], ...
        'FontName', 'Book Antiqua', 'FontWeight', 'Normal', 'Fontsize', font4, ...
        'Callback', @frameratetoDrop_stitching, 'enable', 'on');
elseif ispc == 1;
    handles2.frameratetoDrop_qual = uicontrol('parent', handles2.frameratePanel_qual, 'Style', 'Popupmenu', 'Visible', 'on', ...
        'units', 'pixels', 'position', [25, 8, 155, 20], 'Value', valEC, 'HorizontalAlignment', 'Center', ...
        'String', framerate_listDrop, 'ForegroundColor', [1 1 1], 'BackgroundColor', [0 0 0], ...
        'FontName', 'Book Antiqua', 'FontWeight', 'Normal', 'Fontsize', font4, ...
        'Callback', @frameratetoDrop_stitching, 'enable', 'on');
end;
set(handles2.frameratetoDrop_qual, 'fontunits', 'normalized', 'units', 'normalized');


%---Fish eye panel
handles2.fisheyePanel_qual = uipanel('parent', handles2.hf_w2_advancedStitching, 'Visible', 'on', 'units', 'pixels', 'position', [610, 110, 185, 115], ...
    'BackgroundColor', [0.2 0.2 0.2], 'Title', 'Image Correction', 'ForegroundColor', [1 1 1], ...
    'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font4);
set(handles2.fisheyePanel_qual, 'fontunits', 'normalized', 'units', 'normalized');


%---Valid image
if isempty(VidInfo.keepValid) == 1;
    valEC = 1;
else;
    if strcmpi(VidInfo.keepValid, 'Full') == 1;
        valEC = 1;
    else;
        valEC = 2;
    end;
end;
enableEC = 'on';
validFrame_listDrop = {'Keep full image'; 'Crop to valid image only'};
if ismac == 1;
    handles2.validImageDrop_qual = uicontrol('parent', handles2.fisheyePanel_qual, 'Style', 'Popupmenu', 'Visible', 'on', ...
        'units', 'pixels', 'position', [5, 75, 175, 20], 'Value', valEC, 'HorizontalAlignment', 'Center', ...
        'String', validFrame_listDrop, 'ForegroundColor', [0 0 0], 'BackgroundColor', [1 1 1], ...
        'FontName', 'Book Antiqua', 'FontWeight', 'Normal', 'Fontsize', font4, ...
        'Callback', @validFrame_listDrop_stitching, 'enable', enableEC);
elseif ispc == 1;
    handles2.validImageDrop_qual = uicontrol('parent', handles2.fisheyePanel_qual, 'Style', 'Popupmenu', 'Visible', 'on', ...
        'units', 'pixels', 'position', [5, 75, 175, 20], 'Value', valEC, 'HorizontalAlignment', 'Center', ...
        'String', validFrame_listDrop, 'ForegroundColor', [1 1 1], 'BackgroundColor', [0 0 0], ...
        'FontName', 'Book Antiqua', 'FontWeight', 'Normal', 'Fontsize', font4, ...
        'Callback', @validFrame_listDrop_stitching, 'enable', enableEC);
end;
set(handles2.validImageDrop_qual, 'fontunits', 'normalized', 'units', 'normalized');

%---Top/down or angled image
if isempty(VidInfo.viewAngle) == 1;
    valEC = 1;
else;
    if strcmpi(VidInfo.viewAngle, 'NormalView') == 1;
        valEC = 1;
    else;
        valEC = 2;
    end;
end;
if isempty(savedOutputStichingTop) == 1;
    enableEC = 'off';
else;
    enableEC = 'on';
end;
validFrame_listDrop = {'Normal View'; 'Top-Down View'};
if ismac == 1;
    handles2.viewDrop_qual = uicontrol('parent', handles2.fisheyePanel_qual, 'Style', 'Popupmenu', 'Visible', 'on', ...
        'units', 'pixels', 'position', [5, 55, 175, 20], 'Value', valEC, 'HorizontalAlignment', 'Center', ...
        'String', validFrame_listDrop, 'ForegroundColor', [0 0 0], 'BackgroundColor', [1 1 1], ...
        'FontName', 'Book Antiqua', 'FontWeight', 'Normal', 'Fontsize', font4, ...
        'Callback', @view_listDrop_stitching, 'enable', enableEC);
elseif ispc == 1;
    handles2.viewDrop_qual = uicontrol('parent', handles2.fisheyePanel_qual, 'Style', 'Popupmenu', 'Visible', 'on', ...
        'units', 'pixels', 'position', [5, 55, 175, 20], 'Value', valEC, 'HorizontalAlignment', 'Center', ...
        'String', validFrame_listDrop, 'ForegroundColor', [1 1 1], 'BackgroundColor', [0 0 0], ...
        'FontName', 'Book Antiqua', 'FontWeight', 'Normal', 'Fontsize', font4, ...
        'Callback', @view_listDrop_stitching, 'enable', enableEC);
end;
set(handles2.viewDrop_qual, 'fontunits', 'normalized', 'units', 'normalized');

%---Multithread
handles2.multiThreadRadio_qual = uicontrol('parent', handles2.fisheyePanel_qual, 'Style', 'radio', 'Visible', 'on', 'units', 'pixels', 'position', [5, 35, 200, 20], ...
    'String', 'Multi-thread processing', 'BackgroundColor', [0.2 0.2 0.2], 'ForegroundColor', [1 1 1], 'Value' , VidInfo.multithreadOption, ...
    'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font4, 'HorizontalAlignment', 'left', ...
    'callback', @multiThreadSelect_stitching);
set(handles2.multiThreadRadio_qual, 'tooltipstring', 'Enable multithread processing [faster but create errors]', 'fontunits', 'normalized', 'units', 'normalized');

%---Apply and restore
handles2.apply2_qual = uicontrol('parent',handles2.fisheyePanel_qual, 'Style', 'pushbutton', 'Visible', 'on', 'units', 'pixels', ...
    'position', [10, 5, 80, 20], 'callback', @applyStitchingUI_stitching, 'cdata', [], 'String', 'Update', ...
    'BackgroundColor', [0 0 0], 'ForegroundColor', [1 1 1], ...
    'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font4, 'enable', 'on');
set(handles2.apply2_qual, 'fontunits', 'normalized', 'units', 'normalized');

handles2.restore2_qual = uicontrol('parent',handles2.fisheyePanel_qual, 'Style', 'pushbutton', 'Visible', 'on', 'units', 'pixels', ...
    'position', [95, 5, 80, 20], 'callback', @restoreStitchingUI_stitching, 'cdata', [], 'String', 'Restore', ...
    'BackgroundColor', [0 0 0], 'ForegroundColor', [1 1 1], ...
    'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font4, 'enable', 'on');
set(handles2.restore2_qual, 'fontunits', 'normalized', 'units', 'normalized');





%---Validate and cancel
handles2.validate_qual = uicontrol('parent', handles2.hf_w2_advancedStitching, 'Style', 'pushbutton', 'Visible', 'on', 'units', 'pixels', ...
    'position', [215, 5, 80, 25], 'callback', @validateUI_stitching, 'cdata', [], 'String', 'Validate', ...
    'BackgroundColor', [0 0 0], 'ForegroundColor', [1 1 1], ...
    'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font4, 'enable', 'on');
set(handles2.validate_qual, 'fontunits', 'normalized', 'units', 'normalized');

handles2.cancel_qual = uicontrol('parent', handles2.hf_w2_advancedStitching, 'Style', 'pushbutton', 'Visible', 'on', 'units', 'pixels', ...
    'position', [315, 5, 80, 25], 'callback', @cancelUI_stitching, 'cdata', [], 'String', 'Cancel', ...
    'BackgroundColor', [0 0 0], 'ForegroundColor', [1 1 1], ...
    'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font4, 'enable', 'on');
set(handles2.cancel_qual, 'fontunits', 'normalized', 'units', 'normalized');



% %---load image correction file
% handles2.loadImageCorrection_stitch = uicontrol('parent', handles2.hf_w2_advancedStitching, 'Style', 'pushbutton', 'Visible', 'on', 'units', 'pixels', ...
%     'position', [610, 5, 90, 20], 'callback', @loadImCorrection_stitching, 'cdata', [], 'String', 'Load', ...
%     'BackgroundColor', [0 0 0], 'ForegroundColor', [1 1 1], ...
%     'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font4, 'enable', 'on');
% set(handles2.loadImageCorrection_stitch, 'fontunits', 'normalized', 'units', 'normalized');
% 
% %---save image correction file
% handles2.loadImageCorrection_stitch = uicontrol('parent', handles2.hf_w2_advancedStitching, 'Style', 'pushbutton', 'Visible', 'on', 'units', 'pixels', ...
%     'position', [705, 5, 90, 20], 'callback', @saveImCorrection_stitching, 'cdata', [], 'String', 'Save', ...
%     'BackgroundColor', [0 0 0], 'ForegroundColor', [1 1 1], ...
%     'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font4, 'enable', 'on');
% set(handles2.loadImageCorrection_stitch, 'fontunits', 'normalized', 'units', 'normalized');



drawnow;
handles2.VidInfo = VidInfo;
handles2.filetosave = filetosave;
% fh = findobj(0,'type','figure');
% set(0, 'CurrentFigure', fh(1).Number);
% guidata(gcf, handles2);



guidata(handles2.hf_w2_advancedStitching, handles2);
uiwait(handles2.hf_w2_advancedStitching);




% guidata(handles2.hf_w2_advancedStitching, handles2);

fh = findobj(0,'type','figure');

if length(fh) > 1;
    set(0, 'CurrentFigure', fh(1).Number);

    handles2 = guidata(gcf);
    try;
        guidata(gcf, handles2);
        close(gcf);
    catch;

    end;
end;
