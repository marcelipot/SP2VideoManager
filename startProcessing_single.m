function [] = startProcessing_single(varargin);



handles = guidata(gcf);

feefoffpanningVal = handles.feefoffpanningVal_single;
feefoff4KVal = handles.feefoff4KVal_single;
fileprocess = handles.pathPanningfile_single;

if ispc == 1;
    MDIR = getenv('USERPROFILE');
elseif ismac == 1;
    MDIR = '/Applications';
end;

if isempty(fileprocess) == 1;
    errorwindow = errordlg('No panning video selected', 'Error');
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
if isempty(feefoff4KVal) == 1;
    errorwindow = errordlg('No feet-off frame (4K)', 'Error');
    if ispc == 1;
        jFrame=get(handle(errorwindow), 'javaframe');
        jicon=javax.swing.ImageIcon([MDIR '\SP2VideoManager\SpartaManager_IconSoftware.png']);
        jFrame.setFigureIcon(jicon);
        clc;
    end;
    return;
end;

trimVal = feefoffpanningVal - feefoff4KVal;
if trimVal == 0;
    errorwindow = errordlg('Cannot trim 0 frame off this file', 'Error');
    if ispc == 1;
        jFrame=get(handle(errorwindow), 'javaframe');
        jicon=javax.swing.ImageIcon([MDIR '\SP2Viewer\SpartaViewer_IconSoftware.png']);
        jFrame.setFigureIcon(jicon);
        clc;
    end;
    return;
end;

%Temp folder
if ismac == 1
    ffmpegfolder = '/opt/homebrew/bin/ffmpeg';
elseif ispc == 1;
    ffmpegfolder = [MDIR '\SP2VideoManager\ffmpeg\bin\ffmpeg'];
end;

if ismac == 1;
    tempfolder = [MDIR '/SP2VideoManager/Temp/'];
    if isdir('/Applications/SP2VideoManager/Temp') == 0;
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
% set(handles2.status_main, 'String', 'Processing');
drawnow;

set(handles.txtProgress_single, 'String', 'Preparing video ...', 'Visible', 'on');
drawnow;
if trimVal > 0;
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
        bitrate = [num2str(handles.CurrenCompressionPanning) 'M'];
    end;
    if isempty(liRes1080) == 0;
        resolutionVideo = [1920 1080];
        bitrate = [num2str(handles.CurrenCompressionPanning) 'M'];;
    end;
    if isempty(liRes2160) == 0;
        resolutionVideo = [3840 2160];
        bitrate = [num2str(handles.CurrenCompressionPanning) 'M'];;
    end;

    bitrate = [num2str(handles.CurrenCompressionPanning) 'M'];
    maxrate = bitrate;
    bufrate = [num2str(floor((handles.CurrenCompressionPanning)./3)) 'M'];

    %export frames
    timecut = ceil(trimVal*framerate);
    %                 extratime = 0.2; %10 frames at 50
    framecut = (ceil(trimVal*framerate))./framerate;
    
    if ismac == 1;
        outTemp1 = [tempfolder 'out%d.jpg'];
        command = ['"' ffmpegfolder '" -i "' partIn ...
            '" -vf "select=' '''' 'between(n,1,' num2str(framecut+(1/framerate)) ')' '''' '"' ...
            ' -q:v 2 -vframes ' num2str(framecut+(1/framerate)) ' "' outTemp1 '"'];
    elseif ispc == 1;
        outTemp1 = [tempfolder 'out%d.jpg'];
        command = ['"' ffmpegfolder '" -i "' partIn ...
            '" -vf "select=' '''' 'between(n,1,' num2str(framecut+(1/framerate)) ')' '''' '"' ...
            ' -q:v 2 -vframes ' num2str(framecut+(1/framerate)) ' "' outTemp1 '"'];
    end;
    [status, cmdout] = system(command);
   
    if status == 0;
        %trim video
        set(handles.txtProgress_single, 'String', 'Triming frames ...');
        drawnow;
        if ismac == 1;
            partIn = fileprocess;
            outTemp2 = [tempfolder 'tempVideo.MP4'];

%             command = [ffmpegfolder ' -accurate_seek -ss ' num2str(timecut) ...
%                 ' -i ' partIn ' -c:v copy ' ...
%                 outTemp2];

            command = ['"' ffmpegfolder '" -accurate_seek -ss ' num2str(timecut) ...
                ' -i "' partIn '" -vcodec libx264 -g 24 -x264-params keyint=24 -preset ultrafast -r ' num2str(1/framerate) ...
                ' -profile:v main -b:v ' bitrate ' -maxrate ' maxrate ' -bufsize ' bufrate ...
                ' -threads 0 -pix_fmt yuv420p "' outTemp2 '"'];

        elseif ispc == 1;
            partIn = fileprocess;
            outTemp2 = [tempfolder 'tempVideo.MP4'];
            
%             command = [ffmpegfolder ' -accurate_seek -ss ' num2str(timecut) ...
%                 ' -i ' partIn ' -c:v copy ' ...
%                 outTemp2];

            command = ['"' ffmpegfolder '" -accurate_seek -ss ' num2str(timecut) ...
                ' -i "' partIn '" -vcodec libx264 -g 24 -x264-params keyint=24 -preset ultrafast -r ' num2str(1/framerate) ...
                ' -profile:v main -b:v ' bitrate ' -maxrate ' maxrate ' -bufsize ' bufrate ...
                ' -threads 0 -pix_fmt yuv420p "' outTemp2 '"'];            
        end;
        [status, cmdout] = system(command);

        %check video
        if ismac == 1;
            command = ['"' ffmpegfolder '" -i "' outTemp2 ...
                '" -map 0:v:0 -c copy -f null -'];
        elseif ispc == 1;
            command = ['"' ffmpegfolder '" -i "' outTemp2 ...
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
                vidTimeIni = trimVal*framerate;
                vidDurTheory = VidTimeOriginal - vidTimeIni;
                vidDurReal = VidTimeProcessed;
                missingFrames = roundn((vidDurTheory - vidDurReal).*(1/framerate),0) + 1;

                imageIni = roundn(trimVal, 0);
                imageEnd = roundn(imageIni + missingFrames,0);

                if missingFrames >= -1 & missingFrames <= 1;
                    %just copy the temp video
                    partOut = fileoutput;
                    set(handles.txtProgress_single, 'String', ['creating video ...  ' partOut]);
                    drawnow;

                    if ispc == 1;
                        command = ['copy /Y "' outTemp2 '" "' partOut '"'];
                        [status, cmdout] = system(command);

                    elseif ismac == 1;
                        command = ['move /Y "' outTemp2 '" "' partOut '"'];
                        [status, cmdout] = system(command);
                    end;
                else;
                    if ispc == 1;
                        for i = (imageEnd) : (framecut+(1/framerate));
                            outTemp1 = [tempfolder 'out' num2str(i) '.jpg'];
                            command = ['del /Q "' outTemp1 '"'];
                            [status, cmdout] = system(command);
                        end;
                    else;
                        for i = (imageEnd) : (framecut+(1/framerate));
                            outTemp1 = [tempfolder 'out' num2str(i) '.jpg'];
                            command = ['rm "' outTemp1 '"'];
                            [status, cmdout] = system(command);
                        end;
                    end;
    
                    if ismac == 1;
                        outTemp3 = [tempfolder 'extraVideo.MP4'];
                    elseif ispc == 1;
                        outTemp3 = [tempfolder 'extraVideo.MP4'];
                    end;
    
                    command = ['"' ffmpegfolder '" -f image2 -start_number ' num2str(trimVal+1) ' -r ' num2str(1/framerate) ' -i "' tempfolder 'out%d.jpg" -f lavfi -i anullsrc -c:v libx264 -x264-params keyint=2 ' ...
                        '-profile:v main -preset ultrafast ' ...
                        '-b:v ' bitrate ' -pix_fmt yuv420p -video_track_timescale ' num2str(1/framerate) 'k -c:a aac -shortest "' outTemp3 '"'];
                    [status, cmdout] = system(command);
    
                    %concatenate both videos
                    %command = [ffmpegfolder 'ffmpeg -f concat -safe 0 -i /Applications/SP2VideoManager/concatlistTrimPanning.txt -c copy ' videooutputfolder '/' fileOut];
                    
                    partOut = fileoutput;

                    set(handles.txtProgress_single, 'String', ['creating video ...  ' partOut]);
                    drawnow;
                    if ismac == 1;
                        command = ['"' ffmpegfolder '" -i "' outTemp3 '" -i "' outTemp2 ...
                            '" -filter_complex "[0:v] [0:a] [1:v] [1:a] concat=n=2:v=1:a=1" -vcodec libx264 -g 24 -x264-params keyint=24 -preset ultrafast -r ' num2str(1/framerate) ...
                            ' -profile:v main -b:v ' bitrate ' -maxrate ' maxrate ' -bufsize ' bufrate ...
                            ' -threads 0 -pix_fmt yuv420p "' fileoutput '"'];
                        [status, cmdout] = system(command);
                        if status == 1;
                            command = ['"' ffmpegfolder '" -i "' outTemp3 '" -i "' outTemp2 ...
                                '" -filter_complex "[0:v] [1:v] concat=n=2:v=1:a=0" -vcodec libx264 -g 24 -x264-params keyint=24 -preset ultrafast -r ' num2str(1/framerate) ...
                                ' -profile:v main -b:v ' bitrate ' -maxrate ' maxrate ' -bufsize ' bufrate ...
                                ' -threads 0 -pix_fmt yuv420p "' fileoutput '"'];
                            [status, cmdout] = system(command);
                        end;
                    elseif ispc == 1;
                        command = ['"' ffmpegfolder '" -i "' outTemp3 '" -i "' outTemp2 ...
                            '" -filter_complex "[0:v] [0:a] [1:v] [1:a] concat=n=2:v=1:a=1" -vcodec libx264 -g 24 -x264-params keyint=24 -preset ultrafast -r ' num2str(1/framerate) ...
                            ' -profile:v main -b:v ' bitrate ' -maxrate ' maxrate ' -bufsize ' bufrate ...
                            ' -threads 0 -pix_fmt yuv420p "' partOut '"'];
                        [status, cmdout] = system(command);
                        
                        if status == 1;
                            command = ['"' ffmpegfolder '" -i "' outTemp3 '" -i "' outTemp2 ...
                                '" -filter_complex "[0:v] [1:v] concat=n=2:v=1:a=0" -vcodec libx264 -g 24 -x264-params keyint=24 -preset ultrafast -r ' num2str(1/framerate) ...
                                ' -profile:v main -b:v ' bitrate ' -maxrate ' maxrate ' -bufsize ' bufrate ...
                                ' -threads 0 -pix_fmt yuv420p "' partOut '"'];
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
                extraframe = 0;
                if ismac == 1;
                    partOut = fileoutput;
                    command = ['mv "' outTemp2  '" "' fileoutput '"'];
                elseif ispc == 1;
                    partOut = fileoutput;
                    command = ['copy "' outTemp2 '" "' partOut '"'];
                end;

                set(handles.txtProgress_single, 'String', ['creating video ...  ' partOut]);
                drawnow;
                
                [status, cmdout] = system(command);
              
                if ismac == 1;
                    %delete Temp folder
                    command = ['rm "' tempfolder '"*'];
                    [status, cmdout] = system(command);
                elseif ispc == 1;
                    command = ['del /Q "' tempfolder '"*'];
                    [status, cmdout] = system(command);
                end;
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
        
else;
    %add black frames
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
    framerate = roundn(1./roundn(str2num(cmdoutfps),0),-2);

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
        bitrate = [num2str(handles.CurrenCompressionPanning) 'M'];
    end;
    if isempty(liRes1080) == 0;
        resolutionVideo = [1920 1080];
        bitrate = [num2str(handles.CurrenCompressionPanning) 'M'];
    end;
    if isempty(liRes2160) == 0;
        resolutionVideo = [3840 2160];
        bitrate = [num2str(handles.CurrenCompressionPanning) 'M'];
    end;

    bitrate = [num2str(handles.CurrenCompressionPanning) 'M'];
    maxrate = bitrate;
    bufrate = [num2str(floor((handles.CurrenCompressionPanning)./3)) 'M'];
    
    %Create the black video
    trimVal = abs(trimVal);
    timeadd = (trimVal-1)*framerate;
    
    set(handles.txtProgress_single, 'String', 'Creating black frames ...');
    drawnow;
    
    if ispc == 1;
        outTemp = [tempfolder 'blackVideo.MP4'];
    elseif ismac == 1;
        outTemp = [tempfolder 'blackVideo.MP4'];
    end;

    command = ['"' ffmpegfolder '" -f lavfi -i color=c=black:s=' num2str(resolutionVideo(1)) 'x' num2str(resolutionVideo(2)) ':r=' num2str(1/framerate) '/1 ' ...
        '-f lavfi -i anullsrc=cl=mono:r=48000 -c:v libx264 -x264-params keyint=2 -profile:v main -preset ultrafast ' ...
        '-b:v ' bitrate ' -pix_fmt yuv420p -video_track_timescale ' num2str(1/framerate) 'k -t ' num2str(timeadd) ' "' outTemp '"'];
    [status, cmdout] = system(command);

    partOut = fileoutput;
    set(handles.txtProgress_single, 'String', ['creating video ...  ' partOut]);
    drawnow;

    if status == 0;
        if ismac == 1;
            command = ['"' ffmpegfolder '" -i "' outTemp '" -i "' fileprocess ...
                '" -filter_complex "[0:v] [0:a] [1:v] [1:a] concat=n=2:v=1:a=1" -vcodec libx264 -g 24 -x264-params keyint=24 -preset ultrafast' ...
                ' -profile:v main -r ' num2str(1/framerate) ' -b:v ' bitrate ' -maxrate ' maxrate ' -bufsize ' bufrate ...
                ' -threads 0 -pix_fmt yuv420p "' fileoutput '"'];
            [status, cmdout] = system(command);
            if status == 1;
                command = ['"' ffmpegfolder '" -i "' outTemp '" -i "' fileprocess ...
                    '" -filter_complex "[0:v] [1:v] concat=n=2:v=1:a=0" -vcodec libx264 -g 24 -x264-params keyint=24 -preset ultrafast ' ...
                    ' -profile:v main -r ' num2str(1/framerate) ' -b:v ' bitrate ' -maxrate ' maxrate ' -bufsize ' bufrate ...
                    ' -threads 0 -pix_fmt yuv420p "' fileoutput '"'];
                [status, cmdout] = system(command);
            end;
            
        elseif ispc == 1;
            command = ['"' ffmpegfolder '" -i "' outTemp '" -i "' partIn ...
                '" -filter_complex "[0:v] [0:a] [1:v] [1:a] concat=n=2:v=1:a=1" -vcodec libx264 -g 24 -x264-params keyint=24 -preset ultrafast ' ...
                ' -profile:v main -r ' num2str(1/framerate) ' -b:v ' bitrate ' -maxrate ' maxrate ' -bufsize ' bufrate ...
                ' -threads 0 -pix_fmt yuv420p "' partOut '"'];
            [status, cmdout] = system(command);
            if status == 1;
                command = ['"' ffmpegfolder '" -i "' outTemp '" -i "' partIn ...
                    '" -filter_complex "[0:v] [1:v] concat=n=2:v=1:a=0" -vcodec libx264 -g 24 -x264-params keyint=24 -preset ultrafast ' ...
                    ' -profile:v main -r ' num2str(1/framerate) ' -b:v ' bitrate ' -maxrate ' maxrate ' -bufsize ' bufrate ...
                    ' -threads 0 -pix_fmt yuv420p "' partOut '"'];
                [status, cmdout] = system(command);
            end;
        end;
        
        if status == 0;
            if ispc == 1;
                %delete Temp folder
                command = ['del /Q "' tempfolder '"*'];
            elseif ismac == 1;
                command = ['rm "' tempfolder '"*'];
            end;
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
% set(handles2.status_main, 'String', 'Done');
set(handles.txtProgress_single, 'String', '', 'Visible', 'off');
drawnow;

