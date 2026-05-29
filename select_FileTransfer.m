function [] = select_FileTransfer(varargin);

handles = guidata(gcf);
set(handles.hf_w1_welcome, 'WindowButtonDownFcn', '');

if get(handles.FileTransfer_toggle_main, 'Value') == 1;
    %button is being pressed on
    %reset initialisation
    handles.inputfolderPanning = 0;
    handles.outputfolderPanning = 0;
    handles.inputfolder4K = 0;
    handles.outputfolder4K = 0;
    
    handles.checkboxPanning = 1;
    handles.checkbox4K = 1;
    handles.checkboxRemuxPanning = 0;
    handles.checkboxRemux4K = 0;
    handles.fisheye4K = 0;
    handles.Currenfisheye4K = 1;
    
    handles.trimPanning = 8;
    handles.addPanning = 0;
    handles.trim4K = 0;
    handles.add4K = 0;
    
    handles.Processed4K = {};
    handles.ProcessedPanning = {};
    handles.listVideo4KFiles = {};
    handles.listVideoPanningFiles = {};
    listVideo4KFiles = {};
    listVideoPanningFiles = {};
    if ispc == 1;
        MDIR = getenv('USERPROFILE');
        save([MDIR '\SP2VideoManager\listVideoPanningFiles.mat'], 'listVideoPanningFiles');
        save([MDIR '\SP2VideoManager\listVideo4KFiles.mat'], 'listVideo4KFiles');
    elseif ismac == 1;
        save('/Applications/SP2VideoManager/listVideoPanningFiles.mat', 'listVideoPanningFiles');
        save('/Applications/SP2VideoManager/listVideo4KFiles.mat', 'listVideo4KFiles');
    end;
    
    handles.refreshPlay = 0;
    handles.refreshTime = 30;
    set(handles.help_button_main, 'callback', @helpButton_conv);

    %reset UI
    set(handles.pathinputPanning_conv, 'String', '');
    set(handles.pathoutputPanning_conv, 'String', '');
    set(handles.edittrimPanning_conv, 'String', num2str(handles.trimPanning));
    set(handles.editaddPanning_conv, 'String', num2str(handles.addPanning));
    set(handles.popCompressionPanning_conv, 'Value', 1);
    set(handles.editrefresh_conv, 'String', num2str(handles.refreshTime));
    set(handles.txtupdate_conv, 'String', 'Next update at :    -- : -- : --');
    set(handles.fileprocess_conv, 'String', 'Processing   :   ...');
    set(handles.tablePanning_conv, 'data', [], 'Visible', 'off');

    %display the conv page
    set(handles.pannigVideoPanel_conv, 'Visible', 'on');
    handles.current_panel = 'conv';

    %hide the other pages
    set(handles.entrylistPanel_entry, 'Visible', 'off');
    set(handles.otherPanel_other, 'Visible', 'off');
    set(handles.EntryList_toggle_main, 'Value', 0);
    set(handles.OtherOperations_toggle_main, 'Value', 0);

else;
    %button is being pressed off
    set(handles.FileTransfer_toggle_main, 'Value', 1);
    return;    
end;


guidata(handles.hf_w1_welcome, handles);
