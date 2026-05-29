function [] = cancelProcessing_stitching(varargin);



handles = guidata(gcf);

set(handles.txtProgress_stitching, 'String', 'Clearing session ...', 'Visible', 'on');
set(handles.hf_w1_welcome, 'WindowButtonDownFcn', '');

handles.trimInValLeft_stitching = [];
handles.trimOutValLeft_stitching = [];
handles.trimInValRight_stitching = [];
handles.trimOutValRight_stitching = [];
handles.pathLeftfile_stitching = [];
handles.pathRightfile_stitching = [];
handles.VidInfoLeftStitching = [];
handles.VidInfoRightStitching = [];
handles.ptStitchingLeft = zeros(50,2); %create 50 empty points
handles.ptStitchingRight = zeros(50,2); %create 50 empty points
handles.ptDLTLeft = NaN(50,4); %create 50 empty points
handles.ptDLTRight = NaN(50,4); %create 50 empty points



set(handles.filenameLeftvid_stitching, 'String', '');
set(handles.filenameRightvid_stitching, 'String', '');



set(handles.trimInScreenPush_stitching, 'enable', 'off');
set(handles.trimInScreenEdit_stitching, 'enable', 'off', 'String', '');
set(handles.trimOutScreenPush_stitching, 'enable', 'off');
set(handles.trimOutScreenEdit_stitching, 'enable', 'off', 'String', '');



axes(handles.mainLeftVideo_stitching);
cla reset; %also delete all the stitching and dlt points
set(handles.mainLeftVideo_stitching, 'Xcolor', [0.1 0.1 0.1], 'XTick', [], ...
    'Ycolor', [0.1 0.1 0.1], 'YTick', [], ...
    'color', [0 0 0]);

axes(handles.mainRightVideo_stitching);
cla reset; %also delete all the stitching and dlt points
set(handles.mainRightVideo_stitching, 'Xcolor', [0.1 0.1 0.1], 'XTick', [], ...
    'Ycolor', [0.1 0.1 0.1], 'YTick', [], ...
    'color', [0 0 0]);
    
for ptStitching = 1:50; %left vid axes
    axes(handles.mainLeftVideo_stitching); hold on;
    p = nsidedpoly(10, 'Center', [5 5], 'Radius', 10);
    circle = plot(p, 'FaceColor', [1 0 0], 'EdgeColor', [1 0 0], 'Visible', 'off');
    eval(['handles.markerDispLeftP' num2str(ptStitching) ' = circle;']);
    clear circle;
end;
for ptStitching = 1:50; %Right vid axes
    axes(handles.mainRightVideo_stitching); hold on;
    p = nsidedpoly(10, 'Center', [5 5], 'Radius', 10);
    circle = plot(p, 'FaceColor', [1 0 0], 'EdgeColor', [1 0 0], 'Visible', 'off');
    eval(['handles.markerDispRightP' num2str(ptStitching) ' = circle;']);
    clear circle;
end;

%---Create DLT stitching points
for ptStitching = 1:50; %left vid axes
    axes(handles.mainLeftVideo_stitching); hold on;
    p = nsidedpoly(10, 'Center', [5 5], 'Radius', 10);
    circle = plot(p, 'FaceColor', [1 0 1], 'EdgeColor', [1 0 1], 'Visible', 'off');
    eval(['handles.markerDLTLeftP' num2str(ptStitching) ' = circle;']);
    clear circle;
end;
for ptStitching = 1:50; %Right vid axes
    axes(handles.mainRightVideo_stitching); hold on;
    p = nsidedpoly(10, 'Center', [5 5], 'Radius', 10);
    circle = plot(p, 'FaceColor', [1 0 1], 'EdgeColor', [1 0 1], 'Visible', 'off');
    eval(['handles.markerDLTRightP' num2str(ptStitching) ' = circle;']);
    clear circle;
end;

listPointStitch{1,1} = 'Auto';
for ptEC = 1:50;
    textEC = ['Pt ' num2str(ptEC)];
    eval(['listPointStitch{' num2str(ptEC+1) ',1} = ' '''' textEC '''' ';']);
end;
set(handles.selectPtStitching_stitching, 'String', listPointStitch, 'Value', 1, 'enable', 'off');
set(handles.erasePtStitch_stiching, 'enable', 'off');

istPointDLT{1,1} = '';
for ptEC = 1:50;
    textEC = ['Pt ' num2str(ptEC)];
    eval(['listPointDLT{' num2str(ptEC+1) ',1} = ' '''' textEC '''' ';']);
end;
set(handles.selectPtDLT_stitching, 'String', listPointStitch, 'Value', 1, 'enable', 'off');
set(handles.selectDLTcoorX_EDIT_stitching, 'String', '', 'enable', 'off');
set(handles.selectDLTcoorY_EDIT_stitching, 'String', '', 'enable', 'off');
set(handles.erasePtDLT_stiching, 'enable', 'off');



set(handles.saveCalStitch_stiching, 'enable', 'off');
set(handles.loadCalStitch_stiching, 'enable', 'off');
set(handles.previewStitch_stitching, 'enable', 'off');
set(handles.startProcessing_stitching, 'enable', 'off');
set(handles.cancelProcessing_stitching, 'enable', 'off');



handles.sliderControlLeft_push_stitching.Data = [1:10];
guidata(handles.hf_w1_welcome, handles);
handles.sliderControlLeft_push_stitching.Value = 1;
handles.sliderControlRight_push_stitching.Data = [1:10];
guidata(handles.hf_w1_welcome, handles);
handles.sliderControlRight_push_stitching.Value = 1;
set(handles.prevChapControl_push_stitching, 'enable', 'off');
set(handles.prevFrameControl_push_stitching, 'enable', 'off');
set(handles.previewStitch_stitching, 'enable', 'off');
set(handles.nextFrameControl_push_stitching, 'enable', 'off');
set(handles.nextChapControl_push_stitching, 'enable', 'off');
set(handles.frameCount_TXT_stitching, 'String', 'Frame =      /     ');
set(handles.timeCount_TXT_stitching, 'String', 'Time =      /     ');
set(handles.swapVid_push_stitching, 'enable', 'off');


set(handles.txtProgress_stitching, 'String', '', 'Visible', 'off');
guidata(handles.hf_w1_welcome, handles);

