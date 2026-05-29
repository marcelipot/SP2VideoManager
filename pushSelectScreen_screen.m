function [] = pushSelectScreen_screen(varargin);

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
set(handles.filenameScreen_screen, 'String', disppath);
posExtent = get(handles.filenameScreen_screen, 'Extent');
posReal = get(handles.filenameScreen_screen, 'Position');
if posExtent(3) >= posReal(3);
    disppath = [disppath(1:10) ' ... ' disppath(end-10:end)];
    set(handles.filenameScreen_screen, 'String', disppath);
end;
if ispc == 1;
    handles.pathSceenfile_screen = [path '\' fileEC];
    set(handles.filenameScreen_screen, 'tooltipstring', handles.pathSceenfile_screen);
elseif ismac == 1;
    if strcmpi(path(end), '/') == 1;
        path = path(1:end-1);
    end;
    handles.pathSceenfile_screen = [path '/' fileEC];
    set(handles.filenameScreen_screen, 'tooltipstring', handles.pathSceenfile_screen);
end;

% if ismac == 1;
% 
%     if strcmpi(path(end), '/') == 1
%         path = path(1:end-1);
%     end;
% 
%     inputfile = [path '/' fileEC];
% elseif ispc == 1;
%     
%     if strcmpi(path(end), '\') == 1
%         path = path(1:end-1);
%     end;
% 
%     inputfile = [path '\' fileEC];
% end;
% handles.pathScreenfile_screen = inputfile;

%trim frames

% if ismac == 1;
%     ffmpegfolder = [MDIR '/SP2VideoManager/ffmpeg/bin/ffmpeg'];
%     command = ['"' ffmpegfolder '"' ' -i ' '"' handles.pathScreenfile_screen '"' ...
%         ' -map 0:v:0 -c copy -f null -'];
% 
% elseif ispc == 1;
%     ffmpegfolder = [MDIR '\SP2VideoManager\ffmpeg\bin\ffmpeg'];
%     command = ['"' ffmpegfolder '"' ' -i ' '"' handles.pathScreenfile_screen '"' ...
%         ' -map 0:v:0 -c copy -f null -'];
% end;
% [status, cmdout] = system(command);
% 
% status
% cmdout
% 
% eee=eee
% 
% if status == 1;
%     liRestriction = strfind(cmdout, 'Permission denied');
%     if isempty(liRestriction) == 0;
%         liOneDrive = strfind(lower(cmdout), 'onedrive');
%         liDropbox = strfind(lower(cmdout), 'dropbox');
% 
%         if isempty(liOneDrive) == 0;
%             if ispc == 1;
%                 errorwindow = errordlg('Permission denied, cannot access this OneDrive folder. Please move your file into a local folder', 'Error');
%                 jFrame = get(handle(errorwindow), 'javaframe');
%                 jicon = javax.swing.ImageIcon([MDIR '\SP2VideoManager\SpartaManager_IconSoftware.png']);
%                 jFrame.setFigureIcon(jicon);
%                 clc;
%                 return;
%             elseif ismac == 1;
%                 errordlg('Permission denied, cannot access this OneDrive folder. Please move your file into a local folder', 'Error');
%                 return;
%             end;
%         else;
%             if isempty(liDropbox) == 0;
%                 if ispc == 1;
%                     errorwindow = errordlg('Permission denied, cannot access this Dropbox folder. Please move your file into a local folder', 'Error');
%                     jFrame = get(handle(errorwindow), 'javaframe');
%                     jicon = javax.swing.ImageIcon([MDIR '\SP2VideoManager\SpartaManager_IconSoftware.png']);
%                     jFrame.setFigureIcon(jicon);
%                     clc;
%                     return;
%                 elseif ismac == 1;
%                     errordlg('Permission denied, cannot access this Dropbox folder. Please move your file into a local folder', 'Error');
%                     return;
%                 end;
%             else;
%                 if ispc == 1;
%                     errorwindow = errordlg('Permission denied, cannot access this folder', 'Error');
%                     jFrame = get(handle(errorwindow), 'javaframe');
%                     jicon = javax.swing.ImageIcon([MDIR '\SP2VideoManager\SpartaManager_IconSoftware.png']);
%                     jFrame.setFigureIcon(jicon);
%                     clc;
%                     return;
%                 elseif ismac == 1;
%                     errordlg('Permission denied, cannot access this folder', 'Error');
%                     return;
%                 end;
%             end;
%         end;
%     else;
%         if ispc == 1;
%             set(handles.filenameScreen_screen, 'String', '', 'tooltipstring', '');
%             errorwindow = errordlg('Unknown error, file cannot be found', 'Error');
%             jFrame = get(handle(errorwindow), 'javaframe');
%             jicon = javax.swing.ImageIcon([MDIR '\SP2VideoManager\SpartaManager_IconSoftware.png']);
%             jFrame.setFigureIcon(jicon);
%             clc;
%             return;
%         elseif ismac == 1;
%             set(handles.filenameScreen_screen, 'String', '', 'tooltipstring', '');
%             errordlg('Unknown error, file cannot be found', 'Error');
%             return;
%         end;
%     end;
% %     set(handles.filename4K_single, 'tooltip', '', 'String', '');
% end;
% 
% liduration = strfind(cmdout, 'time=');
% cmdoutShort = cmdout(liduration(end)+5:liduration(end)+15);
% liduration1 = strfind(cmdoutShort, ':');
% liduration2 = strfind(cmdoutShort, '.');
% sec = str2num(cmdoutShort(liduration1(2)+1:end));
% minu = str2num(cmdoutShort(liduration1(1)+1:liduration1(2)-1)).*60;
% hour = str2num(cmdoutShort(1:liduration1(1)-1)).*3600;
% VidTimeOriginal = hour+minu+sec;
% 
% lifps = strfind(cmdout, 'fps');
% cmdoutfps = cmdout(lifps(1)-3:lifps(1)-2);
% framerate = roundn(1./roundn(str2num(cmdoutfps),0),-2);
% liRes720 = strfind(cmdout, '1280x720');
% liRes1080 = strfind(cmdout, '1920x1080');
% liRes2160 = strfind(cmdout, '3840x2160');

handles.resolutionVideoScreen = [3840 2160];
% if isempty(liRes720) == 0;
%     handles.resolutionVideoScreen = [1280 720];
% end;
% if isempty(liRes1080) == 0;
%     handles.resolutionVideoScreen = [1920 1080];
% end;
% if isempty(liRes2160) == 0;
    handles.resolutionVideoScreen = [3840 2160];
% end;

if handles.resolutionVideoScreen(1) == 1280;
    listDrop = {'17 Mbits/s'; '16 Mbits/s'; '15 Mbits/s'; '14 Mbits/s'; '13 Mbits/s'; '12 Mbits/s'; '11 Mbits/s'; '10 Mbits/s'; ...
        '9 Mbits/s'; '8 Mbits/s'; '7 Mbits/s'; '6 Mbits/s'; '5 Mbits/s'; 'Remux'};
    handles.CurrenCompressionScreen = 17;
    
elseif handles.resolutionVideoScreen(1) == 1920;
    listDrop = {'35 Mbits/s'; '34 Mbits/s'; '33 Mbits/s'; '32 Mbits/s'; '31 Mbits/s'; '30 Mbits/s'; '29 Mbits/s'; '28 Mbits/s'; ...
        '27 Mbits/s'; '26 Mbits/s'; '25 Mbits/s'; '23 Mbits/s'; '24 Mbits/s'; '23 Mbits/s'; '22 Mbits/s'; '21 Mbit/s'; ...
        '20 Mbits/s'; '19 Mbits/s'; '18 Mbits/s'; '17 Mbits/s'; '16 Mbits/s'; '15 Mbits/s'; '14 Mbits/s'; '13 Mbit/s'; ...
        '12 Mbits/s'; '11 Mbits/s'; '10 Mbits/s'; '9 Mbits/s'; '8 Mbits/s'; '7 Mbits/s'; '6 Mbits/s'; '5 Mbit/s'; '4 Mbit/s'; '3 Mbit/s'; '2 Mbit/s'; 'Remux'};
    handles.CurrenCompressionScreen = 35;

elseif handles.resolutionVideoScreen(1) == 3840;
    listDrop = {'250 Mbits/s'; '240 Mbits/s'; '230 Mbits/s'; '220 Mbits/s'; '210 Mbits/s'; '200 Mbits/s'; '190 Mbits/s'; '180 Mbits/s'; ...
        '170 Mbits/s'; '160 Mbits/s'; '150 Mbits/s'; '140 Mbits/s'; '130 Mbits/s'; '120 Mbits/s'; '110 Mbits/s'; '100 Mbit/s'; ...
        '90 Mbits/s'; '80 Mbits/s'; '70 Mbits/s'; '60 Mbits/s'; '50 Mbits/s'; '40 Mbits/s'; '30 Mbits/s'; '20 Mbits/s'; '10 Mbits/s'; 'Remux'};
    handles.CurrenCompressionScreen = 250;
end;    
set(handles.popCompression_screen, 'String', listDrop);
handles.listDropCompressionScreen = listDrop;
handles.listDropCompressionPosScreen = 1;


%---Get video
fileEC = handles.pathSceenfile_screen;
VidInfo.name = fileEC;
VidInfo.VidObj = VideoReader(VidInfo.name);
VidInfo.player_type = 'Matlab';
VidInfo.Duration = VidInfo.VidObj.Duration-(1/VidInfo.VidObj.FrameRate);
VidInfo.multithreadOption = 1;

try;
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
end;
VidInfo.Height = VidInfo.VidObj.Height;
VidInfo.Width = VidInfo.VidObj.Width;
VidInfo.Rate = VidInfo.VidObj.FrameRate;
VidInfo.exportRate = VidInfo.Rate;
VidInfo.isexportRateDefault = 1;
VidInfo.NbFrames = roundn(VidInfo.Rate.*VidInfo.Duration,0)+1;
VidInfo.FrameEC = 1;
VidInfo.TimeEC = 0;
VidInfo.filename = fileEC;
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

% try;
%     set(handles.loadVideoimdisplayedScreen, 'Visible', 'off');
% end;
% set(handles.mainVideoScreen_screen, 'Visible', 'on');
% uistack(handles.mainVideoScreen_screen, 'top');


xlim(handles.mainVideoScreen_screen, VidInfo.xlimValCurrent);
ylim(handles.mainVideoScreen_screen, VidInfo.ylimValCurrent);
VidInfo.NbFrames = VidInfo.NbFrames-1;
VidInfo.ImageEnhance.Contract = 0;
VidInfo.ImageEnhance.Brightness = 0;
VidInfo.FishEye = [];

handles.sliderControl_push_screen.Data = [1:VidInfo.NbFrames];
handles.VidInfoScreen = VidInfo;
guidata(handles.hf_w1_welcome, handles);
handles.sliderControl_push_screen.Value = 1;
handles = guidata(gcf);

axes(handles.mainVideoScreen_screen);
[tb,btns] = axtoolbar(handles.mainVideoScreen_screen, {'zoomin','zoomout','pan'});


set(handles.timeCount_TXT_screen, 'String', [num2str(roundn(VidInfo.TimeEC,-2)) '  /  ' num2str(roundn(VidInfo.Duration,-2))]);
set(handles.frameCount_TXT_screen, 'String', [num2str(VidInfo.FrameEC) '  /  ' num2str(VidInfo.NbFrames)]);


%---Enable tools
handles.trimInVal_screen = [];
handles.trimOutVal_screen = [];

set(handles.trimInScreenPush_screen, 'enable', 'on');
set(handles.trimInScreenEdit_screen, 'enable', 'on', 'String', '');
set(handles.trimOutScreenPush_screen, 'enable', 'on');
set(handles.trimOutScreenEdit_screen, 'enable', 'on', 'String', '');
set(handles.popCompression_screen, 'enable', 'on', 'Value', 1);
set(handles.advancedSetting_screen, 'enable', 'on', 'BackgroundColor', [0.26 0.26 0.26]);
set(handles.startProcessing_screen, 'enable', 'on');
set(handles.cancelProcessing_screen, 'enable', 'on');
set(handles.prevChapControl_push_screen, 'enable', 'on');
set(handles.prevFrameControl_push_screen, 'enable', 'on');
set(handles.nextFrameControl_push_screen, 'enable', 'on');
set(handles.nextChap_push_screen, 'enable', 'on');
% set(handles.swapVid_push_screen, 'enable', 'on');

drawnow;
guidata(handles.hf_w1_welcome, handles);

