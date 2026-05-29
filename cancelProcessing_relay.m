function [] = cancelProcessing_relay(varargin);



handles = guidata(gcf);
set(handles.hf_w1_welcome, 'WindowButtonDownFcn', '');

handles.pathRelayfile_relay = [];
handles.feetoffVal_relay = [];
handles.trimOutVal_relay = [];
handles.RTVal_relay = [];


set(handles.filenameRelay_relay, 'String', '');
set(handles.feetOffRelayPush_relay, 'enable', 'off');
set(handles.feetOffRelayEdit_relay, 'String', '', 'enable', 'off');
set(handles.trimOutRelayPush_relay, 'enable', 'off');
set(handles.trimOutRelayEdit_relay, 'String', '', 'enable', 'off');
set(handles.RTEditRelay_relay, 'String', '', 'enable', 'off');
set(handles.popCompression_relay, 'String', 'Not available', 'Value', 1, 'enable', 'off');
set(handles.txtProgress_relay, 'String', 'off', 'Visible', 'off');
set(handles.startProcessing_relay, 'enable', 'off');
set(handles.cancelProcessing_relay, 'enable', 'off');

axes(handles.mainVideoRelay_relay);
cla reset;
set(handles.mainVideoRelay_relay, 'Xcolor', [0.1 0.1 0.1], 'XTick', [], ...
    'Ycolor', [0.1 0.1 0.1], 'YTick', [], ...
    'color', [0 0 0]);


guidata(handles.hf_w1_welcome, handles);
handles.sliderControl_push_relay.Value = 1;

set(handles.prevChapControl_push_relay, 'enable', 'off');
set(handles.prevFrameControl_push_relay, 'enable', 'off');
set(handles.nextFrameControl_push_relay, 'enable', 'off');
set(handles.nextChap_push_relay, 'enable', 'off');
set(handles.frameCount_TXT_relay, 'String', 'Frame =      /     ');
set(handles.timeCount_TXT_relay, 'String', 'Time =      /     ');

guidata(handles.hf_w1_welcome, handles);

