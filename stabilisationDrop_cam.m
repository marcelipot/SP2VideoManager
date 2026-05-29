function [] = hypersmoothDrop_cam(varargin);


handles3 = guidata(gcf);

valEC = get(handles3.hypersmoothDrop_qual, 'Value');

if valEC == handles3.valStab;
    return;
end;

if handles3.valModel == 2;
    %DJI
    if valEC == 1;
        %No selection, reset everything
        set(handles3.horizonDrop_qual, 'String', 'Option not available', 'Value', 1, 'enable', 'off');
    elseif valEC == 2;
        %no diff for the 3 options... rocksteady off
        set(handles3.horizonDrop_qual, 'String', 'Option not available', 'Value', 1, 'enable', 'off');
    elseif valEC == 3;
        %no diff for the 3 options... rocksteady on
        set(handles3.horizonDrop_qual, 'String', 'Option not available', 'Value', 1, 'enable', 'off');
    elseif valEC == 4;
        %no diff for the 3 options... rocksteady plus
        set(handles3.horizonDrop_qual, 'String', 'Option not available', 'Value', 1, 'enable', 'off');
    end;

elseif handles3.valModel == 3;
    %Gopro12
    if handles3.valLens == 2;
        %normal
        if handles3.valFOV == 2;
            %Linear
            if handles3.valRatio == 2;
                %no other other only 16/9
                if valEC == 1;
                    %No selection, reset everything
                    set(handles3.horizonDrop_qual, 'String', 'Option not available', 'Value', 1, 'enable', 'off');
                elseif valEC == 2;
                    %no diff for the 3 options... hyoersmooth off
                    set(handles3.horizonDrop_qual, 'String', 'Option not available', 'Value', 1, 'enable', 'off');
                elseif valEC == 3;
                    %no diff for the 3 options... hyoersmooth on
                    set(handles3.horizonDrop_qual, 'String', 'Option not available', 'Value', 1, 'enable', 'off');
                elseif valEC == 4;
                    %no diff for the 3 options... hyoersmooth boost
                    set(handles3.horizonDrop_qual, 'String', 'Option not available', 'Value', 1, 'enable', 'off');
                end;
            end;
        elseif handles3.valFOV == 3;
            %Wide
            if handles3.valRatio == 2;
                %16/9
                if valEC == 1;
                    %No selection, reset everything
                    set(handles3.horizonDrop_qual, 'String', 'Option not available', 'Value', 1, 'enable', 'off');
                elseif valEC == 2;
                    %no diff for the 3 options... hyoersmooth off
                    set(handles3.horizonDrop_qual, 'String', 'Option not available', 'Value', 1, 'enable', 'off');
                elseif valEC == 3;
                    %no diff for the 3 options... hyoersmooth on
                    set(handles3.horizonDrop_qual, 'String', 'Option not available', 'Value', 1, 'enable', 'off');
                elseif valEC == 4;
                    %no diff for the 3 options... hyoersmooth boost
                    set(handles3.horizonDrop_qual, 'String', 'Option not available', 'Value', 1, 'enable', 'off');
                end;
            elseif handles3.valRatio == 3;
                %8/7
                if valEC == 1;
                    %No selection, reset everything
                    set(handles3.horizonDrop_qual, 'String', 'Option not available', 'Value', 1, 'enable', 'off');
                elseif valEC == 2;
                    %no diff for the 3 options... hyoersmooth off
                    set(handles3.horizonDrop_qual, 'String', 'Option not available', 'Value', 1, 'enable', 'off');
                elseif valEC == 3;
                    %no diff for the 3 options... hyoersmooth on
                    set(handles3.horizonDrop_qual, 'String', 'Option not available', 'Value', 1, 'enable', 'off');
                end;
            end;
        end;
    
    elseif handles3.valLens == 3;
        %max mod 2
        if handles3.valFOV == 2;
            %Wide
            if handles3.valRatio == 2;
                %no other other only 16/9
                if valEC == 1;
                    %No selection, reset everything
                    set(handles3.horizonDrop_qual, 'String', 'Select Horizon', 'Value', 1, 'enable', 'off');
                elseif valEC == 2;
                    %hyperboost off so no horizon lock
                    set(handles3.horizonDrop_qual, 'String', 'Option not available', 'Value', 1, 'enable', 'off');
                elseif valEC == 3;
                    %hyperboost on so horizon lock
                    set(handles3.horizonDrop_qual, 'String', handles3.horizon2_listDrop, 'Value', 1, 'enable', 'on');
                end;
            end;
        elseif handles3.valFOV == 3;
            %Max Super View
            if handles3.valRatio == 2;
                %no other other only 16/9
                if valEC == 1;
                    %No selection, reset everything
                    set(handles3.horizonDrop_qual, 'String', 'Select Horizon', 'Value', 1, 'enable', 'off');
                elseif valEC == 2;
                    %hyperboost off so no horizon lock
                    set(handles3.horizonDrop_qual, 'String', 'Option not available', 'Value', 1, 'enable', 'off');
                elseif valEC == 3;
                    %hyperboost on so horizon lock
                    set(handles3.horizonDrop_qual, 'String', handles3.horizon2_listDrop, 'Value', 1, 'enable', 'on');
                end;
            end;
        end;
    end;
end;

handles3.valStab = valEC;
handles3.valHorizon = 1;

guidata(handles3.hf_w3_advancedImage, handles3);
