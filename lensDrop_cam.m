function [] = lensDrop_cam(varargin);


handles3 = guidata(gcf);
valEC = get(handles3.lensDrop_qual, 'value');

if valEC == handles3.valLens;
    return;
end;


if handles3.valModel == 2;
    %DJI selected
    if valEC == 1;
        %nothing selected... reset everything else
        set(handles3.fov_qual, 'String', 'Select a FOV', 'Value', 1, 'enable', 'off');
        set(handles3.ratioDrop_qual, 'String', 'Select a ratio', 'Value', 1, 'enable', 'off');
        set(handles3.hypersmoothDrop_qual, 'String', 'Select stabilisation', 'Value', 1, 'enable', 'off');
        set(handles3.horizonDrop_qual, 'String', 'Select Horizon', 'Value', 1, 'enable', 'off');
    elseif valEC == 2;
        %normal lens
        set(handles3.fov_qual, 'String', handles3.fovDJINormal_listDrop, 'Value', 1, 'enable', 'on');
        set(handles3.ratioDrop_qual, 'String', 'Select a ratio', 'Value', 1, 'enable', 'off');
        set(handles3.hypersmoothDrop_qual, 'String', 'Select stabilisation', 'Value', 1, 'enable', 'off');
        set(handles3.horizonDrop_qual, 'String', 'Select Horizon', 'Value', 1, 'enable', 'off');
    elseif valEC == 3;
        %normal boost
        set(handles3.fov_qual, 'String', handles3.fovDJIBoost_listDrop, 'Value', 1, 'enable', 'on');
        set(handles3.ratioDrop_qual, 'String', 'Select a ratio', 'Value', 1, 'enable', 'off');
        set(handles3.hypersmoothDrop_qual, 'String', 'Select stabilisation', 'Value', 1, 'enable', 'off');
        set(handles3.horizonDrop_qual, 'String', 'Select Horizon', 'Value', 1, 'enable', 'off');
    end;
elseif handles3.valLens == 3;
    %Gopro 12 selected
    if valEC == 1;
        %nothing selected... reset everything else
        set(handles3.fov_qual, 'String', 'Select a FOV', 'Value', 1, 'enable', 'off');
        set(handles3.ratioDrop_qual, 'String', 'Select a ratio', 'Value', 1, 'enable', 'off');
        set(handles3.hypersmoothDrop_qual, 'String', 'Select stabilisation', 'Value', 1, 'enable', 'off');
        set(handles3.horizonDrop_qual, 'String', 'Select Horizon', 'Value', 1, 'enable', 'off');
    elseif valEC == 2;
        %normal lens
        set(handles3.fov_qual, 'String', handles3.fovGoproNormal_listDrop, 'Value', 1, 'enable', 'on');
        set(handles3.ratioDrop_qual, 'String', 'Select a ratio', 'Value', 1, 'enable', 'off');
        set(handles3.hypersmoothDrop_qual, 'String', 'Select stabilisation', 'Value', 1, 'enable', 'off');
        set(handles3.horizonDrop_qual, 'String', 'Select Horizon', 'Value', 1, 'enable', 'off');
    elseif valEC == 2;
        %max mod lens
        set(handles3.fov_qual, 'String', handles3.fovGoproMaxMod_listDrop, 'Value', 1, 'enable', 'on');
        set(handles3.ratioDrop_qual, 'String', 'Select a ratio', 'Value', 1, 'enable', 'off');
        set(handles3.hypersmoothDrop_qual, 'String', 'Select stabilisation', 'Value', 1, 'enable', 'off');
        set(handles3.horizonDrop_qual, 'String', 'Select Horizon', 'Value', 1, 'enable', 'off');
    end;
end;

handles3.valLens = valEC;
handles3.valFOV = 1;
handles3.valRatio = 1;
handles3.valStab = 1;
handles3.valHorizon = 1;

guidata(handles3.hf_w3_advancedImage, handles3);
