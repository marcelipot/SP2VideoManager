function [] = cancelProcessing_screen(varargin);



handles = guidata(gcf);
set(handles.hf_w1_welcome, 'WindowButtonDownFcn', '');

handles.pathSceenfile_screen = [];
handles.trimInVal_screen = [];
handles.trimOutVal_screen = [];


set(handles.filenameScreen_screen, 'String', '');
set(handles.trimInScreenPush_screen, 'enable', 'off');
set(handles.trimInScreenEdit_screen, 'String', '', 'enable', 'off');
set(handles.trimOutScreenPush_screen, 'enable', 'off');
set(handles.trimOutScreenEdit_screen, 'String', '', 'enable', 'off');
set(handles.popCompression_screen, 'String', 'Not available', 'Value', 1, 'enable', 'off');
set(handles.txtProgress_screen, 'String', 'off', 'Visible', 'off');
set(handles.advancedSetting_screen, 'enable', 'off', 'BackgroundColor', [0.55 0.55 0.55]);
set(handles.startProcessing_screen, 'enable', 'off');
set(handles.cancelProcessing_screen , 'enable', 'off');

axes(handles.mainVideoScreen_screen);
cla reset;
set(handles.mainVideoScreen_screen, 'Xcolor', [0.1 0.1 0.1], 'XTick', [], ...
    'Ycolor', [0.1 0.1 0.1], 'YTick', [], ...
    'color', [0 0 0]);


guidata(handles.hf_w1_welcome, handles);
handles.sliderControl_push_screen.Value = 1;

set(handles.prevChapControl_push_screen, 'enable', 'off');
set(handles.prevFrameControl_push_screen, 'enable', 'off');
set(handles.nextFrameControl_push_screen, 'enable', 'off');
set(handles.nextChap_push_screen, 'enable', 'off');
set(handles.frameCount_TXT_screen, 'String', 'Frame =      /     ');
set(handles.timeCount_TXT_screen, 'String', 'Time =      /     ');

guidata(handles.hf_w1_welcome, handles);

