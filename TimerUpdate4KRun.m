 function [] = TimerUpdate4KRun(varargin);


handles = guidata(gcf);
if ispc == 1;
    MDIR = getenv('USERPROFILE');
end;
try;
    if handles.checkbox4K == 1;

        if isdir(handles.inputfolder4K) == 0;
            errorwindow = errordlg('4K videos input folder deleted', 'Error');
            if ispc == 1;
                jFrame = get(handle(errorwindow), 'javaframe');
                jicon = javax.swing.ImageIcon([MDIR '\SP2VideoManager\SpartaManager_IconSoftware.png']);
                jFrame.setFigureIcon(jicon);
                clc;
            end;
            return;
        end;

        if ismac == 1;
            videoinputfolder = [];
            li = strfind(handles.inputfolder4K, ' ');
            if isempty(li) == 0;
                for liEC = 1:length(li);
                    if liEC == 1;
                        videoinputfolder = [videoinputfolder handles.inputfolder4K(1:li(liEC)-1) '\ '];
                    else;
                        videoinputfolder = [videoinputfolder handles.inputfolder4K(li(liEC-1)+1 : li(liEC)-1) '\ '];
                    end;
                end;
                videoinputfolder = [videoinputfolder handles.inputfolder4K(li(liEC)+1 : end)];
            else;
                videoinputfolder = handles.inputfolder4K;
            end;
        elseif ispc == 1;
            videoinputfolder = handles.inputfolder4K;
        end;

        if isdir(handles.outputfolder4K) == 0;
            errorwindow = errordlg('4K videos output folder deleted', 'Error');
            if ispc == 1;
                jFrame = get(handle(errorwindow), 'javaframe');
                jicon = javax.swing.ImageIcon([MDIR '\SP2VideoManager\SpartaManager_IconSoftware.png']);
                jFrame.setFigureIcon(jicon);
                clc;
            end;
            return;
        end;

        if ismac == 1;
            videooutputfolder = [];
            li = strfind(handles.outputfolder4K, ' ');
            if isempty(li) == 0;
                for liEC = 1:length(li);
                    if liEC == 1;
                        videooutputfolder = [videooutputfolder handles.outputfolder4K(1:li(liEC)-1) '\ '];
                    else;
                        videooutputfolder = [videooutputfolder handles.outputfolder4K(li(liEC-1)+1 : li(liEC)-1) '\ '];
                    end;
                end;
                videooutputfolder = [videooutputfolder handles.outputfolder4K(li(liEC)+1 : end)];
            else;
                videooutputfolder = handles.outputfolder4K;
            end;

        elseif ispc == 1;
            videooutputfolder = handles.outputfolder4K;
        end;

        %delete Temp folder
        if ismac == 1
            ffmpegfolder = '/Applications/SP2VideoManager/ffmpeg/bin/';
            if isdir(ffmpegfolder) == 0;
                errorwindow = errordlg('ffmpeg root folder deleted', 'Error');
                return;
            end;
        elseif ispc == 1;
            ffmpegfolder = [MDIR '\SP2VideoManager\ffmpeg\bin\'];
            if isdir(ffmpegfolder) == 0;
                errorwindow = errordlg('ffmpeg root folder deleted', 'Error');
                if ispc == 1;
                    jFrame = get(handle(errorwindow), 'javaframe');
                    jicon = javax.swing.ImageIcon([MDIR '\SP2VideoManager\SpartaManager_IconSoftware.png']);
                    jFrame.setFigureIcon(jicon);
                    clc;
                end;
                return;
            end;
        end;

        if ismac == 1;
            tempfolder = '/Applications/SP2VideoManager/Temp/';
            if isdir('/Applications/SP2VideoManager/Temp') == 0;
                command = ['mkdir /Applications/SP2VideoManager/Temp'];
                [status, cmdout] = system(command);
            end;
            command = ['rm /Applications/SP2VideoManager/Temp/*'];
            [status, cmdout] = system(command);

            load /Applications/SP2VideoManager/listVideo4KFiles.mat;

        elseif ispc == 1;
            tempfolder = [MDIR '\SP2VideoManager\Temp\'];
            if isdir([MDIR '\SP2VideoManager\Temp']) == 0;
                command = ['mkdir ' MDIR '\SP2VideoManager\Temp'];
                [status, cmdout] = system(command);
            end;
            command = ['del /Q ' MDIR '\SP2VideoManager\Temp\*'];
            [status, cmdout] = system(command);

            load([MDIR '\SP2VideoManager\listVideo4KFiles.mat']);
        end;

        if isempty(listVideo4KFiles) == 1;
            dummy{1,1} = 'No Video available';
            dummy{1,2} = '';
            set(handles.table4K_main, 'data', dummy);
            table_extent = get(handles.table4K_main, 'Extent');
            table_position = get(handles.table4K_main, 'Position');
            set(handles.table4K_main, 'Position', [table_position(1) table_position(2)+table_position(4)-table_extent(4) table_extent(3) table_extent(4)]);
        else;
            for i = 1:length(listVideo4KFiles(:,1));
                fileEC = listVideo4KFiles{i,1};
                fileStatus = listVideo4KFiles{i,2};

                if strcmpi(fileStatus, 'Waiting') == 1;
                    %process the file
                    %Check first if the file still exists
                    fileprocess = listVideo4KFiles{i,1};
                    listDir = dir(handles.inputfolder4K);
                    fileExist = 0;
                    for carac = 1:length(listDir);
                        fileCheck = listDir(carac);
                        NameEC = fileCheck.name;
                        if strcmpi(NameEC, fileprocess) == 1;
                            fileExist = 1;
                        end;
                    end;
                    if fileExist == 0;
                        listVideo4KFiles{i,2} = 'Deleted';
                        set(handles.table4K_main, 'data', listVideo4KFiles);

                        table_extent = get(handles.table4K_main, 'Extent');
                        table_position = get(handles.table4K_main, 'Position');
                        posLeft = table_position(1);
                        posBottom = table_position(2)+table_position(4)-table_extent(4);
                        posWidth = table_extent(3);
                        posHeight = table_extent(4);

                        set(gcf, 'units', 'pixels');
                        posFig = get(gcf, 'position');
                        set(gcf, 'units', 'normalized');

                        if posBottom < (75./posFig(4));
                            posBottom = (75./posFig(4));

                            posTopMax = get(handles.test4K_button_main, 'position');
                            posTopMax = posTopMax(2) - (10./posFig(4));
                            posHeight = posTopMax - posBottom;
                        end;               
                        set(handles.table4K_main, 'Visible', 'on', 'Position', [posLeft posBottom posWidth posHeight]);

                        drawnow;
                        if ismac == 1
                            save('/Applications/SP2VideoManager/listVideo4KFiles.mat', 'listVideo4KFiles');
                        elseif ispc == 1;
                            save([MDIR '\SP2VideoManager\listVideo4KFiles.mat'], 'listVideo4KFiles');
                        end;
                    else;
                        listVideo4KFiles{i,2} = 'Processing';
                        set(handles.table4K_main, 'data', listVideo4KFiles);

                        table_extent = get(handles.table4K_main, 'Extent');
                        table_position = get(handles.table4K_main, 'Position');
                        posLeft = table_position(1);
                        posBottom = table_position(2)+table_position(4)-table_extent(4);
                        posWidth = table_extent(3);
                        posHeight = table_extent(4);

                        set(gcf, 'units', 'pixels');
                        posFig = get(gcf, 'position');
                        set(gcf, 'units', 'normalized');

                        if posBottom < (75./posFig(4));
                            posBottom = (75./posFig(4));

                            posTopMax = get(handles.test4K_button_main, 'position');
                            posTopMax = posTopMax(2) - (10./posFig(4));
                            posHeight = posTopMax - posBottom;
                        end;               
                        set(handles.table4K_main, 'Visible', 'on', 'Position', [posLeft posBottom posWidth posHeight]);

                        drawnow;
                        if ismac == 1;
                            save('/Applications/SP2VideoManager/listVideo4KFiles.mat', 'listVideo4KFiles');
                        elseif ispc == 1;
                            save([MDIR '\SP2VideoManager\listVideo4KFiles.mat'], 'listVideo4KFiles');
                        end;

                        if ismac == 1;
                            fileECNew = [];
                            li = strfind(fileEC, ' ');
                            if isempty(li) == 0;
                                for liEC = 1:length(li);
                                    if liEC == 1;
                                        fileECNew = [fileECNew fileEC(1:li(liEC)-1) '\ '];
                                    else;
                                        fileECNew = [fileECNew fileEC(li(liEC-1)+1 : li(liEC)-1) '\ '];
                                    end;
                                end;
                                fileECNew = [fileECNew fileEC(li(liEC)+1 : end)];
                            else;
                                fileECNew = fileEC;
                            end;
                        elseif ispc == 1;
                            fileECNew = fileEC;
                        end;
                        lidot = strfind(fileECNew, '.');
                        lidot = lidot(end);
                        fileOut = [fileECNew(1:lidot-1) '_copy' fileECNew(lidot:end)];

                        proceed = 1;
                        fileOutORI = fileOut;
                        while proceed == 1;
                            lispecial = strfind(fileOut, '-');
                            if isempty(lispecial) == 0;
                                fileOut2 = [fileOut(1:lispecial(1)-1) fileOut(lispecial(1)+1:end)];
                            else;
                                proceed = 0;
                                fileOut2 = fileOut;
                            end;
                            fileOut = fileOut2;
                        end;
                        
                        proceed = 1;
                        fileOutORI = fileOut;
                        while proceed == 1;
                            lispecial = strfind(fileOut, ['''']);;
                            if isempty(lispecial) == 0;
                                fileOut2 = [fileOut(1:lispecial(1)-1) fileOut(lispecial(1)+1:end)];
                            else;
                                proceed = 0;
                                fileOut2 = fileOut;
                            end;
                            fileOut = fileOut2;
                        end;
                        
                        fileoutExist = 0;
                        listdir = dir(handles.outputfolder4K);
                        for filelist = 1:length(listdir);
                            fileCheck = listdir(filelist);
                            NameEC = fileCheck.name;
                            if strcmpi(NameEC, fileOut) == 1;
                                fileoutExist = 1;
                            end;
                        end;
                        if ismac == 1;
                            if fileoutExist == 1;
                                command = ['rm ' videooutputfolder '/' fileOut];
                                [status, cmdout] = system(command);
                            end;
                        elseif ispc == 1;
                            if fileoutExist == 1;
                                command = ['del /Q ' videooutputfolder '\' fileOut];
                                [status, cmdout] = system(command);
                            end;
                        end;

                        if handles.trim4K == 0 & handles.add4K == 0;
                            %Copy videos only
                            if handles.fisheye4K == 0;
                                if ismac == 1;
                                    command = ['cp ' videoinputfolder '/' fileECNew ' ' videooutputfolder '/' fileOut];
                                elseif ispc == 1;
                                    lispace1 = strfind(videoinputfolder, ' ');
                                    lispace2 = strfind(fileECNew, ' ');
                                    if isempty(lispace1) == 1 & isempty(lispace2) == 1;
                                        partIn = [videoinputfolder '\' fileECNew];
                                    else
                                        partIn = ['"' videoinputfolder '\' fileECNew '"'];
                                    end;

                                    lispace1 = strfind(videooutputfolder, ' ');
                                    lispace2 = strfind(fileOut, ' ');
                                    if isempty(lispace1) == 1 & isempty(lispace2) == 1;
                                        partOut = [videooutputfolder '\' fileOut];
                                    else
                                        partOut = ['"' videooutputfolder '\' fileOut '"'];
                                    end;

                                    command = ['copy ' partIn ' ' partOut];
                                end;
                                
                            else;
                                txtlens = lens2k(handles.Currenfisheye4K);
                                if ismac == 1;
                                    partIn = [videoinputfolder '/' fileECNew];
                                    partOut = [videooutputfolder '/' fileOut];

                                elseif ispc == 1;
                                    lispace1 = strfind(videoinputfolder, ' ');
                                    lispace2 = strfind(fileECNew, ' ');
                                    if isempty(lispace1) == 1 & isempty(lispace2) == 1;
                                        partIn = [videoinputfolder '\' fileECNew];
                                    else
                                        partIn = ['"' videoinputfolder '\' fileECNew '"'];
                                    end;

                                    lispace1 = strfind(videooutputfolder, ' ');
                                    lispace2 = strfind(fileOut, ' ');
                                    if isempty(lispace1) == 1 & isempty(lispace2) == 1;
                                        partOut = [videooutputfolder '\' fileOut];
                                    else
                                        partOut = ['"' videooutputfolder '\' fileOut '"'];
                                    end;
                                end;
                                bitrate = [num2str(handles.CurrenCompression4K) 'M'];
                                maxrate = bitrate;
                                bufrate = [num2str(floor((handles.CurrenCompression4K)./3)) 'M'];
%                                 command = [ffmpegfolder 'ffmpeg -i ' partIn ' -vf ' txtlens ...
%                                     ' -c:v libx264 -profile:v baseline -preset ultrafast -x264-params keyint=2 -b:v ' bitrate ...
%                                     ' -maxrate ' maxrate ' -bufsize ' bufrate ' -threads 0 -refs 2 -x264opts b-pyramid=0 ' partOut];


%                                 command = [ffmpegfolder 'ffmpeg -i ' partIn ' -vf ' txtlens ...
%                                     ' -c:v libx264 -profile:v baseline -preset ultrafast -b:v ' bitrate ...
%                                     ' -refs 2 -x264opts b-pyramid=0 -maxrate ' maxrate ' -bufsize ' bufrate ...
%                                     ' -threads 0 -x264-params keyint=2:min-keyint=24:ref=2:b-adapt=0 ' ...
%                                     partOut];
                                
                                command = [ffmpegfolder 'ffmpeg -accurate_seek -ss 1 -i ' partIn ' -vf ' txtlens ...
                                    ' -c:v libx264 -profile:v baseline -preset ultrafast -b:v ' bitrate ...
                                    ' -refs 2 -x264opts b-pyramid=0 -maxrate ' maxrate ' -bufsize ' bufrate ...
                                    ' -threads 0 -x264-params keyint=2:min-keyint=24:ref=2:b-adapt=0 ' ...
                                    partOut];
                                
                                command
                            
                            end;
                            
                            
                            
                            
                            
                            
                            
                            tic
                            [status, cmdout] = system(command);
                            t=toc
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            if status ~= 0;
                                errorwindow = errordlg('Impossible to copy', 'Error');
                                if ispc == 1;
                                    jFrame = get(handle(errorwindow), 'javaframe');
                                    jicon = javax.swing.ImageIcon([MDIR '\SP2VideoManager\SpartaManager_IconSoftware.png']);
                                    jFrame.setFigureIcon(jicon);
%                                     clc;
                                end;
                                return;
                            end;
                        elseif handles.trim4K == 0 & handles.add4K ~= 0;
                            %process videos Add`
                            %Check video
                            if ismac == 1;
                                command = [ffmpegfolder 'ffmpeg -i ' videoinputfolder '/' fileECNew ...
                                    ' -map 0:v:0 -c copy -f null -'];
                            elseif ispc == 1;
                                lispace1 = strfind(videoinputfolder, ' ');
                                lispace2 = strfind(fileECNew, ' ');
                                if isempty(lispace1) == 1 & isempty(lispace2) == 1;
                                    partIn = [videoinputfolder '\' fileECNew];
                                else
                                    partIn = ['"' videoinputfolder '\' fileECNew '"'];
                                end;

                                command = [ffmpegfolder 'ffmpeg -i ' partIn ...
                                    ' -map 0:v:0 -c copy -f null -'];
                            end;
                            [status, cmdout] = system(command);

                            liduration = strfind(cmdout, 'Duration');
                            cmdoutShort = cmdout(liduration(1):liduration(1)+50);
                            liduration1 = strfind(cmdoutShort, ' ');
                            liduration2 = strfind(cmdoutShort, ',');
                            duration = cmdoutShort(liduration1(1)+1:liduration2(1)-1);
                            lidots = strfind(duration, ':');
                            sec = str2num(duration(lidots(2)+1:end));
                            min = str2num(duration(lidots(1)+1:lidots(2)-1)).*60;
                            hour = str2num(duration(1:lidots(1)-1)).*3600;
                            VidTimeOriginal = hour+min+sec;

                            lifps = strfind(cmdout, 'fps');
                            cmdoutfps = cmdout(lifps(1)-3:lifps(1)-2);
                            framerate = roundn(1./roundn(str2num(cmdoutfps),0),-2);
                            liRes720 = strfind(cmdout, '1280x720');
                            liRes1080 = strfind(cmdout, '1920x1080');
                            liRes2160 = strfind(cmdout, '3840x2160');
                            if isempty(liRes720) == 0;
                                resolutionVideo = [1280 720];
                                bitrate = [num2str(handles.CurrenCompression4K) 'M'];
                            end;
                            if isempty(liRes1080) == 0;
                                resolutionVideo = [1920 1080];
                                bitrate = [num2str(handles.CurrenCompression4K) 'M'];
                            end;
                            if isempty(liRes2160) == 0;
                                resolutionVideo = [3840 2160];
                                bitrate = [num2str(handles.CurrenCompression4K) 'M'];
                            end;

                            %Create the black video
                            timeadd = handles.add4K*framerate;
                            command = [ffmpegfolder 'ffmpeg -f lavfi -i color=c=black:s=' num2str(resolutionVideo(1)) 'x' num2str(resolutionVideo(2)) ':r=' num2str(1/framerate) '/1 ' ...
                                '-f lavfi -i anullsrc=cl=mono:r=48000 -c:v libx264 -x264-params keyint=2 -profile:v main -preset ultrafast ' ...
                                '-b:v ' bitrate ' -pix_fmt yuv420p -video_track_timescale ' num2str(1/framerate) 'k -t ' num2str(timeadd) ' ' tempfolder 'blackVideo.MP4'];
                            [status, cmdout] = system(command);

                            if status == 0;
                                if ismac == 1;
                                    if handles.checkboxRemux4K == 1;
                                        fid = fopen('/Applications/SP2VideoManager/Temp/batchlist.txt', 'wt');
                                        text1 = ['file ' '''' '/Applications/SP2VideoManager/Temp/blackVideo.MP4' ''''];
                                        fprintf(fid, '%s\n', text1);
                                        text2 = ['file ' '''' videoinputfolder '/' fileECNew ''''];
                                        fprintf(fid, '%s', text2);
                                        fclose(fid);
                                        command = [ffmpegfolder 'ffmpeg -f concat -safe 0 -i /Applications/SP2VideoManager/Temp/batchlist.txt -c copy ' ...
                                                videooutputfolder '/' fileOut];
                                    else;
                                        command = [ffmpegfolder 'ffmpeg -i ' tempfolder 'blackVideo.MP4 -i ' videoinputfolder '/' ...
                                            fileECNew ' -filter_complex "[0:v] [0:a] [1:v] [1:a] concat=n=2:v=1:a=1" -vcodec libx264 -x264-params keyint=2 -preset ultrafast ' ...
                                            '-r ' num2str(1/framerate) ' -b:v ' bitrate ' -pix_fmt yuv420p ' videooutputfolder '/' fileOut];
                                        [status, cmdout] = system(command);
                                        if status == 1;
                                            command = [ffmpegfolder 'ffmpeg -i ' tempfolder 'blackVideo.MP4 -i ' videoinputfolder '/' ...
                                                fileECNew ' -filter_complex "[0:v] [1:v] concat=n=2:v=1:a=0" -vcodec libx264 -x264-params keyint=2 -preset ultrafast ' ...
                                                '-r ' num2str(1/framerate) ' -b:v ' bitrate ' -pix_fmt yuv420p ' videooutputfolder '/' fileOut];
                                            [status, cmdout] = system(command);
                                        end;
                                    end;

                                elseif ispc == 1;
                                    lispace1 = strfind(videoinputfolder, ' ');
                                    lispace2 = strfind(fileECNew, ' ');
                                    if isempty(lispace1) == 1 & isempty(lispace2) == 1;
                                        partIn = [videoinputfolder '\' fileECNew];
                                    else
                                        partIn = ['"' videoinputfolder '\' fileECNew '"'];
                                    end;

                                    lispace1 = strfind(videooutputfolder, ' ');
                                    lispace2 = strfind(fileOut, ' ');
                                    if isempty(lispace1) == 1 & isempty(lispace2) == 1;
                                        partOut = [videooutputfolder '\' fileOut];
                                    else
                                        partOut = ['"' videooutputfolder '\' fileOut '"'];
                                    end;

                                    if handles.checkboxRemux4K == 1;
                                        fid = fopen([MDIR '\SP2VideoManager\Temp\batchlist.txt'], 'wt');
                                        text1 = ['file ' '''' MDIR '\SP2VideoManager\Temp\blackVideo.MP4' ''''];
                                        fprintf(fid, '%s\n', text1);
                                        text2 = ['file ' '''' videoinputfolder '\' fileECNew ''''];
                                        fprintf(fid, '%s', text2);
                                        fclose(fid);
                                        command = [ffmpegfolder 'ffmpeg -f concat -safe 0 -i ' MDIR '\SP2VideoManager\Temp\batchlist.txt -c copy ' ...
                                                partOut];
                                        [status, cmdout] = system(command);
                                    else;
                                        command = [ffmpegfolder 'ffmpeg -i ' tempfolder 'blackVideo.MP4 -i ' partIn ...
                                            ' -filter_complex "[0:v] [0:a] [1:v] [1:a] concat=n=2:v=1:a=1" -vcodec libx264 -x264-params keyint=2 -preset ultrafast ' ...
                                            '-r ' num2str(1/framerate) ' -b:v ' bitrate ' -pix_fmt yuv420p ' partOut];
                                        [status, cmdout] = system(command);
                                        if status == 1;
                                            command = [ffmpegfolder 'ffmpeg -i ' tempfolder 'blackVideo.MP4 -i ' partIn ...
                                                ' -filter_complex "[0:v] [1:v] concat=n=2:v=1:a=0" -vcodec libx264 -x264-params keyint=2 -preset ultrafast ' ...
                                                '-r ' num2str(1/framerate) ' -b:v ' bitrate ' -pix_fmt yuv420p ' partOut];
                                            [status, cmdout] = system(command);
                                        end;
                                    end;
                                end;


                                if status == 0;
                                    %delete Temp folder
                                    if ismac == 1;
                                        command = ['rm ' tempfolder '*'];
                                        [status, cmdout] = system(command);
                                    elseif ispc == 1;
                                        command = ['del /Q ' tempfolder '*'];
                                        [status, cmdout] = system(command);
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
                            end;

                        elseif handles.trim4K ~= 0 & handles.add4K == 0;
                            %process videos Trim
                            %check the original video
                            if ismac == 1;
                                command = [ffmpegfolder 'ffmpeg -i ' videoinputfolder '/' fileECNew ...
                                    ' -map 0:v:0 -c copy -f null -'];
                            elseif ispc == 1;
                                lispace1 = strfind(videoinputfolder, ' ');
                                lispace2 = strfind(fileECNew, ' ');
                                if isempty(lispace1) == 1 & isempty(lispace2) == 1;
                                    partIn = [videoinputfolder '\' fileECNew];
                                else
                                    partIn = ['"' videoinputfolder '\' fileECNew '"'];
                                end;

                                command = [ffmpegfolder 'ffmpeg -i ' partIn ...
                                    ' -map 0:v:0 -c copy -f null -'];
                            end;
                            [status, cmdout] = system(command);

                            liduration = strfind(cmdout, 'Duration');
                            cmdoutShort = cmdout(liduration(1):liduration(1)+50);
                            liduration1 = strfind(cmdoutShort, ' ');
                            liduration2 = strfind(cmdoutShort, ',');
                            duration = cmdoutShort(liduration1(1)+1:liduration2(1)-1);
                            lidots = strfind(duration, ':');
                            sec = str2num(duration(lidots(2)+1:end));
                            min = str2num(duration(lidots(1)+1:lidots(2)-1)).*60;
                            hour = str2num(duration(1:lidots(1)-1)).*3600;
                            VidTimeOriginal = hour+min+sec;

                            lifps = strfind(cmdout, 'fps');
                            cmdoutfps = cmdout(lifps(1)-3:lifps(1)-2);
                            framerate = roundn(1./roundn(str2num(cmdoutfps),0),-2);
                            liRes720 = strfind(cmdout, '1280x720');
                            liRes1080 = strfind(cmdout, '1920x1080');
                            liRes2160 = strfind(cmdout, '3840x2160');
                            if isempty(liRes720) == 0;
                                resolutionVideo = [1280 720];
                                bitrate = [num2str(handles.CurrenCompression4K) 'M'];
                            end;
                            if isempty(liRes1080) == 0;
                                resolutionVideo = [1920 1080];
                                bitrate = [num2str(handles.CurrenCompression4K) 'M'];
                            end;
                            if isempty(liRes2160) == 0;
                                resolutionVideo = [3840 2160];
                                bitrate = [num2str(handles.CurrenCompression4K) 'M'];
                            end;

                            %export frames
                            timecut = ceil(handles.trim4K*framerate);
                            %                 extratime = 0.2; %10 frames at 50
                            framecut = (ceil(handles.trim4K*framerate))./framerate;
                            if ismac == 1;
                                command = [ffmpegfolder 'ffmpeg -i ' videoinputfolder '/' fileECNew ...
                                    ' -vf "select=' '''' 'between(n,1,' num2str(framecut) ')' '''' '"' ...
                                    ' -q:v 10 -vframes ' num2str(framecut) ' ' tempfolder 'out%d.jpg'];
                            elseif ispc == 1;
                                lispace1 = strfind(videoinputfolder, ' ');
                                lispace2 = strfind(fileECNew, ' ');
                                if isempty(lispace1) == 1 & isempty(lispace2) == 1;
                                    partIn = [videoinputfolder '\' fileECNew];
                                else
                                    partIn = ['"' videoinputfolder '\' fileECNew '"'];
                                end;

                                command = [ffmpegfolder 'ffmpeg -i ' partIn ...
                                    ' -vf "select=' '''' 'between(n,1,' num2str(framecut) ')' '''' '"' ...
                                    ' -q:v 2 -vframes ' num2str(framecut) ' ' tempfolder 'out%d.jpg'];
                            end;
                            [status, cmdout] = system(command);

                            if status == 0;
                                %trim video
                                if ismac == 1;
                                    command = [ffmpegfolder 'ffmpeg -accurate_seek -ss ' num2str(timecut) ...
                                        ' -i ' videoinputfolder '/' fileECNew ' -c:v copy ' ...
                                        tempfolder 'tempVideo.MP4'];
                                elseif ispc == 1;
                                    lispace1 = strfind(videoinputfolder, ' ');
                                    lispace2 = strfind(fileECNew, ' ');
                                    if isempty(lispace1) == 1 & isempty(lispace2) == 1;
                                        partIn = [videoinputfolder '\' fileECNew];
                                    else
                                        partIn = ['"' videoinputfolder '\' fileECNew '"'];
                                    end;

                                    command = [ffmpegfolder 'ffmpeg -accurate_seek -ss ' num2str(timecut) ...
                                        ' -i ' partIn ' -c:v copy ' ...
                                        tempfolder 'tempVideo.MP4'];
                                end;
                                [status, cmdout] = system(command);

                                %check video
                                if ismac == 1;
                                    command = [ffmpegfolder 'ffmpeg -i ' tempfolder 'tempVideo.MP4' ...
                                        ' -map 0:v:0 -c copy -f null -'];
                                elseif ispc == 1;
                                    command = [ffmpegfolder 'ffmpeg -i ' tempfolder 'tempVideo.MP4' ...
                                        ' -map 0:v:0 -c copy -f null -'];
                                end;
                                [status, cmdout] = system(command);

                                liduration = strfind(cmdout, 'Duration');
                                cmdoutShort = cmdout(liduration(1):liduration(1)+50);
                                liduration1 = strfind(cmdoutShort, ' ');
                                liduration2 = strfind(cmdoutShort, ',');
                                duration = cmdoutShort(liduration1(1)+1:liduration2(1)-1);
                                lidots = strfind(duration, ':');
                                sec = str2num(duration(lidots(2)+1:end));
                                min = str2num(duration(lidots(1)+1:lidots(2)-1)).*60;
                                hour = str2num(duration(1:lidots(1)-1)).*3600;
                                VidTimeProcessed = hour+min+sec;

                                if abs(VidTimeOriginal - VidTimeProcessed) >= framerate;
                                    %create the extra video using the still frame
                                    if VidTimeOriginal - VidTimeProcessed > 1;
                                        extraframe = floor(rem(VidTimeOriginal - VidTimeProcessed, 1)./framerate);
                                        if ismac == 1;
                                            command = [ffmpegfolder 'ffmpeg -i ' videoinputfolder '/' fileECNew ...
                                                ' -vf "select=' '''' 'between(n,' num2str(framecut+1) ',' num2str(framecut+extraframe) ')' '''' '"' ...
                                                ' -vframes ' num2str(extraframe) ' ' tempfolder 'extra_out%d.jpg'];
                                        elseif ispc == 1;
                                            lispace1 = strfind(videoinputfolder, ' ');
                                            lispace2 = strfind(fileECNew, ' ');
                                            if isempty(lispace1) == 1 & isempty(lispace2) == 1;
                                                partIn = [videoinputfolder '\' fileECNew];
                                            else
                                                partIn = ['"' videoinputfolder '\' fileECNew '"'];
                                            end;

                                            lispace1 = strfind(videooutputfolder, ' ');
                                            lispace2 = strfind(fileOut, ' ');
                                            if isempty(lispace1) == 1 & isempty(lispace2) == 1;
                                                partOut = [videooutputfolder '\' fileOut];
                                            else
                                                partOut = ['"' videooutputfolder '\' fileOut '"'];
                                            end;

                                            extraframe = floor(rem(VidTimeOriginal - VidTimeProcessed, 1)./framerate);
                                            command = [ffmpegfolder 'ffmpeg -i ' partIn ...
                                                ' -vf "select=' '''' 'between(n,' num2str(framecut+1) ',' num2str(framecut+extraframe) ')' '''' '"' ...
                                                ' -vframes ' num2str(extraframe) ' ' tempfolder 'extra_out%d.jpg'];
                                        end;
                                        [status, cmdout] = system(command);

                                        iter = framecut+1;
                                        if ismac == 1;
                                            for frameRel = 1:extraframe;
                                                command = ['mv ' tempfolder 'extra_out' num2str(frameRel) '.jpg ' tempfolder 'out' num2str(iter) '.jpg'];
                                                [status, cmdout] = system(command);
                                                iter = iter + 1;
                                            end;
                                        elseif ispc == 1;
                                            for frameRel = 1:extraframe;
                                                command = ['move ' tempfolder 'extra_out' num2str(frameRel) '.jpg ' tempfolder 'out' num2str(iter) '.jpg'];
                                                [status, cmdout] = system(command);
                                                iter = iter + 1;
                                            end;
                                        end;
                                    else;
                                        extraframe = 0;
                                    end;

                                    if ismac == 1;
                                        command = ['rm '];
                                    elseif ispc == 1;
                                        command = ['del /Q '];
                                    end;
                                    for frameRem = 1:handles.trim4K;
                                        command = [command tempfolder 'out' num2str(frameRem) '.jpg '];
                                    end;
                                    command = command(1:end-1);
                                    [status, cmdout] = system(command);

                                    iter = 1;
                                    if ismac == 1;
                                        for frameRel = (handles.trim4K+1):(framecut+extraframe);
                                            command = ['mv ' tempfolder 'out' num2str(frameRel) '.jpg ' tempfolder 'out' num2str(iter) '.jpg'];
                                            [status, cmdout] = system(command);
                                            iter = iter + 1;
                                        end;
                                    elseif ispc == 1;
                                        for frameRel = (handles.trim4K+1):(framecut+extraframe);
                                            command = ['move /Y ' tempfolder 'out' num2str(frameRel) '.jpg ' tempfolder 'out' num2str(iter) '.jpg'];
                                            [status, cmdout] = system(command);
                                            iter = iter + 1;
                                        end;
                                    end;
                                    command = [ffmpegfolder 'ffmpeg -f image2 -start_number ' num2str(frameRel+1) ' -r ' num2str(1/framerate) ' -i "' tempfolder 'out%d.jpg" -f lavfi -i anullsrc -c:v libx264 -x264-params keyint=2 ' ...
                                        '-profile:v main -preset ultrafast ' ...
                                        '-b:v ' bitrate ' -pix_fmt yuv420p -video_track_timescale ' num2str(1/framerate) 'k -c:a aac -shortest ' tempfolder 'stillVideo.MP4'];
                                    [status, cmdout] = system(command);

                                    %concatenate both videos
                                    %command = [ffmpegfolder 'ffmpeg -f concat -safe 0 -i /Applications/SP2VideoManager/concatlistTrimPanning.txt -c copy ' videooutputfolder '/' fileOut];
                                    if ismac == 1;
                                        if handles.checkboxRemux4K == 1;
                                            fid = fopen('/Applications/SP2VideoManager/Temp/batchlist.txt', 'wt');
                                            text1 = ['file ' '''' '/Applications/SP2VideoManager/Temp/stillVideo.MP4' ''''];
                                            fprintf(fid, '%s\n', text1);
                                            text2 = ['file ' '''' '/Applications/SP2VideoManager/Temp/tempVideo.MP4' ''''];
                                            fprintf(fid, '%s', text2);
                                            fclose(fid);
                                            command = [ffmpegfolder 'ffmpeg -f concat -safe 0 -i /Applications/SP2VideoManager/Temp/batchlist.txt -c copy ' ...
                                                videooutputfolder '/' fileOut];
                                            [status, cmdout] = system(command);
                                        else;
                                            command = [ffmpegfolder 'ffmpeg -i ' tempfolder 'stillVideo.MP4 -i ' tempfolder ...
                                                'tempVideo.MP4 -filter_complex "[0:v] [0:a] [1:v] [1:a] concat=n=2:v=1:a=1" -vcodec libx264 -x264-params keyint=2 -preset ultrafast -r ' num2str(1/framerate) ...
                                                ' -b:v ' bitrate ' -pix_fmt yuv420p ' videooutputfolder '/' fileOut];
                                            [status, cmdout] = system(command);
                                            if status == 1;
                                                command = [ffmpegfolder 'ffmpeg -i ' tempfolder 'stillVideo.MP4 -i ' tempfolder ...
                                                    'tempVideo.MP4 -filter_complex "[0:v] [1:v] concat=n=2:v=1:a=0" -vcodec libx264 -x264-params keyint=2 -preset ultrafast -r ' num2str(1/framerate) ...
                                                    ' -b:v ' bitrate ' -pix_fmt yuv420p ' videooutputfolder '/' fileOut];
                                                [status, cmdout] = system(command);
                                            end;
                                        end;

                                    elseif ispc == 1;
                                        lispace1 = strfind(videoinputfolder, ' ');
                                        lispace2 = strfind(fileECNew, ' ');
                                        if isempty(lispace1) == 1 & isempty(lispace2) == 1;
                                            partIn = [videoinputfolder '\' fileECNew];
                                        else
                                            partIn = ['"' videoinputfolder '\' fileECNew '"'];
                                        end;

                                        lispace1 = strfind(videooutputfolder, ' ');
                                        lispace2 = strfind(fileOut, ' ');
                                        if isempty(lispace1) == 1 & isempty(lispace2) == 1;
                                            partOut = [videooutputfolder '\' fileOut];
                                        else
                                            partOut = ['"' videooutputfolder '\' fileOut '"'];
                                        end;

                                        if handles.checkboxRemux4K == 1;
                                            fid = fopen([MDIR '\SP2VideoManager\Temp\batchlist.txt'], 'wt');
                                            text1 = ['file ' '''' MDIR '\SP2VideoManager\Temp\stillVideo.MP4' ''''];
                                            fprintf(fid, '%s\n', text1);
                                            text2 = ['file ' '''' MDIR '\SP2VideoManager\Temp\tempVideo.MP4' ''''];
                                            fprintf(fid, '%s', text2);
                                            fclose(fid);

                                            command = [ffmpegfolder 'ffmpeg -f concat -safe 0 -i ' MDIR '\SP2VideoManager\Temp\batchlist.txt -c copy ' ...
                                                partOut];
                                            [status, cmdout] = system(command);
                                        else;
                                            command = [ffmpegfolder 'ffmpeg -i ' tempfolder 'stillVideo.MP4 -i ' tempfolder ...
                                                'tempVideo.MP4 -filter_complex "[0:v] [0:a] [1:v] [1:a] concat=n=2:v=1:a=1" -vcodec libx264 -x264-params keyint=2 -preset ultrafast -r ' num2str(1/framerate) ...
                                                ' -b:v ' bitrate ' -pix_fmt yuv420p ' partOut];
                                            [status, cmdout] = system(command);
                                            if status == 1;
                                                command = [ffmpegfolder 'ffmpeg -i ' tempfolder 'stillVideo.MP4 -i ' tempfolder ...
                                                    'tempVideo.MP4 -filter_complex "[0:v] [1:v] concat=n=2:v=1:a=0" -vcodec libx264 -x264-params keyint=2 -preset ultrafast -r ' num2str(1/framerate) ...
                                                    ' -b:v ' bitrate ' -pix_fmt yuv420p ' partOut];
                                                [status, cmdout] = system(command);
                                            end;
                                        end;
                                    end;
                                    

                                    if status == 0
                                        %delete Temp folder
                                        if ismac == 1;
                                            command = ['rm ' tempfolder '*'];
                                        elseif ispc == 1;
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
                        end;

%                         if handles.fisheye4K == 1;
%                             li = strfind(fileECNew, '.');
%                             file = fileECNew(1:li(end)-1);
% 
%                             if ismac == 1;
%                                 command = ['rm ' videooutputfolder '/' file];
%                                 [status, cmdout] = system(command);
%                                 command = ['mkdir ' videooutputfolder '/' file];
%                                 [status, cmdout] = system(command);
% 
%                                 command = [ffmpegfolder 'ffmpeg -i ' videoinputfolder '/' fileECNew ' -vsync 0 -q:v ' num2str(handles.ImageQuality) ' ' videooutputfolder '/' file '/' 'frame%d.jpg'];
%                                 [status, cmdout] = system(command);
%                                 nbFrames = length(dir([videooutputfolder '/' file]))-2;
% 
%                                 if handles.trim4K ~= 0;
%                                     command = ['rm '];
%                                     for frameRem = 1:handles.trim4K;
%                                         command = [command videooutputfolder '/' file '/frame' num2str(frameRem) '.jpg '];
%                                     end;
%                                     [status, cmdout] = system(command);
% 
%                                     iter = 1;
%                                     for frameRel = (handles.trim4K+1):nbFrames;
%                                         command = ['mv ' videooutputfolder '/' file '/frame' num2str(frameRel) '.jpg ' videooutputfolder '/' file '/frame' num2str(iter) '.jpg'];
%                                         [status, cmdout] = system(command);
%                                         iter = iter + 1;
%                                     end;
%                                 end;
%                                 if handles.add4K ~= 0;
%                                     iter = nbFrames+handles.add4K;
%                                     for frameRel = -nbFrames:-1;
%                                         command = ['mv ' videooutputfolder '/' file '/frame' num2str(abs(frameRel)) '.jpg ' videooutputfolder '/' file '/frame' num2str(iter) '.jpg'];
%                                         [status, cmdout] = system(command);
%                                         iter = iter - 1;
%                                     end;
% 
%                                     for frameRel = 1:handles.add4K;
%                                         command = ['cp ' rootfolder 'frame' num2str(resolutionVideo(2)) '.jpg ' ...
%                                             videooutputfolder '/' file '/frame' num2str(frameRel) '.jpg'];
%                                         [status, cmdout] = system(command);
%                                     end;
%                                 end;
% 
%                             elseif ispc == 1;
%                                 command = ['del /Q ' videooutputfolder '\' file];
%                                 [status, cmdout] = system(command);
%                                 command = ['mkdir ' videooutputfolder '\' file];
%                                 [status, cmdout] = system(command);
% 
%                                 command = [ffmpegfolder 'ffmpeg -i ' videoinputfolder '\' fileECNew ' -vsync 0 -q:v ' num2str(handles.ImageQuality) ' ' videooutputfolder '\' file '\' 'frame%d.jpg'];
%                                 [status, cmdout] = system(command);
%                                 nbFrames = length(dir([videooutputfolder '\' file]))-2;
% 
%                                 if handles.trim4K ~= 0;
%                                     command = ['del /Q '];
%                                     for frameRem = 1:handles.trim4K;
%                                         command = [command videooutputfolder '\' file '\frame' num2str(frameRem) '.jpg '];
%                                     end;
%                                     [status, cmdout] = system(command);
% 
%                                     iter = 1;
%                                     for frameRel = (handles.trim4K+1):nbFrames;
%                                         command = ['move /Y ' videooutputfolder '\' file '\frame' num2str(frameRel) '.jpg ' videooutputfolder '\' file '\frame' num2str(iter) '.jpg'];
%                                         [status, cmdout] = system(command);
%                                         iter = iter + 1;
%                                     end;
%                                 end;
%                                 if handles.add4K ~= 0;
%                                     iter = nbFrames+handles.add4K;
%                                     for frameRel = -nbFrames:-1;
%                                         command = ['move /Y ' videooutputfolder '\' file '\frame' num2str(abs(frameRel)) '.jpg ' videooutputfolder '\' file '\frame' num2str(iter) '.jpg'];
%                                         [status, cmdout] = system(command);
%                                         iter = iter - 1;
%                                     end;
% 
%                                     for frameRel = 1:handles.add4K;
%                                         command = ['copy ' rootfolder 'frame' num2str(resolutionVideo(2)) '.jpg ' ...
%                                             videooutputfolder '\' file '\frame' num2str(frameRel) '.jpg'];
%                                         [status, cmdout] = system(command);
%                                     end;
%                                 end;
%                             end;
%                         end;

                        if status == 0;
                            listVideo4KFiles{i,2} = 'Done';
                            set(handles.table4K_main, 'data', listVideo4KFiles);

                            table_extent = get(handles.table4K_main, 'Extent');
                            table_position = get(handles.table4K_main, 'Position');
                            posLeft = table_position(1);
                            posBottom = table_position(2)+table_position(4)-table_extent(4);
                            posWidth = table_extent(3);
                            posHeight = table_extent(4);

                            set(gcf, 'units', 'pixels');
                            posFig = get(gcf, 'position');
                            set(gcf, 'units', 'normalized');

                            if posBottom < (75./posFig(4));
                                posBottom = (75./posFig(4));

                                posTopMax = get(handles.test4K_button_main, 'position');
                                posTopMax = posTopMax(2) - (10./posFig(4));
                                posHeight = posTopMax - posBottom;
                            end;               
                            set(handles.table4K_main, 'Visible', 'on', 'Position', [posLeft posBottom posWidth posHeight]);

                            drawnow limitrate;
                            if ismac == 1;
                                save('/Applications/SP2VideoManager/listVideo4KFiles.mat', 'listVideo4KFiles');
                            elseif ispc == 1;
                                save([MDIR '\SP2VideoManager\listVideo4KFiles.mat'], 'listVideo4KFiles');
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;
end;
