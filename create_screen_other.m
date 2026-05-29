function [] = create_screen_other(varargin);


handles = guidata(gcf);

set(handles.singleFilePanel_single, 'Visible', 'off');
set(handles.screenPanel_screen, 'Visible', 'on');
set(handles.relayPanel_relay, 'Visible', 'off');
set(handles.stitchingPanel_stiching, 'Visible', 'off');
set(handles.help_button_main, 'callback', @helpButton_otherScreen);
cancelProcessing_screen;

guidata(handles.hf_w1_welcome, handles);