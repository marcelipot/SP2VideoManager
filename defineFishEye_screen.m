function defineFishEye_screen(varargin);



handles2 = guidata(gcf);
handles3 = defineFishEyeUI_screen;

if isempty(handles3) == 1;
    return;
end;
if isempty(handles3.fileFishEyeName) == 1;
    return;
end;

if ismac == 1;
    MDIR = '/Applications/SP2VideoManager';
    fileEC = [MDIR '/FishEyeParam/' handles3.fileFishEyeName];
elseif ispc == 1;
    MDIR = getenv('USERPROFILE');
    fileEC = [MDIR '\SP2VideoManager\FishEyeParam\' handles3.fileFishEyeName];
end;

if isfile(fileEC) == 0;
    if ismac == 1;
        errorwindow = errordlg('FishEye parameters could not be found', 'Error');
        return;
    elseif ispc == 1;
        errorwindow = errordlg('FishEye parameters could not be found', 'Error');
        jFrame = get(handle(errorwindow), 'javaframe');
        jicon = javax.swing.ImageIcon([MDIR '\SP2VideoManager\SpartaManager_IconSoftware.png']);
        jFrame.setFigureIcon(jicon);
        clc;
        return;
    end;
end;

load(fileEC);
VidInfo = handles2.VidInfo;
VidInfo.FishEye.fileFishEyeName = handles3.fileFishEyeName;
VidInfo.FishEye.fileFishEyeLoaded = 'defined';
VidInfo.FishEye.param = filetosave.params;
VidInfo.FishEye.paramIni = [];
VidInfo.FishEye.paramOpt = [];
VidInfo.FishEye.ptDLTAll = NaN(50,4);
VidInfo.FishEye.ptDLTAllOri = NaN(50,4);
VidInfo.FishEye.ptDLTAllOpt = NaN(50,4);
VidInfo.FishEye.map_xIni = [];
VidInfo.FishEye.map_yIni = [];
VidInfo.FishEye.map_xOpt = [];
VidInfo.FishEye.map_yOpt = [];
VidInfo.FishEye.extraMappingParamsIni = [];
VidInfo.FishEye.extraMappingParamsOpt = [];
VidInfo.FishEye.doOptimisation1 = 0;
VidInfo.FishEye.doOptimisation2 = 0;
VidInfo.FishEye.doTopDown = 0;
VidInfo.FishEye.multithreadOption = 1;
VidInfo.ActiveFrameIni = [];
VidInfo.ActiveFrameOpt = [];

map_x = VidInfo.FishEye.map_xIni;
map_y = VidInfo.FishEye.map_yIni;

if isfield(filetosave, 'keepValid') == 1;
    VidInfo.FishEye.keepValid = filetosave.keepValid;
    if filetosave.keepValid == 1;
        set(handles2.validImageDrop_qual, 'Value', 1, 'enable', 'on');
    else;
        set(handles2.validImageDrop_qual, 'Value', 2, 'enable', 'on');
    end;
else;
    set(handles2.validImageDrop_qual, 'Value', 1, 'enable', 'on');
    VidInfo.FishEye.keepValid = 'Full';
end;


% %---Update the UI
set(handles2.multiThreadRadio_qual, 'enable', 'on', 'value', 1);
set(handles2.fisheyeType1Radio_qual, 'enable', 'on', 'value', 1);
VidInfo.FishEye.fisheyeSourceType = 1;
set(handles2.fisheyeType2Radio_qual, 'enable', 'on', 'value', 0);
set(handles2.fisheyeType3Radio_qual, 'enable', 'on', 'value', 0);
set(handles2.fisheyeType4Radio_qual, 'enable', 'on', 'value', 0);
set(handles2.apply2_qual, 'enable', 'on');
set(handles2.restore2_qual, 'enable', 'on');

% for ptDLT = 1:50; %left vid axes
%     axes(handles2.mainVideo_qual); hold on;
%     p = nsidedpoly(10, 'Center', [5 5], 'Radius', 10);
%     circle = plot(p, 'FaceColor', [1 0 0], 'EdgeColor', [1 0 0], 'Visible', 'off');
%     eval(['handles2.markerDLTP' num2str(ptDLT) ' = circle;']);
%     clear circle;
% end;
% handles2.ptDLTAll = NaN(50,4);
drawnow;

%---Save parameters
handles2.filetosave = filetosave;
handles2.VidInfo = VidInfo;
guidata(handles2.hf_w2_advancedImage, handles2);


%---Apply parameters
if isempty(VidInfo.FishEye.map_xIni) == 1;
    %no existing mapping data... create it
%     applyFishEyeUI_screen;
else;
    %exiting mapping data... just apply it
    frame = VidInfo.ActiveFrame;
    [frame, ~] = imagesbuiltinImageInterpolation2D(frame, map_x, map_y, 'nearest', 0);

    %---Apply enhancement
    if VidInfo.ImageEnhance.Contract ~= 0;
        contrastamt = 1 + VidInfo.ImageEnhance.Contract./10;
        HSV = rgb2hsv(frame);
        HSV(:, :, 2) = HSV(:, :, 2) * contrastamt;
        HSV(HSV > 1) = 1;
        frame = hsv2rgb(HSV);
    end;
    
    if VidInfo.ImageEnhance.Brightness ~= 0;
        contrastamt = VidInfo.ImageEnhance.Brightness./10;
        if VidInfo.ImageEnhance.Brightness < 0;
            olhi = tan((contrastamt+1)*pi/4)*0.5 + 0.5;
            frame = imadjust(frame, [0 1], [1-olhi olhi], 1);
    %         frame = imadjust(frame, [(VidInfo.ImageEnhance.Brightness./10) 0]);
        else;
            olhi = tan((1-contrastamt)*pi/4)*0.5 + 0.5;
            frame = imadjust(frame, [1-olhi olhi], [0 1], 1);
    %         frame = imadjust(frame, [0 (VidInfo.ImageEnhance.Brightness./10)]);
        end;
    end;
    
    
    %---update the axes
    if isfield(handles2, 'qualVideoimdisplayed') == 1;
        %field exist
        if isvalid(handles2.qualVideoimdisplayed) == 1;
            %exist and valid
            cla(handles2.mainVideo_qual, 'reset');
            axes(handles2.mainVideo_qual);
            handles2.qualVideoimdisplayed = imshow(frame);
        else;
            %not valid: need to create it again
            cla(handles2.mainVideo_qual, 'reset');
            axes(handles2.mainVideo_qual);
            handles2.qualVideoimdisplayed = imshow(frame);
        end;
    else;
        %create field
        cla(handles2.mainVideo_qual, 'reset');
        axes(handles2.mainVideo_qual);
        handles2.qualVideoimdisplayed = imshow(frame);
    end;
    [tb,btns] = axtoolbar(handles2.mainVideo_qual, {'zoomin','zoomout','pan'});

    set(handles2.mainInfos_qual, 'String', '');
end;


%---Create refine DLT stitching points
for ptDLT = 1:50; 
    axes(handles2.mainVideo_qual); hold on;
    p = nsidedpoly(10, 'Center', [5 5], 'Radius', 10);
    circle = plot(p, 'FaceColor', [1 0 0], 'EdgeColor', [1 0 0], 'Visible', 'off');
    eval(['handles2.markerDLTP' num2str(ptDLT) ' = circle;']);
    clear circle;
end;
handles2.correctionUpdateTrigger = 'new';
guidata(handles2.hf_w2_advancedImage, handles2);
