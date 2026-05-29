function [] = modelDrop_cam(varargin);


handles3 = guidata(gcf);
valEC = get(handles3.cameraDrop_qual, 'value');

if valEC == handles3.valModel;
    return;
end;

if valEC == 1;
    %No camera selection, reset everything
    set(handles3.lensDrop_qual, 'String', 'Select a lens', 'Value', 1, 'enable', 'off');
    set(handles3.fov_qual, 'String', 'Select a FOV', 'Value', 1, 'enable', 'off');
    set(handles3.ratioDrop_qual, 'String', 'Select a ratio', 'Value', 1, 'enable', 'off');
    set(handles3.hypersmoothDrop_qual, 'String', 'Select stabilisation', 'Value', 1, 'enable', 'off');
    set(handles3.horizonDrop_qual, 'String', 'Select Horizon', 'Value', 1, 'enable', 'off');
elseif valEC == 2;
    %DJI Osmo 6
    set(handles3.lensDrop_qual, 'String', handles3.lensModeDJI6_listDrop , 'Value', 1, 'enable', 'on');
    set(handles3.fov_qual, 'String', 'Select a FOV', 'Value', 1, 'enable', 'off');
    set(handles3.ratioDrop_qual, 'String', 'Select a ratio', 'Value', 1, 'enable', 'off');
    set(handles3.hypersmoothDrop_qual, 'String', 'Select stabilisation', 'Value', 1, 'enable', 'off');
    set(handles3.horizonDrop_qual, 'String', 'Select Horizon', 'Value', 1, 'enable', 'off');
elseif valEC == 3;
    %Gopro 12
    set(handles3.lensDrop_qual, 'String', handles3.lensModeGopro12_listDrop, 'Value', 1, 'enable', 'on');
    set(handles3.fov_qual, 'String', 'Select a FOV', 'Value', 1, 'enable', 'off');
    set(handles3.ratioDrop_qual, 'String', 'Select a ratio', 'Value', 1, 'enable', 'off');
    set(handles3.hypersmoothDrop_qual, 'String', 'Select stabilisation', 'Value', 1, 'enable', 'off');
    set(handles3.horizonDrop_qual, 'String', 'Select Horizon', 'Value', 1, 'enable', 'off');
end;
handles3.valModel = valEC;
handles3.valLens = 1;
handles3.valFOV = 1;
handles3.valRatio = 1;
handles3.valStab = 1;
handles3.valHorizon = 1;

guidata(handles3.hf_w3_advancedImage, handles3);
