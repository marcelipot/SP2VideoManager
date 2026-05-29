function handles3 = defineFishEyeUI_screen;



handles2 = guidata(gcf);

VidInfo = handles2.VidInfo;
handles3.fileFishEyeName = [];
valModel = 1;
valLens = 1;
valFOV = 1;
listFOV = [];
valRatio = 1;
listRatio = [];
valStab = 1;
listHyper = [];
valHorizon = 1;
listHorizon = [];
if isempty(VidInfo.FishEye) == 0;
    handles3.fileFishEyeName = VidInfo.FishEye.fileFishEyeName;
    
    if strcmpi(handles3.fileFishEyeName, 'GOPRO12_LensNormal_4K_Linear_16.9_HypersmoothOffv1.mat') == 1;
        valModel = 3;
        valLens = 2;
        listLens = 2;
        valFOV = 2;
        listFOV = 2;
        valRatio = 2;
        listRatio = 2;
        valStab = 2;
        listHyper = 2;
        valHorizon = 2;
        listHorizon = 1;
    elseif strcmpi(handles3.fileFishEyeName, 'GOPRO12_LensNormal_4K_Linear_16.9_HypersmoothOnv1.mat') == 1;
        valModel = 3;
        valLens = 2;
        listLens = 2;
        valFOV = 2;
        listFOV = 2;
        valRatio = 2;
        listRatio = 2;
        valStab = 3;
        listHyper = 2;
        valHorizon = 2;
        listHorizon = 1;
    elseif strcmpi(handles3.fileFishEyeName, 'GOPRO12_LensNormal_4K_Linear_16.9_HypersmoothBoostv1.mat') == 1;
        valModel = 3;
        valLens = 2;
        listLens = 2;
        valFOV = 2;
        listFOV = 2;
        valRatio = 2;
        listRatio = 2;
        valStab = 4;
        listHyper = 2;
        valHorizon = 2;
        listHorizon = 1;
    elseif strcmpi(handles3.fileFishEyeName, 'GOPRO12_LensNormal_4K_Wide_16.9_HypersmoothOffv1.mat') == 1;
        valModel = 3;
        valLens = 2;
        listLens = 2;
        valFOV = 3;
        listFOV = 2;
        valRatio = 2;
        listRatio = 1;
        valStab = 2;
        listHyper = 2;
        valHorizon = 2;
        listHorizon = 1;
    elseif strcmpi(handles3.fileFishEyeName, 'GOPRO12_LensNormal_4K_Wide_16.9_HypersmoothOnv1.mat') == 1;
        valModel = 3;
        valLens = 2;
        listLens = 2;
        valFOV = 3;
        listFOV = 2;
        valRatio = 2;
        listRatio = 1;
        valStab = 3;
        listHyper = 2;
        valHorizon = 2;
        listHorizon = 1;
    elseif strcmpi(handles3.fileFishEyeName, 'GOPRO12_LensNormal_4K_Wide_16.9_HypersmoothBoostv1.mat') == 1;
        valModel = 3;
        valLens = 2;
        listLens = 2;
        valFOV = 3;
        listFOV = 2;
        valRatio = 2;
        listRatio = 1;
        valStab = 4;
        listHyper = 2;
        valHorizon = 2;
        listHorizon = 1;
    elseif strcmpi(handles3.fileFishEyeName, 'GOPRO12_LensNormal_4K_Wide_8.7_HypersmoothOffv1.mat') == 1;
        valModel = 3;
        valLens = 2;
        listLens = 2;
        valFOV = 3;
        listFOV = 2;
        valRatio = 3;
        listRatio = 1;
        valStab = 2;
        listHyper = 3;
        valHorizon = 2;
        listHorizon = 1;
    elseif strcmpi(handles3.fileFishEyeName, 'GOPRO12_LensNormal_4K_Wide_8.7_HypersmoothOnv1.mat') == 1;
        valModel = 3;
        valLens = 2;
        listLens = 2;
        valFOV = 3;
        listFOV = 2;
        valRatio = 3;
        listRatio = 1;
        valStab = 3;
        listHyper = 3;
        valHorizon = 2;
        listHorizon = 1;
    elseif strcmpi(handles3.fileFishEyeName, 'GOPRO12_LensMaxMod2_2.7K_Wide_16.9_HypersmoothOff_HorizonOffv1.mat') == 1;
        valModel = 3;
        valLens = 3;
        listLens = 2;
        valFOV = 2;
        listFOV = 3;
        valRatio = 2;
        listRatio = 1;
        valStab = 2;
        listHyper = 3;
        valHorizon = 2;
        listHorizon = 1;
    elseif strcmpi(handles3.fileFishEyeName, 'GOPRO12_LensMaxMod2_2.7K_Wide_16.9_HypersmoothOn_HorizonOffv1.mat') == 1;
        valModel = 3;
        valLens = 3;
        listLens = 2;
        valFOV = 2;
        listFOV = 3;
        valRatio = 2;
        listRatio = 1;
        valStab = 3;
        listHyper = 3;
        valHorizon = 2;
        listHorizon = 2;
    elseif strcmpi(handles3.fileFishEyeName, 'GOPRO12_LensMaxMod2_2.7K_Wide_16.9_HypersmoothOn_HorizonOnv1.mat') == 1;
        valModel = 3;
        valLens = 3;
        listLens = 2;
        valFOV = 2;
        listFOV = 3;
        valRatio = 2;
        listRatio = 1;
        valStab = 3;
        listHyper = 3;
        valHorizon = 3;
        listHorizon = 2;
    elseif strcmpi(handles3.fileFishEyeName, 'GOPRO12_LensMaxMod2_2.7K_MaxSuperView_16.9_HypersmoothOff_HorizonOffv1.mat') == 1;
        valModel = 3;
        valLens = 3;
        listLens = 2;
        valFOV = 3;
        listFOV = 3;
        valRatio = 2;
        listRatio = 1;
        valStab = 2;
        listHyper = 3;
        valHorizon = 2;
        listHorizon = 1;
    elseif strcmpi(handles3.fileFishEyeName, 'GOPRO12_LensMaxMod2_2.7K_MaxSuperView_16.9_HypersmoothOn_HorizonOffv1.mat') == 1;
        valModel = 3;
        valLens = 3;
        listLens = 2;
        valFOV = 3;
        listFOV = 2;
        valRatio = 2;
        listRatio = 1;
        valStab = 3;
        listHyper = 3;
        valHorizon = 2;
        listHorizon = 2;
    elseif strcmpi(handles3.fileFishEyeName, 'GOPRO12_LensMaxMod2_2.7K_MaxSuperView_16.9_HypersmoothOn_HorizonOnv1.mat') == 1;
        valModel = 3;
        valLens = 3;
        listLens = 2;
        valFOV = 3;
        listFOV = 3;
        valRatio = 2;
        listRatio = 1;
        valStab = 3;
        listHyper = 3;
        valHorizon = 3;
        listHorizon = 2;
    elseif strcmpi(handles3.fileFishEyeName, 'DJI6_LensNormal_4K_Standard_16.9_NoRockSteadyv1.mat') == 1;
        valModel = 2;
        valLens = 2;
        listLens = 1;
        valFOV = 2;
        listFOV = 1;
        valRatio = 2;
        listRatio = 2;
        valStab = 2;
        listHyper = 1;
        valHorizon = 1;
        listHorizon = 1;
    elseif strcmpi(handles3.fileFishEyeName, 'DJI6_LensNormal_4K_Standard_16.9_RockSteadyv1.mat') == 1;
        valModel = 2;
        valLens = 2;
        listLens = 1;
        valFOV = 2;
        listFOV = 1;
        valRatio = 2;
        listRatio = 2;
        valStab = 3;
        listHyper = 1;
        valHorizon = 1;
        listHorizon = 1;
    elseif strcmpi(handles3.fileFishEyeName, 'DJI6_LensNormal_4K_Standard_16.9_RockSteadyPlusv1.mat') == 1;
        valModel = 2;
        valLens = 2;
        listLens = 1;
        valFOV = 2;
        listFOV = 1;
        valRatio = 2;
        listRatio = 2;
        valStab = 4;
        listHyper = 1;
        valHorizon = 1;
        listHorizon = 1;
    elseif strcmpi(handles3.fileFishEyeName, 'DJI6_LensNormal_4K_NaturalWide_16.9_NoRockSteadyv1.mat') == 1;
        valModel = 2;
        valLens = 2;
        listLens = 1;
        valFOV = 3;
        listFOV = 1;
        valRatio = 2;
        listRatio = 2;
        valStab = 2;
        listHyper = 1;
        valHorizon = 1;
        listHorizon = 1;
    elseif strcmpi(handles3.fileFishEyeName, 'DJI6_LensNormal_4K_NaturalWide_16.9_RockSteadyv1.mat') == 1;
        valModel = 2;
        valLens = 2;
        listLens = 1;
        valFOV = 3;
        listFOV = 1;
        valRatio = 2;
        listRatio = 2;
        valStab = 3;
        listHyper = 1;
        valHorizon = 1;
        listHorizon = 1;
    elseif strcmpi(handles3.fileFishEyeName, 'DJI6_LensNormal_4K_NaturalWide_16.9_RockSteadyPlusv1.mat') == 1;
        valModel = 2;
        valLens = 2;
        listLens = 1;
        valFOV = 3;
        listFOV = 1;
        valRatio = 2;
        listRatio = 2;
        valStab = 4;
        listHyper = 1;
        valHorizon = 1;
        listHorizon = 1;
    elseif strcmpi(handles3.fileFishEyeName, 'DJI6_LensNormal_4K_Wide_16.9_NoRockSteadyv1.mat') == 1;
        valModel = 2;
        valLens = 2;
        listLens = 1;
        valFOV = 4;
        listFOV = 1;
        valRatio = 2;
        listRatio = 2;
        valStab = 2;
        listHyper = 1;
        valHorizon = 1;
        listHorizon = 1;
    elseif strcmpi(handles3.fileFishEyeName, 'DJI6_LensNormal_4K_Wide_16.9_RockSteadyv1.mat') == 1;
        valModel = 2;
        valLens = 2;
        listLens = 1;
        valFOV = 4;
        listFOV = 1;
        valRatio = 2;
        listRatio = 2;
        valStab = 3;
        listHyper = 1;
        valHorizon = 1;
        listHorizon = 1;
    elseif strcmpi(handles3.fileFishEyeName, 'DJI6_LensNormal_4K_Wide_16.9_RockSteadyPlusv1.mat') == 1;
        valModel = 2;
        valLens = 2;
        listLens = 1;
        valFOV = 4;
        listFOV = 1;
        valRatio = 2;
        listRatio = 2;
        valStab = 4;
        listHyper = 1;
        valHorizon = 1;
        listHorizon = 1;
    elseif strcmpi(handles3.fileFishEyeName, 'DJI6_LensNormal_4K_UltraWide_16.9_NoRockSteadyv1.mat') == 1;
        valModel = 2;
        valLens = 2;
        listLens = 1;
        valFOV = 4;
        listFOV = 1;
        valRatio = 2;
        listRatio = 2;
        valStab = 2;
        listHyper = 1;
        valHorizon = 1;
        listHorizon = 1;
    elseif strcmpi(handles3.fileFishEyeName, 'DJI6_LensNormal_4K_UltraWide_16.9_RockSteadyv1.mat') == 1;
        valModel = 2;
        valLens = 2;
        listLens = 1;
        valFOV = 4;
        listFOV = 1;
        valRatio = 2;
        listRatio = 2;
        valStab = 3;
        listHyper = 1;
        valHorizon = 1;
        listHorizon = 1;
    elseif strcmpi(handles3.fileFishEyeName, 'DJI6_LensNormal_4K_UltraWide_16.9_RockSteadyPlusv1.mat') == 1;
        valModel = 2;
        valLens = 2;
        listLens = 1;
        valFOV = 4;
        listFOV = 1;
        valRatio = 2;
        listRatio = 2;
        valStab = 4;
        listHyper = 1;
        valHorizon = 1;
        listHorizon = 1;
    elseif strcmpi(handles3.fileFishEyeName, 'DJI6_LensBoost_4K_UltraWide_16.9_RockSteadyv1.mat') == 1;
        valModel = 2;
        valLens = 2;
        listLens = 1;
        valFOV = 4;
        listFOV = 1;
        valRatio = 2;
        listRatio = 2;
        valStab = 3;
        listHyper = 1;
        valHorizon = 1;
        listHorizon = 1;
    elseif strcmpi(handles3.fileFishEyeName, 'DJI6_LensBoost_4K_UltraWide_16.9_RockSteadyPlusv1.mat') == 1;
        valModel = 2;
        valLens = 2;
        listLens = 1;
        valFOV = 4;
        listFOV = 1;
        valRatio = 2;
        listRatio = 2;
        valStab = 4;
        listHyper = 1;
        valHorizon = 1;
        listHorizon = 1;
    else;
        valModel = 1;
        valLens = 1;
        listLens = 1;
        valFOV = 1;
        listFOV = 1;
        valRatio = 1;
        listRatio = 2;
        valStab = 1;
        listHyper = 1;
        valHorizon = 1;
        listHorizon = 1;
    end;
end;

handles3.valModel = valModel;
handles3.valLens = valLens;
handles3.valFOV = valFOV;
handles3.valRatio = valRatio;
handles3.valStab = valStab;
handles3.valHorizon = valHorizon;

if ismac == 1;
    font1 = 14;
    font2 = 13;
    font3 = 12;
    font4 = 9;
elseif ispc == 1;
    font1 = 13;
    font2 = 12;
    font3 = 11;
    font4 = 8;
end;


resolution = get(0, 'MonitorPositions');
set(gcf, 'units', 'pixel');
figPos = get(gcf, 'Position');
set(gcf, 'units', 'normalized');

screenValid = 0;
for screenEC = 1:length(resolution(:,1));
    screenLim1 = resolution(screenEC,1);
    screenLim2 = screenLim1+resolution(screenEC,3)-1;

    if figPos(1) >= screenLim1 & figPos(1) <= screenLim2;
        screenValid = screenEC;
    end;
end;
if screenValid == 0;
    screenValid = 1;
end;
offsetLeft = resolution(screenValid,1);
offsetBottom = resolution(screenValid,2);
resolution = resolution(screenValid,3:4);

window_size = floor([(resolution(1)-200)./2 (resolution(2)-300)./2 200 300]);
window_size(1) = window_size(1) + offsetLeft;
window_size(2) = window_size(2) + offsetBottom;
% resolution = get(0,'screensize');
% resolution = resolution(3:4);
% pos = [(resolution(1)-200)./2 (resolution(2)-300)./2 200 300];
handles3.hf_w3_advancedImage = figure('visible', 'on', 'menubar', 'none', 'toolbar', 'none', ...
    'windowstyle', 'normal', 'color', [0.1 0.1 0.1], 'units', 'pixels', 'position', window_size);
set(handles3.hf_w3_advancedImage, 'Name', 'Define your camera', 'NumberTitle', 'off');

if ispc == 1;
    MDIR = getenv('USERPROFILE');
    jFrame=get(handle(handles3.hf_w3_advancedImage), 'javaframe');
    jicon=javax.swing.ImageIcon([MDIR '\SP2VideoManager\SpartaManager_IconSoftware.png']);
    jFrame.setFigureIcon(jicon);
    clc;
end;


%---panel
handles3.cameraSelectionPanel_qual = uipanel('parent', handles3.hf_w3_advancedImage, 'Visible', 'on', 'units', 'pixels', 'position', [5, 5, 190, 290], ...
    'BackgroundColor', [0.1 0.1 0.1], 'Title', 'Select your camera', 'ForegroundColor', [1 1 1], ...
    'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font4+1);
set(handles3.cameraSelectionPanel_qual, 'fontunits', 'normalized', 'units', 'normalized');


%---Camera model
handles3.camera_listDrop = {'Select a camera'; 'DJI Osmo 6'; 'GoPro 12'};
if ismac == 1;
    handles3.cameraDrop_qual = uicontrol('parent', handles3.cameraSelectionPanel_qual, 'Style', 'Popupmenu', 'Visible', 'on', ...
        'units', 'pixels', 'position', [5, 250, 180, 20], 'Value', valModel, 'HorizontalAlignment', 'Center', ...
        'String', handles3.camera_listDrop, 'ForegroundColor', [0 0 0], 'BackgroundColor', [1 1 1], ...
        'FontName', 'Book Antiqua', 'FontWeight', 'Normal', 'Fontsize', font4+1, 'Callback', @modelDrop_cam, 'enable', 'on');
elseif ispc == 1;
    handles3.cameraDrop_qual = uicontrol('parent', handles3.cameraSelectionPanel_qual, 'Style', 'Popupmenu', 'Visible', 'on', ...
        'units', 'pixels', 'position', [5, 250, 180, 20], 'Value', valModel, 'HorizontalAlignment', 'Center', ...
        'String', handles3.camera_listDrop, 'ForegroundColor', [1 1 1], 'BackgroundColor', [0 0 0], ...
        'FontName', 'Book Antiqua', 'FontWeight', 'Normal', 'Fontsize', font4+1, 'Callback', @modelDrop_cam, 'enable', 'on');
end;
set(handles3.cameraDrop_qual, 'fontunits', 'normalized', 'units', 'normalized');


%---Camera lens
handles3.lensModeDJI6_listDrop = {'Select a lens'; 'Normal'; 'Boost'};
handles3.lensModeGopro12_listDrop = {'Select a lens'; 'Normal'; 'Max Mod 2'};
if valLens == 1;
    lensModeEC = 'Select a lens';
    enableEC = 'off';
else;
    if valModel == 2;
        lensModeEC = handles3.lensModeDJI6_listDrop;
    elseif valModel == 3;
        lensModeEC = handles3.lensModeGopro12_listDrop;
    end;
    enableEC = 'on';
end;
if ismac == 1;
    handles3.lensDrop_qual = uicontrol('parent', handles3.cameraSelectionPanel_qual, 'Style', 'Popupmenu', 'Visible', 'on', ...
        'units', 'pixels', 'position', [5, 225, 180, 20], 'Value', valLens, ...
        'HorizontalAlignment', 'Center', 'callback', @lensDrop_cam, ...
        'String', lensModeEC, 'ForegroundColor', [0 0 0], 'BackgroundColor', [1 1 1], ...
        'FontName', 'Book Antiqua', 'FontWeight', 'Normal', 'Fontsize', font4+1, 'enable', enableEC);
elseif ispc == 1;
    handles3.lensDrop_qual = uicontrol('parent', handles3.cameraSelectionPanel_qual, 'Style', 'Popupmenu', 'Visible', 'on', ...
        'units', 'pixels', 'position', [5, 225, 180, 20], 'Value', valLens, ...
        'HorizontalAlignment', 'Center', 'callback', @lensDrop_cam, ...
        'String', lensModeEC, 'ForegroundColor', [1 1 1], 'BackgroundColor', [0 0 0], ...
        'FontName', 'Book Antiqua', 'FontWeight', 'Normal', 'Fontsize', font4+1, 'enable', enableEC);
end;
set(handles3.lensDrop_qual, 'fontunits', 'normalized', 'units', 'normalized');


handles3.fovDJINormal_listDrop = {'Select a FOV'; 'Standard'; 'Natural Wide'; 'Wide'; 'Ultra Wide'};
handles3.fovDJIBoost_listDrop = {'Select a FOV'; 'Wide'; 'Ultra Wide'};
handles3.fovGoproNormal_listDrop = {'Select a FOV'; 'Linear'; 'Wide'};
handles3.fovGoproMaxMod_listDrop = {'Select a FOV'; 'Wide'; 'Max Super View'};
if valModel == 1;
    fovNormal_listDrop_Current = 'Select a FOV';
    enableEC = 'off';
elseif valModel == 2;
    %lists for DJI Osmo 6
    if isempty(listFOV) == 1;
        fovNormal_listDrop_Current = handles3.fovDJINormal_listDrop;
    else;
        if listFOV == 1;
            fovNormal_listDrop_Current = handles3.fovDJINormal_listDrop;
        else;
            fovNormal_listDrop_Current = handles3fovDJIBoost_listDropfovDJIMax_listDrop;
        end;
    end;
    enableEC = 'on';
elseif valModel == 3;
    %lists for Gopro12
    if isempty(listFOV) == 1;
        fovNormal_listDrop_Current = handles3.fovGoproNormal_listDrop;
    else;
        if listFOV == 1;
            fovNormal_listDrop_Current = handles3.fovGoproNormal_listDrop;
        elseif listFOV == 2;
            fovNormal_listDrop_Current = handles3.fovGoproMaxMod_listDrop;
        end;
    end;
    enableEC = 'on';
end;
if ismac == 1;
    handles3.fov_qual = uicontrol('parent', handles3.cameraSelectionPanel_qual, 'Style', 'Popupmenu', 'Visible', 'on', ...
        'units', 'pixels', 'position', [5, 200, 180, 20], 'Value', valFOV, ...
        'HorizontalAlignment', 'Center', 'callback', @fovDrop_cam, ...
        'String', fovNormal_listDrop_Current, 'ForegroundColor', [0 0 0], 'BackgroundColor', [1 1 1], ...
        'FontName', 'Book Antiqua', 'FontWeight', 'Normal', 'Fontsize', font4+1, 'enable', enableEC);
elseif ispc == 1;
    handles3.fov_qual = uicontrol('parent', handles3.cameraSelectionPanel_qual, 'Style', 'Popupmenu', 'Visible', 'on', ...
        'units', 'pixels', 'position', [5, 200, 180, 20], 'Value', valFOV, ...
        'HorizontalAlignment', 'Center', 'callback', @fovDrop_cam, ...
        'String', fovNormal_listDrop_Current, 'ForegroundColor', [1 1 1], 'BackgroundColor', [0 0 0], ...
        'FontName', 'Book Antiqua', 'FontWeight', 'Normal', 'Fontsize', font4+1, 'enable', enableEC);
end;
set(handles3.fov_qual, 'fontunits', 'normalized', 'units', 'normalized');


handles3.ratio87_listDrop = {'Select a ratio'; '16/9'; '8/7'};
handles3.ratio169_listDrop = {'Select a ratio'; '16/9'};
if isempty(listRatio) == 1;
    ratio_listDrop_Current = 'Select a ratio';
    enableEC = 'off';
else;
    if listRatio == 1;
        ratio_listDrop_Current = handles3.ratio87_listDrop;
    elseif listRatio == 2;
        ratio_listDrop_Current = handles3.ratio169_listDrop;
    end;
    enableEC = 'on';
end;

if ismac == 1;
    handles3.ratioDrop_qual = uicontrol('parent', handles3.cameraSelectionPanel_qual, 'Style', 'Popupmenu', 'Visible', 'on', ...
        'units', 'pixels', 'position', [5, 175, 180, 20], 'Value', valRatio, ...
        'HorizontalAlignment', 'Center', 'callback', @ratioDrop_cam, ...
        'String', ratio_listDrop_Current, 'ForegroundColor', [0 0 0], 'BackgroundColor', [1 1 1], ...
        'FontName', 'Book Antiqua', 'FontWeight', 'Normal', 'Fontsize', font4+1, 'enable', enableEC);
elseif ispc == 1;
    handles3.ratioDrop_qual = uicontrol('parent', handles3.cameraSelectionPanel_qual, 'Style', 'Popupmenu', 'Visible', 'on', ...
        'units', 'pixels', 'position', [5, 175, 180, 20], 'Value', valRatio, ...
        'HorizontalAlignment', 'Center', 'callback', @ratioDrop_cam, ...
        'String', ratio_listDrop_Current, 'ForegroundColor', [1 1 1], 'BackgroundColor', [0 0 0], ...
        'FontName', 'Book Antiqua', 'FontWeight', 'Normal', 'Fontsize', font4+1, 'enable', enableEC);
end;
set(handles3.ratioDrop_qual, 'fontunits', 'normalized', 'units', 'normalized');


handles3.DJIhypersmooth1_listDrop = {'Select stabilisation'; 'RockSteady Off'; 'RockSteady On'; 'RockSteady Plus'};
handles3.DJIhypersmooth2_listDrop = {'Select stabilisation'; 'RockSteady On'};
handles3.Goprohypersmooth1_listDrop = {'Select stabilisation'; 'Hypersmooth Off'; 'Hypersmooth On'; 'Hypersmooth Boost'};
handles3.Goprohypersmooth2_listDrop = {'Select stabilisation'; 'Hypersmooth Off'; 'Hypersmooth On'};
if isempty(listHyper) == 1;
    hypersmooth_listDrop_current = 'Select stabilisation';
    enableEC = 'off';
else;
    if valModel == 2;
        if listHyper == 1;
            hypersmooth_listDrop_current = handles3.DJIhypersmooth1_listDrop;
        elseif listHyper == 2;
            hypersmooth_listDrop_current = handles3.DJIhypersmooth1_listDrop;
        end;
    elseif valModel == 3;
        if listHyper == 1;
            hypersmooth_listDrop_current = handles3.Goprohypersmooth1_listDrop;
        elseif listHyper == 2;
            hypersmooth_listDrop_current = handles3.Goprohypersmooth2_listDrop;
        end;
    end;
    enableEC = 'on';
end;
if ismac == 1;
    handles3.hypersmoothDrop_qual = uicontrol('parent', handles3.cameraSelectionPanel_qual, 'Style', 'Popupmenu', 'Visible', 'on', ...
        'units', 'pixels', 'position', [5, 150, 180, 20], 'Value', valStab, ...
        'HorizontalAlignment', 'Center', 'callback', @stabilisationDrop_cam, ...
        'String', hypersmooth_listDrop_current, 'ForegroundColor', [0 0 0], 'BackgroundColor', [1 1 1], ...
        'FontName', 'Book Antiqua', 'FontWeight', 'Normal', 'Fontsize', font4+1, 'enable', enableEC);
elseif ispc == 1;
    handles3.hypersmoothDrop_qual = uicontrol('parent', handles3.cameraSelectionPanel_qual, 'Style', 'Popupmenu', 'Visible', 'on', ...
        'units', 'pixels', 'position', [5, 150, 180, 20], 'Value', valStab, ...
        'HorizontalAlignment', 'Center', 'callback', @stabilisationDrop_cam, ...
        'String', hypersmooth_listDrop_current, 'ForegroundColor', [1 1 1], 'BackgroundColor', [0 0 0], ...
        'FontName', 'Book Antiqua', 'FontWeight', 'Normal', 'Fontsize', font4+1, 'enable', enableEC);
end;
set(handles3.hypersmoothDrop_qual, 'fontunits', 'normalized', 'units', 'normalized');


handles3.horizon1_listDrop = 'Select Horizon';
handles3.horizon2_listDrop = {'Horizon Lock Off'; 'Horizon Lock On'};
if isempty(listHorizon) == 1;
    horizon_listDrop_current = handles3.horizon1_listDrop;
    enableEC = 'off';
else;
    if valModel == 2;
        horizon_listDrop_current = handles3.horizon1_listDrop;
        enableEC = 'off';
    else;
        if listHorizon == 1;
            horizon_listDrop_current = handles3.horizon1_listDrop;
        elseif listHorizon == 2;
            horizon_listDrop_current = handles3.horizon2_listDrop;
        end;
        enableEC = 'on';
    end;
end;
if ismac == 1;
    handles3.horizonDrop_qual = uicontrol('parent', handles3.cameraSelectionPanel_qual, 'Style', 'Popupmenu', 'Visible', 'on', ...
        'units', 'pixels', 'position', [5, 125, 180, 20], 'Value', valHorizon, 'HorizontalAlignment', 'Center', ...
        'String', horizon_listDrop_current, 'ForegroundColor', [0 0 0], 'BackgroundColor', [1 1 1], ...
        'FontName', 'Book Antiqua', 'FontWeight', 'Normal', 'Fontsize', font4+1, 'Callback', '', 'enable', enableEC);
elseif ispc == 1;
    handles3.horizonDrop_qual = uicontrol('parent', handles3.cameraSelectionPanel_qual, 'Style', 'Popupmenu', 'Visible', 'on', ...
        'units', 'pixels', 'position', [5, 125, 180, 20], 'Value', valHorizon, 'HorizontalAlignment', 'Center', ...
        'String', horizon_listDrop_current, 'ForegroundColor', [1 1 1], 'BackgroundColor', [0 0 0], ...
        'FontName', 'Book Antiqua', 'FontWeight', 'Normal', 'Fontsize', font4+1, 'Callback', '', 'enable', enableEC);
end;
set(handles3.horizonDrop_qual, 'fontunits', 'normalized', 'units', 'normalized');


%---Validate and cancel
handles3.validate_qual = uicontrol('parent', handles3.cameraSelectionPanel_qual, 'Style', 'pushbutton', 'Visible', 'on', 'units', 'pixels', ...
    'position', [10, 5, 80, 25], 'callback', @validateCameraSelect_cam, 'cdata', [], 'String', 'Validate', ...
    'BackgroundColor', [0 0 0], 'ForegroundColor', [1 1 1], ...
    'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font4+1, 'enable', 'on');
set(handles3.validate_qual, 'fontunits', 'normalized', 'units', 'normalized');

handles3.cancel_qual = uicontrol('parent', handles3.cameraSelectionPanel_qual, 'Style', 'pushbutton', 'Visible', 'on', 'units', 'pixels', ...
    'position', [100, 5, 80, 25], 'callback', @cancelCameraSelect_cam, 'cdata', [], 'String', 'Cancel', ...
    'BackgroundColor', [0 0 0], 'ForegroundColor', [1 1 1], ...
    'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font4+1, 'enable', 'on');
set(handles3.cancel_qual, 'fontunits', 'normalized', 'units', 'normalized');



drawnow;

% fh = findobj(0,'type','figure');
% set(0, 'CurrentFigure', fh(1).Number);
% guidata(gcf, handles2);

guidata(handles3.hf_w3_advancedImage, handles3);
uiwait(handles3.hf_w3_advancedImage);

% 
% 
% 
% guidata(handles3.hf_w3_advancedImage, handles3);

fh = findobj(0,'type','figure');


if length(fh) > 1;
    index = strcmpi(fh(1).Name, 'Define your camera') == 1;
    if index == 1;
        set(0, 'CurrentFigure', fh(1).Number);
    
        handles3 = guidata(gcf);
        try;
            guidata(gcf, handles3);
            close(gcf);
        catch;
    %         handles2.VidInfo.NbMask = 0;
    %         handles2.VidInfo.Mask1.Pos = [];
    %         handles2.VidInfo.Mask1.Time = [];
    %         handles2.VidInfo.Mask2.Pos = [];
    %         handles2.VidInfo.Mask2.Time = [];
    %         handles2.VidInfo.Mask3.Pos = [];
    %         handles2.VidInfo.Mask3.Time = [];
    %         handles2.VidInfo.Mask4.Pos = [];
    %         handles2.VidInfo.Mask4.Time = [];
    %         handles2.VidInfo.Mask5.Pos = [];
    %         handles2.VidInfo.Mask5.Time = [];
    %         handles2.VidInfo.Mask6.Pos = [];
    %         handles2.VidInfo.Mask6.Time = [];
    %         handles2.VidInfo.Mask7.Pos = [];
    %         VidInfo.Mask7.Time = [];
    %         VidInfo.Mask8.Pos = [];
    %         VidInfo.Mask8.Time = [];
    %         VidInfo.Mask9.Pos = [];
    %         VidInfo.Mask9.Time = [];
    %         VidInfo.Mask10.Pos = [];
    %         VidInfo.Mask10.Time = [];
    %         VidInfo.ImageEnhance.Brightness = 0;
    %         VidInfo.ImageEnhance.Contract = 0;
    % 
    %         handles2.athleteName = [];
    %         handles2.athleteBodyMass = [];
    %         handles2.trialDate = [];
    %         handles2.trialStroke = [];
    %         handles2.trialType = [];
    %         handles2.trialKicker = [];
    %         handles2.trialWedge = [];
    %         handles2.trialTech1 = [];
    %         handles2.trialTech2 = [];
    %         handles2.trialTech3 = [];
    %         handles2.trialLoad = [];
    %         handles2.trialComments = [];
    %         guidata(gcf, handles2);
        end;
    end;
end;