%process videos Add`
%Check video
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

%Create the black video
timeadd = (handles.addPanning-1)*framerate;
if ispc == 1
    tempfolder = [MDIR '\SP2VideoManager\Temp\blackVideo.MP4'];
    if specialChar_MDIR == 1;
        tempfolder = ['"' tempfolder '"'];
    end;
elseif ismac == 1;
    tempfolder = [MDIR '/SP2VideoManager/Temp/blackVideo.MP4'];
    if specialChar_MDIR == 1;
        tempfolder = ['"' tempfolder '"'];
    end;
end;

command = [ffmpegfolder ' -f lavfi -i color=c=black:s=' num2str(resolutionVideo(1)) 'x' num2str(resolutionVideo(2)) ':r=' num2str(1/framerate) '/1 ' ...
    '-f lavfi -i anullsrc=cl=mono:r=48000 -c:v libx264 -x264-params keyint=2 -profile:v main -preset ultrafast ' ...
    '-b:v ' bitrate ' -pix_fmt yuv420p -video_track_timescale ' num2str(1/framerate) 'k -t ' num2str(timeadd) ' ' tempfolder];
[status, cmdout] = system(command);

if status == 0;
    checkSpecialChar;

    if ismac == 1;

        if specialChar_inputfolder == 1 | specialChar_fileECNew == 1;
            partIn = ['"' videoinputfolder '/' fileECNew '"'];
        else;
            partIn = [videoinputfolder '/' fileECNew];
        end;

        if specialChar_outputfolder == 1 | specialChar_fileOut == 1;
            partOut = ['"' videooutputfolder '/' fileOut '"'];
        else;
            partOut = [videooutputfolder '/' fileOut];
        end;

        if handles.checkboxRemuxPanning == 1;

            batchlistfile = [MDIR '/SP2VideoManager/Temp/batchlist.txt'];
            fid = fopen(batchlistfile, 'wt');
            text1 = ['file ' '''' MDIR '/SP2VideoManager/Temp/blackVideo.MP4' ''''];
            fprintf(fid, '%s\n', text1);
            text2 = ['file ' '''' videoinputfolder '/' fileECNew ''''];
            fprintf(fid, '%s', text2);
            fclose(fid);
            if specialChar_MDIR == 1;
                batchlistfile = ['"' batchlistfile '"'];
            end;
            
            command = [ffmpegfolder ' -f concat -safe 0 -i ' batchlistfile ' -c copy ' ...
                    partOut];

            [status, cmdout] = system(command);

        else;

            tempfolder = [MDIR '/SP2VideoManager/Temp/blackVideo.MP4'];
            if specialChar_MDIR == 1;
                tempfolder = ['"' tempfolder '"'];
            end;

            if specialChar_inputfolder == 1 | specialChar_fileECNew == 1;
                if specialChar_outputfolder == 1 | specialChar_fileOut == 1;
                    command = [ffmpegfolder ' -i ' tempfolder ' -i "' videoinputfolder '/' ...
                        fileECNew '" -filter_complex "[0:v] [0:a] [1:v] [1:a] concat=n=2:v=1:a=1" -vcodec libx264 -g 24 -x264-params keyint=24 -preset ultrafast ' ...
                        '-profile:v main -r ' num2str(1/framerate) ' -b:v ' bitrate ' -maxrate ' maxrate ' -bufsize ' bufrate ...
                        ' -pix_fmt yuv420p -threads 0 "' videooutputfolder '/' fileOut '"'];
                else;
                    command = [ffmpegfolder ' -i ' tempfolder ' -i "' videoinputfolder '/' ...
                        fileECNew '" -filter_complex "[0:v] [0:a] [1:v] [1:a] concat=n=2:v=1:a=1" -vcodec libx264 -g 24 -x264-params keyint=24 -preset ultrafast ' ...
                        '-profile:v main -r ' num2str(1/framerate) ' -b:v ' bitrate ' -maxrate ' maxrate ' -bufsize ' bufrate ...
                        ' -pix_fmt yuv420p -threads 0 ' videooutputfolder '/' fileOut];
                end;
                
            else;
                if specialChar_outputfolder == 1 | specialChar_fileOut == 1;
                    command = [ffmpegfolder ' -i ' tempfolder ' -i ' videoinputfolder '/' ...
                        fileECNew ' -filter_complex "[0:v] [0:a] [1:v] [1:a] concat=n=2:v=1:a=1" -vcodec libx264 -g 24 -x264-params keyint=24 -preset ultrafast ' ...
                        '-profile:v main -r ' num2str(1/framerate) ' -b:v ' bitrate ' -maxrate ' maxrate ' -bufsize ' bufrate ...
                        ' -pix_fmt yuv420p -threads 0 "' videooutputfolder '/' fileOut '"'];
                else;
                    command = [ffmpegfolder ' -i ' tempfolder ' -i ' videoinputfolder '/' ...
                        fileECNew ' -filter_complex "[0:v] [0:a] [1:v] [1:a] concat=n=2:v=1:a=1" -vcodec libx264 -g 24 -x264-params keyint=24 -preset ultrafast ' ...
                        '-profile:v main -r ' num2str(1/framerate) ' -b:v ' bitrate ' -maxrate ' maxrate ' -bufsize ' bufrate ...
                        ' -pix_fmt yuv420p -threads 0 ' videooutputfolder '/' fileOut];
                end;
            end;
            [status, cmdout] = system(command);

            if status == 1;
          
                if specialChar_outputfolder == 1 | specialChar_fileOut == 1;
                    command = ['del "' videooutputfolder '/' fileOut '"'];
                else;
                    command = ['del ' videooutputfolder '/' fileOut];
                end;
                [status, cmdout] = system(command);


                if specialChar_inputfolder == 1 | specialChar_fileECNew == 1;
                    if specialChar_outputfolder == 1 | specialChar_fileOut == 1;
                        command = [ffmpegfolder 'ffmpeg -i ' tempfolder ' -i "' videoinputfolder '/' ...
                            fileECNew '" -filter_complex "[0:v] [1:v] concat=n=2:v=1:a=0" -vcodec libx264 -g 24 -x264-params keyint=24 -preset ultrafast ' ...
                            '-profile:v main -r ' num2str(1/framerate) ' -b:v ' bitrate ' -maxrate ' maxrate ' -bufsize ' bufrate ...
                            ' -pix_fmt yuv420p -threads 0 "' videooutputfolder '/' fileOut '"'];
                    else;
                        command = [ffmpegfolder 'ffmpeg -i ' tempfolder ' -i "' videoinputfolder '/' ...
                            fileECNew '" -filter_complex "[0:v] [1:v] concat=n=2:v=1:a=0" -vcodec libx264 -g 24 -x264-params keyint=24 -preset ultrafast ' ...
                            '-profile:v main -r ' num2str(1/framerate) ' -b:v ' bitrate ' -maxrate ' maxrate ' -bufsize ' bufrate ...
                            ' -pix_fmt yuv420p -threads 0 ' videooutputfolder '/' fileOut];
                    end;
                    
                else;
                    if specialChar_outputfolder == 1 | specialChar_fileOut == 1;
                        ccommand = [ffmpegfolder 'ffmpeg -i ' tempfolder ' -i ' videoinputfolder '/' ...
                            fileECNew ' -filter_complex "[0:v] [1:v] concat=n=2:v=1:a=0" -vcodec libx264 -g 24 -x264-params keyint=24 -preset ultrafast ' ...
                            '-profile:v main -r ' num2str(1/framerate) ' -b:v ' bitrate ' -maxrate ' maxrate ' -bufsize ' bufrate ...
                            ' -pix_fmt yuv420p -threads 0 "' videooutputfolder '/' fileOut '"'];
                    else;
                        command = [ffmpegfolder 'ffmpeg -i ' tempfolder ' -i ' videoinputfolder '/' ...
                            fileECNew ' -filter_complex "[0:v] [1:v] concat=n=2:v=1:a=0" -vcodec libx264 -g 24 -x264-params keyint=24 -preset ultrafast ' ...
                            '-profile:v main -r ' num2str(1/framerate) ' -b:v ' bitrate ' -maxrate ' maxrate ' -bufsize ' bufrate ...
                            ' -pix_fmt yuv420p -threads 0 ' videooutputfolder '/' fileOut];
                    end;
                end;
                [status, cmdout] = system(command);
            end;
        end;

    elseif ispc == 1;
        if specialChar_inputfolder == 1 | specialChar_fileECNew == 1;
            partIn = ['"' videoinputfolder '\' fileECNew '"'];
        else;
            partIn = [videoinputfolder '\' fileECNew];
        end;

        if specialChar_outputfolder == 1 | specialChar_fileOut == 1;
            partOut = ['"' videooutputfolder '\' fileOut '"'];
        else;
            partOut = [videooutputfolder '\' fileOut];
        end;

        if handles.checkboxRemuxPanning == 1;

            batchlistfile = [MDIR '\SP2VideoManager\Temp\batchlist.txt'];
            fid = fopen(batchlistfile, 'wt');
            text1 = ['file ' '''' MDIR '\SP2VideoManager\Temp\blackVideo.MP4' ''''];
            fprintf(fid, '%s\n', text1);
            text2 = ['file ' '''' videoinputfolder '\' fileECNew ''''];
            fprintf(fid, '%s', text2);
            fclose(fid);

            if specialChar_MDIR == 1;
                batchlistfile = ['"' batchlistfile '"'];
            end;
            command = [ffmpegfolder ' -f concat -safe 0 -i ' batchlistfile ' -c copy ' ...
                partOut];

            [status, cmdout] = system(command);

        else;

            tempfolder = [MDIR '\SP2VideoManager\Temp\blackVideo.MP4'];
            if specialChar_MDIR == 1;
                tempfolder = ['"' tempfolder '"'];
            end;

            if specialChar_inputfolder == 1 | specialChar_fileECNew == 1;
                if specialChar_outputfolder == 1 | specialChar_fileOut == 1;
                    command = [ffmpegfolder ' -i ' tempfolder ' -i "' videoinputfolder '\' ...
                        fileECNew '" -filter_complex "[0:v] [0:a] [1:v] [1:a] concat=n=2:v=1:a=1" -vcodec libx264 -g 24 -x264-params keyint=24 -preset ultrafast ' ...
                        '-profile:v main -r ' num2str(1/framerate) ' -b:v ' bitrate ' -maxrate ' maxrate ' -bufsize ' bufrate ...
                        ' -pix_fmt yuv420p -threads 0 "' videooutputfolder '\' fileOut '"'];
                else;
                    command = [ffmpegfolder ' -i ' tempfolder ' -i "' videoinputfolder '\' ...
                        fileECNew '" -filter_complex "[0:v] [0:a] [1:v] [1:a] concat=n=2:v=1:a=1" -vcodec libx264 -g 24 -x264-params keyint=24 -preset ultrafast ' ...
                        '-profile:v main -r ' num2str(1/framerate) ' -b:v ' bitrate ' -maxrate ' maxrate ' -bufsize ' bufrate ...
                        ' -pix_fmt yuv420p -threads 0 ' videooutputfolder '\' fileOut];
                end;
                
            else;
                if specialChar_outputfolder == 1 | specialChar_fileOut == 1;
                    command = [ffmpegfolder ' -i ' tempfolder ' -i ' videoinputfolder '\' ...
                        fileECNew ' -filter_complex "[0:v] [0:a] [1:v] [1:a] concat=n=2:v=1:a=1" -vcodec libx264 -g 24 -x264-params keyint=24 -preset ultrafast ' ...
                        '-profile:v main -r ' num2str(1/framerate) ' -b:v ' bitrate ' -maxrate ' maxrate ' -bufsize ' bufrate ...
                        ' -pix_fmt yuv420p -threads 0 "' videooutputfolder '\' fileOut '"'];
                else;
                    command = [ffmpegfolder ' -i ' tempfolder ' -i ' videoinputfolder '\' ...
                        fileECNew ' -filter_complex "[0:v] [0:a] [1:v] [1:a] concat=n=2:v=1:a=1" -vcodec libx264 -g 24 -x264-params keyint=24 -preset ultrafast ' ...
                        '-profile:v main -r ' num2str(1/framerate) ' -b:v ' bitrate ' -maxrate ' maxrate ' -bufsize ' bufrate ...
                        ' -pix_fmt yuv420p -threads 0 ' videooutputfolder '\' fileOut];
                end;
            end;
            [status, cmdout] = system(command);
            
            if status == 1;

                if specialChar_outputfolder == 1 | specialChar_fileOut == 1;
                    command = ['rm "' videooutputfolder '\' fileOut '"'];
                else;
                    command = ['rm ' videooutputfolder '\' fileOut];
                end;
                [status, cmdout] = system(command);
                        

                if specialChar_inputfolder == 1 | specialChar_fileECNew == 1;
                    if specialChar_outputfolder == 1 | specialChar_fileOut == 1;
                        command = [ffmpegfolder ' -i ' tempfolder ' -i "' videoinputfolder '\' ...
                            fileECNew '" -filter_complex "[0:v] [1:v] concat=n=2:v=1:a=0" -vcodec libx264 -g 24 -x264-params keyint=24 -preset ultrafast ' ...
                            '-profile:v main -r ' num2str(1/framerate) ' -b:v ' bitrate ' -maxrate ' maxrate ' -bufsize ' bufrate ...
                            ' -pix_fmt yuv420p -threads 0 "' videooutputfolder '\' fileOut '"'];
                    else;
                        command = [ffmpegfolder ' -i ' tempfolder ' -i "' videoinputfolder '\' ...
                            fileECNew '" -filter_complex "[0:v] [1:v] concat=n=2:v=1:a=0" -vcodec libx264 -g 24 -x264-params keyint=24 -preset ultrafast ' ...
                            '-profile:v main -r ' num2str(1/framerate) ' -b:v ' bitrate ' -maxrate ' maxrate ' -bufsize ' bufrate ...
                            ' -pix_fmt yuv420p -threads 0 ' videooutputfolder '\' fileOut];
                    end;
                    
                else;
                    if specialChar_outputfolder == 1 | specialChar_fileOut == 1;
                        command = [ffmpegfolder ' -i ' tempfolder ' -i ' videoinputfolder '\' ...
                            fileECNew ' -filter_complex "[0:v] [1:v] concat=n=2:v=1:a=0" -vcodec libx264 -g 24 -x264-params keyint=24 -preset ultrafast ' ...
                            '-profile:v main -r ' num2str(1/framerate) ' -b:v ' bitrate ' -maxrate ' maxrate ' -bufsize ' bufrate ...
                            ' -pix_fmt yuv420p -threads 0 "' videooutputfolder '\' fileOut '"'];
                    else;
                        command = [ffmpegfolder ' -i ' tempfolder ' -i ' videoinputfolder '\' ...
                            fileECNew ' -filter_complex "[0:v] [1:v] concat=n=2:v=1:a=0" -vcodec libx264 -g 24 -x264-params keyint=24 -preset ultrafast ' ...
                            '-profile:v main -r ' num2str(1/framerate) ' -b:v ' bitrate ' -maxrate ' maxrate ' -bufsize ' bufrate ...
                            ' -pix_fmt yuv420p -threads 0 ' videooutputfolder '\' fileOut];
                    end;
                end;
                [status, cmdout] = system(command);
            end;
        end;

    end;

    if status == 0;
        %delete Temp folder
        if ismac == 1;
            tempfolder = [MDIR '/SP2VideoManager/Temp/'];
            if specialChar_MDIR == 1;
                tempfolder = ['"' tempfolder '"'];
            end;
            command = ['rm ' tempfolder '*'];
        elseif ispc == 1;
            tempfolder = [MDIR '\SP2VideoManager\Temp\'];
            if specialChar_MDIR == 1;
                tempfolder = ['"' tempfolder '"'];
            end;
            command = ['del /Q ' tempfolder '*'];
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