function [] = fisheyeRadio1Select_screen(varargin);

handles2 = guidata(gcf);
set(handles2.mainInfos_qual, 'String', 'Loading parameters ...');
drawnow;

if ispc == 1;
    MDIR = getenv('USERPROFILE');
elseif ismac == 1;
    MDIR = '/Applications';
end;

VidInfo = handles2.VidInfo;
if strcmpi(VidInfo.FishEye.fileFishEyeName(end-5:end-4), 'v1') == 1;
    set(handles2.fisheyeType1Radio_qual, 'Value', 1);
    set(handles2.fisheyeType2Radio_qual, 'Value', 0);
    set(handles2.fisheyeType3Radio_qual, 'Value', 0);
    set(handles2.fisheyeType4Radio_qual, 'Value', 0);
    return;
else;
    set(handles2.fisheyeType2Radio_qual, 'Value', 0);
    set(handles2.fisheyeType3Radio_qual, 'Value', 0);
    set(handles2.fisheyeType4Radio_qual, 'Value', 0);
end;

VidInfo.FishEye.fileFishEyeName = [VidInfo.FishEye.fileFishEyeName(1:end-6) 'v1.mat'];
VidInfo.FishEye.fileFishEyeLoaded = 'defined';
VidInfo.FishEye.fisheyeSourceType = 1;

if ismac == 1;
    MDIR = '/Applications/SP2VideoManager';
    fileEC = [MDIR '/FishEyeParam/' VidInfo.FishEye.fileFishEyeName];
elseif ispc == 1;
    MDIR = getenv('USERPROFILE');
    fileEC = [MDIR '\SP2VideoManager\FishEyeParam\' VidInfo.FishEye.fileFishEyeName];
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
VidInfo.FishEye.param = filetosave.params;
VidInfo.FishEye.fileFishEyeLoaded = 'defined';
VidInfo.FishEye.paramIni = [];
VidInfo.FishEye.paramOpt = [];
VidInfo.FishEye.ptDLTAll = NaN(50,4);
VidInfo.FishEye.map_xIni = [];
VidInfo.FishEye.map_yIni = [];
VidInfo.FishEye.map_xOpt = [];
VidInfo.FishEye.map_yOpt = [];
VidInfo.FishEye.extraMappingParamsIni = [];
VidInfo.FishEye.extraMappingParamsOpt = [];
VidInfo.FishEye.doOptimisation = 0;
VidInfo.FishEye.doTopDown = 0;
VidInfo.FishEye.multithreadOption = 1;
VidInfo.ActiveFrameIni = [];
VidInfo.ActiveFrameOpt = [];

map_x = VidInfo.FishEye.map_xIni;
map_y = VidInfo.FishEye.map_yIni;

valEC = get(handles2.validImageDrop_qual, 'value');
if valEC == 1;
    VidInfo.FishEye.keepValid = 'Full';
elseif valEC == 3;
    VidInfo.FishEye.keepValid = 'Valid';
end;

drawnow;

handles2.filetosave = filetosave;
handles2.VidInfo = VidInfo;
guidata(handles2.hf_w2_advancedImage, handles2);
set(handles2.mainInfos_qual, 'String', '');
drawnow;
