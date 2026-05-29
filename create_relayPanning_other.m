function [] = create_relayPanning_other(varargin);


handles = guidata(gcf);

set(handles.singleFilePanel_single, 'Visible', 'off');
set(handles.screenPanel_screen, 'Visible', 'off');
set(handles.relayPanel_relay, 'Visible', 'on');
set(handles.stitchingPanel_stiching, 'Visible', 'off');
set(handles.help_button_main, 'callback', @helpButton_otherRelay);
cancelProcessing_relay;

guidata(handles.hf_w1_welcome, handles);