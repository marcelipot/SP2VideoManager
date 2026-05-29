function [] = nextFrameControl_push_single(varargin)


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
    return;
end;
handles.sourceSlider = 1;

if isModuleActive == 1;
    if handles.activeVideo_single == 1;
        if isempty(handles.pathPanningfile_single) == 1;
            return;
        end;
        VidInfo = handles.VidInfoPanning;
        sliderActive = handles.sliderControl_push_singlePanning;
    else;
        if isempty(handles.path4Kfile_single) == 1;
            return;
        end;
        VidInfo = handles.VidInfo4K;
        sliderActive = handles.sliderControl_push_single4K;
    end;

elseif isModuleActive == 2;
    VidInfo = handles.VidInfoScreen;
    sliderActive = handles.sliderControl_push_screen;

elseif isModuleActive == 3;
    VidInfo = handles.VidInfoRelay;
    sliderActive = handles.sliderControl_push_relay;

elseif isModuleActive == 4;
    if handles.activeVideo_stitching == 1;
        VidInfo = handles.VidInfoLeftStitching;
        sliderActive = handles.sliderControlLeft_push_stitching;
    else;
        VidInfo = handles.VidInfoRightStitching;
        sliderActive = handles.sliderControlRight_push_stitching;
    end;
end;


jumpFrame = 1;
if VidInfo.NbFrames == 1;
    return;
end;

if VidInfo.FrameEC+jumpFrame > VidInfo.NbFrames;
    jumpFrame = -VidInfo.FrameEC + 1;
end;
VidInfo.FrameEC  = VidInfo.FrameEC + jumpFrame;

if VidInfo.FrameEC > VidInfo.NbFrames;
    VidInfo.FrameEC = 1;
end;

if isModuleActive == 1;
    if handles.activeVideo_single == 1;
        handles.VidInfoPanning = VidInfo;
    else;
        handles.VidInfo4K = VidInfo;
    end;
    
elseif isModuleActive == 2;
    handles.VidInfoScreen = VidInfo;
    
elseif isModuleActive == 3;
    handles.VidInfoRelay = VidInfo;

elseif isModuleActive == 4;
    if handles.activeVideo_stitching == 1;
        handles.VidInfoLeftStitching = VidInfo;
    else;
        handles.VidInfoRightStitching = VidInfo;
    end;
end;
guidata(handles.hf_w1_welcome, handles);

sliderActive.Value = VidInfo.FrameEC;

