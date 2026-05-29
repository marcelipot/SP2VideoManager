function [] = select_OtherOperations(varargin);

handles = guidata(gcf);
set(handles.hf_w1_welcome, 'WindowButtonDownFcn', '');

if handles.refreshPlay == 1;
    set(handles.playrefresh_conv, 'units', 'pixels');
    pos = get(handles.playrefresh_conv, 'position');
    set(handles.playrefresh_conv, 'cdata', imresize(handles.icones.play_offb, [pos(3) pos(4)]));
    set(handles.playrefresh_conv, 'units', 'normalized');
    
    handles.refreshPlay = 0;
    stop([handles.TimerScanFolder handles.TimerUpdatePanning handles.TimerUpdatePanning]);
end;

if get(handles.OtherOperations_toggle_main, 'Value') == 1;
    %button is being pressed on
    %reset initialisation
    
    set(handles.help_button_main, 'callback', @helpButton_other1);

    %display the entry page
    set(handles.otherPanel_other, 'Visible', 'on');
    set(handles.singleFilePanel_single, 'Visible', 'off');
    set(handles.screenPanel_screen, 'Visible', 'off');
    set(handles.relayPanel_relay, 'Visible', 'off');
    set(handles.stitchingPanel_stiching, 'Visible', 'off');
    handles.current_panel = 'other';

    %hide the other pages
    set(handles.pannigVideoPanel_conv, 'Visible', 'off');
    set(handles.entrylistPanel_entry, 'Visible', 'off');
    set(handles.EntryList_toggle_main, 'Value', 0);
    set(handles.FileTransfer_toggle_main, 'Value', 0);

else;
    %button is being pressed off
    set(handles.OtherOperations_toggle_main, 'Value', 1);
    return;    
end;


guidata(handles.hf_w1_welcome, handles);




