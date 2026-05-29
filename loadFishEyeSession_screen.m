function loadFishEyeSession_screen(varargin);



handles2 = guidata(gcf);

[file,path] = uigetfile({'*.*';'*.MAT';'*.mat'},...
                      'Select your session file', handles2.defaultpath);

if file == 0
    return;
end;

%-------------------------------Load data----------------------------------
filename = [path file];
set(handles2.mainInfos_qual, 'String', 'Loading session ...');
drawnow;
load(filename);


handles2.VidInfo.ImageEnhance.Contract = VidInfo.ImageEnhance.Contract;
handles2.VidInfo.ImageEnhance.Brightness = VidInfo.ImageEnhance.Brightness;
handles2.VidInfo.isexportRateDefault = VidInfo.isexportRateDefault;
handles2.VidInfo.exportRate = VidInfo.exportRate;
if isempty(VidInfo.FishEye) == 0;
    handles2.VidInfo.FishEye.fileFishEyeName = VidInfo.FishEye.fileFishEyeName;
    handles2.VidInfo.FishEye.fileFishEyeLoaded = VidInfo.FishEye.fileFishEyeLoaded;
    handles2.VidInfo.FishEye.param = VidInfo.FishEye.param;
    handles2.VidInfo.FishEye.paramIni = VidInfo.FishEye.paramIni;
    handles2.VidInfo.FishEye.paramOpt = VidInfo.FishEye.paramOpt;
    handles2.VidInfo.FishEye.ptDLTAll = VidInfo.FishEye.ptDLTAll;
    handles2.VidInfo.FishEye.ptDLTAllOri = VidInfo.FishEye.ptDLTAllOri;
    handles2.VidInfo.FishEye.ptDLTAllOpt = VidInfo.FishEye.ptDLTAllOpt;
    handles2.VidInfo.FishEye.map_xIni = VidInfo.FishEye.map_xIni;
    handles2.VidInfo.FishEye.map_yIni = VidInfo.FishEye.map_yIni;
    handles2.VidInfo.FishEye.map_xOpt = VidInfo.FishEye.map_xOpt;
    handles2.VidInfo.FishEye.map_yOpt = VidInfo.FishEye.map_yOpt;
    handles2.VidInfo.FishEye.extraMappingParamsIni = VidInfo.FishEye.extraMappingParamsIni;
    handles2.VidInfo.FishEye.extraMappingParamsOpt = VidInfo.FishEye.extraMappingParamsOpt;
    handles2.VidInfo.FishEye.doOptimisation1 = VidInfo.FishEye.doOptimisation1;
    handles2.VidInfo.FishEye.doOptimisation2 = VidInfo.FishEye.doOptimisation2;
    handles2.VidInfo.FishEye.doTopDown = VidInfo.FishEye.doTopDown;
    handles2.VidInfo.FishEye.multithreadOption = VidInfo.FishEye.multithreadOption;
    handles2.VidInfo.ActiveFrameIni = VidInfo.ActiveFrameIni;
    handles2.VidInfo.ActiveFrameOpt = VidInfo.ActiveFrameOpt;
    handles2.VidInfo.FishEye.keepValid = VidInfo.FishEye.keepValid;
    handles2.VidInfo.FishEye.fisheyeSourceType = VidInfo.FishEye.fisheyeSourceType;

    map_x = VidInfo.FishEye.map_xIni;
    map_y = VidInfo.FishEye.map_yIni;

    ptDLTAll = VidInfo.FishEye.ptDLTAll;
    ptDLTValid = [];         %point for optimisation
    for liEC = 1:length(ptDLTAll(:,1));
        ptEC = ptDLTAll(liEC,:);
        indexNaN = find(isnan(ptEC) == 1);
        if isempty(indexNaN) == 1;
            %full set of points
            ptDLTValid = [ptDLTValid; ptEC];
        end;
    end;
end;

VidInfo = handles2.VidInfo;
%--------------------------------------------------------------------------




%--------------------------Refresh UI options------------------------------
%---Contrast
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
set(handles2.dropdownContrast_qual, 'value', valEC);

%---Brightness
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
set(handles2.dropdownBrightness_qual, 'value', valEC);

%---Framerate
if VidInfo.isexportRateDefault == 1;
    valEC = 1;
else;
    if VidInfo.exportRate == 25;
        valEC = 3;
    elseif VidInfo.exportRate == 50;
        valEC = 2;
    end;
end;
set(handles2.frameratetoDrop_qual, 'value', valEC);




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

%---Load fish eye
if optimisationState == 4;
    enableEC = 'off';
else;
    enableEC = 'on';
end;
set(handles2.loadFishEye_qual, 'enable', enableEC);
set(handles2.defineFishEye_qual, 'enable', enableEC);

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
set(handles2.multiThreadRadio_qual, 'value', radioEC, 'enable', enableEC);

%---parameter type radio button
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
set(handles2.fisheyeType1Radio_qual, 'value', radioEC, 'enable', enableEC);
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
set(handles2.fisheyeType2Radio_qual, 'value', radioEC, 'enable', enableEC);
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
set(handles2.fisheyeType3Radio_qual, 'value', radioEC, 'enable', enableEC);
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
set(handles2.fisheyeType4Radio_qual, 'value', radioEC, 'enable', enableEC);

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
set(handles2.validImageDrop_qual, 'value', valEC, 'enable', enableEC);

%---Refine list
if optimisationState == 4;
    valEC = 1;
    enableEC = 'on';
else;
    enableEC = 'off';
    valEC = 1;
end;
set(handles2.selectPtDLT_qual, 'enable', enableEC, 'value', valEC);

%---Refine pt X
set(handles2.selectDLTcoorX_EDIT_qual, 'enable', 'off', 'string', '');
set(handles2.selectDLTcoorY_EDIT_qual, 'enable', 'off', 'string', '');
set(handles2.erasePtDLT_qual, 'enable', 'off');

%---apply optimisation
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
set(handles2.applyOptimisation1_qual, 'enable', enableEC, 'value', radioEC);

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
set(handles2.applyOptimisation2_qual, 'enable', enableEC, 'value', radioEC);

%---Apply top down
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
set(handles2.applyTopDown_qual, 'enable', enableEC, 'value', radioEC);

%---Update & restore
if optimisationState == 1;
    enableEC = 'off';
else;
    enableEC = 'on';
end;
set(handles2.apply2_qual, 'enable', enableEC);
set(handles2.restore2_qual, 'enable', enableEC);

handles2.correctionUpdateTrigger = 'load';
guidata(handles2.hf_w2_advancedImage, handles2);
drawnow;
%--------------------------------------------------------------------------


%------------------------Apply setting to image----------------------------
if optimisationState == 1 | optimisationState == 2;
    %----------No fisheye data

    frame = VidInfo.ActiveFrame;
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
    handles2.correctionUpdateTrigger = 'new';
    guidata(handles2.hf_w2_advancedImage, handles2);

    
    set(handles2.mainInfos_qual, 'String', '');
else;
    %-----------Fisheye data
    applyFishEyeUI_screen;
end;

