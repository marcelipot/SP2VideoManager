function [] = sliderControl_push_single(src,eventData)


handles = guidata(gcf);

if get(handles.singleFilePanel_single, 'Visible') == 1;
    isVidActive = handles.activeVideo_single;
    isModuleActive = 1;
elseif get(handles.screenPanel_screen, 'Visible') == 1;
    isVidActive = handles.pathSceenfile_screen;
    isModuleActive = 2;
elseif get(handles.relayPanel_relay, 'Visible') == 1;
    isVidActive = handles.pathRelayfile_relay;
    isModuleActive = 3;
elseif get(handles.stitchingPanel_stiching, 'Visible') == 1;
    isVidActive = handles.activeVideo_stitching;
    isModuleActive = 4;
end;

if isempty(isVidActive) == 1;
    handles.sourceSlider = 0;
    return;
end;


if isModuleActive == 1;
    if handles.activeVideo_single == 1;
        if isempty(handles.pathPanningfile_single) == 1;
            return;
        end;
        VidInfo = handles.VidInfoPanning;
        if isfield(handles, 'loadVideoimdisplayedPanning') == 1;
            loadVideoimdisplayed = handles.loadVideoimdisplayedPanning;
        else;
            loadVideoimdisplayed = [];
        end;
        mainVideoAxe = handles.mainVideoPanning_single;
        sliderActive = handles.sliderControl_push_singlePanning;
    else;
        if isempty(handles.path4Kfile_single) == 1;
            return;
        end;
        VidInfo = handles.VidInfo4K;
        if isfield(handles, 'loadVideoimdisplayed4K') == 1;
            loadVideoimdisplayed = handles.loadVideoimdisplayed4K;
        else;
            loadVideoimdisplayed = [];
        end;
        mainVideoAxe = handles.mainVideo4K_single;
        sliderActive = handles.sliderControl_push_single4K;
    end;

    frameCount_TXTActive = handles.frameCount_TXT_single;
    timeCount_TXTActive = handles.timeCount_TXT_single;

elseif isModuleActive == 2;
    VidInfo = handles.VidInfoScreen;
    if isfield(handles, 'loadVideoimdisplayedScreen') == 1;
        loadVideoimdisplayed = handles.loadVideoimdisplayedScreen;
    else;
        loadVideoimdisplayed = [];
    end;
    mainVideoAxe = handles.mainVideoScreen_screen;

    sliderActive = handles.sliderControl_push_screen;
    frameCount_TXTActive = handles.frameCount_TXT_screen;
    timeCount_TXTActive = handles.timeCount_TXT_screen;

elseif isModuleActive == 3;
    VidInfo = handles.VidInfoRelay;
    loadVideoimdisplayed = handles.loadVideoimdisplayedRelay;
    if isfield(handles, 'loadVideoimdisplayedRelay') == 1;
        loadVideoimdisplayed = handles.loadVideoimdisplayedRelay;
    else;
        loadVideoimdisplayed = [];
    end;
    mainVideoAxe = handles.mainVideoRelay_relay;

    sliderActive = handles.sliderControl_push_relay;
    frameCount_TXTActive = handles.frameCount_TXT_relay;
    timeCount_TXTActive = handles.timeCount_TXT_relay;

elseif isModuleActive == 4;
    if handles.activeVideo_stitching == 1;
        if isempty(handles.pathLeftfile_stitching) == 1;
            return;
        end;
        VidInfo = handles.VidInfoLeftStitching;
        if isfield(handles, 'loadVideoimdisplayedStitchLeft') == 1;
            loadVideoimdisplayed = handles.loadVideoimdisplayedStitchLeft;
        else;
            loadVideoimdisplayed = [];
        end;
        mainVideoAxe = handles.mainLeftVideo_stitching;
    
        sliderActive = handles.sliderControlLeft_push_stitching;
        frameCount_TXTActive = handles.frameCount_TXT_stitching;
        timeCount_TXTActive = handles.timeCount_TXT_stitching;
    else;
        if isempty(handles.pathRightfile_stitching) == 1;
            return;
        end;
        VidInfo = handles.VidInfoRightStitching;
        if isfield(handles, 'loadVideoimdisplayedStitchRight') == 1;
            loadVideoimdisplayed = handles.loadVideoimdisplayedStitchRight;
        else;
            loadVideoimdisplayed = [];
        end;
        mainVideoAxe = handles.mainRightVideo_stitching;
    
        sliderActive = handles.sliderControlRight_push_stitching;
        frameCount_TXTActive = handles.frameCount_TXT_stitching;
        timeCount_TXTActive = handles.timeCount_TXT_stitching;
    end;
end;

if handles.sourceSlider == 0;
    jumpFrame = sliderActive.Value - VidInfo.FrameEC;
    FrameECSave = VidInfo.FrameEC;
    TimeECSave = VidInfo.TimeEC;
    
    VidInfo.FrameEC  = VidInfo.FrameEC + jumpFrame;
    VidInfo.TimeEC  = VidInfo.TimeEC + (jumpFrame.*(1/VidInfo.Rate));
else;
    VidInfo.TimeEC = (VidInfo.FrameEC./VidInfo.Rate) - (1/VidInfo.Rate);
end;

try;
    frame = read(VidInfo.VidObj, VidInfo.FrameEC);
catch;
    jumpFrame = jumpFrame - 1;

    VidInfo.FrameEC  = VidInfo.FrameEC + jumpFrame;
    VidInfo.TimeEC  = VidInfo.TimeEC + (jumpFrame.*(1/VidInfo.Rate));

    try;
        frame = read(VidInfo.VidObj, VidInfo.FrameEC);
    catch;
        jumpFrame = jumpFrame - 1;
        VidInfo.FrameEC  = FrameECSave + jumpFrame;
        VidInfo.TimeEC  = TimeECSave + (jumpFrame.*(1/VidInfo.Rate));
        try;
            frame = read(VidInfo.VidObj, VidInfo.FrameEC);
        catch;
            jumpFrame = jumpFrame - 1;
            VidInfo.FrameEC  = FrameECSave + jumpFrame;

            VidInfo.TimeEC  = TimeECSave + (jumpFrame.*(1/VidInfo.Rate));
            frame = read(VidInfo.VidObj, VidInfo.FrameEC);
        end;
    end;
end;
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
            frameProcessed = frame(rowsFrom:rowsTo,:,:);
            frame = imresize(frameProcessed, [2160 3840], 'nearest');

        elseif roundn(cols./rows,-3) > roundn(16/9,-3);
            %they are too many cols... need to add black rows to have 16/9 ratio
            nbrowsTOT = (cols.*9)./16;
            missingRows = floor((rows-nbrowsTOT)./2); 
            frame2a1 = zeros(missingRows,cols);
%                         frame2a2 = [frame2a1; frame(:,:,1); frame2a1];
            frame2a2 = cat(1,frame2a1,frame(:,:,1),frame2a1);
%                         frame2b1 = zeros(missingRows,cols);
%                         frame2b2 = [frame2b1; frame(:,:,2); frame2b1];
            frame2b2 = cat(1,frame2a1,frame(:,:,2),frame2a1);
%                         frame2c1 = zeros(missingRows,cols);
%                         frame2c2 = [frame2c1; frame(:,:,3); frame2c1];
            frame2c2 = cat(1,frame2a1,frame(:,:,3),frame2a1);

%                         frameProcessed = cat(3,frame2a2,frame2b2,frame2c2);
            frameProcessed = cat(3,frame2a2,frame2b2,frame2c2);
%                         frame(:,:,1) = frame2a2;
%                         frame(:,:,2) = frame2b2;
%                         frame(:,:,3) = frame2c2;
            frame = imresize(frameProcessed, [2160 3840], 'nearest');
        else;
            %no need to change the ratio
            %already 16/9
        end;

    elseif strcmpi(VidInfo.FishEye.keepValid, 'Valid');
        %Crop the image to 16/9
        [checkH, checkW, ~] = size(frame);
        if checkH > 2160 & checkW > 3840;
            midFrameRows = (rows./2) - 2160./2;
            midFrameCols = (cols./2) - 3840./2;
            posRec = [midFrameCols midFrameRows 3840 2160];

            frame = imcrop(frame, posRec);    
        end;
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
VidInfo.xlimValCurrent = get(mainVideoAxe, 'xlim');
VidInfo.ylimValCurrent = get(mainVideoAxe, 'ylim');

if isempty(loadVideoimdisplayed) == 0;
    %field exist
    if isvalid(loadVideoimdisplayed) == 1;
        %exist and valid
        set(loadVideoimdisplayed, 'cdata', frame);
    else;
        %not valid: need to create it again
        axes(mainVideoAxe);
        loadVideoimdisplayed = imshow(frame);
    end;
else;
    %create field
    axes(mainVideoAxe);
    loadVideoimdisplayed = imshow(frame);
end;
set(mainVideoAxe, 'xtick', [], 'xticklabels', [], 'ytick', [], 'yticklabels', []);
xlim(mainVideoAxe, VidInfo.xlimValCurrent);
ylim(mainVideoAxe, VidInfo.ylimValCurrent);


%---Update time and frame count
set(frameCount_TXTActive, 'String', ['Frame =   ' num2str(VidInfo.FrameEC) '  /  ' num2str(VidInfo.NbFrames)]);
set(timeCount_TXTActive, 'String', ['Time =   ' num2str(roundn(VidInfo.TimeEC,-2)) '  /  ' num2str(roundn(VidInfo.Duration,-2))]);
drawnow;


%---Save info
if isModuleActive == 1;
    if handles.activeVideo_single == 1;
        handles.VidInfoPanning = VidInfo;
        handles.mainVideoPanning_single = mainVideoAxe;
        handles.loadVideoimdisplayedPanning = loadVideoimdisplayed;
        handles.sliderControl_push_singlePanning = sliderActive;
    else;
        handles.VidInfo4K = VidInfo;
        handles.mainVideo4K_single = mainVideoAxe;
        handles.loadVideoimdisplayed4K = loadVideoimdisplayed;
        handles.sliderControl_push_single4K = sliderActive;
    end;
    handles.frameCount_TXT_single = frameCount_TXTActive;
    handles.timeCount_TXT_single = timeCount_TXTActive;

elseif isModuleActive == 2;
    handles.VidInfoScreen = VidInfo;
    handles.loadVideoimdisplayedScreen = loadVideoimdisplayed;
    handles.mainVideoScreen_screen = mainVideoAxe;

    handles.sliderControl_push_screen = sliderActive;
    handles.frameCount_TXT_screen = frameCount_TXTActive;
    handles.timeCount_TXT_screen = timeCount_TXTActive;

elseif isModuleActive == 3;
    handles.VidInfoRelay = VidInfo;
    handles.loadVideoimdisplayedRelay = loadVideoimdisplayed;
    handles.mainVideoScreen_relay = mainVideoAxe;

    handles.sliderControl_push_relay = sliderActive;
    handles.frameCount_TXT_relay = frameCount_TXTActive;
    handles.timeCount_TXT_relay = timeCount_TXTActive;

elseif isModuleActive == 4;
    if handles.activeVideo_stitching == 1;
        handles.VidInfoLeftStitching = VidInfo;
        handles.mainLeftVideo_stitching = mainVideoAxe;
        handles.loadVideoimdisplayedStitchLeft = loadVideoimdisplayed;
        handles.sliderControlLeft_push_stitching = sliderActive;
    else;
        handles.VidInfoRightStitching = VidInfo;
        handles.mainRightVideo_stitching = mainVideoAxe;
        handles.loadVideoimdisplayedStitchRight = loadVideoimdisplayed;
        handles.sliderControlRight_push_stitching = sliderActive;
    end;
    handles.frameCount_TXT_stitching = frameCount_TXTActive;
    handles.timeCount_TXT_stitching = timeCount_TXTActive;
end;
handles.sourceSlider = 0;

guidata(handles.hf_w1_welcome, handles);

