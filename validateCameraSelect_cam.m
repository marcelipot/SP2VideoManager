function [] = validateCameraSelect_cam(varargin);

handles3 = guidata(gcf);

if handles3.valModel == 2;
    %DJI Osmo 6 
    if handles3.valLens == 2;
        if handles3.valFOV == 2;
            %Standard
            if handles3.valRatio == 2;
                %16/9
                if handles3.valStab == 2;
                    %rocksteady off
                    fileFishEyeName = 'DJI6_LensNormal_4K_Standard_16.9_NoRockSteadyv1.mat';
                elseif handles3.valStab == 3;
                    %rocksteady on
                    fileFishEyeName = 'DJI6_LensNormal_4K_Standard_16.9_RockSteadyv1.mat';
                elseif handles3.valStab == 4;
                    %rocksteady plus
                    fileFishEyeName = 'DJI6_LensNormal_4K_Standard_16.9_RockSteadyPlusv1.mat';
                end;
            end;
        elseif handles3.valFOV == 3;
            %Natural Wide
            if handles3.valRatio == 2;
                %16/9
                if handles3.valStab == 2;
                    %rocksteady off
                    fileFishEyeName = 'DJI6_LensNormal_4K_NaturalWide_16.9_NoRockSteadyv1.mat';
                elseif handles3.valStab == 3;
                    %rocksteady on
                    fileFishEyeName = 'DJI6_LensNormal_4K_NaturalWide_16.9_RockSteadyv1.mat';
                elseif handles3.valStab == 4;
                    %rocksteady plus
                    fileFishEyeName = 'DJI6_LensNormal_4K_NaturalWide_16.9_RockSteadyPlusv1.mat';
                end;
            end;
        elseif handles3.valFOV == 4;
            %Wide
            if handles3.valRatio == 2;
                %16/9
                if handles3.valStab == 2;
                    %rocksteady off
                    fileFishEyeName = 'DJI6_LensNormal_4K_Wide_16.9_NoRockSteadyv1.mat';
                elseif handles3.valStab == 3;
                    %rocksteady on
                    fileFishEyeName = 'DJI6_LensNormal_4K_Wide_16.9_RockSteadyv1.mat';
                elseif handles3.valStab == 4;
                    %rocksteady plus
                    fileFishEyeName = 'DJI6_LensNormal_4K_Wide_16.9_RockSteadyPlusv1.mat';
                end;
            end;
        elseif handles3.valFOV == 5;
            %Ultra Wide
            if handles3.valRatio == 2;
                %16/9
                if handles3.valStab == 2;
                    %rocksteady off
                    fileFishEyeName = 'DJI6_LensNormal_4K_UltraWide_16.9_NoRockSteadyv1.mat';
                elseif handles3.valStab == 3;
                    %rocksteady on
                    fileFishEyeName = 'DJI6_LensNormal_4K_UltraWide_16.9_RockSteadyv1.mat';
                elseif handles3.valStab == 4;
                    %rocksteady plus
                    fileFishEyeName = 'DJI6_LensNormal_4K_UltraWide_16.9_RockSteadyPlusv1.mat';
                end;
            end;
        end;
    else;
        %Lens boost
        if handles3.valFOV == 2;
            %Wide
            if handles3.valRatio == 2;
                %16/9
                if handles3.valStab == 2;
                    %rocksteady off
                    fileFishEyeName = 'DJI6_LensBoost_4K_Wide_16.9_RockSteadyv1.mat';
                end;
            end;
        elseif handles3.valFOV == 3;
            %Ultra Wide
            if handles3.valRatio == 2;
                %16/9
                if handles3.valStab == 2;
                    %rocksteady on
                    fileFishEyeName = 'DJI6_LensBoost_4K_UltraWide_16.9_RockSteadyv1.mat';
                end;
            end;
        end;
    end;
    
elseif handles3.valModel == 3;
    %GOPRO 12

    if handles3.valLens == 2;
        %Lens normal
        if handles3.valFOV == 2;
            %Linear
            if handles3.valRatio == 2;
                %16/9 and no other options
                if handles3.valStab == 2;
                    %hypersmooth off
                    fileFishEyeName = 'GOPRO12_LensNormal_4K_Linear_16.9_HypersmoothOffv1.mat';
                elseif handles3.valStab == 3;
                    %hypersmooth on
                    fileFishEyeName = 'GOPRO12_LensNormal_4K_Linear_16.9_HypersmoothOnv1.mat';
                elseif handles3.valStab == 4;
                    %hypersmooth boost
                    fileFishEyeName = 'GOPRO12_LensNormal_4K_Linear_16.9_HypersmoothBoostv1.mat';
                end;
            end;
        elseif handles3.valFOV == 3;
            %Wide
            if handles3.valRatio == 2;
                %16/9
                if handles3.valStab == 2;
                    %hypersmooth off
                    fileFishEyeName = 'GOPRO12_LensNormal_4K_Wide_16.9_HypersmoothOffv1.mat';
                elseif handles3.valStab == 3;
                    %hypersmooth on
                    fileFishEyeName = 'GOPRO12_LensNormal_4K_Wide_16.9_HypersmoothOnv1.mat';
                elseif handles3.valStab == 4;
                    %hypersmooth boost
                    fileFishEyeName = 'GOPRO12_LensNormal_4K_Wide_16.9_HypersmoothBoostv1.mat';
                end;
            elseif handles3.valRatio == 3;
                %8/7
                if handles3.valStab == 2;
                    %hypersmooth off
                    fileFishEyeName = 'GOPRO12_LensNormal_4K_Wide_8.7_HypersmoothOffv1.mat';
                elseif handles3.valStab == 3;
                    %hypersmooth on
                    fileFishEyeName = 'GOPRO12_LensNormal_4K_Wide_8.7_HypersmoothOnv1.mat';
                end;
            end;
        end;
    elseif handles3.valLens == 3;
        %lens max mod2
        if handles3.valFOV == 2;
            %Wide
            if handles3.valRatio == 2;
                %16/9 and no other options
                if handles3.valStab == 2;
                    %hypersmooth off
                    fileFishEyeName = 'GOPRO12_LensMaxMod2_2.7K_Wide_16.9_HypersmoothOff_HorizonOffv1.mat';
                elseif handles3.valStab == 3;
                    %hypersmooth on
                    if handles3.valHorizon == 2;
                        %Horizon lock off
                        fileFishEyeName = 'GOPRO12_LensMaxMod2_2.7K_Wide_16.9_HypersmoothOn_HorizonOffv1.mat';
                    elseif handles3.valHorizon == 3;
                        %Horizon lock on
                        fileFishEyeName = 'GOPRO12_LensMaxMod2_2.7K_Wide_16.9_HypersmoothOn_HorizonOnv1.mat';
                    end;
                end;
            end;
        elseif handles3.valFOV == 3;
            %Max Super View
            if handles3.valRatio == 2;
                %16/9 and no other options
                if handles3.valStab == 2;
                    %hypersmooth off
                    fileFishEyeName = 'GOPRO12_LensMaxMod2_2.7K_MaxSuperView_16.9_HypersmoothOff_HorizonOffv1.mat';
                elseif handles3.valStab == 3;
                    %hypersmooth on
                    if handles3.valHorizon == 2;
                        %Horizon lock off
                        fileFishEyeName = 'GOPRO12_LensMaxMod2_2.7K_MaxSuperView_16.9_HypersmoothOn_HorizonOffv1.mat';
                    elseif handles3.valHorizon == 3;
                        %Horizon lock on
                        fileFishEyeName = 'GOPRO12_LensMaxMod2_2.7K_MaxSuperView_16.9_HypersmoothOn_HorizonOnv1.mat';
                    end;
                end;
            end;
        end;
    end;
end;
handles3.fileFishEyeName = fileFishEyeName;
guidata(handles3.hf_w3_advancedImage, handles3);


uiresume(gcf);


guidata(handles3.hf_w3_advancedImage, handles3);