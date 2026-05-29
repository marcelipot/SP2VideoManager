function [] = select_convBatch4K_conv(varargin);

handles = guidata(gcf);
set(handles.hf_w1_welcome, 'WindowButtonDownFcn', '');

if get(handles.select4K_toggle_conv, 'Value') == 1;
    %button is being pressed on
    %reset ???  
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

    handles.isStitchingFile = 0;
    handles.isFishEyeFile = 0;
    handles.VidCorrectionBatch = [];
    handles.VidStitchingBatch = [];

    if ispc == 1;
        MDIR = getenv('USERPROFILE');
        save([MDIR '\SP2VideoManager\listVideoPanningFiles.mat'], 'listVideoPanningFiles');
        save([MDIR '\SP2VideoManager\listVideo4KFiles.mat'], 'listVideo4KFiles');
    elseif ismac == 1;
        save('/Applications/SP2VideoManager/listVideoPanningFiles.mat', 'listVideoPanningFiles');
        save('/Applications/SP2VideoManager/listVideo4KFiles.mat', 'listVideo4KFiles');
    end;

    %reset UI
    set(handles.pathinputPanning_conv, 'String', '');
   
    %display the conv page
    set(handles.batchprocessing4KPanel_conv, 'Visible', 'on');
    set(handles.batchprocessingPanningPanel_conv, 'Visible', 'off');
    handles.current_panel = 'conv';
    set(handles.selectPanning_toggle_conv, 'Value', 0);


else;
    %button is being pressed off
    set(handles.select4K_toggle_conv, 'Value', 1);
    return;    
end;


guidata(handles.hf_w1_welcome, handles);
