%process videos Trim
%check the original video
checkSpecialChar;


if ismac == 1;
    if specialChar_inputfolder == 1 | specialChar_fileECNew == 1;
        partIn = ['"' videoinputfolder '/' fileECNew '"'];
    else;
        partIn = [videoinputfolder '/' fileECNew];
    end;
    command = [ffmpegfolder ' -i ' partIn ...
        ' -map 0:v:0 -c copy -f null -'];

elseif ispc == 1;    
    if specialChar_inputfolder == 1 | specialChar_fileECNew == 1;
        partIn = ['"' videoinputfolder '\' fileECNew '"'];
    else
        partIn = [videoinputfolder '\' fileECNew];
    end;
    command = [ffmpegfolder ' -i ' partIn ...
        ' -map 0:v:0 -c copy -f null -'];
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
    bitrate = [num2str(handles.CurrenCompressionPanning) 'M'];
end;
if isempty(liRes2160) == 0;
    resolutionVideo = [3840 2160];
    bitrate = [num2str(handles.CurrenCompressionPanning) 'M'];
end;

%export frames
timecut = ceil(handles.trimPanning*framerate);
%                 extratime = 0.2; %10 frames at 50
framecut = (ceil(handles.trimPanning*framerate))./framerate;
if ismac == 1;
    if specialChar_inputfolder == 1 | specialChar_fileECNew == 1;
        partIn = ['"' videoinputfolder '/' fileECNew '"'];
    else
        partIn = [videoinputfolder '/' fileECNew];
    end;

    tempfolder = [MDIR '/SP2VideoManager/Temp/out%d.jpg'];
    if specialChar_MDIR == 1;
        tempfolder = ['"' tempfolder '"'];
    end;
    command = [ffmpegfolder ' -i ' partIn ...
        ' -vf "select=' '''' 'between(n,1,' num2str(framecut+(1/framerate)) ')' '''' '"' ...
        ' -q:v 2 -vframes ' num2str(framecut+(1/framerate)) ' ' tempfolder];

elseif ispc == 1;

    if specialChar_inputfolder == 1 | specialChar_fileECNew == 1;
        partIn = ['"' videoinputfolder '\' fileECNew '"'];
    else
        partIn = [videoinputfolder '\' fileECNew];
    end;
    
    tempfolder = [MDIR '\SP2VideoManager\Temp\out%d.jpg'];
    if specialChar_MDIR == 1;
        tempfolder = ['"' tempfolder '"'];
    end;
    command = [ffmpegfolder ' -i ' partIn ...
        ' -vf "select=' '''' 'between(n,1,' num2str(framecut+(1/framerate)) ')' '''' '"' ...
        ' -q:v 2 -vframes ' num2str(framecut+(1/framerate)) ' ' tempfolder];
end;
[status, cmdout] = system(command);

if status == 0;
    %trim video
    if ismac == 1;
        if specialChar_inputfolder == 1 | specialChar_fileECNew == 1;
            partIn = ['"' videoinputfolder '/' fileECNew '"'];
        else
            partIn = [videoinputfolder '/' fileECNew];
        end;

        tempfolder = [MDIR '/SP2VideoManager/Temp/tempVideo.MP4'];
        if specialChar_MDIR == 1;
            tempfolder = ['"' tempfolder '"'];
        end;
        command = [ffmpegfolder ' -accurate_seek -ss ' num2str(timecut) ...
                ' -i ' partIn ' -vcodec libx264 -g 24 -x264-params keyint=24 -preset ultrafast -r ' num2str(1/framerate) ...
                ' -profile:v main -b:v ' bitrate ' -maxrate ' maxrate ' -bufsize ' bufrate ...
                ' -threads 0 -pix_fmt yuv420p ' tempfolder];

    elseif ispc == 1;
        if specialChar_inputfolder == 1 | specialChar_fileECNew == 1;
            partIn = ['"' videoinputfolder '\' fileECNew '"'];
        else
            partIn = [videoinputfolder '\' fileECNew];
        end;

        tempfolder = [MDIR '\SP2VideoManager\Temp\tempVideo.MP4'];
        if specialChar_MDIR == 1;
            tempfolder = ['"' tempfolder '"'];
        end;
        command = [ffmpegfolder ' -accurate_seek -ss ' num2str(timecut) ...
                ' -i ' partIn ' -vcodec libx264 -g 24 -x264-params keyint=24 -preset ultrafast -r ' num2str(1/framerate) ...
                ' -profile:v main -b:v ' bitrate ' -maxrate ' maxrate ' -bufsize ' bufrate ...
                ' -threads 0 -pix_fmt yuv420p ' tempfolder];
    end;
    [status, cmdout] = system(command);

    %check video
    if ismac == 1;
        tempfolder = [MDIR '/SP2VideoManager/Temp/tempVideo.MP4'];
        if specialChar_MDIR == 1;
            tempfolder = ['"' tempfolder '"'];
        end;
        command = [ffmpegfolder ' -i ' tempfolder ...
            ' -map 0:v:0 -c copy -f null -'];

    elseif ispc == 1;
        tempfolder = [MDIR '\SP2VideoManager\Temp\tempVideo.MP4'];
        if specialChar_MDIR == 1;
            tempfolder = ['"' tempfolder '"'];
        end;
        command = [ffmpegfolder ' -i ' tempfolder ...
            ' -map 0:v:0 -c copy -f null -'];
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
%         if VidTimeOriginal - VidTimeProcessed > (trimVal*framerate);
%             extraframe = floor(rem(VidTimeOriginal - VidTimeProcessed, 1)./framerate);
%             if ismac == 1;
%                 command = [ffmpegfolder 'ffmpeg -i ' videoinputfolder '/' fileECNew ...
%                     ' -vf "select=' '''' 'between(n,' num2str(framecut+1) ',' num2str(framecut+extraframe) ')' '''' '"' ...
%                     ' -vframes ' num2str(extraframe) ' ' tempfolder 'extra_out%d.jpg'];
%             elseif ispc == 1;
%                 lispace1 = strfind(videoinputfolder, ' ');
%                 lispace2 = strfind(fileECNew, ' ');
%                 if isempty(lispace1) == 1 & isempty(lispace2) == 1;
%                     partIn = [videoinputfolder '\' fileECNew];
%                 else
%                     partIn = ['"' videoinputfolder '\' fileECNew '"'];
%                 end;
% 
%                 lispace1 = strfind(videooutputfolder, ' ');
%                 lispace2 = strfind(fileOut, ' ');
%                 if isempty(lispace1) == 1 & isempty(lispace2) == 1;
%                     partOut = [videooutputfolder '\' fileOut];
%                 else
%                     partOut = ['"' videooutputfolder '\' fileOut '"'];
%                 end;
% 
%                 extraframe = floor(rem(VidTimeOriginal - VidTimeProcessed, 1)./framerate);
%                 command = [ffmpegfolder 'ffmpeg -i ' partIn ...
%                     ' -vf "select=' '''' 'between(n,' num2str(framecut+1) ',' num2str(framecut+extraframe) ')' '''' '"' ...
%                     ' -vframes ' num2str(extraframe) ' ' tempfolder 'extra_out%d.jpg'];
%             end;
%             [status, cmdout] = system(command);
% 
%             iter = framecut+1;
%             if ismac == 1;
%                 for frameRel = 1:extraframe;
%                     command = ['mv ' tempfolder 'extra_out' num2str(frameRel) '.jpg ' tempfolder 'out' num2str(iter) '.jpg'];
%                     [status, cmdout] = system(command);
%                     iter = iter + 1;
%                 end;
%             elseif ispc == 1;
%                 for frameRel = 1:extraframe;
%                     command = ['move ' tempfolder 'extra_out' num2str(frameRel) '.jpg ' tempfolder 'out' num2str(iter) '.jpg'];
%                     [status, cmdout] = system(command);
%                     iter = iter + 1;
%                 end;
%             end;
%         else;
%             extraframe = 0;
%         end;
% 
%         if ismac == 1;
%             command = ['rm '];
%         elseif ispc == 1;
%             command = ['del /Q '];
%         end;
%         for frameRem = 1:handles.trimPanning;
%             command = [command tempfolder 'out' num2str(frameRem) '.jpg '];
%         end;
%         command = command(1:end-1);
%         [status, cmdout] = system(command);
% 
%         iter = 1;
%         if ismac == 1;
%             for frameRel = (handles.trimPanning+1):(framecut+extraframe);
%                 command = ['mv ' tempfolder 'out' num2str(frameRel) '.jpg ' tempfolder 'out' num2str(iter) '.jpg'];
%                 [status, cmdout] = system(command);
%                 iter = iter + 1;
%             end;
%         elseif ispc == 1;
%             for frameRel = (handles.trimPanning+1):(framecut+extraframe);
%                 command = ['move /Y ' tempfolder 'out' num2str(frameRel) '.jpg ' tempfolder 'out' num2str(iter) '.jpg'];
%                 [status, cmdout] = system(command);
%                 iter = iter + 1;
%             end;
%         end;
%         command = [ffmpegfolder 'ffmpeg -y -f image2 -start_number ' num2str(frameRem+1) ' -r ' num2str(1/framerate) ' -i "' tempfolder 'out%d.jpg" -f lavfi -i anullsrc -c:v libx264 -x264-params keyint=2 '...
%             '-profile:v main -preset ultrafast ' ...
%             '-b:v ' bitrate ' -pix_fmt yuv420p -video_track_timescale ' num2str(1/framerate) 'k -c:a aac -shortest ' tempfolder 'stillVideo.MP4'];
%         [status, cmdout] = system(command);

        trimVal = handles.trimPanning;
        vidTimeIni = trimVal*framerate;
        vidDurTheory = VidTimeOriginal - vidTimeIni;
        vidDurReal = VidTimeProcessed;
        missingFrames = roundn((vidDurTheory - vidDurReal).*(1/framerate),0) + 1;
        imageIni = roundn(trimVal, 0);
        imageEnd = roundn(imageIni + missingFrames,0);
        if missingFrames >= -1 & missingFrames <= 1;
            %just copy the temp video
            if ispc == 1;

                if specialChar_outputfolder == 1 | specialChar_fileOut == 1;
                    partOut = ['"' videooutputfolder '/' fileOut '"'];
                else
                    partOut = [videooutputfolder '/' fileOut];
                end;

                command = ['copy /Y ' tempfolder ' ' partOut];
                [status, cmdout] = system(command);

            elseif ismac == 1;
                if specialChar_outputfolder == 1 | specialChar_fileOut == 1;
                    partOut = ['"' videooutputfolder '/' fileOut '"'];
                else
                    partOut = [videooutputfolder '/' fileOut];
                end;
                command = ['move /Y ' tempfolder ' ' partOut];
                [status, cmdout] = system(command);
            end;
        else;
            if ispc == 1;
                for im = (imageEnd) : (framecut+(1/framerate));
                    tempfolder = [MDIR '\SP2VideoManager\Temp\out' num2str(im) '.jpg'];
                    if specialChar_MDIR == 1;
                        tempfolder = ['"' tempfolder '"'];
                    end;
                    command = ['del /Q ' tempfolder];
                    [status, cmdout] = system(command);
    
                end;
            elseif ismac == 1;
                for im = (imageEnd) : (framecut+(1/framerate));
                    tempfolder = [MDIR '/SP2VideoManager/Temp/out' num2str(im) '.jpg'];
                    if specialChar_MDIR == 1;
                        tempfolder = ['"' tempfolder '"'];
                    end;
                    command = ['rm ' tempfolder];
                    [status, cmdout] = system(command);
    
                end;
            end;
    
            if ispc == 1;
                tempfolder1 = [MDIR '\SP2VideoManager\Temp\out%d.jpg'];
                if specialChar_MDIR == 1;
                    tempfolder = ['"' tempfolder1 '"'];
                end;
    
                tempfolder2 = [MDIR '\SP2VideoManager\Temp\extraVideo.MP4'];
                if specialChar_MDIR == 1;
                    tempfolder2 = ['"' tempfolder2 '"'];
                end;
    
            elseif ismac == 1;
                tempfolder1 = [MDIR '/SP2VideoManager/Temp/out%d.jpg'];
                if specialChar_MDIR == 1;
                    tempfolder = ['"' tempfolder1 '"'];
                end;
    
                tempfolder2 = [MDIR '/SP2VideoManager/Temp/extraVideo.MP4'];
                if specialChar_MDIR == 1;
                    tempfolder2 = ['"' tempfolder2 '"'];
                end;
            end;
            command = [ffmpegfolder ' -f image2 -start_number ' num2str(trimVal+1) ' -r ' num2str(1/framerate) ' -i ' tempfolder1 ' -f lavfi -i anullsrc -c:v libx264 -x264-params keyint=2 ' ...
                '-profile:v main -preset ultrafast ' ...
                '-b:v ' bitrate ' -pix_fmt yuv420p -video_track_timescale ' num2str(1/framerate) 'k -c:a aac -shortest ' tempfolder2];
            [status, cmdout] = system(command);
                    

            %concatenate both videos
            %command = [ffmpegfolder 'ffmpeg -f concat -safe 0 -i /Applications/SP2VideoManager/concatlistTrimPanning.txt -c copy ' videooutputfolder '/' fileOut];
            if ismac == 1;
                if specialChar_inputfolder == 1 | specialChar_fileECNew == 1;
                    partIn = ['"' videoinputfolder '/' fileECNew '"'];
                else
                    partIn = [videoinputfolder '/' fileECNew];
                end;
    
                if specialChar_outputfolder == 1 | specialChar_fileOut == 1;
                    partOut = ['"' videooutputfolder '/' fileOut '"'];
                else
                    partOut = [videooutputfolder '/' fileOut];
                end;
    
                if handles.checkboxRemuxPanning == 1;
                    batchlistFile = [MDIR '/SP2VideoManager/Temp/batchlist.txt'];
                    fid = fopen(batchlistFile, 'wt');
                    text1 = ['file ' '''' MDIR '/SP2VideoManager/Temp/extraVideo.MP4' ''''];
                    fprintf(fid, '%s\n', text1);
                    text2 = ['file ' '''' MDIR '/SP2VideoManager/Temp/tempVideo.MP4' ''''];
                    fprintf(fid, '%s', text2);
                    fclose(fid);
    
                    if specialChar_MDIR == 1;
                        batchlistFile = ['"' batchlistFile '"'];
                    end;
                    command = [ffmpegfolder ' -f concat -safe 0 -i ' batchlistFile ' -c copy ' ...
                        partOut];
    
                else;
    
                    if isdir(handles.outputfolderPanning) == 1;

                        tempfolder1 = [MDIR '/SP2VideoManager/Temp/extraVideo.MP4'];
                        if specialChar_MDIR == 1;
                            tempfolder1 = ['"' tempfolder1 '"'];
                        end;
    
                        tempfolder2 = [MDIR '/SP2VideoManager/Temp/tempVideo.MP4'];
                        if specialChar_MDIR == 1;
                            tempfolder2 = ['"' tempfolder2 '"'];
                        end;
    
                        command = [ffmpegfolder ' -y -i ' tempfolder1 ' -i ' tempfolder2 ...
                            ' -filter_complex "[0:v] [0:a] [1:v] [1:a] concat=n=2:v=1:a=1" -vcodec libx264 -g 24 -x264-params keyint=24 -preset ultrafast -r ' num2str(1/framerate) ...
                            ' -b:v ' bitrate ' -maxrate ' maxrate ' -bufsize ' bufrate ...
                            ' -threads 0 -pix_fmt yuv420p ' partOut];
                        [status, cmdout] = system(command);
    
                        if status == 1;
                            command = [ffmpegfolder ' -y -i ' tempfolder1 ' -i ' tempfolder2 ...
                                ' -filter_complex "[0:v] [1:v] concat=n=2:v=1:a=0" -vcodec libx264 -x264-params -g 24 keyint=24 -preset ultrafast -r ' num2str(1/framerate) ...
                                ' -b:v ' bitrate ' -maxrate ' maxrate ' -bufsize ' bufrate ...
                                ' -threads 0 -pix_fmt yuv420p ' partOut];
                            [status, cmdout] = system(command);
                        end;
    
                        fileprocess = listVideoPanningFiles{i,1};
                        listDir = dir(handles.outputfolderPanning);
                        fileExist = 0;
                        for carac = 1:length(listDir);
                            fileCheck = listDir(carac);
                            NameEC = fileCheck.name;
    
                            if strcmpi(NameEC, fileOut) == 1;
                                fileExist = 1;
                            end;
                        end;
                        if fileExist == 0;
                            %export failed
                            status = 1;
                        end;
                        
                    else;
                        %network dropped
                        status = 1;
    
                    end;
                end;
    
            elseif ispc == 1;
                
                if specialChar_inputfolder == 1 | specialChar_fileECNew == 1;
                    partIn = ['"' videoinputfolder '\' fileECNew '"'];
                else
                    partIn = [videoinputfolder '\' fileECNew];
                end;
    
                if specialChar_outputfolder == 1 | specialChar_fileOut == 1;
                    partOut = ['"' videooutputfolder '\' fileOut '"'];
                else
                    partOut = [videooutputfolder '\' fileOut];
                end;
    
                if handles.checkboxRemuxPanning == 1;
    
                    batchlistFile = [MDIR '\SP2VideoManager\Temp\batchlist.txt'];
                    fid = fopen(batchlistFile, 'wt');
                    text1 = ['file ' '''' MDIR '\SP2VideoManager\Temp\extraVideo.MP4' ''''];
                    fprintf(fid, '%s\n', text1);
                    text2 = ['file ' '''' MDIR '\SP2VideoManager\Temp\tempVideo.MP4' ''''];
                    fprintf(fid, '%s', text2);
                    fclose(fid);
    
                    if specialChar_MDIR == 1;
                        batchlistFile = ['"' batchlistFile '"'];
                    end;
                    command = [ffmpegfolder ' -f concat -safe 0 -i ' batchlistFile ' -c copy ' ...
                        partOut];
                else;
                    if isdir(videooutputfolder) == 1;
    
                        tempfolder1 = [MDIR '\SP2VideoManager\Temp\extraVideo.MP4'];
                        if specialChar_MDIR == 1;
                            tempfolder1 = ['"' tempfolder1 '"'];
                        end;
    
                        tempfolder2 = [MDIR '\SP2VideoManager\Temp\tempVideo.MP4'];
                        if specialChar_MDIR == 1;
                            tempfolder2 = ['"' tempfolder2 '"'];
                        end;
    
                        command = [ffmpegfolder ' -y -i ' tempfolder1 ' -i ' tempfolder2 ...
                            ' -filter_complex "[0:v] [0:a] [1:v] [1:a] concat=n=2:v=1:a=1" -vcodec libx264 -g 24 -x264-params keyint=24 -preset ultrafast -r ' num2str(1/framerate) ...
                            ' -b:v ' bitrate ' -maxrate ' maxrate ' -bufsize ' bufrate ...
                            ' -threads 0 -pix_fmt yuv420p ' partOut];
                        [status, cmdout] = system(command);
   
                        if status == 1;
                            command = [ffmpegfolder ' -y -i ' tempfolder1 ' -i ' tempfolder2 ...
                                ' -filter_complex "[0:v] [1:v] concat=n=2:v=1:a=0" -vcodec libx264 -x264-params -g 24 keyint=24 -preset ultrafast -r ' num2str(1/framerate) ...
                                ' -b:v ' bitrate ' -maxrate ' maxrate ' -bufsize ' bufrate ...
                                ' -threads 0 -pix_fmt yuv420p ' partOut];
                            [status, cmdout] = system(command);
                        end;
                        fileprocess = listVideoPanningFiles{file2process,1};
    
                        lidot = findstr(fileprocess, '.');
                        if isempty(lidot) == 1;
                            fileprocess = 'empty';
                        else;
                            fileprocess = [fileprocess(1:lidot(end)-1) '_copy' fileprocess(lidot(end):end)];
                        end;
    
                        listDir = dir(handles.outputfolderPanning);
                        fileExist = 0;
                        for carac = 1:length(listDir);
                            fileCheck = listDir(carac);                        
                            NameEC = fileCheck.name;
                            if strcmpi(NameEC, fileprocess) == 1;
                                fileExist = 1;
                            end;
                        end;

                        if fileExist == 0;
                            %export failed
                            status = 1;
                        end;
                    else;
                        status = 1;
                    end;
                end;
            end;
        end;
        if status == 0;
            %delete Temp folder
            if ismac == 1;
                tempfolder = ['/Applications/SP2VideoManager/Temp/'];
                command = ['rm ' tempfolder '*'];
            elseif ispc == 1;
                tempfolder = [MDIR '\SP2VideoManager\Temp\'];
                lispaceTemp = strfind(tempfolder, ' ');
                if isempty(lispace) == 0;
                    tempfolder = ['"' tempfolder '"'];
                end;
                command = ['del /Q ' tempfolder '*'];
            end;
            [status, cmdout] = system(command);
        else;

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