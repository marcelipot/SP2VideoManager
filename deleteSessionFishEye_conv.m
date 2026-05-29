function deleteSessionFishEye_conv(varargin);



handles = guidata(gcf);

handles.VidCorrectionBatch = [];
handles.isFishEyeFile = 0;
set(handles.loadSessionFishEye_conv, 'ForegroundColor', [1 1 1]);

guidata(handles.hf_w1_welcome, handles);