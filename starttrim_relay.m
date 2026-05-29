function [] = starttrim_relay(varargin);

handles2 = guidata(gcf);
feefoffpanningVal = handles2.feefoffpanningVal;
RT = handles2.RT;
fileprocess = handles2.fileprocess;

if ispc == 1;
    MDIR = getenv('USERPROFILE');
elseif ismac == 1;
    MDIR = '/Applications';
end;
if isempty(fileprocess) == 1;
    errorwindow = errordlg('No video file selected', 'Error');
    if ispc == 1;
        MDIR = getenv('USERPROFILE');
        jFrame=get(handle(errorwindow), 'javaframe');
        jicon=javax.swing.ImageIcon([MDIR '\SP2VideoManager\SpartaManager_IconSoftware.png']);
        jFrame.setFigureIcon(jicon);
        clc;
    end;
    return;
end;
if isempty(feefoffpanningVal) == 1;
    errorwindow = errordlg('No feet-off frame (panning)', 'Error');
    if ispc == 1;
        jFrame=get(handle(errorwindow), 'javaframe');
        jicon=javax.swing.ImageIcon([MDIR '\SP2VideoManager\SpartaManager_IconSoftware.png']);
        jFrame.setFigureIcon(jicon);
        clc;
    end;
    return;
end;
if isempty(RT) == 1;
    errorwindow = errordlg('No reation time', 'Error');
    if ispc == 1;
        jFrame=get(handle(errorwindow), 'javaframe');
        jicon=javax.swing.ImageIcon([MDIR '\SP2VideoManager\SpartaManager_IconSoftware.png']);
        jFrame.setFigureIcon(jicon);
        clc;
    end;
    return;
end;

trimVal = floor(feefoffpanningVal - (RT./handles2.framerate));
if trimVal <= 0;
    errorwindow = errordlg('Error negative frame number', 'Error');
    if ispc == 1;
        jFrame=get(handle(errorwindow), 'javaframe');
        jicon=javax.swing.ImageIcon([MDIR '\SP2VideoManager\SpartaManager_IconSoftware.png']);
        jFrame.setFigureIcon(jicon);
        clc;
    end;
    return;
end;

%Temp folder
checkSpecialChar;
if ismac == 1;
    ffmpegfolder = '/opt/homebrew/bin/ffmpeg';
elseif ispc == 1;
    ffmpegfolder = [MDIR '\SP2VideoManager\ffmpeg\bin\ffmpeg'];
end;

if ismac == 1;
    tempfolder = [MDIR '/SP2VideoManager/Temp/'];
    if isdir([MDIR '/SP2VideoManager/Temp']) == 0;
        command = ['mkdir "' tempfolder '"'];
        [status, cmdout] = system(command);
    end;
    command = ['rm "' tempfolder '"*'];
    [status, cmdout] = system(command);
    load /Applications/SP2VideoManager/listVideoPanningFiles.mat;

elseif ispc == 1;
    tempfolder = [MDIR '\SP2VideoManager\Temp\'];
    if isdir([MDIR '\SP2VideoManager\Temp']) == 0;
        command = ['mkdir "' tempfolder '"'];
        [status, cmdout] = system(command);
    end;
    command = ['del /Q "' tempfolder '"*'];
    [status, cmdout] = system(command);
    loadfolder = [MDIR '\SP2VideoManager\listVideoPanningFiles.mat'];
    load(loadfolder);
end;
    
[folder, name, ext] = fileparts(fileprocess);
li = findstr(name, '_copy');
if isempty(li) == 0;
    name = name(1:li(1)-1);
end;

% proceed = 1;
% while proceed == 1;
%     lispecial = strfind(name, '-');
%     if isempty(lispecial) == 0;
%         name2 = [name(1:lispecial(1)-1) name(lispecial(1)+1:end)];
%     else;
%         proceed = 0;
%         name2 = name;
%     end;
%     name = name2;
% end;
% 
% proceed = 1;
% while proceed == 1;
%     lispecial = strfind(name, ['''']);;
%     if isempty(lispecial) == 0;
%         name2 = [name(1:lispecial(1)-1) name(lispecial(1)+1:end)];
%     else;
%         proceed = 0;
%         name2 = name;
%     end;
%     name = name2;
% end;

if ismac == 1;
    if strcmpi(folder(end), '/') == 0;
        folder = [folder '/'];
    end;
elseif ispc == 1;
    if strcmpi(folder(end), '\') == 0;
        folder = [folder '\'];
    end;
end;

fileoutput = [folder name '_synch' ext];
fileoutput2 = [folder name '_synch'];

proceed = 1;
iter = 1;
while proceed == 1
    if isfile(fileoutput) == 1;
        fileoutput = [fileoutput2 '(' num2str(iter) ')' ext];
        iter = iter + 1;
    else;
        proceed = 0;
    end;
    if iter == 10;
        proceed = 0;
    end;
end;
if iter == 10;
    errorwindow = errordlg('File already exists', 'Error');
    if ispc == 1;
        jFrame = get(handle(errorwindow), 'javaframe');
        jicon = javax.swing.ImageIcon([MDIR '\SP2VideoManager\SpartaManager_IconSoftware.png']);
        jFrame.setFigureIcon(jicon);
        clc;
    end;
    return;
end;
set(handles2.status_main, 'String', 'Processing');
drawnow;


%trim frames
if ismac == 1;
    partIn = fileprocess;
    command = ['"' ffmpegfolder '" -i "' partIn ...
        '" -map 0:v:0 -c copy -f null -'];

elseif ispc == 1;
    partIn = fileprocess;
    command = ['"' ffmpegfolder '" -i "' partIn ...
        '" -map 0:v:0 -c copy -f null -'];
end;
[status, cmdout] = system(command);

lifps = strfind(cmdout, 'fps');
cmdoutfps = cmdout(lifps(1)-3:lifps(1)-2);
framerate = roundn(str2num(cmdoutfps),-2);
if framerate < 1;
    framerate = roundn(str2num(cmdoutfps),-2);
else;
    framerate = roundn(1/str2num(cmdoutfps),-2);
end;

failFrame = 0;
liduration = strfind(cmdout, 'frame=');
if length(liduration) ~= 2;
    failFrame = 1;
else;
    cmdoutShort = cmdout(liduration(end)+1:liduration(end)+15);
    lispace = strfind(cmdoutShort, ' ');
    if length(lispace) ~= 2;
        failFrame = 1;
    end;
end;

if failFrame == 0;
    framecount = str2num(cmdoutShort(lispace(1)+1:lispace(2)-1));
    VidTimeOriginal = framecount*roundn(framerate,-2);
    framecountOriginal = framecount;
else;
    liduration = strfind(cmdout, 'time=');
    cmdoutShort = cmdout(liduration(end)+5:liduration(end)+15);
    liduration1 = strfind(cmdoutShort, ':');
    liduration2 = strfind(cmdoutShort, '.');
    sec = str2num(cmdoutShort(liduration1(2)+1:end));
    min = str2num(cmdoutShort(liduration1(1)+1:liduration1(2)-1)).*60;
    hour = str2num(cmdoutShort(1:liduration1(1)-1)).*3600;
    VidTimeOriginal = hour+min+sec;
end;

liRes720 = strfind(cmdout, '1280x720');
liRes1080 = strfind(cmdout, '1920x1080');
liRes2160 = strfind(cmdout, '3840x2160');
if isempty(liRes720) == 0;
    resolutionVideo = [1280 720];
    bitrate = [num2str(handles2.CurrenCompression) 'M'];
end;
if isempty(liRes1080) == 0;
    resolutionVideo = [1920 1080];
    bitrate = [num2str(handles2.CurrenCompression) 'M'];;
end;
if isempty(liRes2160) == 0;
    resolutionVideo = [3840 2160];
    bitrate = [num2str(handles2.CurrenCompression) 'M'];;
end;

bitrate = [num2str(handles2.CurrenCompression) 'M'];
maxrate = bitrate;
bufrate = [num2str(floor((handles2.CurrenCompression)./3)) 'M'];

%export frames
timecut = ceil(trimVal*framerate);


% if framecutIni <= 0;
%     framecutIni = 1;
% end;
if ismac == 1;
    videocutIni = floor(trimVal*framerate);

    outTemp1 = [tempfolder 'tempVideoCrop.MP4'];
    command = ['"' ffmpegfolder '" -accurate_seek -ss ' num2str(videocutIni) ...
        ' -i "' partIn '" -to ' num2str(2) ' -c:v copy "' ...
        outTemp1 '"'];
    [status, cmdout] = system(command);

    if status == 0;
        framecutIni = ((floor(trimVal*framerate))./framerate);
        framecutEnd = framecutIni + (2.*(1/framerate));

        outTemp2 = [tempfolder 'out%d.jpg'];
        command = ['"' ffmpegfolder '" -i "' outTemp1 ...
            '" -r ' num2str(1/framerate) '/1 -q:v 2 "' outTemp2 '"'];
        [status, cmdout] = system(command);
        
        if status == 0;
            command = ['rm "' outTemp1 '"'];
            [status, cmdout] = system(command);
        else;
            errorwindow = errordlg('Impossible to transcode', 'Error');
            return;
        end;
    else;
        errorwindow = errordlg('Impossible to transcode', 'Error');
        return;
    end;

elseif ispc == 1;

    videocutIni = floor(trimVal*framerate);
    outTemp1 = [tempfolder 'tempVideoCrop.MP4'];
    command = ['"' ffmpegfolder '" -accurate_seek -ss ' num2str(videocutIni) ...
        ' -i "' partIn '" -to ' num2str(2) ' -c:v copy "' ...
        outTemp1 '"'];
    [status, cmdout] = system(command);

    if status == 0;
        framecutIni = ((floor(trimVal*framerate))./framerate);
        framecutEnd = framecutIni + (2.*(1/framerate));

        outTemp2 = [tempfolder 'out%d.jpg'];
        command = ['"' ffmpegfolder '" -i "' outTemp1 ...
            '" -r ' num2str(1/framerate) '/1 -q:v 2 "' outTemp2 '"'];
        [status, cmdout] = system(command);

        if status == 0;
            command = ['del /Q "' outTemp1 '"'];
            [status, cmdout] = system(command);
        else;
            errorwindow = errordlg('Impossible to transcode', 'Error');
            if ispc == 1;
                jFrame = get(handle(errorwindow), 'javaframe');
                jicon = javax.swing.ImageIcon([MDIR '\SP2VideoManager\SpartaManager_IconSoftware.png']);
                jFrame.setFigureIcon(jicon);
                clc;
            end;
            return;
        end;
    else;
        errorwindow = errordlg('Impossible to transcode', 'Error');
        if ispc == 1;
            jFrame = get(handle(errorwindow), 'javaframe');
            jicon = javax.swing.ImageIcon([MDIR '\SP2VideoManager\SpartaManager_IconSoftware.png']);
            jFrame.setFigureIcon(jicon);
            clc;
        end;
        return;
    end;
end;

if status == 0;
    %trim video
    if ismac == 1;
        command = ['"' ffmpegfolder '" -accurate_seek -ss ' num2str(timecut) ...
            ' -i "' partIn '" -vcodec libx264 -g 24 -x264-params keyint=24 -preset ultrafast -r ' num2str(1/framerate) ...
            ' -profile:v main -b:v ' bitrate ' -maxrate ' maxrate ' -bufsize ' bufrate ...
            ' -threads 0 -pix_fmt yuv420p "' outTemp1 '"'];

    elseif ispc == 1;
        command = ['"' ffmpegfolder '" -accurate_seek -ss ' num2str(timecut) ...
            ' -i "' partIn '" -vcodec libx264 -g 24 -x264-params keyint=24 -preset ultrafast -r ' num2str(1/framerate) ...
            ' -profile:v main -b:v ' bitrate ' -maxrate ' maxrate ' -bufsize ' bufrate ...
            ' -threads 0 -pix_fmt yuv420p "' outTemp1 '"'];
    end;
    [status, cmdout] = system(command);

    %check video
    if ismac == 1;
        command = ['"' ffmpegfolder '" -i "' outTemp1 ...
            '" -map 0:v:0 -c copy -f null -'];
    elseif ispc == 1;
        command = ['"' ffmpegfolder '" -i "' outTemp1 ...
            '" -map 0:v:0 -c copy -f null -'];
    end;
    [status, cmdout] = system(command);

    failFrame = 0;
    liduration = strfind(cmdout, 'frame=');
    if length(liduration) ~= 2;
        failFrame = 1;
    else;
        cmdoutShort = cmdout(liduration(end)+1:liduration(end)+15);
        lispace = strfind(cmdoutShort, ' ');
        if length(lispace) ~= 2;
            failFrame = 1;
        end;
    end;

    if failFrame == 0;
        framecount = str2num(cmdoutShort(lispace(1)+1:lispace(2)-1));
        VidTimeProcessed = framecount*roundn(framerate,-2);
        framecountProcessed = framecount;
    else;
        liduration = strfind(cmdout, 'time=');
        cmdoutShort = cmdout(liduration(end)+5:liduration(end)+15);
        liduration1 = strfind(cmdoutShort, ':');
        liduration2 = strfind(cmdoutShort, '.');
        sec = str2num(cmdoutShort(liduration1(2)+1:end));
        min = str2num(cmdoutShort(liduration1(1)+1:liduration1(2)-1)).*60;
        hour = str2num(cmdoutShort(1:liduration1(1)-1)).*3600;
        VidTimeProcessed = hour+min+sec;
    end;

    if abs(VidTimeOriginal - VidTimeProcessed) >= framerate;
        %create the extra video using the still frame
        if VidTimeOriginal - VidTimeProcessed > (trimVal*framerate);
            vidTimeIni = trimVal*framerate; %start signal time in the original video
            vidDurTheory = VidTimeOriginal - vidTimeIni; %handles2.Duration;
            vidDurReal = VidTimeProcessed;

            missingFrames = roundn((vidDurTheory - vidDurReal).*(1/framerate),0);

            imageIni = roundn(trimVal - framecutIni + 1, 0);
            imageEnd = roundn(imageIni + missingFrames,0) + 1;

            if missingFrames <= 1;
                if ispc == 1;
                    partOut = fileoutput;
                    fileoutExist = 0;
                    [path, file, cont] = fileparts(fileoutput);
                    listdir = dir(path);
                    file = [file cont];
                    for filelist = 1:length(listdir);
                        fileCheck = listdir(filelist);
                        NameEC = fileCheck.name;
                        if strcmpi(NameEC, file) == 1;
                            fileoutExist = 1;
                        end;
                    end;
                    if fileoutExist == 1;
                        command = ['del /Q "' fileoutput '"'];
                        [status, cmdout] = system(command);
                    end;

                    command = ['"' ffmpegfolder '" -accurate_seek -ss 0' ...
                        ' -to ' num2str(handles2.Duration) ' -i "' outTemp1 '" -c:v copy "' ...
                        partOut '"'];

                elseif ismac == 1;
                    partOut = fileoutput;
                    fileoutExist = 0;
                    [path, file, cont] = fileparts(fileoutput);
                    listdir = dir(path);
                    file = [file cont];
                    for filelist = 1:length(listdir);
                        fileCheck = listdir(filelist);
                        NameEC = fileCheck.name;
                        if strcmpi(NameEC, file) == 1;
                            fileoutExist = 1;
                        end;
                    end;
                    if fileoutExist == 1;
                        command = ['rm "' fileoutput '"'];
                        [status, cmdout] = system(command);
                    end;
                    command = ['"' ffmpegfolder '" -accurate_seek -ss 0' ...
                        ' -to ' num2str(handles2.Duration) ' -i "' outTemp1 '" -c:v copy "' ...
                        partOut '"'];
                end;
                [status, cmdout] = system(command);

            else;

                if ispc == 1;
                    for i = (imageEnd) : 103;
                        outTemp2 = [tempfolder 'out' num2str(i) '.jpg'];
                        command = ['del /Q "' outTemp2 '"'];
                        [status, cmdout] = system(command);
                    end;
                elseif ismac == 1;
                    for i = (imageEnd) : 103;
                        outTemp2 = [tempfolder 'out' num2str(i) '.jpg'];
                        command = ['rm "' outTemp2 '"'];
                        [status, cmdout] = system(command);
                    end;
                end;

                if ismac == 1;
                    outTemp2 = [tempfolder 'out%d.jpg'];
                    outTemp3 = [tempfolder 'extraVideo.MP4'];
                    outTemp4 = [tempfolder 'totVideo.MP4'];
                elseif ispc == 1;
                    outTemp2 = [tempfolder 'out%d.jpg'];
                    outTemp3 = [tempfolder 'extraVideo.MP4'];
                    outTemp4 = [tempfolder 'totVideo.MP4'];
                end;
                command = ['"' ffmpegfolder '" -f image2 -start_number ' num2str(trimVal-framecutIni+1) ' -r ' num2str(1/framerate) ' -i "' outTemp2 '" -f lavfi -i anullsrc -c:v libx264 -x264-params keyint=2 ' ...
                    '-profile:v main -preset ultrafast ' ...
                    '-b:v ' bitrate ' -pix_fmt yuv420p -video_track_timescale ' num2str(1/framerate) 'k -c:a aac -shortest "' outTemp3 '"'];
                [status, cmdout] = system(command);

                %concatenate both videos
                %command = [ffmpegfolder 'ffmpeg -f concat -safe 0 -i /Applications/SP2VideoManager/concatlistTrimPanning.txt -c copy ' videooutputfolder '/' fileOut];
                if ismac == 1;
                    partOut = fileoutput;
                    fileoutExist = 0;
                    [path, file, cont] = fileparts(fileoutput);
                    listdir = dir(path);
                    file = [file cont];
                    for filelist = 1:length(listdir);
                        fileCheck = listdir(filelist);
                        NameEC = fileCheck.name;
                        if strcmpi(NameEC, file) == 1;
                            fileoutExist = 1;
                        end;
                    end;
                    if fileoutExist == 1;
                        command = ['rm "' partOut '"'];
                        [status, cmdout] = system(command);
                    end;
                    command = ['"' ffmpegfolder '" -i "' outTemp3 '" -i "' outTemp1 ...
                        '" -filter_complex "[0:v] [0:a] [1:v] [1:a] concat=n=2:v=1:a=1" -vcodec libx264 -g 24 -x264-params keyint=24 -preset ultrafast -r ' num2str(1/framerate) ...
                        ' -profile:v main -b:v ' bitrate ' -maxrate ' maxrate ' -bufsize ' bufrate ...
                        ' -threads 0 -pix_fmt yuv420p "' outTemp4 '"'];
                    [status, cmdout] = system(command);
                    if status == 1;
                        command = ['"' ffmpegfolder '" -i "' outTemp3 '" -i "' outTemp1 ...
                            '" -filter_complex "[0:v] [1:v] concat=n=2:v=1:a=0" -vcodec libx264 -g 24 -x264-params keyint=24 -preset ultrafast -r ' num2str(1/framerate) ...
                            ' -profile:v main -b:v ' bitrate ' -maxrate ' maxrate ' -bufsize ' bufrate ...
                            ' -threads 0 -pix_fmt yuv420p "' outTemp4 '"'];
                        [status, cmdout] = system(command);
                    end;

                    if status == 0;
                        command = ['"' ffmpegfolder '" -accurate_seek -ss 0' ...
                            ' -to ' num2str(handles2.Duration) ' -i "' outTemp4 '" -c:v copy "' ...
                            partOut '"'];
                        [status, cmdout] = system(command);
                    end;

                elseif ispc == 1;
                    partOut = fileoutput;
                    fileoutExist = 0;
                    [path, file, cont] = fileparts(fileoutput);
                    listdir = dir(path);
                    file = [file cont];
                    for filelist = 1:length(listdir);
                        fileCheck = listdir(filelist);
                        NameEC = fileCheck.name;
                        if strcmpi(NameEC, file) == 1;
                            fileoutExist = 1;
                        end;
                    end;
                    if fileoutExist == 1;
                        command = ['del /Q "' partOut '"'];
                        [status, cmdout] = system(command);
                    end;

                    command = ['"' ffmpegfolder '" -i "' outTemp3 '" -i "' outTemp1 ...
                        '" -filter_complex "[0:v] [0:a] [1:v] [1:a] concat=n=2:v=1:a=1" -vcodec libx264 -g 24 -x264-params keyint=24 -preset ultrafast -r ' num2str(1/framerate) ...
                        ' -profile:v main -b:v ' bitrate ' -maxrate ' maxrate ' -bufsize ' bufrate ...
                        ' -threads 0 -pix_fmt yuv420p "' outTemp4 '"'];
                    [status, cmdout] = system(command);
                    
                    if status == 1;
                        command = ['"' ffmpegfolder '" -i "' outTemp3 '" -i "' outTemp1 ...
                            '" -filter_complex "[0:v] [1:v] concat=n=2:v=1:a=0" -vcodec libx264 -g 24 -x264-params keyint=24 -preset ultrafast -r ' num2str(1/framerate) ...
                            ' -profile:v main -b:v ' bitrate ' -maxrate ' maxrate ' -bufsize ' bufrate ...
                            ' -threads 0 -pix_fmt yuv420p "' outTemp4 '"'];
                        [status, cmdout] = system(command);
                    end;

                    if status == 0;
                        command = ['"' ffmpegfolder '" -accurate_seek -ss 0' ...
                            ' -to ' num2str(handles2.Duration) ' -i "' outTemp4 '" -c:v copy "' ...
                            partOut '"'];
                        [status, cmdout] = system(command);
                    end;
                end;
            end;

            if ismac == 1;
                %delete Temp folder
                command = ['rm "' tempfolder '"*'];
                [status, cmdout] = system(command);
            elseif ispc == 1;
                command = ['del /Q "' tempfolder '"*'];
                [status, cmdout] = system(command);
            end;
        else;
            %%%%%%%%%%%%%%%%%%%%%%%%%
        end
    else;
        errorwindow = errordlg('Impossible to transcode', 'Error');
        if ispc == 1;
            jFrame = get(handle(errorwindow), 'javaframe');
            jicon = javax.swing.ImageIcon([MDIR '\SP2VideoManager\SpartaManager_IconSoftware.png']);
            jFrame.setFigureIcon(jicon);
            clc;
        end;
        return;
    end;
else;
    errorwindow = errordlg('Impossible to transcode', 'Error');
    if ispc == 1;
        jFrame = get(handle(errorwindow), 'javaframe');
        jicon = javax.swing.ImageIcon([MDIR '\SP2VideoManager\SpartaManager_IconSoftware.png']);
        jFrame.setFigureIcon(jicon);
        clc;
    end;
    return;
end

    
    
set(handles2.status_main, 'String', 'Done');
drawnow;

