function [] = swapVid_push_stitching(varargin)


handles = guidata(gcf);


% set(handles.loadVideoimdisplayedPanning, 'Visible', 'off');

if isempty(handles.pathLeftfile_stitching) == 1 |  isempty(handles.pathRightfile_stitching) == 1;
    return;
end;

if handles.activeVideo_stitching == 1;
    %Left is on, replace it by Right
    handles.activeVideo_stitching = 2;

    %---Load video data
    VidInfo = handles.VidInfoRightStitching;
%     loadVideoimdisplayed = handles.loadVideoimdisplayed4K;
    mainVideoAxe = handles.mainRightVideo_stitching;

    %---Display axe
    set(handles.mainRightVideo_stitching, 'Visible', 'on');
    set(handles.loadVideoimdisplayedStitchRight, 'Visible', 'on');
    uistack(handles.mainRightVideo_stitching, 'top');
    set(handles.mainRightVideo_stitching, 'xtick', [], 'xticklabels', [], 'ytick', [], 'yticklabels', []);

    %---Update DLT points
    if strcmpi(handles.ptcurrentDisplay, 'dlt') == 1;
        set(handles.selectPtDLT_stitching, 'Value', handles.ptDLTRight_lastSelect+1);
        if isnan(handles.ptDLTRight(handles.ptDLTRight_lastSelect,3)) == 0 & isnan(handles.ptDLTRight(handles.ptDLTRight_lastSelect,4)) == 0;
            set(handles.selectDLTcoorX_EDIT_stitching, 'String', num2str(handles.ptDLTRight(handles.ptDLTRight_lastSelect,3)));
            set(handles.selectDLTcoorY_EDIT_stitching, 'String', num2str(handles.ptDLTRight(handles.ptDLTRight_lastSelect,4)));
        else;
            set(handles.selectDLTcoorX_EDIT_stitching, 'String', '');
            set(handles.selectDLTcoorY_EDIT_stitching, 'String', '');
        end;
    else;
        set(handles.selectPtDLT_stitching, 'Value', 1);
        set(handles.selectDLTcoorX_EDIT_stitching, 'String', '');
        set(handles.selectDLTcoorY_EDIT_stitching, 'String', '');
    end;
    for ptDLT = 1:50; %left vid axes
        eval(['circleEC = handles.markerDLTRightP' num2str(ptDLT) ';']);
        if ptDLT == handles.ptDLTRight_lastSelect;
            circleEC.FaceColor = [1 1 0];
            circleEC.EdgeColor = [1 1 0]; 
        else;
            circleEC.FaceColor = [1 0 1];
            circleEC.EdgeColor = [1 0 1]; 
        end;
        if isnan(handles.ptDLTRight(ptDLT,1)) == 0 & isnan(handles.ptDLTRight(ptDLT,2)) == 0;
            if strcmpi(handles.ptcurrentDisplay, 'dlt') == 1;
                circleEC.Visible = 'on';
            else;
                circleEC.Visible = 'off';
            end;
        else;
            circleEC.Visible = 'off';
        end;
        eval(['handles.markerDLTRightP' num2str(ptDLT) ' = circleEC;']);
        clear circleEC;
    end;

    %---Update stitching points
    if strcmpi(handles.ptcurrentDisplay, 'stitch') == 1;
        set(handles.selectPtStitching_stitching, 'Value', handles.ptStitichingRight_lastSelect+1);
    else;
        set(handles.selectPtStitching_stitching, 'Value', 1);
    end;
    for ptStitching = 1:50; %left vid axes
        eval(['circleEC = handles.markerDispRightP' num2str(ptStitching) ';']);
        if ptStitching == handles.ptStitichingRight_lastSelect;
            circleEC.FaceColor = [0 1 0];
            circleEC.EdgeColor = [0 1 0]; 
        else;
            circleEC.FaceColor = [1 0 0];
            circleEC.EdgeColor = [1 0 0]; 
        end;
        if handles.ptStitchingRight(ptStitching,1) ~= 0 & handles.ptStitchingRight(ptStitching,2) ~= 0;
            if strcmpi(handles.ptcurrentDisplay, 'stitch') == 1;
                circleEC.Visible = 'on';
            else;
                circleEC.Visible = 'off';
            end;
        else;
            circleEC.Visible = 'off';
        end;
        eval(['handles.markerDispRightP' num2str(ptStitching) ' = circleEC;']);
        clear circleEC;
    end;

    set(handles.hf_w1_welcome, 'units', 'Pixels');
    posWindow = get(handles.hf_w1_welcome, 'Position');
    set(handles.hf_w1_welcome, 'units', 'Normalized');
    posSliderNew(1,1) = handles.sliderControlLeft_push_stitchingPositionNorm(1,1).*posWindow(1,3);
    posSliderNew(1,2) = handles.sliderControlLeft_push_stitchingPositionNorm(1,2).*posWindow(1,4);
    posSliderNew(1,3) = handles.sliderControlLeft_push_stitchingPositionNorm(1,3).*posWindow(1,3);
    posSliderNew(1,4) = handles.sliderControlLeft_push_stitchingPositionNorm(1,4).*posWindow(1,4);
    handles.sliderControlLeft_push_stitching.Position = [0 0 1 1];
    handles.sliderControlRight_push_stitching.Position = posSliderNew;

    %---Change bitrate values
%     set(handles.popCompression_single, 'String', handles.listDropCompression4K, 'Value', handles.listDropCompressionPos4K);

    %---Hide other axe
    set(handles.mainLeftVideo_stitching, 'Visible', 'off');
    try;
        set(handles.loadVideoimdisplayedStitchLeft, 'Visible', 'off');
    end;

    %---Uodate slider
    handles.sliderControlRight_push_stitching.Data = [1:VidInfo.NbFrames];
    guidata(handles.hf_w1_welcome, handles);
    handles.sliderControlRight_push_stitching.Value = VidInfo.FrameEC;

    %---Update trim in and out boxes
    set(handles.trimInScreenEdit_stitching, 'String', num2str(handles.trimInValRight_stitching));
    set(handles.trimOutScreenEdit_stitching, 'String', num2str(handles.trimOutValRight_stitching));

else;
    %Right is on, replace it by Left
    handles.activeVideo_stitching = 1;

    %---Load video data
    VidInfo = handles.VidInfoLeftStitching;

%     loadVideoimdisplayed = handles.loadVideoimdisplayedPanning;
    mainVideoAxe = handles.mainLeftVideo_stitching;
    
    %---Display axe
    set(handles.mainLeftVideo_stitching, 'Visible', 'on');
    set(handles.loadVideoimdisplayedStitchLeft, 'Visible', 'on');
    uistack(handles.mainLeftVideo_stitching, 'top');
    set(handles.mainLeftVideo_stitching, 'xtick', [], 'xticklabels', [], 'ytick', [], 'yticklabels', []);
    
    %---Update DLT points
    if strcmpi(handles.ptcurrentDisplay, 'dlt') == 1;
        set(handles.selectPtDLT_stitching, 'Value', handles.ptDLTLeft_lastSelect+1);
        if isnan(handles.ptDLTLeft(handles.ptDLTLeft_lastSelect,3)) == 0 & isnan(handles.ptDLTLeft(handles.ptDLTLeft_lastSelect,4)) == 0
            set(handles.selectDLTcoorX_EDIT_stitching, 'String', num2str(handles.ptDLTLeft(handles.ptDLTLeft_lastSelect,3)));
            set(handles.selectDLTcoorY_EDIT_stitching, 'String', num2str(handles.ptDLTLeft(handles.ptDLTLeft_lastSelect,4)));
        else;
            set(handles.selectDLTcoorX_EDIT_stitching, 'String', '');
            set(handles.selectDLTcoorY_EDIT_stitching, 'String', '');
        end;
    else;
        set(handles.selectPtDLT_stitching, 'Value', 1);
        set(handles.selectDLTcoorX_EDIT_stitching, 'String', '');
        set(handles.selectDLTcoorY_EDIT_stitching, 'String', '');
    end;
    for ptDLT = 1:50; %left vid axes
        eval(['circleEC = handles.markerDLTLeftP' num2str(ptDLT) ';']);
        if ptDLT == handles.ptDLTLeft_lastSelect;
            circleEC.FaceColor = [1 1 0];
            circleEC.EdgeColor = [1 1 0]; 
        else;
            circleEC.FaceColor = [1 0 1];
            circleEC.EdgeColor = [1 0 1]; 
        end;
        if isnan(handles.ptDLTLeft(ptDLT,1)) == 0 & isnan(handles.ptDLTLeft(ptDLT,2)) == 0;
            if strcmpi(handles.ptcurrentDisplay, 'dlt') == 1;
                circleEC.Visible = 'on';
            else;
                circleEC.Visible = 'off';
            end;
        else;
            circleEC.Visible = 'off';
        end;
        eval(['handles.markerDLTLeftP' num2str(ptDLT) ' = circleEC;']);
        clear circleEC;
    end;




    %---Update stitching points
    if strcmpi(handles.ptcurrentDisplay, 'stitch') == 1;
        set(handles.selectPtStitching_stitching, 'Value', handles.ptStitichingLeft_lastSelect+1);
    else;
        set(handles.selectPtStitching_stitching, 'Value', 1);
    end;
    for ptStitching = 1:50; %left vid axes
        eval(['circleEC = handles.markerDispLeftP' num2str(ptStitching) ';']);
        if ptStitching == handles.ptStitichingLeft_lastSelect;
            circleEC.FaceColor = [0 1 0];
            circleEC.EdgeColor = [0 1 0]; 
        else;
            circleEC.FaceColor = [1 0 0];
            circleEC.EdgeColor = [1 0 0]; 
        end;
        if handles.ptStitchingRight(ptStitching,1) ~= 0 & handles.ptStitchingLeft(ptStitching,2) ~= 0;
            if strcmpi(handles.ptcurrentDisplay, 'stitch') == 1;
                circleEC.Visible = 'on';
            else;
                circleEC.Visible = 'off';
            end;
        else;
            circleEC.Visible = 'off';
        end;
        eval(['handles.markerDispLeftP' num2str(ptStitching) ' = circleEC;']);
        clear circleEC;
    end;

    set(handles.hf_w1_welcome, 'units', 'Pixels');
    posWindow = get(handles.hf_w1_welcome, 'Position');
    set(handles.hf_w1_welcome, 'units', 'Normalized');
    posSliderNew(1,1) = handles.sliderControlRight_push_stitchingPositionNorm(1,1).*posWindow(1,3);
    posSliderNew(1,2) = handles.sliderControlRight_push_stitchingPositionNorm(1,2).*posWindow(1,4);
    posSliderNew(1,3) = handles.sliderControlRight_push_stitchingPositionNorm(1,3).*posWindow(1,3);
    posSliderNew(1,4) = handles.sliderControlRight_push_stitchingPositionNorm(1,4).*posWindow(1,4);
    handles.sliderControlRight_push_stitching.Position = [0 0 1 1];
    handles.sliderControlLeft_push_stitching.Position = posSliderNew;

    %---Change bitrate values
%     set(handles.popCompression_single, 'String', handles.listDropCompressionPanning, 'Value', handles.listDropCompressionPosPanning);
    
    %---Hide other axe
    set(handles.mainRightVideo_stitching, 'Visible', 'off');
    try;
        set(handles.loadVideoimdisplayedStitchRight, 'Visible', 'off');
    end;

    %---Uodate slider
    handles.sliderControlLeft_push_stitching.Data = [1:VidInfo.NbFrames];
    guidata(handles.hf_w1_welcome, handles);
    handles.sliderControlLeft_push_stitching.Value = VidInfo.FrameEC;

    %---Update trim in and out boxes
    set(handles.trimInScreenEdit_stitching, 'String', num2str(handles.trimInValLeft_stitching));
    set(handles.trimOutScreenEdit_stitching, 'String', num2str(handles.trimOutValLeft_stitching));
end;


%---Update counts
set(handles.timeCount_TXT_stitching, 'String', ['Time =   ' num2str(roundn(VidInfo.TimeEC,-2)) '  /  ' num2str(roundn(VidInfo.Duration,-2))]);
set(handles.frameCount_TXT_stitching, 'String', ['Frame =   ' num2str(VidInfo.FrameEC) '  /  ' num2str(VidInfo.NbFrames)]);


% guidata(handles.hf_w1_analyser, handles);

