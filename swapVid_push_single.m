function [] = swapVid_push_single(varargin)


handles = guidata(gcf);


% set(handles.loadVideoimdisplayedPanning, 'Visible', 'off');

if isempty(handles.pathPanningfile_single) == 1 |  isempty(handles.path4Kfile_single) == 1;
    return;
end;


if handles.activeVideo_single == 1;
    %Panning is on, replace it by 4K
    handles.activeVideo_single = 2;

    %---Load video data
    VidInfo = handles.VidInfo4K;
%     loadVideoimdisplayed = handles.loadVideoimdisplayed4K;
    mainVideoAxe = handles.mainVideo4K_single;

    %---Display axe
    set(handles.mainVideo4K_single, 'Visible', 'on');
    set(handles.loadVideoimdisplayed4K, 'Visible', 'on');
    uistack(handles.mainVideo4K_single, 'top');
    set(handles.mainVideo4K_single, 'xtick', [], 'xticklabels', [], 'ytick', [], 'yticklabels', []);

    set(handles.hf_w1_welcome, 'units', 'Pixels');
    posWindow = get(handles.hf_w1_welcome, 'Position');
    set(handles.hf_w1_welcome, 'units', 'Normalized');
    posSliderNew(1,1) = handles.sliderControl_push_singlePanningPositionNorm(1,1).*posWindow(1,3);
    posSliderNew(1,2) = handles.sliderControl_push_singlePanningPositionNorm(1,2).*posWindow(1,4);
    posSliderNew(1,3) = handles.sliderControl_push_singlePanningPositionNorm(1,3).*posWindow(1,3);
    posSliderNew(1,4) = handles.sliderControl_push_singlePanningPositionNorm(1,4).*posWindow(1,4);
    handles.sliderControl_push_singlePanning.Position = [0 0 1 1];
    handles.sliderControl_push_single4K.Position = posSliderNew;

    %---Change bitrate values
    set(handles.popCompression_single, 'String', handles.listDropCompression4K, 'Value', handles.listDropCompressionPos4K);

    %---Hide other axe
    set(handles.mainVideoPanning_single, 'Visible', 'off');
    try;
        set(handles.loadVideoimdisplayedPanning, 'Visible', 'off');
    end;

    %---Uodate slider
    handles.sliderControl_push_single4K.Data = [1:VidInfo.NbFrames];
    guidata(handles.hf_w1_welcome, handles);
    handles.sliderControl_push_single4K.Value = VidInfo.FrameEC;

else;
    %4K is on, replace it by panning
    handles.activeVideo_single = 1;

    %---Load video data
    VidInfo = handles.VidInfoPanning;
%     loadVideoimdisplayed = handles.loadVideoimdisplayedPanning;
    mainVideoAxe = handles.mainVideoPanning_single;
    
    %---Display axe
    set(handles.mainVideoPanning_single, 'Visible', 'on');
    set(handles.loadVideoimdisplayedPanning, 'Visible', 'on');
    uistack(handles.mainVideoPanning_single, 'top');
    set(handles.mainVideoPanning_single, 'xtick', [], 'xticklabels', [], 'ytick', [], 'yticklabels', []);
    
    set(handles.hf_w1_welcome, 'units', 'Pixels');
    posWindow = get(handles.hf_w1_welcome, 'Position');
    set(handles.hf_w1_welcome, 'units', 'Normalized');
    posSliderNew(1,1) = handles.sliderControl_push_single4KPositionNorm(1,1).*posWindow(1,3);
    posSliderNew(1,2) = handles.sliderControl_push_single4KPositionNorm(1,2).*posWindow(1,4);
    posSliderNew(1,3) = handles.sliderControl_push_single4KPositionNorm(1,3).*posWindow(1,3);
    posSliderNew(1,4) = handles.sliderControl_push_single4KPositionNorm(1,4).*posWindow(1,4);
    handles.sliderControl_push_single4K.Position = [0 0 1 1];
    handles.sliderControl_push_singlePanning.Position = posSliderNew;

    %---Change bitrate values
    set(handles.popCompression_single, 'String', handles.listDropCompressionPanning, 'Value', handles.listDropCompressionPosPanning);
    
    %---Hide other axe
    set(handles.mainVideo4K_single, 'Visible', 'off');
    try;
        set(handles.loadVideoimdisplayed4K, 'Visible', 'off');
    end;

    %---Uodate slider
    handles.sliderControl_push_singlePanning.Data = [1:VidInfo.NbFrames];
    guidata(handles.hf_w1_welcome, handles);
    handles.sliderControl_push_singlePanning.Value = VidInfo.FrameEC;
end;

%---Uodate slider
% handles.sliderControl_push_single.Data = [1:VidInfo.NbFrames];
% guidata(handles.hf_w1_welcome, handles);
% handles.sliderControl_push_single.Value = VidInfo.FrameEC;


%---Update counts
set(handles.timeCount_TXT_single, 'String', ['Time =   ' num2str(roundn(VidInfo.TimeEC,-2)) '  /  ' num2str(roundn(VidInfo.Duration,-2))]);
set(handles.frameCount_TXT_single, 'String', ['Frame =   ' num2str(VidInfo.FrameEC) '  /  ' num2str(VidInfo.NbFrames)]);

% guidata(handles.hf_w1_analyser, handles);

