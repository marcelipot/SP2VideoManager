function handles2 = advancedSettingConvertUI_screen;



handles = guidata(gcf);
VidInfo = handles.VidInfoScreen;
try
    filetosave = handles.filetosave;
catch;
    filetosave = [];
end;
handles2.defaultpath = handles.defaultpath;
handles2.icones = handles.icones;
handles2.ImageEnhance = VidInfo.ImageEnhance;

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
handles2.hf_w2_advancedImage = figure('visible', 'on', 'menubar', 'none', 'toolbar', 'none', ...
    'windowstyle', 'normal', 'color', [0.2 0.2 0.2], 'units', 'pixels', 'position', window_size);
set(handles2.hf_w2_advancedImage, 'Name', 'Advanced Image Settings', 'NumberTitle', 'off');

if ispc == 1;
    MDIR = getenv('USERPROFILE');
    jFrame=get(handle(handles2.hf_w2_advancedImage), 'javaframe');
    jicon=javax.swing.ImageIcon([MDIR '\SP2VideoManager\SpartaManager_IconSoftware.png']);
    jFrame.setFigureIcon(jicon);
    clc;
end;
handles2.correctionUpdateTrigger = 'new';


%---txt for infos
handles2.mainInfos_qual = uicontrol('parent', handles2.hf_w2_advancedImage, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', ...
    'position', [5, 375, 600, 20], ...
    'String', '', 'BackgroundColor', [0.2 0.2 0.2], 'ForegroundColor', [0 1 0], ...
    'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font4+1, 'HorizontalAlignment', 'Left');
set(handles2.mainInfos_qual, 'fontunits', 'normalized', 'units', 'normalized');


%---Video Axes
handles2.mainVideo_qual = axes('parent', handles2.hf_w2_advancedImage, 'units', 'pixels', ...
    'Position', [5, 35, 600, 338], 'color', [0 0 0], ...
    'Xcolor', [0 0 0], 'XTick', [], 'Ycolor', [0 0 0], 'YTick', []);
set(handles2.mainVideo_qual, 'units', 'normalized');

%---Display current frame
frame = read(VidInfo.VidObj, VidInfo.FrameEC);
VidInfo.ActiveFrame = frame;


%---Apply fish eye
if isempty(VidInfo.FishEye) == 0;
    if isempty(VidInfo.FishEye.map_xOpt) == 0;
        %---Use the optimsed maps
        map_x = VidInfo.FishEye.map_xOpt;
        map_y = VidInfo.FishEye.map_yOpt;
    else;
        %--- Use the non-optimised maps
        map_x = VidInfo.FishEye.map_xIni;
        map_y = VidInfo.FishEye.map_yIni;
    end;
%     if strcmpi(class(VidInfo.FishEye.param), 'cameraParameters');
%         %pinhole model
        [frame, ~] = imagesbuiltinImageInterpolation2D(frame, map_x, map_y, 'nearest',0); 
%     elseif strcmpi(class(VidInfo.FishEye.param), 'fisheyeParameters');
%         %fisheye model
%         [frame, ~] = imagesbuiltinImageInterpolation2D(frame, VidInfo.FishEye.map_x, VidInfo.FishEye.map_y, 'nearest', 0);
%     end;

    [rows, cols, ~] = size(frame);
    if strcmpi(VidInfo.FishEye.keepValid, 'Full');
        %Keep the entire image: just remove the rows and cols to make it 16/9
        if roundn(cols./rows,-3) < roundn(16/9,-3);
            %they are too many rows... need to remove some to have 16/9 ratio
            nbrowsTOT = (cols.*9)./16;
            rowsFrom = floor((rows-nbrowsTOT)./2) + 1;
            rowsTo = rows-floor((rows-nbrowsTOT)./2) - 1;
            frame = frame(rowsFrom:rowsTo,:,:);

        elseif roundn(cols./rows,-3) > roundn(16/9,-3);
            %they are too many cols... need to add black rows to have 16/9 ratio
            nbrowsTOT = (cols.*9)./16;
            missingRows = floor((rows-nbrowsTOT)./2);

            frame2a1 = zeros(missingRows,cols);
            frame2a2 = [frame2a1; frame(:,:,1); frame2a1];
            frame2b1 = zeros(missingRows,cols);
            frame2b2 = [frame2b1; frame(:,:,2); frame2b1];
            frame2c1 = zeros(missingRows,cols);
            frame2c2 = [frame2c1; frame(:,:,3); frame2c1];

            frame(:,:,1) = frame2a2;
            frame(:,:,2) = frame2b2;
            frame(:,:,3) = frame2c2;
        else;
            %no need to change the ratio
            %already 16/9
        end;
        frame = imresize(frame, [2160 3840]);

    elseif strcmpi(VidInfo.FishEye.keepValid, 'Valid');
        %Crop the image to 16/9

        midFrameRows = (rows./2) - 2160./2;
        midFrameCols = (cols./2) - 3840./2;
        posRec = [midFrameCols midFrameRows 3840-1 2160-1];

        frame = imcrop(frame, posRec);
    end;
end;


%---Apply enhancement
if VidInfo.ImageEnhance.Contract ~= 0;
    contrastamt = 1 + VidInfo.ImageEnhance.Contract./10;
    HSV = rgb2hsv(frame);
    HSV(:, :, 2) = HSV(:, :, 2) * contrastamt;
    HSV(HSV > 1) = 1;
    frame = hsv2rgb(HSV);
end;

if VidInfo.ImageEnhance.Brightness ~= 0;
    contrastamt = VidInfo.ImageEnhance.Brightness./10;
    if VidInfo.ImageEnhance.Brightness < 0;
        olhi = tan((contrastamt+1)*pi/4)*0.5 + 0.5;
        frame = imadjust(frame, [0 1], [1-olhi olhi], 1);
%         frame = imadjust(frame, [(VidInfo.ImageEnhance.Brightness./10) 0]);
    else;
        olhi = tan((1-contrastamt)*pi/4)*0.5 + 0.5;
        frame = imadjust(frame, [1-olhi olhi], [0 1], 1);
%         frame = imadjust(frame, [0 (VidInfo.ImageEnhance.Brightness./10)]);
    end;
end;



%---update the axes
if isfield(handles2, 'qualVideoimdisplayed') == 1;
    %field exist
    if isvalid(handles2.qualVideoimdisplayed) == 1;
        %exist and valid
        cla(handles2.mainVideo_qual, 'reset');
%         cla(handles2.mainVideo_qual);
%         set(handles2.qualVideoimdisplayed, 'cdata', frame);
        axes(handles2.mainVideo_qual);
        handles2.qualVideoimdisplayed = imshow(frame);
%         xlim(handles2.mainVideo_qual, VidInfo.xlimValCurrent);
%         ylim(handles2.mainVideo_qual, VidInfo.ylimValCurrent);
    else;
        %not valid: need to create it again

        cla(handles2.mainVideo_qual, 'reset');
        axes(handles2.mainVideo_qual);
        handles2.qualVideoimdisplayed = imshow(frame);
%         axes(handles2.mainVideo_qual);
%         handles2.qualVideoimdisplayed = imshow(frame);
%         xlim(handles2.mainVideo_qual, VidInfo.xlimValCurrent);
%         ylim(handles2.mainVideo_qual, VidInfo.ylimValCurrent);
    end;
else;
    %create field
    cla(handles2.mainVideo_qual, 'reset');
    axes(handles2.mainVideo_qual);
    handles2.qualVideoimdisplayed = imshow(frame);
%     xlim(handles2.mainVideo_qual, VidInfo.xlimValCurrent);
%     ylim(handles2.mainVideo_qual, VidInfo.ylimValCurrent);
end;
[tb,btns] = axtoolbar(handles2.mainVideo_qual, {'zoomin','zoomout','pan'});
handles2.tb = tb;
handles2.btns = btns;


%---Image correction panel
handles2.imagePanel_qual = uipanel('parent', handles2.hf_w2_advancedImage, 'Visible', 'on', 'units', 'pixels', 'position', [610, 305, 185, 95], ...
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
    if VidInfo.ImageEnhance.Contract > 0;
        searchVal = ['+' num2str(VidInfo.ImageEnhance.Contract)];
    elseif VidInfo.ImageEnhance.Contract < 0;
        searchVal = ['-' num2str(VidInfo.ImageEnhance.Contract)];
    else;
        searchVal = num2str(VidInfo.ImageEnhance.Contract);
    end;
    lisearch = strcmpi(contrast_listDrop, searchVal);
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
        'Callback', @dropdownContrast_screen, 'enable', 'on');
elseif ispc == 1;
    handles2.dropdownContrast_qual = uicontrol('parent', handles2.imagePanel_qual, 'Style', 'Popupmenu', 'Visible', 'on', ...
        'units', 'pixels', 'position', [120, 58, 50, 20], 'Value', valEC, 'HorizontalAlignment', 'Center', ...
        'String', contrast_listDrop, 'ForegroundColor', [1 1 1], 'BackgroundColor', [0 0 0], ...
        'FontName', 'Book Antiqua', 'FontWeight', 'Normal', 'Fontsize', font4+1, ...
        'Callback', @dropdownContrast_screen, 'enable', 'on');
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
    if VidInfo.ImageEnhance.Brightness > 0;
        searchVal = ['+' num2str(VidInfo.ImageEnhance.Brightness)];
    elseif VidInfo.ImageEnhance.Brightness < 0;
        searchVal = ['-' num2str(VidInfo.ImageEnhance.Brightness)];
    else;
        searchVal = num2str(VidInfo.ImageEnhance.Brightness);
    end;
    lisearch = strcmpi(brightness_listDrop, searchVal);
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
        'Callback', @dropdownBrightness_screen, 'enable', 'on');
elseif ispc == 1;
    handles2.dropdownBrightness_qual = uicontrol('parent', handles2.imagePanel_qual, 'Style', 'Popupmenu', 'Visible', 'on', ...
        'units', 'pixels', 'position', [120, 35, 50, 20], 'Value', valEC, 'HorizontalAlignment', 'Center', ...
        'String', brightness_listDrop, 'ForegroundColor', [1 1 1], 'BackgroundColor', [0 0 0], ...
        'FontName', 'Book Antiqua', 'FontWeight', 'Normal', 'Fontsize', font4+1, ...
        'Callback', @dropdownBrightness_screen, 'enable', 'on');
end;
set(handles2.dropdownBrightness_qual, 'fontunits', 'normalized', 'units', 'normalized');


%---Apply and restore
handles2.apply1_qual = uicontrol('parent',handles2.imagePanel_qual, 'Style', 'pushbutton', 'Visible', 'on', 'units', 'pixels', ...
    'position', [10, 5, 80, 20], 'callback', @applyImageEnhanceUI_screen, 'cdata', [], 'String', 'Apply', ...
    'BackgroundColor', [0 0 0], 'ForegroundColor', [1 1 1], ...
    'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font4+1, 'enable', 'on');
set(handles2.apply1_qual, 'fontunits', 'normalized', 'units', 'normalized');

handles2.restore1_qual = uicontrol('parent',handles2.imagePanel_qual, 'Style', 'pushbutton', 'Visible', 'on', 'units', 'pixels', ...
    'position', [95, 5, 80, 20], 'callback', @restoreImageEnhanceUI_screen, 'cdata', [], 'String', 'Restore', ...
    'BackgroundColor', [0 0 0], 'ForegroundColor', [1 1 1], ...
    'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font4+1, 'enable', 'on');
set(handles2.restore1_qual, 'fontunits', 'normalized', 'units', 'normalized');




%---Framerate panel
handles2.frameratePanel_qual = uipanel('parent', handles2.hf_w2_advancedImage, 'Visible', 'on', 'units', 'pixels', 'position', [610, 225, 185, 80], ...
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
        'Callback', @frameratetoDrop_screen, 'enable', 'on');
elseif ispc == 1;
    handles2.frameratetoDrop_qual = uicontrol('parent', handles2.frameratePanel_qual, 'Style', 'Popupmenu', 'Visible', 'on', ...
        'units', 'pixels', 'position', [25, 8, 155, 20], 'Value', valEC, 'HorizontalAlignment', 'Center', ...
        'String', framerate_listDrop, 'ForegroundColor', [1 1 1], 'BackgroundColor', [0 0 0], ...
        'FontName', 'Book Antiqua', 'FontWeight', 'Normal', 'Fontsize', font4, ...
        'Callback', @frameratetoDrop_screen, 'enable', 'on');
end;
set(handles2.frameratetoDrop_qual, 'fontunits', 'normalized', 'units', 'normalized');


if isempty(VidInfo.FishEye) == 1;
    optimisationState = 1; %update tools for map not existing
else;
    if isempty(VidInfo.FishEye.map_xOpt) == 0;
        optimisationState = 4; %update tools for map being already optimised
    else;
        if isempty(VidInfo.FishEye.map_xIni) == 0;
            optimisationState = 3; %update tools for map existing but not optimised
        else;
            optimisationState = 2; %update tools for map not existing
        end;
    end;
end;

%---Fish eye panel
handles2.fisheyePanel_qual = uipanel('parent', handles2.hf_w2_advancedImage, 'Visible', 'on', 'units', 'pixels', 'position', [610, 5, 185, 220], ...
    'BackgroundColor', [0.2 0.2 0.2], 'Title', 'Lens Correction', 'ForegroundColor', [1 1 1], ...
    'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font4);
set(handles2.fisheyePanel_qual, 'fontunits', 'normalized', 'units', 'normalized');

%---Load fish eye
if optimisationState == 4;
    enableEC = 'off';
else;
    enableEC = 'on';
end;
handles2.loadFishEye_qual = uicontrol('parent', handles2.fisheyePanel_qual, 'Style', 'pushbutton', 'Visible', 'on', 'units', 'pixels', ...
    'position', [10, 180, 80, 20], 'callback', @loadFishEye_screen, 'cdata', [], 'String', 'Load', ...
    'BackgroundColor', [0 0 0], 'ForegroundColor', [1 1 1], ...
    'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font4, 'enable', enableEC);
set(handles2.loadFishEye_qual, 'fontunits', 'normalized', 'units', 'normalized');

%---define camera fish eye
handles2.defineFishEye_qual = uicontrol('parent', handles2.fisheyePanel_qual, 'Style', 'pushbutton', 'Visible', 'on', 'units', 'pixels', ...
    'position', [95, 180, 80, 20], 'callback', @defineFishEye_screen, 'cdata', [], 'String', 'Define', ...
    'BackgroundColor', [0 0 0], 'ForegroundColor', [1 1 1], ...
    'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font4, 'enable', enableEC);
set(handles2.defineFishEye_qual, 'fontunits', 'normalized', 'units', 'normalized');




%---Fish eye parameters options
%---Multithread
if optimisationState == 2 | optimisationState == 3;
    enableEC = 'on';
     if VidInfo.FishEye.multithreadOption == 1;
        radioEC = 1;
    else;
        radioEC = 0;
    end;
else;
    enableEC = 'off';
    radioEC = 0;
end;
handles2.multiThreadRadio_qual = uicontrol('parent', handles2.fisheyePanel_qual, 'Style', 'radio', 'Visible', 'on', 'units', 'pixels', 'position', [5, 157, 200, 20], ...
    'String', 'Multi-thread processing', 'BackgroundColor', [0.2 0.2 0.2], 'ForegroundColor', [1 1 1], 'Value' , radioEC, 'enable', enableEC, ...
    'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font4, 'HorizontalAlignment', 'left', ...
    'callback', @multiThreadSelect_screen);
set(handles2.multiThreadRadio_qual, 'tooltipstring', 'Enable multithread processing [faster but create errors]', 'fontunits', 'normalized', 'units', 'normalized');


if optimisationState == 2 | optimisationState == 3;
     if strcmpi(VidInfo.FishEye.fileFishEyeLoaded, 'defined');
        if VidInfo.FishEye.fisheyeSourceType == 1;
            radioEC = 1;
        else;
            radioEC = 0;
        end;
        enableEC = 'on';
    else;
        radioEC = 0;
        enableEC = 'off';
    end;
else;
    enableEC = 'off';
    radioEC = 0;
end;
handles2.fisheyeType1Radio_qual = uicontrol('parent', handles2.fisheyePanel_qual, 'Style', 'radio', 'Visible', 'on', 'units', 'pixels', 'position', [10, 137, 80, 20], ...
    'String', 'Pinhole 1', 'BackgroundColor', [0.2 0.2 0.2], 'ForegroundColor', [1 1 1], 'Value' , radioEC, 'enable', enableEC, ...
    'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font4, 'HorizontalAlignment', 'left', ...
    'callback', @fisheyeRadio1Select_screen);
set(handles2.fisheyeType1Radio_qual, 'tooltipstring', 'Pinhole lens model [full field]', 'fontunits', 'normalized', 'units', 'normalized');

if optimisationState == 2 | optimisationState == 3;
     if strcmpi(VidInfo.FishEye.fileFishEyeLoaded, 'defined');
        if VidInfo.FishEye.fisheyeSourceType == 2;
            radioEC = 1;
        else;
            radioEC = 0;
        end;
        enableEC = 'on';
    else;
        radioEC = 0;
        enableEC = 'off';
    end;
else;
    enableEC = 'off';
    radioEC = 0;
end;
handles2.fisheyeType2Radio_qual = uicontrol('parent', handles2.fisheyePanel_qual, 'Style', 'radio', 'Visible', 'on', 'units', 'pixels', 'position', [10, 117, 80, 20], ...
    'String', 'Pinhole 2', 'BackgroundColor', [0.2 0.2 0.2], 'ForegroundColor', [1 1 1], 'Value' , radioEC, 'enable', enableEC, ...
    'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font4, 'HorizontalAlignment', 'left', ...
    'callback', @fisheyeRadio2Select_screen);
set(handles2.fisheyeType2Radio_qual, 'tooltipstring', 'Pinhole lens model [center field]', 'fontunits', 'normalized', 'units', 'normalized');

if optimisationState == 2 | optimisationState == 3;
     if strcmpi(VidInfo.FishEye.fileFishEyeLoaded, 'defined');
        if VidInfo.FishEye.fisheyeSourceType == 3;
            radioEC = 1;
        else;
            radioEC = 0;
        end;
        enableEC = 'on';
    else;
        radioEC = 0;
        enableEC = 'off';
    end;
else;
    enableEC = 'off';
    radioEC = 0;
end;
handles2.fisheyeType3Radio_qual = uicontrol('parent', handles2.fisheyePanel_qual, 'Style', 'radio', 'Visible', 'on', 'units', 'pixels', 'position', [95, 137, 80, 20], ...
    'String', 'FishEye 1', 'BackgroundColor', [0.2 0.2 0.2], 'ForegroundColor', [1 1 1], 'Value' , radioEC, 'enable', enableEC, ...
    'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font4, 'HorizontalAlignment', 'left', ...
    'callback', @fisheyeRadio3Select_screen);
set(handles2.fisheyeType3Radio_qual, 'tooltipstring', 'FishEye lens model [full field]', 'fontunits', 'normalized', 'units', 'normalized');

if optimisationState == 2 | optimisationState == 3;
     if strcmpi(VidInfo.FishEye.fileFishEyeLoaded, 'defined');
        if VidInfo.FishEye.fisheyeSourceType == 4;
            radioEC = 1;
        else;
            radioEC = 0;
        end;
        enableEC = 'on';
    else;
        radioEC = 0;
        enableEC = 'off';
    end;
else;
    enableEC = 'off';
    radioEC = 0;
end;
handles2.fisheyeType4Radio_qual = uicontrol('parent', handles2.fisheyePanel_qual, 'Style', 'radio', 'Visible', 'on', 'units', 'pixels', 'position', [95, 117, 80, 20], ...
    'String', 'FishEye 2', 'BackgroundColor', [0.2 0.2 0.2], 'ForegroundColor', [1 1 1], 'Value' , radioEC, 'enable', enableEC, ...
    'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font4, 'HorizontalAlignment', 'left', ...
    'callback', @fisheyeRadio4Select_screen);
set(handles2.fisheyeType4Radio_qual, 'tooltipstring', 'FishEye lens model [center field]', 'fontunits', 'normalized', 'units', 'normalized');



%---Valid image
if optimisationState == 2 | optimisationState == 3;
    if strcmpi(VidInfo.FishEye.keepValid, 'Full') == 1;
        valEC = 1;
    else;
        valEC = 2;
    end;
    enableEC = 'on';
else;
    enableEC = 'off';
    valEC = 1;
end;
validFrame_listDrop = {'Keep full image'; 'Crop to valid image only'};
if ismac == 1;
    handles2.validImageDrop_qual = uicontrol('parent', handles2.fisheyePanel_qual, 'Style', 'Popupmenu', 'Visible', 'on', ...
        'units', 'pixels', 'position', [5, 95, 175, 20], 'Value', valEC, 'HorizontalAlignment', 'Center', ...
        'String', validFrame_listDrop, 'ForegroundColor', [0 0 0], 'BackgroundColor', [1 1 1], ...
        'FontName', 'Book Antiqua', 'FontWeight', 'Normal', 'Fontsize', font4, ...
        'Callback', @validFrame_listDrop_screen, 'enable', enableEC);
elseif ispc == 1;
    handles2.validImageDrop_qual = uicontrol('parent', handles2.fisheyePanel_qual, 'Style', 'Popupmenu', 'Visible', 'on', ...
        'units', 'pixels', 'position', [5, 95, 175, 20], 'Value', valEC, 'HorizontalAlignment', 'Center', ...
        'String', validFrame_listDrop, 'ForegroundColor', [1 1 1], 'BackgroundColor', [0 0 0], ...
        'FontName', 'Book Antiqua', 'FontWeight', 'Normal', 'Fontsize', font4, ...
        'Callback', @validFrame_listDrop_screen, 'enable', enableEC);
end;
set(handles2.validImageDrop_qual, 'fontunits', 'normalized', 'units', 'normalized');



%---Refine
handles2.refineTXT_qual = uicontrol('parent', handles2.fisheyePanel_qual, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', 'position', [5, 71, 50, 20], ...
    'String', 'Refine:', 'BackgroundColor', [0.2 0.2 0.2], 'ForegroundColor', [1 1 1], ...
    'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font4+1, 'HorizontalAlignment', 'Left');
set(handles2.refineTXT_qual, 'fontunits', 'normalized', 'units', 'normalized');

%point selection
if optimisationState == 3 | optimisationState == 4;
    valEC = 1;
    enableEC = 'on';

    %---need to create the point (usually created when loading param)
    for ptDLT = 1:50; 
        axes(handles2.mainVideo_qual); hold on;
        p = nsidedpoly(10, 'Center', [5 5], 'Radius', 10);
        circle = plot(p, 'FaceColor', [1 0 0], 'EdgeColor', [1 0 0], 'Visible', 'off');
        eval(['handles2.markerDLTP' num2str(ptDLT) ' = circle;']);
        clear circle;
    end;
else;
    enableEC = 'off';
    valEC = 1;
end;

%Load dlt pt
handles2.loadPtDLT_qual = uicontrol('parent', handles2.fisheyePanel_qual, 'Style', 'Pushbutton', 'Visible', 'on', 'units', 'pixels', ...
    'position', [117, 73, 18, 18], 'callback', @loadPtDLT_screen, 'cdata', imresize(handles2.icones.import_offb, [18 18]), 'enable', enableEC, ...
    'BackgroundColor', [0.26 0.26 0.26], 'ForegroundColor', [0.26 0.26 0.26], 'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'String', '');
set(handles2.loadPtDLT_qual, 'fontunits', 'normalized', 'units', 'normalized', 'tooltipstring', 'Load points');

%Save dlt pt
handles2.savePtDLT_qual = uicontrol('parent', handles2.fisheyePanel_qual, 'Style', 'Pushbutton', 'Visible', 'on', 'units', 'pixels', ...
    'position', [137, 73, 18, 18], 'callback', @savePtDLT_screen, 'cdata', imresize(handles2.icones.save_offb, [18 18]), 'enable', enableEC, ...
    'BackgroundColor', [0.26 0.26 0.26], 'ForegroundColor', [0.26 0.26 0.26], 'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'String', '');
set(handles2.savePtDLT_qual, 'fontunits', 'normalized', 'units', 'normalized', 'tooltipstring', 'Save points');

%Delete All dlt pt
handles2.deleteallPtDLT_qual = uicontrol('parent', handles2.fisheyePanel_qual, 'Style', 'Pushbutton', 'Visible', 'on', 'units', 'pixels', ...
    'position', [157, 73, 18, 18], 'callback', @deleteallPtDLT_screen, 'cdata', imresize(handles2.icones.redcross_offb, [18 18]), 'enable', enableEC, ...
    'BackgroundColor', [0.26 0.26 0.26], 'ForegroundColor', [0.26 0.26 0.26], 'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'String', '');
set(handles2.deleteallPtDLT_qual, 'fontunits', 'normalized', 'units', 'normalized', 'tooltipstring', 'Delete all points');


%list
istPointDLT{1,1} = '';
for ptEC = 1:50;
    textEC = ['Pt ' num2str(ptEC)];
    eval(['listPointDLT{' num2str(ptEC+1) ',1} = ' '''' textEC '''' ';']);
end;
if ismac == 1;
    handles2.selectPtDLT_qual = uicontrol('parent', handles2.fisheyePanel_qual, 'Style', 'Popupmenu', 'Visible', 'on', ...
        'units', 'pixels', 'position', [5, 53, 60, 20], 'Callback', @popSelectPtDLT_screen, 'enable', enableEC, ...
        'String', listPointDLT, 'ForegroundColor', [0.1 0.1 0.1], 'BackgroundColor', [1 1 1], 'value', valEC, ...
        'FontName', 'Book Antiqua', 'FontWeight', 'Bold', 'Fontsize', font4);
elseif ispc == 1;
    handles2.selectPtDLT_qual = uicontrol('parent', handles2.fisheyePanel_qual, 'Style', 'Popupmenu', 'Visible', 'on', ...
        'units', 'pixels', 'position', [15, 50, 45, 20], 'Callback', @popSelectPtDLT_screen, 'enable', enableEC, ...
        'String', listPointDLT, 'ForegroundColor', [1 1 1], 'BackgroundColor', [0.1 0.1 0.1], 'value', valEC, ...
        'FontName', 'Book Antiqua', 'FontWeight', 'Bold', 'Fontsize', font4);
end;
set(handles2.selectPtDLT_qual, 'fontunits', 'normalized', 'units', 'normalized');

%x and y coordinates boxes
handles2.selectDLTcoorX_TXT_qual = uicontrol('parent', handles2.fisheyePanel_qual, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', ...
    'position', [67, 50, 15, 20], ...
    'String', 'x:', 'BackgroundColor', [0.2 0.2 0.2], 'ForegroundColor', [1 1 1], ...
    'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font4, 'HorizontalAlignment', 'Left');
set(handles2.selectDLTcoorX_TXT_qual, 'fontunits', 'normalized', 'units', 'normalized');

handles2.selectDLTcoorX_EDIT_qual = uicontrol('parent', handles2.fisheyePanel_qual, 'Style', 'Edit', 'Visible', 'on', 'units', 'pixels', ...
    'position', [77, 53, 30, 18], 'enable', 'off', ...
    'BackgroundColor', [0 0 0], 'ForegroundColor', [1 1 1], 'callback', @coorXDLT_screen, 'String', '', ...
    'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font4, 'HorizontalAlignment', 'Center');
set(handles2.selectDLTcoorX_EDIT_qual, 'fontunits', 'normalized', 'units', 'normalized', 'tooltipstring', 'Enter frame to register the cut if frame');

handles2.selectDLTcoorY_TXT_qual = uicontrol('parent', handles2.fisheyePanel_qual, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', ...
    'position', [110, 50, 15, 20], ...
    'String', 'y:', 'BackgroundColor', [0.2 0.2 0.2], 'ForegroundColor', [1 1 1], ...
    'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font4, 'HorizontalAlignment', 'Left');
set(handles2.selectDLTcoorY_TXT_qual, 'fontunits', 'normalized', 'units', 'normalized');

handles2.selectDLTcoorY_EDIT_qual = uicontrol('parent', handles2.fisheyePanel_qual, 'Style', 'Edit', 'Visible', 'on', 'units', 'pixels', ...
    'position', [122, 53, 30, 18], 'enable', 'off', ...
    'BackgroundColor', [0 0 0], 'ForegroundColor', [1 1 1], 'callback', @coorYDLT_screen, 'String', '', ...
    'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font4, 'HorizontalAlignment', 'Center');
set(handles2.selectDLTcoorY_EDIT_qual, 'fontunits', 'normalized', 'units', 'normalized', 'tooltipstring', 'Enter frame to register the cut if frame');

%Delete dlt pt
handles2.erasePtDLT_qual = uicontrol('parent', handles2.fisheyePanel_qual, 'Style', 'Pushbutton', 'Visible', 'on', 'units', 'pixels', ...
    'position', [157, 53, 18, 18], 'callback', @erasePtDLT_screen, 'cdata', imresize(handles2.icones.eraser_offb, [18 18]), 'enable', 'off', ...
    'BackgroundColor', [0.26 0.26 0.26], 'ForegroundColor', [0.26 0.26 0.26], 'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'String', '');
set(handles2.erasePtDLT_qual, 'fontunits', 'normalized', 'units', 'normalized', 'tooltipstring', 'Delete point');


%---Apply Optimisation
if optimisationState == 4;
    enableEC = 'on';
    if VidInfo.FishEye.doOptimisation1 == 1;
        radioEC = 1;
    else;
        radioEC = 0;
    end;
else;
    enableEC = 'off';
    radioEC = 0;
end;
if ismac == 1;
    fontEC = font4-2;
elseif ispc == 1;
    fontEC = font4;
end;
handles2.applyOptimisation1_qual = uicontrol('parent', handles2.fisheyePanel_qual, 'Style', 'radio', 'Visible', 'on', 'units', 'pixels', 'position', [2, 30, 55, 20], ...
    'String', 'Optim 1', 'BackgroundColor', [0.2 0.2 0.2], 'ForegroundColor', [1 1 1], 'Value' , radioEC, 'enable', enableEC, ...
    'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', fontEC, 'HorizontalAlignment', 'left', ...
    'callback', @doOptimisation1Select_screen);
set(handles2.applyOptimisation1_qual, 'tooltipstring', 'Apply optimisation to image correction (6 points minimum)', 'fontunits', 'normalized', 'units', 'normalized');

if optimisationState == 4;
    enableEC = 'on';
    if VidInfo.FishEye.doOptimisation2 == 1;
        radioEC = 1;
    else;
        radioEC = 0;
    end;
else;
    enableEC = 'off';
    radioEC = 0;
end;
handles2.applyOptimisation2_qual = uicontrol('parent', handles2.fisheyePanel_qual, 'Style', 'radio', 'Visible', 'on', 'units', 'pixels', 'position', [58, 30, 55, 20], ...
    'String', 'Optim 2', 'BackgroundColor', [0.2 0.2 0.2], 'ForegroundColor', [1 1 1], 'Value' , radioEC, 'enable', enableEC, ...
    'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', fontEC, 'HorizontalAlignment', 'left', ...
    'callback', @doOptimisation2Select_screen);
set(handles2.applyOptimisation2_qual, 'tooltipstring', 'Apply optimisation to image correction (6 points minimum)', 'fontunits', 'normalized', 'units', 'normalized');

%---Apply top-down transformation
if optimisationState == 4;
    enableEC = 'on';
    if VidInfo.FishEye.doTopDown == 1;
        radioEC = 1;
    else;
        radioEC = 0;
    end;
else;
    enableEC = 'off';
    radioEC = 0;
end;
handles2.applyTopDown_qual = uicontrol('parent', handles2.fisheyePanel_qual, 'Style', 'radio', 'Visible', 'on', 'units', 'pixels', 'position', [114, 30, 70, 20], ...
    'String', 'Top-Down', 'BackgroundColor', [0.2 0.2 0.2], 'ForegroundColor', [1 1 1], 'Value' , radioEC, 'enable', enableEC, ...
    'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', fontEC, 'HorizontalAlignment', 'left', ...
    'callback', @doTopDownSelect_screen);
set(handles2.applyTopDown_qual, 'tooltipstring', 'Apply top-down projection to image correction (4 points minimum)', 'fontunits', 'normalized', 'units', 'normalized');




%---Apply and restore
if optimisationState == 1;
    enableEC = 'off';
else;
    enableEC = 'on';
end;
handles2.apply2_qual = uicontrol('parent',handles2.fisheyePanel_qual, 'Style', 'pushbutton', 'Visible', 'on', 'units', 'pixels', ...
    'position', [10, 5, 80, 20], 'callback', @applyFishEyeUI_screen, 'cdata', [], 'String', 'Update', ...
    'BackgroundColor', [0 0 0], 'ForegroundColor', [1 1 1], ...
    'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font4, 'enable', enableEC);
set(handles2.apply2_qual, 'fontunits', 'normalized', 'units', 'normalized');

handles2.restore2_qual = uicontrol('parent',handles2.fisheyePanel_qual, 'Style', 'pushbutton', 'Visible', 'on', 'units', 'pixels', ...
    'position', [95, 5, 80, 20], 'callback', @restoreFishEyeUI_screen, 'cdata', [], 'String', 'Restore', ...
    'BackgroundColor', [0 0 0], 'ForegroundColor', [1 1 1], ...
    'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font4, 'enable', enableEC);
set(handles2.restore2_qual, 'fontunits', 'normalized', 'units', 'normalized');



%---Save, validate and cancel
handles2.loadSession_qual = uicontrol('parent', handles2.hf_w2_advancedImage, 'Style', 'pushbutton', 'Visible', 'on', 'units', 'pixels', ...
    'position', [135, 5, 80, 25], 'callback', @loadFishEyeSession_screen, 'cdata', [], 'String', 'Load', ...
    'BackgroundColor', [0 0 0], 'ForegroundColor', [1 1 1], ...
    'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font4, 'enable', 'on');
set(handles2.loadSession_qual, 'fontunits', 'normalized', 'units', 'normalized');

handles2.cancel_qual = uicontrol('parent', handles2.hf_w2_advancedImage, 'Style', 'pushbutton', 'Visible', 'on', 'units', 'pixels', ...
    'position', [220, 5, 80, 25], 'callback', @cancelUI_screen, 'cdata', [], 'String', 'Cancel', ...
    'BackgroundColor', [0 0 0], 'ForegroundColor', [1 1 1], ...
    'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font4, 'enable', 'on');
set(handles2.cancel_qual, 'fontunits', 'normalized', 'units', 'normalized');

handles2.validate_qual = uicontrol('parent', handles2.hf_w2_advancedImage, 'Style', 'pushbutton', 'Visible', 'on', 'units', 'pixels', ...
    'position', [305, 5, 80, 25], 'callback', @validateUI_screen, 'cdata', [], 'String', 'Validate', ...
    'BackgroundColor', [0 0 0], 'ForegroundColor', [1 1 1], ...
    'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font4, 'enable', 'on');
set(handles2.validate_qual, 'fontunits', 'normalized', 'units', 'normalized');

handles2.saveSession_qual = uicontrol('parent', handles2.hf_w2_advancedImage, 'Style', 'pushbutton', 'Visible', 'on', 'units', 'pixels', ...
    'position', [390, 5, 80, 25], 'callback', @saveFishEyeSession_screen, 'cdata', [], 'String', 'Save', ...
    'BackgroundColor', [0 0 0], 'ForegroundColor', [1 1 1], ...
    'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font4, 'enable', 'on');
set(handles2.saveSession_qual, 'fontunits', 'normalized', 'units', 'normalized');


%---Update points on the image if there is any
if optimisationState == 3 | optimisationState == 4;
    %---Update control points
    axes(handles2.mainVideo_qual); hold on;
    if optimisationState == 3;
        ptDLTAll = VidInfo.FishEye.ptDLTAll;
        ptDLTValid = [];         %point for optimisation
        if isempty(ptDLTAll) == 0;
            for liEC = 1:length(ptDLTAll(:,1));
                ptEC = ptDLTAll(liEC,:);
                indexNaN = find(isnan(ptEC) == 1);
                if isempty(indexNaN) == 1;
                    %full set of points
                    ptDLTValid = [ptDLTValid; ptEC];
                end;
            end;
        end;
    elseif optimisationState == 4;
        ptDLTAll = VidInfo.FishEye.ptDLTAllOpt;
        ptDLTValid = [];         %point for optimisation
        if isempty(ptDLTAll) == 0;
            for liEC = 1:length(ptDLTAll(:,1));
                ptEC = ptDLTAll(liEC,:);
                indexNaN = find(isnan(ptEC) == 1);
                if isempty(indexNaN) == 1;
                    %full set of points
                    ptDLTValid = [ptDLTValid; ptEC];
                end;
            end;
        end;
    end;

    if isempty(ptDLTValid) == 0;
        for ptDLT = 1:50; 
            if ptDLT <= length(ptDLTValid(:,1));
                uCircle = ptDLTValid(ptDLT,1);
                vCircle = ptDLTValid(ptDLT,2);
                if isnan(uCircle) == 1;
                    p = nsidedpoly(10, 'Center', [5 5], 'Radius', 10);
                    colorEC = [1 0 0];
                    visibleEC = 'off';
                else;
                    p = nsidedpoly(10, 'Center', [uCircle vCircle], 'Radius', 10);
                    if ptEC == ptDLT;
                        %active point... green
                        colorEC = [0 1 0];
                    else;
                        %inactive point... red
                        colorEC = [1 0 0];
                    end;
                    visibleEC = 'on';
                end;
            else;
                p = nsidedpoly(10, 'Center', [5 5], 'Radius', 10);
                colorEC = [1 0 0];
                visibleEC = 'off';
            end;
            circle = plot(p, 'FaceColor', colorEC, 'EdgeColor', colorEC, 'Visible', visibleEC);
            eval(['handles2.markerDLTP' num2str(ptDLT) ' = circle;']);
            clear circle;
        end;
    end;
end;



drawnow;
handles2.VidInfo = VidInfo;
handles2.filetosave = filetosave;
% fh = findobj(0,'type','figure');
% set(0, 'CurrentFigure', fh(1).Number);
% guidata(gcf, handles2);


guidata(handles2.hf_w2_advancedImage, handles2);
uiwait(handles2.hf_w2_advancedImage);




% guidata(handles2.hf_w2_advancedImage, handles2);

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
