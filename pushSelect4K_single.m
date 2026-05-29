function [] = pushSelect4K_single(varargin);

handles = guidata(gcf);

if ispc == 1;
    MDIR = getenv('USERPROFILE');
elseif ismac == 1;
    MDIR = '/Applications';
end;

[file,path] = uigetfile({'*.*';'*.MP4';'*.mp4';'*.MOV';'*.mov';'*.MXF'},...
                      'Select your 4K video file', handles.defaultpath);

if file == 0
    return;
end;
handles.sourceSlider = 1;

fileEC = [path file];    
[videoinputfolderINI, name, ext] = fileparts(fileEC);
fileEC = [name ext];

disppath = fileEC;
set(handles.filename4K_single, 'String', disppath);
posExtent = get(handles.filename4K_single, 'Extent');
posReal = get(handles.filename4K_single, 'Position');
if posExtent(3) >= posReal(3);
    disppath = [disppath(1:10) ' ... ' disppath(end-10:end)];
    set(handles.filename4K_single, 'String', disppath);
end;
if ispc == 1;
    handles.path4Kfile_single = [path '\' fileEC];
    set(handles.filename4K_single, 'tooltipstring', handles.path4Kfile_single);
elseif ismac == 1;
    if strcmpi(path(end), '/') == 1;
        path = path(1:end-1);
    end;
    handles.path4Kfile_single = [path '/' fileEC];
    set(handles.filename4K_single, 'tooltipstring', handles.path4Kfile_single);
end;

% if ismac == 1;
% 
%     if strcmpi(path(end), '/') == 1
%         path = path(1:end-1);
%     end;
% 
%     inputfile = [path '/' fileEC];
%     checkSpecialChar;
% 
%     if specialChar_inputfile == 1;
%         inputfile = ['"' inputfile '"'];
%     end;
% 
% elseif ispc == 1;
%     
%     if strcmpi(path(end), '\') == 1
%         path = path(1:end-1);
%     end;
% 
%     inputfile = [path '\' fileEC];
%     checkSpecialChar;
% 
%     if specialChar_inputfile == 1;
%         inputfile = ['"' inputfile '"'];
%     end;
% end;
% handles.path4Kfile_single = inputfile;
        
%trim frames

if ismac == 1;
    ffmpegfolder = [MDIR '/SP2VideoManager/ffmpeg/bin/ffmpeg'];
    command = ['"' ffmpegfolder '" -i "' handles.path4Kfile_single ...
        '" -map 0:v:0 -c copy -f null -'];

elseif ispc == 1;
    ffmpegfolder = [MDIR '\SP2VideoManager\ffmpeg\bin\ffmpeg'];
    command = ['"' ffmpegfolder '" -i "' handles.path4Kfile_single ...
        '" -map 0:v:0 -c copy -f null -'];
end;
[status, cmdout] = system(command);


if status == 1;
    liRestriction = strfind(cmdout, 'Permission denied');
    if isempty(liRestriction) == 0;
        liOneDrive = strfind(lower(cmdout), 'onedrive');
        liDropbox = strfind(lower(cmdout), 'dropbox');

        if isempty(liOneDrive) == 0;
            if ispc == 1;
                errorwindow = errordlg('Permission denied, cannot access this OneDrive folder. Please move your file into a local folder', 'Error');
                jFrame = get(handle(errorwindow), 'javaframe');
                jicon = javax.swing.ImageIcon([MDIR '\SP2VideoManager\SpartaManager_IconSoftware.png']);
                jFrame.setFigureIcon(jicon);
                clc;
                return;
            elseif ismac == 1;
                errordlg('Permission denied, cannot access this OneDrive folder. Please move your file into a local folder', 'Error');
                return;
            end;
        else;
            if isempty(liDropbox) == 0;
                if ispc == 1;
                    errorwindow = errordlg('Permission denied, cannot access this Dropbox folder. Please move your file into a local folder', 'Error');
                    jFrame = get(handle(errorwindow), 'javaframe');
                    jicon = javax.swing.ImageIcon([MDIR '\SP2VideoManager\SpartaManager_IconSoftware.png']);
                    jFrame.setFigureIcon(jicon);
                    clc;
                    return;
                elseif ismac == 1;
                    errordlg('Permission denied, cannot access this Dropbox folder. Please move your file into a local folder', 'Error');
                    return;
                end;
            else;
                if ispc == 1;
                    errorwindow = errordlg('Permission denied, cannot access this folder', 'Error');
                    jFrame = get(handle(errorwindow), 'javaframe');
                    jicon = javax.swing.ImageIcon([MDIR '\SP2VideoManager\SpartaManager_IconSoftware.png']);
                    jFrame.setFigureIcon(jicon);
                    clc;
                    return;
                elseif ismac == 1;
                    errordlg('Permission denied, cannot access this folder', 'Error');
                    return;
                end;
            end;
        end;
    else;
        if ispc == 1;
            errorwindow = errordlg('Unknown error, file cannot be found', 'Error');
            jFrame = get(handle(errorwindow), 'javaframe');
            jicon = javax.swing.ImageIcon([MDIR '\SP2VideoManager\SpartaManager_IconSoftware.png']);
            jFrame.setFigureIcon(jicon);
            clc;
            return;
        elseif ismac == 1;
            errordlg('Unknown error, file cannot be found', 'Error');
            return;
        end;
    end;
    set(handles.filename4K_single, 'tooltip', '', 'String', '');
end;

liduration = strfind(cmdout, 'time=');
cmdoutShort = cmdout(liduration(end)+5:liduration(end)+15);
liduration1 = strfind(cmdoutShort, ':');
liduration2 = strfind(cmdoutShort, '.');
sec = str2num(cmdoutShort(liduration1(2)+1:end));
minu = str2num(cmdoutShort(liduration1(1)+1:liduration1(2)-1)).*60;
hour = str2num(cmdoutShort(1:liduration1(1)-1)).*3600;
VidTimeOriginal = hour+minu+sec;

lifps = strfind(cmdout, 'fps');
cmdoutfps = cmdout(lifps(1)-3:lifps(1)-2);
framerate = roundn(1./roundn(str2num(cmdoutfps),0),-2);
liRes720 = strfind(cmdout, '1280x720');
liRes1080 = strfind(cmdout, '1920x1080');
liRes2160 = strfind(cmdout, '3840x2160');
handles.resolutionVideo4K = [3840 2160];
if isempty(liRes720) == 0;
    handles.resolutionVideo4K = [1280 720];
end;
if isempty(liRes1080) == 0;
    handles.resolutionVideo4K = [1920 1080];
end;
if isempty(liRes2160) == 0;
    handles.resolutionVideo4K = [3840 2160];
end;

if handles.resolutionVideo4K(1) == 1280;
    listDrop = {'17 Mbits/s'; '16 Mbits/s'; '15 Mbits/s'; '14 Mbits/s'; '13 Mbits/s'; '12 Mbits/s'; '11 Mbits/s'; '10 Mbits/s'; ...
        '9 Mbits/s'; '8 Mbits/s'; '7 Mbits/s'; '6 Mbits/s'; '5 Mbits/s'};
    handles.CurrenCompression4K = 17;
    
elseif handles.resolutionVideo4K(1) == 1920;
    listDrop = {'35 Mbits/s'; '34 Mbits/s'; '33 Mbits/s'; '32 Mbits/s'; '31 Mbits/s'; '30 Mbits/s'; '29 Mbits/s'; '28 Mbits/s'; ...
        '27 Mbits/s'; '26 Mbits/s'; '25 Mbits/s'; '23 Mbits/s'; '24 Mbits/s'; '23 Mbits/s'; '22 Mbits/s'; '21 Mbit/s'; ...
        '20 Mbits/s'; '19 Mbits/s'; '18 Mbits/s'; '17 Mbits/s'; '16 Mbits/s'; '15 Mbits/s'; '14 Mbits/s'; '13 Mbit/s'; ...
        '12 Mbits/s'; '11 Mbits/s'; '10 Mbits/s'; '9 Mbits/s'; '8 Mbits/s'; '7 Mbits/s'; '6 Mbits/s'; '5 Mbit/s'; '4 Mbit/s'; '3 Mbit/s'; '2 Mbit/s'};
    handles.CurrenCompression4K = 35;

elseif handles.resolutionVideo4K(1) == 3840;
    listDrop = {'150 Mbits/s'; '145 Mbits/s'; '140 Mbits/s'; '135 Mbits/s'; '130 Mbits/s'; '125 Mbits/s'; '120 Mbits/s'; '115 Mbits/s'; ...
        '110 Mbits/s'; '105 Mbits/s'; '100 Mbits/s'; '95 Mbits/s'; '90 Mbits/s'; '85 Mbits/s'; '80 Mbits/s'; '75 Mbit/s'; ...
        '70 Mbits/s'; '65 Mbits/s'; '60 Mbits/s'; '55 Mbits/s'; '50 Mbits/s'; '45 Mbits/s'; '40 Mbits/s'; '35 Mbit/s'; ...
        '30 Mbits/s'; '25 Mbits/s'; '20 Mbits/s'; '15 Mbits/s'; '10 Mbits/s'; '5 Mbit/s'};
    handles.CurrenCompression4K = 150;
end;    
set(handles.popCompression_single, 'String', listDrop);
handles.listDropCompression4K = listDrop;
handles.listDropCompressionPos4K = 1;


%---Get video
index1 = strfind(handles.path4Kfile_single, '''');
index2 = strfind(handles.path4Kfile_single, '"');
index = [index1 index2];
fileEC = handles.path4Kfile_single;
if isempty(index) == 0;
    fileEC(index) = [];
end;
VidInfo.name = fileEC;
VidInfo.VidObj = VideoReader(VidInfo.name);
VidInfo.player_type = 'Matlab';
VidInfo.Duration = VidInfo.VidObj.Duration-(1/VidInfo.VidObj.FrameRate);

checkTime = floor(VidInfo.Duration) : (1./VidInfo.VidObj.FrameRate) : ceil(VidInfo.Duration);
index = find(checkTime == VidInfo.Duration);
if isempty(index) == 1;
    diffTime = abs(checkTime - VidInfo.Duration);
    [valMin, locMin] = min(diffTime);
    if checkTime(locMin) < VidInfo.Duration;
        locMin = locMin + 1;
    end;
    VidInfo.Duration = checkTime(locMin);
end;

VidInfo.Height = VidInfo.VidObj.Height;
VidInfo.Width = VidInfo.VidObj.Width;
VidInfo.Rate = VidInfo.VidObj.FrameRate;
VidInfo.NbFrames = roundn(VidInfo.Rate.*VidInfo.Duration,0)+1;
VidInfo.FrameEC = 1;
VidInfo.TimeEC = 0;
frame = read(VidInfo.VidObj, 1);
VidInfo.ActiveFrame = frame;


%---Display image and frame/time info
xlimVal = [0 VidInfo.Width];  %xlim(handles.mainVideo_main);
ylimVal = [0 VidInfo.Height]; %ylim(handles.mainVideo_main);
% VidInfo.xlimValIni = xlimVal;
% VidInfo.ylimValIni = ylimVal;
VidInfo.xlimValCurrent = xlimVal;
VidInfo.ylimValCurrent = ylimVal;
% VidInfo.xlimValPrev = xlimVal;
% VidInfo.ylimValPrev = ylimVal;
% VidInfo.zoomLevel = 1;
% VidInfo.mousePos = [1 1];


xlim(handles.mainVideo4K_single, VidInfo.xlimValCurrent);
ylim(handles.mainVideo4K_single, VidInfo.ylimValCurrent);
VidInfo.NbFrames = VidInfo.NbFrames-1;
VidInfo.ImageEnhance.Contract = 0;
VidInfo.ImageEnhance.Brightness = 0;
VidInfo.FishEye = [];
handles.activeVideo_single = 2;

handles.sliderControl_push_single4K.Data = [1:VidInfo.NbFrames];
handles.VidInfo4K = VidInfo;
guidata(handles.hf_w1_welcome, handles);
handles.sliderControl_push_single4K.Value = 1;
handles = guidata(gcf);

axes(handles.mainVideo4K_single);
% handles.mainVideo4K_single = gca;
[tb,btns] = axtoolbar(handles.mainVideo4K_single, {'zoomin','zoomout','pan'});

set(handles.mainVideoPanning_single, 'Visible', 'off');
if isfield(handles, 'loadVideoimdisplayedPanning') == 1;
    if isvalid(handles.loadVideoimdisplayedPanning) == 1;
        set(handles.loadVideoimdisplayedPanning, 'Visible', 'off');
    end;
end;

set(handles.hf_w1_welcome, 'units', 'Pixels');
posWindow = get(handles.hf_w1_welcome, 'Position');
set(handles.hf_w1_welcome, 'units', 'Normalized');

posSliderNew(1,1) = handles.sliderControl_push_singlePanningPositionNorm(1,1).*posWindow(1,3);
posSliderNew(1,2) = handles.sliderControl_push_singlePanningPositionNorm(1,2).*posWindow(1,4);
posSliderNew(1,3) = handles.sliderControl_push_singlePanningPositionNorm(1,3).*posWindow(1,3);
posSliderNew(1,4) = handles.sliderControl_push_singlePanningPositionNorm(1,4).*posWindow(1,4);

handles.sliderControl_push_singlePanning.Position = [0 0 1 1];
set(handles.mainVideo4K_single, 'Visible', 'on');
uistack(handles.mainVideo4K_single, 'top');

set(handles.timeCount_TXT_single, 'String', [num2str(roundn(VidInfo.TimeEC,-2)) '  /  ' num2str(roundn(VidInfo.Duration,-2))]);
set(handles.frameCount_TXT_single, 'String', [num2str(VidInfo.FrameEC) '  /  ' num2str(VidInfo.NbFrames)]);


handles.sliderControl_push_screen.Position = posSliderNew;

%---Enable tools
set(handles.registerfeetoffPanningPush_single, 'enable', 'on');
set(handles.registerfeetoffPanningEdit_single, 'enable', 'on');
set(handles.registerfeetoff4KPush_single, 'enable', 'on');
set(handles.registerfeetoff4KEdit_single, 'enable', 'on');
set(handles.popCompression_single, 'enable', 'on');
set(handles.startProcessing_single, 'enable', 'on');
set(handles.cancelProcessing_single, 'enable', 'on');
handles.sliderControl_push_single4K.Position = posSliderNew;
set(handles.prevChapControl_push_single, 'enable', 'on');
set(handles.prevFrameControl_push_single, 'enable', 'on');
set(handles.nextFrameControl_push_single, 'enable', 'on');
set(handles.nextChap_push_single, 'enable', 'on');
set(handles.swapVid_push_single, 'enable', 'on');

drawnow;
guidata(handles.hf_w1_welcome, handles);

