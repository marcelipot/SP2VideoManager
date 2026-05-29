function [] = create_singlePanning_other(varargin);


handles = guidata(gcf);

set(handles.singleFilePanel_single, 'Visible', 'on');
set(handles.screenPanel_screen, 'Visible', 'off');
set(handles.relayPanel_relay, 'Visible', 'off');
set(handles.stitchingPanel_stiching, 'Visible', 'off');
set(handles.help_button_main, 'callback', @helpButton_otherPanning);
cancelProcessing_single;

guidata(handles.hf_w1_welcome, handles);