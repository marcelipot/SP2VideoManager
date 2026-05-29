function [] = cancelProcessing_single(varargin);



handles = guidata(gcf);
set(handles.hf_w1_welcome, 'WindowButtonDownFcn', '');

handles.feefoffpanningVal_single = [];
handles.feefoff4KVal_single = [];
handles.path4Kfile_single = [];
handles.pathPanningfile_single = [];
handles.activeVideo_single = [];


set(handles.filenamePanning_single, 'String', '');
set(handles.filename4K_single, 'String', '');
set(handles.registerfeetoffPanningPush_single, 'enable', 'off');
set(handles.registerfeetoffPanningEdit_single, 'String', '', 'enable', 'off');
set(handles.registerfeetoff4KPush_single, 'enable', 'off');
set(handles.registerfeetoff4KEdit_single, 'String', '', 'enable', 'off');
set(handles.popCompression_single, 'String', 'Not available', 'Value', 1, 'enable', 'off');
set(handles.txtProgress_single, 'String', 'off', 'Visible', 'off');

axes(handles.mainVideoPanning_single);
cla reset;
set(handles.mainVideoPanning_single, 'Xcolor', [0.1 0.1 0.1], 'XTick', [], ...
    'Ycolor', [0.1 0.1 0.1], 'YTick', [], ...
    'color', [0 0 0]);

axes(handles.mainVideo4K_single);
cla reset;
set(handles.mainVideo4K_single, 'Xcolor', [0.1 0.1 0.1], 'XTick', [], ...
    'Ycolor', [0.1 0.1 0.1], 'YTick', [], ...
    'color', [0 0 0]);

% handles.sliderControl_push_single.Data = [1:10];
guidata(handles.hf_w1_welcome, handles);
handles.sliderControl_push_singlePanning.Value = 1;
handles.sliderControl_push_single4K.Value = 1;

set(handles.prevChapControl_push_single, 'enable', 'off');
set(handles.prevFrameControl_push_single, 'enable', 'off');
set(handles.nextFrameControl_push_single, 'enable', 'off');
set(handles.nextChap_push_single, 'enable', 'off');
set(handles.frameCount_TXT_single, 'String', 'Frame =      /     ');
set(handles.timeCount_TXT_single, 'String', 'Time =      /     ');
set(handles.swapVid_push_single, 'enable', 'off');

guidata(handles.hf_w1_welcome, handles);

