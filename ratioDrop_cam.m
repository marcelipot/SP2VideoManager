function [] = ratioDrop_cam(varargin);


handles3 = guidata(gcf);
valEC = get(handles3.ratioDrop_qual, 'value');


% if valEC == handles3.valRatio;
%     return;
% end;

if handles3.valModel == 2;
    %DJI Osmo 6
    if handles3.valLens == 1;
        %No selection, reset everything
        set(handles3.hypersmoothDrop_qual, 'String', 'Select stabilisation', 'Value', 1, 'enable', 'off');
        set(handles3.horizonDrop_qual, 'String', 'Select Horizon', 'Value', 1, 'enable', 'off');
    elseif handles3.valLens == 2;
        %Normal
        set(handles3.hypersmoothDrop_qual, 'String', handles3.DJIhypersmooth1_listDrop, 'Value', 1, 'enable', 'on');
        set(handles3.horizonDrop_qual, 'String', 'Select Horizon', 'Value', 1, 'enable', 'off');
    elseif handles3.valLens == 3;
        %Boost
        set(handles3.hypersmoothDrop_qual, 'String', handles3.DJIhypersmooth2_listDrop, 'Value', 1, 'enable', 'on');
        set(handles3.horizonDrop_qual, 'String', 'Select Horizon', 'Value', 1, 'enable', 'off');
    end;
elseif handles3.valModel == 3;
    %Gopro 12
    if handles3.valLens == 2;
        %normal
        if handles3.valFOV == 2;
            %Linear
            if valEC == 1;
                %No selection, reset everything
                set(handles3.hypersmoothDrop_qual, 'String', 'Select stabilisation', 'Value', 1, 'enable', 'off');
                set(handles3.horizonDrop_qual, 'String', 'Select Horizon', 'Value', 1, 'enable', 'off');
            elseif valEC == 2;
                %no other other only 16/9
                set(handles3.hypersmoothDrop_qual, 'String', handles3.hypersmooth1_listDrop, 'Value', 1, 'enable', 'on');
                set(handles3.horizonDrop_qual, 'String', 'Select Horizon', 'Value', 1, 'enable', 'off');
            end;
        elseif handles3.valFOV == 3;
            %Wide
            if valEC == 1;
                set(handles3.hypersmoothDrop_qual, 'String', 'Select stabilisation', 'Value', 1, 'enable', 'off');
                set(handles3.horizonDrop_qual, 'String', 'Select Horizon', 'Value', 1, 'enable', 'off');
            elseif valEC == 2;
                %16/9
                set(handles3.hypersmoothDrop_qual, 'String', handles3.hypersmooth1_listDrop, 'Value', 1, 'enable', 'on');
                set(handles3.horizonDrop_qual, 'String', 'Select Horizon', 'Value', 1, 'enable', 'off');
            elseif valEC == 3;
                %8/7
                set(handles3.hypersmoothDrop_qual, 'String', handles3.hypersmooth2_listDrop, 'Value', 1, 'enable', 'on');
                set(handles3.horizonDrop_qual, 'String', 'Select Horizon', 'Value', 1, 'enable', 'off');
            end;
        end;
    
    elseif handles3.valLens == 3;
        %max mod 2
        if handles3.valFOV == 2;
            %Wide
            if valEC == 1;
                %No selection, reset everything
                set(handles3.hypersmoothDrop_qual, 'String', 'Select stabilisation', 'Value', 1, 'enable', 'off');
                set(handles3.horizonDrop_qual, 'String', 'Select Horizon', 'Value', 1, 'enable', 'off');
            elseif valEC == 2;
                %16/9
                set(handles3.hypersmoothDrop_qual, 'String', handles3.hypersmooth2_listDrop, 'Value', 1, 'enable', 'on');
                set(handles3.horizonDrop_qual, 'String', 'Select Horizon', 'Value', 1, 'enable', 'off');
            end;
        elseif handles3.valFOV == 3;
            %Max Super View
            if valEC == 1;
                 %No selection, reset everything
                set(handles3.hypersmoothDrop_qual, 'String', 'Select stabilisation', 'Value', 1, 'enable', 'off');
                set(handles3.horizonDrop_qual, 'String', 'Select Horizon', 'Value', 1, 'enable', 'off');
            elseif valEC == 2
                %no other other only 16/9
                set(handles3.hypersmoothDrop_qual, 'String', handles3.hypersmooth2_listDrop, 'Value', 1, 'enable', 'on');
                set(handles3.horizonDrop_qual, 'String', 'Select Horizon', 'Value', 1, 'enable', 'off');
            end;
        end;
    end;
end;

handles3.valRatio = valEC;
handles3.valStab = 1;
handles3.valHorizon = 1;

guidata(handles3.hf_w3_advancedImage, handles3);
