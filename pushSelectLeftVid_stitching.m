function [] = pushSelectLeftVid_stitching(varargin);

handles = guidata(gcf);

if ispc == 1;
    MDIR = getenv('USERPROFILE');
elseif ismac == 1;
    MDIR = '/Applications';
end;

[file,path] = uigetfile({'*.*';'*.MP4';'*.mp4';'*.MOV';'*.mov';'*.MXF'},...
                      'Select your panning video file', handles.defaultpath);

if file == 0
    return;
end;


set(handles.txtProgress_stitching, 'String', 'Loading video ...', 'Visible', 'on');
handles.sourceSlider = 1;
if isempty(handles.pathLeftfile_stitching) == 0 &  isempty(handles.pathRightfile_stitching) == 0;
    %---Reset if both videos have been loaded
    handles.pathLeftfile_stitching = [];

    handles.ptDLTLeft = NaN(50,4); %create 50 empty points
    handles.ptDLTRight = NaN(50,4); %create 50 empty points
    handles.ptStitchingLeft = zeros(50,2); %create 50 empty points
    handles.ptStitchingRight = zeros(50,2); %create 50 empty points
    listPointStitch{1,1} = 'Auto';
    for ptEC = 1:50;
        textEC = ['Pt ' num2str(ptEC)];
        eval(['listPointStitch{' num2str(ptEC+1) ',1} = ' '''' textEC '''' ';']);
    end;
    set(handles.selectPtStitching_stitching, 'String', listPointStitch, 'Value', 1);
    istPointDLT{1,1} = '';
    for ptEC = 1:50;
        textEC = ['Pt ' num2str(ptEC)];
        eval(['listPointDLT{' num2str(ptEC+1) ',1} = ' '''' textEC '''' ';']);
    end;
    set(handles.selectPtDLT_stitching, 'String', listPointDLT, 'Value', 1);
    set(handles.selectDLTcoorX_EDIT_stitching, 'String', '');
    set(handles.selectDLTcoorY_EDIT_stitching, 'String', '');

    handles.trimInValLeft_stitching = [];
    handles.trimOutValLeft_stitching = [];
    handles.trimInValRight_stitching = [];
    handles.trimOutValRight_stitching = [];

    handles.pathRightfile_stitching = [];
    handles.VidInfoRightStitching = [];
    set(handles.filenameRightvid_stitching, 'String', '');
    
    axes(handles.mainLeftVideo_stitching);
    cla reset; %also delete all the stitching and dlt points
    set(handles.mainLeftVideo_stitching, 'Xcolor', [0.1 0.1 0.1], 'XTick', [], ...
        'Ycolor', [0.1 0.1 0.1], 'YTick', [], ...
        'color', [0 0 0]);
    
    axes(handles.mainRightVideo_stitching);
    cla reset; %also delete all the stitching and dlt points
    set(handles.mainRightVideo_stitching, 'Xcolor', [0.1 0.1 0.1], 'XTick', [], ...
        'Ycolor', [0.1 0.1 0.1], 'YTick', [], ...
        'color', [0 0 0]);
        
    for ptStitching = 1:50; %left vid axes
        axes(handles.mainLeftVideo_stitching); hold on;
        p = nsidedpoly(10, 'Center', [5 5], 'Radius', 10);
        circle = plot(p, 'FaceColor', [1 0 0], 'EdgeColor', [1 0 0], 'Visible', 'off');
        eval(['handles.markerDispLeftP' num2str(ptStitching) ' = circle;']);
        clear circle;
    end;
    for ptStitching = 1:50; %Right vid axes
        axes(handles.mainRightVideo_stitching); hold on;
        p = nsidedpoly(10, 'Center', [5 5], 'Radius', 10);
        circle = plot(p, 'FaceColor', [1 0 0], 'EdgeColor', [1 0 0], 'Visible', 'off');
        eval(['handles.markerDispRightP' num2str(ptStitching) ' = circle;']);
        clear circle;
    end;
    
    %---Create DLT stitching points
    for ptStitching = 1:50; %left vid axes
        axes(handles.mainLeftVideo_stitching); hold on;
        p = nsidedpoly(10, 'Center', [5 5], 'Radius', 10);
        circle = plot(p, 'FaceColor', [1 0 1], 'EdgeColor', [1 0 1], 'Visible', 'off');
        eval(['handles.markerDLTLeftP' num2str(ptStitching) ' = circle;']);
        clear circle;
    end;
    for ptStitching = 1:50; %Right vid axes
        axes(handles.mainRightVideo_stitching); hold on;
        p = nsidedpoly(10, 'Center', [5 5], 'Radius', 10);
        circle = plot(p, 'FaceColor', [1 0 1], 'EdgeColor', [1 0 1], 'Visible', 'off');
        eval(['handles.markerDLTRightP' num2str(ptStitching) ' = circle;']);
        clear circle;
    end;
end;
%---



fileEC = [path file];    
[videoinputfolderINI, name, ext] = fileparts(fileEC);
fileEC = [name ext];

disppath = fileEC;
set(handles.filenameLeftvid_stitching, 'String', disppath);
posExtent = get(handles.filenameLeftvid_stitching, 'Extent');
posReal = get(handles.filenameLeftvid_stitching, 'Position');
if posExtent(3) >= posReal(3);
    disppath = [disppath(1:10) ' ... ' disppath(end-10:end)];
    set(handles.filenameLeftvid_stitching, 'String', disppath);
end;
if ispc == 1;
    handles.pathLeftfile_stitching = [path fileEC];
    set(handles.filenameLeftvid_stitching, 'tooltipstring', handles.pathLeftfile_stitching);
elseif ismac == 1;
    if strcmpi(path(end), '/') == 1;
        path = path(1:end-1);
    end;
    handles.pathLeftfile_stitching = [path fileEC];
    set(handles.filenameLeftvid_stitching, 'tooltipstring', handles.pathLeftfile_stitching);
end;


%trim frames
if ismac == 1;
    ffmpegfolder = [MDIR '/SP2VideoManager/ffmpeg/bin/ffmpeg'];
    command = ['"' ffmpegfolder '" -i "' handles.pathLeftfile_stitching ...
        '" -map 0:v:0 -c copy -f null -'];

elseif ispc == 1;
    
    ffmpegfolder = [MDIR '\SP2VideoManager\ffmpeg\bin\ffmpeg'];
    command = ['"' ffmpegfolder '" -i "' handles.pathLeftfile_stitching ...
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
    set(handles.filenameLeftvid_stitching, 'tooltip', '', 'String', '');
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
handles.resolutionVideoPanning = [1920 1080];
if isempty(liRes720) == 0;
    handles.resolutionVideoPanning = [1280 720];
end;
if isempty(liRes1080) == 0;
    handles.resolutionVideoPanning = [1920 1080];
end;
if isempty(liRes2160) == 0;
    handles.resolutionVideoPanning = [3840 2160];
end;

% if handles.resolutionVideoPanning(1) == 1280;
%     listDrop = {'17 Mbits/s'; '16 Mbits/s'; '15 Mbits/s'; '14 Mbits/s'; '13 Mbits/s'; '12 Mbits/s'; '11 Mbits/s'; '10 Mbits/s'; ...
%         '9 Mbits/s'; '8 Mbits/s'; '7 Mbits/s'; '6 Mbits/s'; '5 Mbits/s'};
%     handles.CurrenCompressionPanning = 17;
%     
% elseif handles.resolutionVideoPanning(1) == 1920;
%     listDrop = {'35 Mbits/s'; '34 Mbits/s'; '33 Mbits/s'; '32 Mbits/s'; '31 Mbits/s'; '30 Mbits/s'; '29 Mbits/s'; '28 Mbits/s'; ...
%         '27 Mbits/s'; '26 Mbits/s'; '25 Mbits/s'; '23 Mbits/s'; '24 Mbits/s'; '23 Mbits/s'; '22 Mbits/s'; '21 Mbit/s'; ...
%         '20 Mbits/s'; '19 Mbits/s'; '18 Mbits/s'; '17 Mbits/s'; '16 Mbits/s'; '15 Mbits/s'; '14 Mbits/s'; '13 Mbit/s'; ...
%         '12 Mbits/s'; '11 Mbits/s'; '10 Mbits/s'; '9 Mbits/s'; '8 Mbits/s'; '7 Mbits/s'; '6 Mbits/s'; '5 Mbit/s'; '4 Mbit/s'; '3 Mbit/s'; '2 Mbit/s'};
%     handles.CurrenCompressionPanning = 35;
% 
% elseif handles.resolutionVideoPanning(1) == 3840;
%     listDrop = {'150 Mbits/s'; '145 Mbits/s'; '140 Mbits/s'; '135 Mbits/s'; '130 Mbits/s'; '125 Mbits/s'; '120 Mbits/s'; '115 Mbits/s'; ...
%         '110 Mbits/s'; '105 Mbits/s'; '100 Mbits/s'; '95 Mbits/s'; '90 Mbits/s'; '85 Mbits/s'; '80 Mbits/s'; '75 Mbit/s'; ...
%         '70 Mbits/s'; '65 Mbits/s'; '60 Mbits/s'; '55 Mbits/s'; '50 Mbits/s'; '45 Mbits/s'; '40 Mbits/s'; '35 Mbit/s'; ...
%         '30 Mbits/s'; '25 Mbits/s'; '20 Mbits/s'; '15 Mbits/s'; '10 Mbits/s'; '5 Mbit/s'};
%     handles.CurrenCompressionPanning = 150;
% end;    
% set(handles.popCompression_single, 'String', listDrop);
% handles.listDropCompressionPanning = listDrop;
% handles.listDropCompressionPosPanning = 1;


%---Get video
fileEC = handles.pathLeftfile_stitching;
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

xlim(handles.mainLeftVideo_stitching, VidInfo.xlimValCurrent);
ylim(handles.mainLeftVideo_stitching, VidInfo.ylimValCurrent);
VidInfo.NbFrames = VidInfo.NbFrames-1;
VidInfo.ImageEnhance.Contract = 0;
VidInfo.ImageEnhance.Brightness = 0;
VidInfo.FishEye = [];
handles.activeVideo_stitching = 1;

handles.sliderControlLeft_push_stitching.Data = [1:VidInfo.NbFrames];
handles.VidInfoLeftStitching = VidInfo;
handles.VidInfo = [];
handles.savedOutputStichingNormal = [];
handles.savedOutputStichingTop = [];
guidata(handles.hf_w1_welcome, handles);
handles.sliderControlLeft_push_stitching.Value = 1;
handles = guidata(gcf);
% handles.mainVideoPanning_single = gca;
[tb,btns] = axtoolbar(handles.mainLeftVideo_stitching, {'zoomin','zoomout','pan'});

set(handles.mainRightVideo_stitching, 'Visible', 'off');
if isfield(handles, 'loadVideoimdisplayedStitchRight') == 1;
    if isvalid(handles.loadVideoimdisplayedStitchRight) == 1;
        set(handles.loadVideoimdisplayedStitchRight, 'Visible', 'off');
    end;
end;

set(handles.hf_w1_welcome, 'units', 'Pixels');
posWindow = get(handles.hf_w1_welcome, 'Position');
set(handles.hf_w1_welcome, 'units', 'Normalized');

posSliderNew(1,1) = handles.sliderControlRight_push_stitchingPositionNorm(1,1).*posWindow(1,3);
posSliderNew(1,2) = handles.sliderControlRight_push_stitchingPositionNorm(1,2).*posWindow(1,4);
posSliderNew(1,3) = handles.sliderControlRight_push_stitchingPositionNorm(1,3).*posWindow(1,3);
posSliderNew(1,4) = handles.sliderControlRight_push_stitchingPositionNorm(1,4).*posWindow(1,4);
handles.sliderControlRight_push_stitching.Position = [0 0 1 1];

set(handles.mainLeftVideo_stitching, 'Visible', 'on');
uistack(handles.mainLeftVideo_stitching, 'top');

%Reset pairing points position
for ptStitching = 1:50; %left vid axes
    eval(['circleEC = handles.markerDispLeftP' num2str(ptStitching) ';']);
    p = nsidedpoly(8, 'Center', [0 0], 'Radius', 10);
    circleEC.Shape = p;
    circleEC.Visible = 'off'; 
    eval(['handles.markerDispLeftP' num2str(ptStitching) ' = circleEC;']);
    clear circleEC;
end;
handles.ptStitchingLeft = zeros(50,2); %create 50 empty points
handles.ptStitichingLeft_lastSelect = 0;
set(handles.selectPtStitching_stitching, 'value', 1);

%Reset DLT points position
for ptStitching = 1:50; %left vid axes
    eval(['circleEC = handles.markerDLTLeftP' num2str(ptStitching) ';']);
    p = nsidedpoly(8, 'Center', [0 0], 'Radius', 10);
    circleEC.Shape = p;
    circleEC.Visible = 'off'; 
    eval(['handles.markerDLTLeftP' num2str(ptStitching) ' = circleEC;']);
    clear circleEC;
end;
handles.activeDrop = 1; %DLT dropdown menue active
handles.ptDLTLeft = NaN(50,4); %create 50 empty points
handles.ptDLTLeft_lastSelect = 0;
handles.ptcurrentDisplay = 'stitch';
set(handles.selectPtDLT_stitching, 'value', 1);

set(handles.timeCount_TXT_stitching, 'String', [num2str(roundn(handles.VidInfoLeftStitching.TimeEC,-2)) '  /  ' num2str(roundn(handles.VidInfoLeftStitching.Duration,-2))]);
set(handles.frameCount_TXT_stitching, 'String', [num2str(handles.VidInfoLeftStitching.FrameEC) '  /  ' num2str(handles.VidInfoLeftStitching.NbFrames)]);

%---Reset Trim val
handles.trimInValLeft_stitching = [];
handles.trimOutValLeft_stitching = [];

%---Enable tools
if isempty(handles.pathRightfile_stitching) == 0;
    %enable tools only if right video is loaded too
    set(handles.selectPtDLT_stitching, 'enable', 'on', 'Value', 1);
    set(handles.selectDLTcoorX_EDIT_stitching, 'enable', 'on', 'String', '');
    set(handles.selectDLTcoorY_EDIT_stitching, 'enable', 'on', 'String', '');
    set(handles.erasePtDLT_stiching, 'enable', 'on');
    % set(handles.savePtDLT_stiching, 'enable', 'on');
    % set(handles.loadPtDLT_stiching, 'enable', 'on');
    set(handles.selectPtStitching_stitching, 'enable', 'on', 'Value', 1);
    set(handles.erasePtStitch_stiching, 'enable', 'on');
    set(handles.saveCalStitch_stiching, 'enable', 'on');
    set(handles.loadCalStitch_stiching, 'enable', 'on');
    set(handles.trimInScreenPush_stitching, 'enable', 'on');
    set(handles.trimInScreenEdit_stitching, 'enable', 'on', 'String', '');
    set(handles.trimOutScreenPush_stitching, 'enable', 'on');
    set(handles.trimOutScreenEdit_stitching, 'enable', 'on', 'String', '');
    set(handles.previewStitch_stitching, 'enable', 'on');
    set(handles.startProcessing_stitching, 'enable', 'on');
    set(handles.cancelProcessing_stitching, 'enable', 'on');
    handles.sliderControlLeft_push_stitching.Position = posSliderNew;
    set(handles.prevChapControl_push_stitching, 'enable', 'on');
    set(handles.prevFrameControl_push_stitching, 'enable', 'on');
    set(handles.nextFrameControl_push_stitching, 'enable', 'on');
    set(handles.nextChapControl_push_stitching, 'enable', 'on');
    set(handles.swapVid_push_stitching, 'enable', 'on');
    % set(handles.loadFisheye_stitching, 'enable', 'on');
    set(handles.hf_w1_welcome, 'WindowButtonDownFcn', @clickCalibStitching);
    set(handles.hf_w1_welcome, 'KeyPressFcn', @pressKeySelectpt_stitching);
end;

set(handles.txtProgress_stitching, 'String', '', 'Visible', 'off');
drawnow;
guidata(handles.hf_w1_welcome, handles);

