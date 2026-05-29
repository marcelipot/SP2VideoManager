function [] = fovDrop_cam(varargin);


handles3 = guidata(gcf);
valEC = get(handles3.fov_qual, 'value');

if valEC == handles3.valFOV;
    return;
end;

if handles3.valModel == 2;
    %DJI FOV options for 1 type of lens
    if valEC == 1;
        %no selection, reset everything
        set(handles3.ratioDrop_qual, 'String', 'Select a ratio', 'Value', 1, 'enable', 'off');
        set(handles3.hypersmoothDrop_qual, 'String', 'Select stabilisation', 'Value', 1, 'enable', 'off');
        set(handles3.horizonDrop_qual, 'String', 'Select Horizon', 'Value', 1, 'enable', 'off');
    else
        %same for all the FOV (Linear, natural wide, and wide)
        set(handles3.ratioDrop_qual, 'String', handles3.ratio169_listDrop, 'Value', 1, 'enable', 'on');
        if handles3.valLens == 1;
            set(handles3.hypersmoothDrop_qual, 'String', 'Select stabilisation', 'Value', 1, 'enable', 'on');
            set(handles3.horizonDrop_qual, 'String', 'Select Horizon', 'Value', 1, 'enable', 'off');
        elseif handles3.valLens == 2;
            set(handles3.hypersmoothDrop_qual, 'String', handles3.DJIhypersmooth1_listDrop, 'Value', 1, 'enable', 'on');
            set(handles3.horizonDrop_qual, 'String', 'Select Horizon', 'Value', 1, 'enable', 'off');
        elseif handles3.valLens == 3;
            set(handles3.hypersmoothDrop_qual, 'String', handles3.DJIhypersmooth2_listDrop, 'Value', 1, 'enable', 'on');
            set(handles3.horizonDrop_qual, 'String', 'Select Horizon', 'Value', 1, 'enable', 'off');
        end;
    end;
    
elseif handles3.valModel == 3;
    %Gopro 12 options for 2 types of lenses
    if handles3.valLens == 2;
        %normal
        if valEC == 1;
            %no selection, reset everything
            set(handles3.ratioDrop_qual, 'String', 'Select a ratio', 'Value', 1, 'enable', 'off');
            set(handles3.hypersmoothDrop_qual, 'String', 'Select stabilisation', 'Value', 1, 'enable', 'off');
            set(handles3.horizonDrop_qual, 'String', 'Select Horizon', 'Value', 1, 'enable', 'off');
        elseif valEC == 2;
            %Linear
            set(handles3.ratioDrop_qual, 'String', handles3.ratio169_listDrop, 'Value', 1, 'enable', 'on');
            set(handles3.hypersmoothDrop_qual, 'String', 'Select stabilisation', 'Value', 1, 'enable', 'off');
            set(handles3.horizonDrop_qual, 'String', 'Select Horizon', 'Value', 1, 'enable', 'off');
        elseif valEC == 3;
            %Wide
            set(handles3.ratioDrop_qual, 'String', handles3.ratio87_listDrop, 'Value', 1, 'enable', 'on');
            set(handles3.hypersmoothDrop_qual, 'String', 'Select stabilisation', 'Value', 1, 'enable', 'off');
            set(handles3.horizonDrop_qual, 'String', 'Select Horizon', 'Value', 1, 'enable', 'off');
        end;
    elseif handles3.valLens == 3;
        %max mod 2
        if valEC == 1;
            %no selection, reset everything
            set(handles3.ratioDrop_qual, 'String', 'Select a ratio', 'Value', 1, 'enable', 'off');
            set(handles3.hypersmoothDrop_qual, 'String', 'Select stabilisation', 'Value', 1, 'enable', 'off');
            set(handles3.horizonDrop_qual, 'String', 'Select Horizon', 'Value', 1, 'enable', 'off');
        elseif valEC == 2;
            %Wide
            set(handles3.ratioDrop_qual, 'String', handles3.ratio169_listDrop, 'Value', 1, 'enable', 'on');
            set(handles3.hypersmoothDrop_qual, 'String', 'Select stabilisation', 'Value', 1, 'enable', 'off');
            set(handles3.horizonDrop_qual, 'String', 'Select Horizon', 'Value', 1, 'enable', 'off');
        elseif valEC == 3;
            %Max Super View
            set(handles3.ratioDrop_qual, 'String', handles3.ratio169_listDrop, 'Value', 1, 'enable', 'on');
            set(handles3.hypersmoothDrop_qual, 'String', 'Select stabilisation', 'Value', 1, 'enable', 'off');
            set(handles3.horizonDrop_qual, 'String', 'Select Horizon', 'Value', 1, 'enable', 'off');
        end;
    end;
end;

handles3.valFOV = valEC;
handles3.valRatio = 1;
handles3.valStab = 1;
handles3.valHorizon = 1;

guidata(handles3.hf_w3_advancedImage, handles3);
