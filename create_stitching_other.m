function [] = create_stitching_other(varargin);


handles = guidata(gcf);

set(handles.singleFilePanel_single, 'Visible', 'off');
set(handles.screenPanel_screen, 'Visible', 'off');
set(handles.relayPanel_relay, 'Visible', 'off');
set(handles.stitchingPanel_stiching, 'Visible', 'on');
set(handles.help_button_main, 'callback', @helpButton_otherStitching);
cancelProcessing_stitching;

guidata(handles.hf_w1_welcome, handles);