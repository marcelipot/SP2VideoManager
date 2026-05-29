function loadSessionFishEye_conv(varargin);



handles = guidata(gcf);

[file,path] = uigetfile({'*.*';'*.MAT';'*.mat'},...
                      'Select Image Correction File', handles.defaultpath);

if file == 0
    return;
end;

%-------------------------------Load data----------------------------------
filename = [path file];
set(handles.fileprocess_conv, 'String', 'Loading file ...');
drawnow;
load(filename);

handles.VidCorrectionBatch.ImageEnhance.Contract = VidInfo.ImageEnhance.Contract;
handles.VidCorrectionBatch.ImageEnhance.Brightness = VidInfo.ImageEnhance.Brightness;
handles.VidCorrectionBatch.isexportRateDefault = VidInfo.isexportRateDefault;
handles.VidCorrectionBatch.exportRate = VidInfo.exportRate;
if isempty(VidInfo.FishEye.map_xOpt) == 1;
    %No optimised maps
    if isempty() == 1;
        %no map at all for fish eye correction
        handles.VidCorrectionBatch.FishEye.map_x = [];
        handles.VidCorrectionBatch.FishEye.map_y = [];
    else
        %initial maps for fish eye correction
        handles.VidCorrectionBatch.FishEye.map_x = VidInfo.FishEye.map_xIni;
        handles.VidCorrectionBatch.FishEye.map_y = VidInfo.FishEye.map_yIni;
    end;
else;
    %Optimised maps for fish eye correction
    handles.VidCorrectionBatch.FishEye.map_x = VidInfo.FishEye.map_xOpt;
    handles.VidCorrectionBatch.FishEye.map_y = VidInfo.FishEye.map_yOpt;
end;
handles.VidCorrectionBatch.FishEye.multithreadOption = VidInfo.FishEye.multithreadOption;
handles.isFishEyeFile = 1;
handles.VidStitchingBatch = [];
handles.isStitchingFile = 0;
set(handles.loadSessionFishEye_conv, 'ForegroundColor', [0 1 0]);
set(handles.loadSessionStitching_conv, 'ForegroundColor', [1 1 1]);

set(handles.fileprocess_conv, 'String', 'Processing   :   ...');
%--------------------------------------------------------------------------



guidata(handles.hf_w1_welcome, handles);