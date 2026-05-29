function [] = loadfisheye_main(varargin);


handles = guidata(gcf);
handles.Currenfisheye4K = get(handles.loadfisheye_main, 'value');
set(handles.loadfisheye_main, 'tooltipstring', handles.listDropFishEye{handles.Currenfisheye4K});

guidata(handles.hf_w1_welcome, handles);

