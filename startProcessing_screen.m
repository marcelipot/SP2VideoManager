function [] = startProcessing_screen(varargin);


tic;



handles = guidata(gcf);

VidInfo = handles.VidInfoScreen;

% feefoffpanningVal = handles.feefoffpanningVal_single;
% feefoff4KVal = handles.feefoff4KVal_single;
% fileprocess = handles.pathPanningfile_single;

if isempty(VidInfo.exportRate) == 0;
    if VidInfo.exportRate ~= VidInfo.Rate;
        isMatlab = 1;
        isNewRate = 1;
    else;
        isMatlab = 0;
        isNewRate = 0;
    end;
else;
    isMatlab = 0;
    isNewRate = 0;
end;

if isempty(VidInfo.FishEye) == 0;
    isMatlab = 1;
    isFishEye = 1;
else;
    isFishEye = 0;
end;

if VidInfo.ImageEnhance.Contract ~= 0;
    isMatlab = 1;
    isContrast = 1;
else;
    isContrast = 0;
end;

if VidInfo.ImageEnhance.Brightness ~= 0;
    isMatlab = 1;
    isBrightness = 1;
else;
    isBrightness = 0;
end;

frameGrab = zeros(VidInfo.Height,VidInfo.Width,3);
frameUndist = zeros(VidInfo.Height,VidInfo.Width,3);
frameProcessed = zeros(VidInfo.Height,VidInfo.Width,3);
frame = zeros(VidInfo.Height,VidInfo.Width,3);

if isMatlab == 1;
    %----------------process with matlab-----------------
    %FFMPEG folder (for the final compression)
    set(handles.txtProgress_screen, 'String', 'Processing images ...', 'Visible', 'on');
    drawnow;

    %User and applications folder
    if ispc == 1;
        MDIR = getenv('USERPROFILE');
    elseif ismac == 1;
        MDIR = '/Applications';
    end;
    
    %FFMPEG folder
    if ismac == 1
        ffmpegfolder = '/opt/homebrew/bin/ffmpeg';
    elseif ispc == 1;
        ffmpegfolder = [MDIR '/SP2VideoManager/ffmpeg/bin/ffmpeg'];
    end;

    %Temporary and root folders. Empty Temporaty (not root)
    if ismac == 1;
        rootfolder = [MDIR '/SP2VideoManager/'];
        tempfolder = [MDIR '/SP2VideoManager/Temp/'];
        
        if isdir([MDIR '/SP2VideoManager/Temp']) == 0;
            command = ['mkdir "' tempfolder '"'];
            [status, cmdout] = system(command);
        end;
        command = ['rm "' tempfolder '"*'];
        [status, cmdout] = system(command);
    
        tempfolder = [MDIR '/SP2VideoManager/Temp/'];

    elseif ispc == 1;
        rootfolder = [MDIR '\SP2VideoManager\'];
        tempfolder = [MDIR '\SP2VideoManager\Temp\'];
        
        if isdir([MDIR '\SP2VideoManager\Temp']) == 0;
            command = ['mkdir "' tempfolder '"'];
            [status, cmdout] = system(command);
        end;

        command = ['del /Q "' tempfolder '"*'];
        [status, cmdout] = system(command);
    
        tempfolder = [MDIR '\SP2VideoManager\Temp\'];
    end;

    %determine frame rate
    if VidInfo.exportRate < VidInfo.Rate;
        %the original frame rate is higher than the export rate
        tempRate = VidInfo.exportRate;
        targetRate = VidInfo.exportRate;

    elseif VidInfo.exportRate > VidInfo.Rate;
        %the original frame rate is lower than the export rate
        tempRate = VidInfo.exportRate./2;
        targetRate = VidInfo.exportRate;

    else;
        %equal frame rate
        tempRate = VidInfo.exportRate;
        targetRate = VidInfo.exportRate;
    end;

    %List of targetted frames
    if isempty(handles.trimInVal_screen) == 1 & isempty(handles.trimOutVal_screen) == 1;
        frameDataTemp = 0 : 1./VidInfo.Rate : VidInfo.Duration;
        frameINI = 1;
        frameEND = length(frameDataTemp);

    elseif isempty(handles.trimInVal_screen) == 1 & isempty(handles.trimOutVal_screen) == 0;
        %Trim at the end
        trimOutTime = (handles.trimOutVal_screen./VidInfo.Rate) - (1/VidInfo.Rate); %use the actual rate as frame were determined on the original video
        frameDataTemp = 0 : 1./VidInfo.Rate : trimOutTime;

        frameINI = 1;
        frameEND = handles.trimOutVal_screen;

    elseif isempty(handles.trimInVal_screen) == 0 & isempty(handles.trimOutVal_screen) == 1;
        %trim at the beginning
        trimInTime = (handles.trimInVal_screen./VidInfo.Rate) - (1/VidInfo.Rate);  %use the actual rate as frame were determined on the original video
        frameDataTemp = trimInTime : 1./VidInfo.Rate : VidInfo.Duration;

        frameINI = handles.trimInVal_screen;
        frameEND = frameINI + length(frameDataTemp) - 1;

    else;
        %Trim at the beginning and end
        trimInTime = (handles.trimInVal_screen./VidInfo.Rate) - (1/VidInfo.Rate);
        trimOutTime = (handles.trimOutVal_screen./VidInfo.Rate) - (1/VidInfo.Rate);
        frameDataTemp = trimInTime : 1./VidInfo.Rate : trimOutTime;

        frameINI = handles.trimInVal_screen;
        frameEND = handles.trimOutVal_screen;

    end;
    frameDataTemp = [[frameINI:frameEND]' frameDataTemp' zeros(length(frameDataTemp),1)];

    %get the list of frames to use for the new video
    timeEC = frameDataTemp(1,2);
    for imEC = 1:length(frameDataTemp(:,1))-1;
        diffTime = abs(frameDataTemp(:,2)-timeEC);
        [minVal, minLoc] = min(diffTime);
        if frameDataTemp(minLoc,3) == 0;
            frameDataTemp(minLoc,3) = 1;
        end;
        timeEC = timeEC + (1./tempRate);
    end;

    %Main processing... parallel processing
    nthreads = 6;
    maxFrameCount = length(frameDataTemp(:,1))-2;
%     if nthreads == 1;
%         %Create frame list for each sub-video (parallel processing)
%         frameListP1 = 1 : maxFrameCount;
% 
%         %Export parameters for parallel processing
%         fileSettings = [tempfolder 'tempVideoSettings.mat'];
%         save(fileSettings, 'VidInfo', ...
%             'frameListP1', ...
%             'isMatlab', 'tempfolder', 'frameDataTemp', 'targetRate', 'tempRate');
%     
%         %Temporary video filenames
%         fileTemp1 = [tempfolder 'tempVid1'];
% 
%         %Trigger the process
%         if ispc == 1;
%             command1 = [rootfolder 'bin\export4Kparts1_screen.exe'];
%         elseif ismac == 1;
%     
%         end;
%         command = ['start /B ' command1]
%         [status, out] = system(command);
%         proceed = 1;
%         while proceed == 1; %resume when all flags are found
%             if isfile([tempfolder 'outputVid1.mat']);
%                 proceed = 0;
%             end;
%         end;
% 
%     elseif nthreads == 2;
%         %Create frame list for each sub-video (parallel processing)
%         frameListP1 = 1 : (maxFrameCount./2);
%         frameListP2 = frameListP1(end) + 1 : maxFrameCount;
% 
%         %Export parameters for parallel processing
%         fileSettings = [tempfolder 'tempVideoSettings.mat'];
%         save(fileSettings, 'VidInfo', ...
%             'frameListP1', 'frameListP2', ...
%             'isMatlab', 'tempfolder', 'frameDataTemp', 'targetRate', 'tempRate');
%     
%         %Temporary video filenames
%         fileTemp1 = [tempfolder 'tempVid1'];
%         fileTemp2 = [tempfolder 'tempVid2'];
% 
%         %Trigger the process
%         if ispc == 1;
%             command1 = [rootfolder 'bin\export4Kparts1_screen.exe'];
%             command2 = [rootfolder 'bin\export4Kparts2_screen.exe'];
%         elseif ismac == 1;
%     
%         end;
%         command = ['start /B ' command1 ...
%             ' & start /B ' command2]
%         [status, out] = system(command);
%         proceed = 1;
%         while proceed == 1; %resume when all flags are found
%             if isfile([tempfolder 'outputVid1.mat']) == 1 & ...
%                     isfile([tempfolder 'outputVid2.mat']) == 1;
%                 proceed = 0;
%             end;
%         end;
% 
%     elseif nthreads == 3;
%         %Create frame list for each sub-video (parallel processing)
%         frameListP1 = 1 : (maxFrameCount./3);
%         frameListP2 = frameListP1(end) + 1 : (2.*(maxFrameCount./3));
%         frameListP3 = frameListP2(end) + 1 : maxFrameCount;
% 
%         %Export parameters for parallel processing
%         fileSettings = [tempfolder 'tempVideoSettings.mat'];
%         save(fileSettings, 'VidInfo', ...
%             'frameListP1', 'frameListP2', 'frameListP3', ...
%             'isMatlab', 'tempfolder', 'frameDataTemp', 'targetRate', 'tempRate');
%     
%         %Temporary video filenames
%         fileTemp1 = [tempfolder 'tempVid1'];
%         fileTemp2 = [tempfolder 'tempVid2'];
%         fileTemp3 = [tempfolder 'tempVid3'];
% 
%         %Trigger the process
%         if ispc == 1;
%             command1 = [rootfolder 'bin\export4Kparts1_screen.exe'];
%             command2 = [rootfolder 'bin\export4Kparts2_screen.exe'];
%             command3 = [rootfolder 'bin\export4Kparts3_screen.exe'];
%         elseif ismac == 1;
%     
%         end;
%         command = ['start /B ' command1 ...
%             ' & start /B ' command2 ...
%             ' & start /B ' command3]
%         [status, out] = system(command);
%         proceed = 1;
%         while proceed == 1; %resume when all flags are found
%             if isfile([tempfolder 'outputVid1.mat']) == 1 & ...
%                     isfile([tempfolder 'outputVid2.mat']) == 1 & ...
%                     isfile([tempfolder 'outputVid3.mat']) == 1;
%                 proceed = 0;
%             end;
%         end;
% 
%     elseif nthreads == 4;
%         %Create frame list for each sub-video (parallel processing)
%         frameListP1 = 1 : (maxFrameCount./4);
%         frameListP2 = frameListP1(end) + 1 : (2.*(maxFrameCount./4));
%         frameListP3 = frameListP2(end) + 1 : (3.*(maxFrameCount./4));
%         frameListP4 = frameListP3(end) + 1 : maxFrameCount;
% 
%         %Export parameters for parallel processing
%         fileSettings = [tempfolder 'tempVideoSettings.mat'];
%         save(fileSettings, 'VidInfo', ...
%             'frameListP1', 'frameListP2', 'frameListP3', 'frameListP4', ...
%             'isMatlab', 'tempfolder', 'frameDataTemp', 'targetRate', 'tempRate');
%     
%         %Temporary video filenames
%         fileTemp1 = [tempfolder 'tempVid1'];
%         fileTemp2 = [tempfolder 'tempVid2'];
%         fileTemp3 = [tempfolder 'tempVid3'];
%         fileTemp4 = [tempfolder 'tempVid4'];
% 
%         %Trigger the process
%         if ispc == 1;
%             command1 = [rootfolder 'bin\export4Kparts1_screen.exe'];
%             command2 = [rootfolder 'bin\export4Kparts2_screen.exe'];
%             command3 = [rootfolder 'bin\export4Kparts3_screen.exe'];
%             command4 = [rootfolder 'bin\export4Kparts4_screen.exe'];
%         elseif ismac == 1;
%     
%         end;
%         command = ['start /B ' command1 ...
%             ' & start /B ' command2 ...
%             ' & start /B ' command3 ...
%             ' & start /B ' command4]
%         [status, out] = system(command);
%         proceed = 1;
%         while proceed == 1; %resume when all flags are found
%             if isfile([tempfolder 'outputVid1.mat']) == 1 & ...
%                     isfile([tempfolder 'outputVid2.mat']) == 1 & ...
%                     isfile([tempfolder 'outputVid3.mat']) == 1 & ...
%                     isfile([tempfolder 'outputVid4.mat']) == 1;
%                 proceed = 0;
%             end;
%         end;
% 
%     elseif nthreads == 5;
        %Create frame list for each sub-video (parallel processing)
        frameListP1 = 1 : (maxFrameCount./6);
        frameListP2 = frameListP1(end) + 1 : (2.*(maxFrameCount./6));
        frameListP3 = frameListP2(end) + 1 : (3.*(maxFrameCount./6));
        frameListP4 = frameListP3(end) + 1 : (4.*(maxFrameCount./6));
        frameListP5 = frameListP4(end) + 1 : (5.*(maxFrameCount./6));
        frameListP6 = frameListP5(end) + 1 : maxFrameCount; 

        %Export parameters for parallel processing
        fileSettings = [tempfolder 'tempVideoSettings.mat'];
        save(fileSettings, 'VidInfo', ...
            'frameListP1', 'frameListP2', 'frameListP3', 'frameListP4', 'frameListP5', 'frameListP6', ...
            'isMatlab', 'tempfolder', 'frameDataTemp', 'targetRate', 'tempRate');

        %Temporary video filenames
        fileTemp1 = [tempfolder 'tempVid1'];
        fileTemp2 = [tempfolder 'tempVid2'];
        fileTemp3 = [tempfolder 'tempVid3'];
        fileTemp4 = [tempfolder 'tempVid4'];
        fileTemp5 = [tempfolder 'tempVid5'];
        fileTemp6 = [tempfolder 'tempVid6'];
        
        if VidInfo.FishEye.multithreadOption == 1;
            %Multithread
            %Trigger the process
            if ispc == 1;
                command1 = [rootfolder 'bin\export4Kparts1_screen.exe'];
                command2 = [rootfolder 'bin\export4Kparts2_screen.exe'];
                command3 = [rootfolder 'bin\export4Kparts3_screen.exe'];
                command4 = [rootfolder 'bin\export4Kparts4_screen.exe'];
                command5 = [rootfolder 'bin\export4Kparts5_screen.exe'];
                command6 = [rootfolder 'bin\export4Kparts6_screen.exe'];

                command = ['start /B ' command1 ...
                    ' & start /B ' command2 ...
                    ' & start /B ' command3 ...
                    ' & start /B ' command4 ...
                    ' & start /B ' command5 ...
                    ' & start /B ' command6];
                [status, out] = system(command);

            elseif ismac == 1;
                command1 = [rootfolder 'bin/export4Kparts1_screen.app'];
                command2 = [rootfolder 'bin/export4Kparts1b_screen.app'];
                command3 = [rootfolder 'bin/export4Kparts3_screen.app'];
                command4 = [rootfolder 'bin/export4Kparts4_screen.app'];
                command5 = [rootfolder 'bin/export4Kparts5_screen.app'];
                command6 = [rootfolder 'bin/export4Kparts6_screen.app'];
                command = ['open -W -a "' command1 ...
                    '" & open -W -a "' command2 ...
                    '" & open -W -a "' command3 ...
                    '" & open -W -a "' command4 ...
                    '" & open -W -a "' command5 ...
                    '" & open -W -a "' command6 '"'];
                [status, out] = system(command);
            end;

            proceed = 1;
            while proceed == 1; %resume when all flags are found
                if isfile([tempfolder 'outputVid1.mat']) == 1 & ...
                        isfile([tempfolder 'outputVid2.mat']) == 1 & ...
                        isfile([tempfolder 'outputVid3.mat']) == 1 & ...
                        isfile([tempfolder 'outputVid4.mat']) == 1 & ...
                        isfile([tempfolder 'outputVid5.mat']) == 1 & ...
                        isfile([tempfolder 'outputVid6.mat']) == 1;
                    try;
                        load([tempfolder 'outputVid1.mat']);
                        load([tempfolder 'outputVid2.mat']);
                        load([tempfolder 'outputVid3.mat']);
                        load([tempfolder 'outputVid4.mat']);
                        load([tempfolder 'outputVid5.mat']);
                        load([tempfolder 'outputVid6.mat']);

                        if finishVid1 == 1 & finishVid2 == 1 & finishVid3 == 1 & finishVid4 == 1 & finishVid5 == 1 & finishVid6 == 1;
                            proceed = 0;
                        else;
                            frameCount = iterVid1 + iterVid2 + iterVid3 + iterVid4 + iterVid5 + iterVid6;
                            set(handles.txtProgress_screen, 'String', ['Processing images ...   ' num2str(frameCount) '  /  ' num2str(maxFrameCount)], 'Visible', 'on');
                            drawnow;
                        end;
                    end;
                end;
            end;

        else;
            %Sequence single thread
            outputTXT = handles.txtProgress_screen;
            export4Kparts1single_screen;
            export4Kparts2single_screen;
            export4Kparts3single_screen;
            export4Kparts4single_screen;
            export4Kparts5single_screen;
            export4Kparts6single_screen;
        end;
    % end;

    %get output filename
    fileEC = handles.VidInfoScreen.name;
    [videoinputfolder, name, ext] = fileparts(fileEC);
    fileECNew = [name ext];
    videooutputfolder = videoinputfolder;
    
    lidot = strfind(fileECNew, '.');
    lidot = lidot(end);
    if ismac == 1;
        fileOut = [fileECNew(1:lidot-1) '_conv.MP4'];
    elseif ispc == 1;
        fileOut = [fileECNew(1:lidot-1) '_conv.MP4'];
    end;
    
    %if output exist delete it
    fileoutExist = 0;
    listdir = dir(videooutputfolder);
    for filelist = 1:length(listdir);
        fileCheck = listdir(filelist);
        NameEC = fileCheck.name;
        if strcmpi(NameEC, fileOut) == 1;
            fileoutExist = 1;
        end;
    end;
    if ismac == 1;
        if fileoutExist == 1;
            command = ['rm "' videooutputfolder '/' fileOut '"'];
            [status, cmdout] = system(command);
        end;
    elseif ispc == 1;
        if fileoutExist == 1;
            command = ['del /Q "' videooutputfolder '\' fileOut '"'];
            [status, cmdout] = system(command);
        end;
    end;
    videooutputfolder = videoinputfolder;
    
    %check onedrive or dropbox issues
    liOneDrive = strfind(lower(path), 'onedrive');
    liDropbox = strfind(lower(path), 'dropbox');
    if ismac == 1;
        testFileInput = ['"' MDIR '/SP2VideoManager/frame720.jpg"'];
    elseif ispc == 1;
        testFileInput = ['"' MDIR '\SP2VideoManager\frame720.jpg"'];
    end;
    if ismac == 1;
        testFileOutput = ['"' videooutputfolder '/frame720.jpg"'];
    elseif ispc == 1;
        testFileOutput = ['"' videooutputfolder '\frame720.jpg"'];
    end;
    
    if isempty(liOneDrive) == 0;
        %test OneDrive
        if ispc == 1;
            command = ['del /f "' testFileOutput '"'];
        else;
            command = ['rm "' testFileInput '" "' testFileOutput '"'];
        end;
        [status, cmdout] = system(command);
    
        if ispc == 1;
            command = ['copy "' testFileInput '" "' testFileOutput '"'];
        else;
            command = ['cp "' testFileInput '" "' testFileOutput '"'];
        end;
        [statusOnline, cmdout] = system(command);
    
        if statusOnline == 0;
            if ispc == 1;
                command = ['del /f "' testFileOutput '"'];
            else;
                command = ['rm "' testFileInput '" "' testFileOutput '"'];
            end;
            [status, cmdout] = system(command);
        end;
    else;
        statusOnline = 0;
    end;
    
    if isempty(liDropbox) == 0;
        %test DropBox
        if ispc == 1;
            command = ['del /f "' testFileOutput '"'];
        else;
            command = ['rm "' testFileInput '" "' testFileOutput '"'];
        end;
        [status, cmdout] = system(command);
    
        if ispc == 1;
            command = ['copy "' testFileInput '" "' testFileOutput '"'];
        else;
            command = ['cp "' testFileInput '" "' testFileOutput '"'];
        end;
        [statusOnline, cmdout] = system(command);
    
        if statusOnline == 0;
            if ispc == 1;
                command = ['del /f "' testFileOutput '"'];
            else;
                command = ['rm "' testFileInput '" "' testFileOutput '"'];
            end;
            [status, cmdout] = system(command);
        end;
    else;
        statusOnline = 0;
    end;

    if ismac == 1;
        partOut = [videooutputfolder '/' fileOut];
    elseif ispc == 1;
        partOut = [videooutputfolder '\' fileOut];
    end;

    txtEC = ['Exporting video ...  ' partOut];
    set(handles.txtProgress_screen, 'String', txtEC, 'Visible', 'on', 'tooltipstring', txtEC);
    posExtent = get(handles.txtProgress_screen, 'Extent');
    posReal = get(handles.txtProgress_screen, 'Position');
    if posExtent(3) >= posReal(3);
        fileStr = [txtEC(1:50) ' ... ' txtEC(end-50:end)];
        set(handles.txtProgress_screen, 'String', fileStr);
    end;
    drawnow;


    %Convert to ts
%     if nthreads == 1;
%         vidFile1 = [MDIR '\SP2VideoManager\Temp\tempVid1'];
%         
%         command1 = [ffmpegfolder ' -i "' vidFile1 '.mp4"' ' -c copy "' vidFile1 '.ts"'];
%         command = command1;
%         [status, out] = system(command);
%     
%         %concatenate the files together
%         command = [ffmpegfolder ' -i ' '"concat:"' vidFile1 '.ts"' ...
%             '" -c copy "' partOut '"'];
%         [status, out] = system(command);
% 
%     elseif nthreads == 2;
%         vidFile1 = [MDIR '\SP2VideoManager\Temp\tempVid1'];
%         vidFile2 = [MDIR '\SP2VideoManager\Temp\tempVid2'];
%         
%         command1 = [ffmpegfolder ' -i "' vidFile1 '.mp4"' ' -c copy "' vidFile1 '.ts"'];
%         command2 = [ffmpegfolder ' -i "' vidFile2 '.mp4"' ' -c copy "' vidFile2 '.ts"'];
%         command = [command1 ' & ' command2];
%         [status, out] = system(command);
%     
%         %concatenate the files together
%         command = [ffmpegfolder ' -i ' '"concat:"' vidFile1 '.ts"' '|"' ...
%             vidFile2 '.ts"' ...
%             '" -c copy "' partOut '"'];
%         [status, out] = system(command);
% 
%     elseif nthreads == 3;
%         vidFile1 = [MDIR '\SP2VideoManager\Temp\tempVid1'];
%         vidFile2 = [MDIR '\SP2VideoManager\Temp\tempVid2'];
%         vidFile3 = [MDIR '\SP2VideoManager\Temp\tempVid3'];
%         
%         command1 = [ffmpegfolder ' -i "' vidFile1 '.mp4"' ' -c copy "' vidFile1 '.ts"'];
%         command2 = [ffmpegfolder ' -i "' vidFile2 '.mp4"' ' -c copy "' vidFile2 '.ts"'];
%         command3 = [ffmpegfolder ' -i "' vidFile3 '.mp4"' ' -c copy "' vidFile3 '.ts"'];
%         command = [command1 ' & ' command2 ' & ' command3];
%         [status, out] = system(command);
%     
%         %concatenate the files together
%         command = [ffmpegfolder ' -i ' '"concat:"' vidFile1 '.ts"' '|"' ...
%             vidFile2 '.ts"' '|"' ...
%             vidFile3 '.ts"' ...
%             '" -c copy "' partOut '"'];
%         [status, out] = system(command);
% 
%     elseif nthreads == 4;
%         vidFile1 = [MDIR '\SP2VideoManager\Temp\tempVid1'];
%         vidFile2 = [MDIR '\SP2VideoManager\Temp\tempVid2'];
%         vidFile3 = [MDIR '\SP2VideoManager\Temp\tempVid3'];
%         vidFile4 = [MDIR '\SP2VideoManager\Temp\tempVid4'];
%         
%         command1 = [ffmpegfolder ' -i "' vidFile1 '.mp4"' ' -c copy "' vidFile1 '.ts"'];
%         command2 = [ffmpegfolder ' -i "' vidFile2 '.mp4"' ' -c copy "' vidFile2 '.ts"'];
%         command3 = [ffmpegfolder ' -i "' vidFile3 '.mp4"' ' -c copy "' vidFile3 '.ts"'];
%         command4 = [ffmpegfolder ' -i "' vidFile4 '.mp4"' ' -c copy "' vidFile4 '.ts"'];
%         command = [command1 ' & ' command2 ' & ' command3 ' & ' command4];
%         [status, out] = system(command);
%     
%         %concatenate the files together
%         command = [ffmpegfolder ' -i ' '"concat:"' vidFile1 '.ts"' '|"' ...
%             vidFile2 '.ts"' '|"' ...
%             vidFile3 '.ts"' '|"' ...
%             vidFile4 '.ts"' ...
%             '" -c copy "' partOut '"'];
%         [status, out] = system(command);
% 
%     elseif nthreads == 5;

        if ismac == 1;
            vidFile1 = [MDIR '/SP2VideoManager/Temp/tempVid1'];
            vidFile2 = [MDIR '/SP2VideoManager/Temp/tempVid2'];
            vidFile3 = [MDIR '/SP2VideoManager/Temp/tempVid3'];
            vidFile4 = [MDIR '/SP2VideoManager/Temp/tempVid4'];
            vidFile5 = [MDIR '/SP2VideoManager/Temp/tempVid5'];
            vidFile6 = [MDIR '/SP2VideoManager/Temp/tempVid6'];
        elseif ispc == 1;
            vidFile1 = [MDIR '\SP2VideoManager\Temp\tempVid1'];
            vidFile2 = [MDIR '\SP2VideoManager\Temp\tempVid2'];
            vidFile3 = [MDIR '\SP2VideoManager\Temp\tempVid3'];
            vidFile4 = [MDIR '\SP2VideoManager\Temp\tempVid4'];
            vidFile5 = [MDIR '\SP2VideoManager\Temp\tempVid5'];
            vidFile6 = [MDIR '\SP2VideoManager\Temp\tempVid6'];
        end;
    
        command1 = ['"' ffmpegfolder '" -i "' vidFile1 '.mp4"' ' -c copy "' vidFile1 '.ts"'];
        command2 = ['"' ffmpegfolder '" -i "' vidFile2 '.mp4"' ' -c copy "' vidFile2 '.ts"'];
        command3 = ['"' ffmpegfolder '" -i "' vidFile3 '.mp4"' ' -c copy "' vidFile3 '.ts"'];
        command4 = ['"' ffmpegfolder '" -i "' vidFile4 '.mp4"' ' -c copy "' vidFile4 '.ts"'];
        command5 = ['"' ffmpegfolder '" -i "' vidFile5 '.mp4"' ' -c copy "' vidFile5 '.ts"'];
        command6 = ['"' ffmpegfolder '" -i "' vidFile6 '.mp4"' ' -c copy "' vidFile6 '.ts"'];
        command = [command1 ' & ' command2 ' & ' command3 ' & ' command4 ' & ' command5 ' & ' command6];
        [status, out] = system(command);

        %concatenate the files together
        command = ['"' ffmpegfolder '" -i ' '"concat:"' vidFile1 '.ts"' '|"' ...
            vidFile2 '.ts"' '|"' ...
            vidFile3 '.ts"' '|"' ...
            vidFile4 '.ts"' '|"' ...
            vidFile5 '.ts"' '|"' ...
            vidFile6 '.ts"' ...
            '" -c copy "' partOut '"'];
        [status, out] = system(command);

%     end;

    %empty the Temp folder
    if ismac == 1;
        command = ['rm "' tempfolder '"*'];
        [status, cmdout] = system(command);
    elseif ispc == 1;
        command = ['del /Q "' tempfolder '"*'];
        [status, cmdout] = system(command);
    end;
 
    
else;
    %----------------process with FFMPEG-----------------

    if ispc == 1;
        MDIR = getenv('USERPROFILE');
    elseif ismac == 1;
        MDIR = '/Applications';
    end;

    if VidInfo.Rate == 50 | VidInfo.Rate == 25;
        %all good
    else;
        if ispc == 1;
            warningwindow = warndlg(['This video has a native framerate of ' num2str(VidInfo.Rate) ' and might not be compatible with SP2'], 'Warning');
            jFrame = get(handle(warningwindow), 'javaframe');
            jicon = javax.swing.ImageIcon([MDIR '\SP2VideoManager\SpartaManager_IconSoftware.png']);
            jFrame.setFigureIcon(jicon);
            clc;
            waitfor(warningwindow);
        elseif ismac == 1;
            warningwindow = warndlg(['This video has a native framerate of ' num2str(VidInfo.Rate) ' and might not be compatible with SP2'], 'Warning');
            waitfor(warningwindow);
        end;
    end;
    
    if ismac == 1
        ffmpegfolder = '/opt/homebrew/bin/ffmpeg';
    elseif ispc == 1;
        ffmpegfolder = [MDIR '\SP2VideoManager\ffmpeg\bin\ffmpeg'];
    end;
        
    fileEC = handles.VidInfoScreen.name;    
    [videoinputfolder, name, ext] = fileparts(fileEC);
    fileECNew = [name ext];
    videooutputfolder = videoinputfolder;
    
    lidot = strfind(fileECNew, '.');
    lidot = lidot(end);
    if ismac == 1;
        fileOut = [fileECNew(1:lidot-1) '_conv.MP4'];
    elseif ispc == 1;
        fileOut = [fileECNew(1:lidot-1) '_conv.MP4'];
    end;
    
    fileoutExist = 0;
    listdir = dir(videooutputfolder);
    for filelist = 1:length(listdir);
        fileCheck = listdir(filelist);
        NameEC = fileCheck.name;
        if strcmpi(NameEC, fileOut) == 1;
            fileoutExist = 1;
        end;
    end;
    if ismac == 1;
        if fileoutExist == 1;
            command = ['rm "' videooutputfolder '/' fileOut '"'];
            [status, cmdout] = system(command);
        end;
    elseif ispc == 1;
        if fileoutExist == 1;
            command = ['del /Q "' videooutputfolder '\' fileOut '"'];
            [status, cmdout] = system(command);
        end;
    end;
    
    liOneDrive = strfind(lower(path), 'onedrive');
    liDropbox = strfind(lower(path), 'dropbox');
    if ismac == 1;
        if specialChar_MDIR == 1;
            testFileInput = ['"' MDIR '/SP2VideoManager/frame720.jpg"'];
        else;
            testFileInput = [MDIR '/SP2VideoManager/frame720.jpg'];
        end;
    elseif ispc == 1;
        if specialChar_MDIR == 1;
            testFileInput = ['"' MDIR '\SP2VideoManager\frame720.jpg"'];
        else;
            testFileInput = [MDIR '\SP2VideoManager\frame720.jpg'];
        end;
    end;
    if ismac == 1;
        if specialChar_outputfolder == 1;
            testFileOutput = ['"' videooutputfolder '/frame720.jpg"'];
        else;
            testFileOutput = [videooutputfolder '/frame720.jpg'];
        end;
    elseif ispc == 1;
        if specialChar_outputfolder == 1;
            testFileOutput = ['"' videooutputfolder '\frame720.jpg"'];
        else;
            testFileOutput = [videooutputfolder '\frame720.jpg'];
        end;
    end;
    
    if isempty(liOneDrive) == 0;
        %test OneDrive
        if ispc == 1;
            command = ['del /f "' testFileOutput '"'];
        else;
            command = ['rm "' testFileInput '" "' testFileOutput '"'];
        end;
        [status, cmdout] = system(command);
    
        if ispc == 1;
            command = ['copy "' testFileInput '" "' testFileOutput '"'];
        else;
            command = ['cp "' testFileInput '" "' testFileOutput '"'];
        end;
        [statusOnline, cmdout] = system(command);
    
        if statusOnline == 0;
            if ispc == 1;
                command = ['del /f "' testFileOutput '"'];
            else;
                command = ['rm "' testFileInput '" "' testFileOutput '"'];
            end;
            [status, cmdout] = system(command);
        end;
    else;
        statusOnline = 0;
    end;
    
    if isempty(liDropbox) == 0;
        %test DropBox
        if ispc == 1;
            command = ['del /f "' testFileOutput '"'];
        else;
            command = ['rm "' testFileInput '" "' testFileOutput '"'];
        end;
        [status, cmdout] = system(command);
    
        if ispc == 1;
            command = ['copy "' testFileInput '" "' testFileOutput '"'];
        else;
            command = ['cp "' testFileInput '" "' testFileOutput '"'];
        end;
        [statusOnline, cmdout] = system(command);
    
        if statusOnline == 0;
            if ispc == 1;
                command = ['del /f "' testFileOutput '"'];
            else;
                command = ['rm "' testFileInput '" "' testFileOutput '"'];
            end;
            [status, cmdout] = system(command);
        end;
    else;
        statusOnline = 0;
    end;
    
    
    if ismac == 1;
        tempfolder = [MDIR '/SP2VideoManager/Temp/'];
        
        if isdir([MDIR '/SP2VideoManager/Temp']) == 0;
            command = ['mkdir ' tempfolder];
            [status, cmdout] = system(command);
        end;
        command = ['rm "' tempfolder '"' '*'];
        [status, cmdout] = system(command);
    
        tempfolder = [MDIR '/SP2VideoManager/Temp/'];
    elseif ispc == 1;
        tempfolder = [MDIR '\SP2VideoManager\Temp\'];
        if isdir([MDIR '\SP2VideoManager\Temp']) == 0;
            command = ['mkdir "' tempfolder '"'];
            [status, cmdout] = system(command);
        end;
        
        command = ['del /Q "' tempfolder  '"' '*'];
        [status, cmdout] = system(command);
    
        tempfolder = [MDIR '\SP2VideoManager\Temp\'];
    end;
    
    
    if statusOnline == 0;
        set(handles.txtProgress_screen, 'String', 'Preparing video ...', 'Visible', 'on');
        drawnow;
    
        if ismac == 1;
        
            partIn = [videoinputfolder '/' fileECNew];
            partOut = [videooutputfolder '/' fileOut];
            
            command = ['"' ffmpegfolder '" -i "' partIn '"' ...
            ' -map 0:v:0 -c copy -f null -'];
            [status, cmdout] = system(command);

            lifps = strfind(cmdout, 'fps');
            cmdoutfps = cmdout(lifps(1)-7:lifps(1)-2);
            index = strfind(cmdoutfps, '.');
            cmdoutfps = cmdoutfps(index-2:index+2);
            % framerate = roundn(str2num(cmdoutfps),-2);
            framerate = VidInfo.Rate;
    
            txtEC = ['Exporting video ...  ' partOut];
            set(handles.txtProgress_screen, 'String', txtEC, 'Visible', 'on', 'tooltipstring', txtEC);
            posExtent = get(handles.txtProgress_screen, 'Extent');
            posReal = get(handles.txtProgress_screen, 'Position');
            if posExtent(3) >= posReal(3);
                fileStr = [txtEC(1:50) ' ... ' txtEC(end-50:end)];
                set(handles.txtProgress_screen, 'String', fileStr);
            end;
            drawnow;
            
            if isempty(handles.trimInVal_screen) == 1 & isempty(handles.trimOutVal_screen) == 1;
                if handles.CurrenCompressionScreen == 0;
                    %remuxing
                    command = ['"' ffmpegfolder '" -i "' partIn '" -c copy "' partOut '"'];
                else;
                    command = ['"' ffmpegfolder '" -i "' partIn ...
                        '" -c:v libx264 -preset superfast -g 24 -keyint_min 24 -b:v ' ...
                        num2str(handles.CurrenCompressionScreen) 'M -pix_fmt yuv420p -threads 0 "' ...
                        partOut '"'];
                end;
                        
            elseif isempty(handles.trimInVal_screen) == 1 & isempty(handles.trimOutVal_screen) == 0;
                %Trim at the end
                trimOutTime = (handles.trimOutVal_screen./VidInfo.Rate) - (1/VidInfo.Rate);
                
                if handles.CurrenCompressionScreen == 0;
                    %remuxing
                    command = ['"' ffmpegfolder '" -i "' partIn '"' ...
                        ' -c copy -t ' num2str(trimOutTime) ' "' partOut '"'];
                else;
                    command = ['"' ffmpegfolder "' -i "'  partIn ...
                        '" -c:v libx264 -preset superfast -g 24 -keyint_min 24 -b:v ' ...
                        num2str(handles.CurrenCompressionScreen) 'M -pix_fmt yuv420p -threads 0 ' ...
                        '-t ' num2str(trimOutTime) ' "' partOut '"'];
                end;

            elseif isempty(handles.trimInVal_screen) == 0 & isempty(handles.trimOutVal_screen) == 1;
                %trim at the beginning
                trimInTime = (handles.trimInVal_screen./VidInfo.Rate) - (1/VidInfo.Rate);
                
                if handles.CurrenCompressionScreen == 0;
                    %remuxing
                    command = ['"' ffmpegfolder '" -ss ' num2str(trimInTime) ...
                        ' -i "' partIn '" -c copy "' partOut '"'];
                else;
                    command = ['"' ffmpegfolder '" -ss ' num2str(trimInTime) ' -i "' partIn ...
                        '" -c:v libx264 -preset superfast -g 24 -keyint_min 24 -b:v ' ...
                        num2str(handles.CurrenCompressionScreen) 'M -pix_fmt yuv420p -threads 0 "' ...
                        partOut '"'];
                end;
            else;
                %trim both beginning and end
                trimInTime = (handles.trimInVal_screen./VidInfo.Rate) - (1/VidInfo.Rate);
                trimOutTime = ((handles.trimOutVal_screen./VidInfo.Rate) - (1/VidInfo.Rate)) - trimInTime;

                if handles.CurrenCompressionScreen == 0;
                    %remuxing
                    command = ['"' ffmpegfolder '" -ss ' num2str(trimInTime) ...
                        ' -i "' partIn '" -c copy -t ' num2str(trimOutTime) ' "' partOut '"'];
                else;
                    command = ['"' ffmpegfolder '" -ss ' num2str(trimInTime) ' -i "' partIn '"' ...
                        ' -c:v libx264 -preset superfast -g 24 -keyint_min 24 -b:v ' ...
                        num2str(handles.CurrenCompressionScreen) 'M -pix_fmt yuv420p -threads 0 ' ...
                        '-t ' num2str(trimOutTime) ' "' partOut '"'];
                end;
            end;
    
        elseif ispc == 1;
            partIn = [videoinputfolder '\' fileECNew];
            partOut = [videooutputfolder '\' fileOut];
            
            command = ['"' ffmpegfolder '" -i "' partIn '"' ...
            ' -map 0:v:0 -c copy -f null -'];
            [status, cmdout] = system(command);
    
            lifps = strfind(cmdout, 'fps');
            cmdoutfps = cmdout(lifps(1)-7:lifps(1)-2);
            index = strfind(cmdoutfps, '.');
            cmdoutfps = cmdoutfps(index-2:index+2);
            % framerate = roundn(str2num(cmdoutfps),-2);
            framerate = roundn(VidInfo.Rate,-2);
            
            txtEC = ['Exporting video ...  ' partOut];
            set(handles.txtProgress_screen, 'String', txtEC, 'Visible', 'on', 'tooltipstring', txtEC);
            posExtent = get(handles.txtProgress_screen, 'Extent');
            posReal = get(handles.txtProgress_screen, 'Position');
            if posExtent(3) >= posReal(3);
                fileStr = [txtEC(1:50) ' ... ' txtEC(end-50:end)];
                set(handles.txtProgress_screen, 'String', fileStr);
            end;
            drawnow;

            if isempty(handles.trimInVal_screen) == 1 & isempty(handles.trimOutVal_screen) == 1;
                %no triming
                if handles.CurrenCompressionScreen == 0;
                    %remuxing
                    command = ['"' ffmpegfolder '" -i "' partIn '" -c copy "' partOut '"'];
                else;
                    command = ['"' ffmpegfolder '" -i "' partIn ...
                        '" -c:v libx264 -preset superfast -g 24 -keyint_min 24 -b:v ' ...
                        num2str(handles.CurrenCompressionScreen) 'M -pix_fmt yuv420p -threads 0 "' ...
                        partOut '"'];
                end;

            elseif isempty(handles.trimInVal_screen) == 1 & isempty(handles.trimOutVal_screen) == 0;
                %Trim at the end
                trimOutTime = (handles.trimOutVal_screen./VidInfo.Rate) - (1/VidInfo.Rate);
                
                if handles.CurrenCompressionScreen == 0;
                    %remuxing
                    command = ['"' ffmpegfolder '" -i "' partIn ...
                        '" -c copy -t ' num2str(trimOutTime) ' "' partOut '"'];
                else;
                    command = ['"' ffmpegfolder '" -i "'  partIn ...
                        '" -c:v libx264 -preset superfast -g 24 -keyint_min 24 -b:v ' ...
                        num2str(handles.CurrenCompressionScreen) 'M -pix_fmt yuv420p -threads 0 ' ...
                        '-t ' num2str(trimOutTime) ' "' partOut '"'];
                end;
                
            elseif isempty(handles.trimInVal_screen) == 0 & isempty(handles.trimOutVal_screen) == 1;
                %trim at the beginning
                trimInTime = (handles.trimInVal_screen./VidInfo.Rate) - (1/VidInfo.Rate);
                
                if handles.CurrenCompressionScreen == 0;
                    %remuxing
                    command = ['"' ffmpegfolder '" -ss ' num2str(trimInTime) ...
                        ' -i "' partIn '" -c copy "' partOut '"'];
                else;
                    command = ['"' ffmpegfolder '" -ss ' num2str(trimInTime) ' -i "' partIn ...
                        '" -c:v libx264 -preset superfast -g 24 -keyint_min 24 -b:v ' ...
                        num2str(handles.CurrenCompressionScreen) 'M -pix_fmt yuv420p -threads 0 "' ...
                        partOut '"'];
                end;
            else;
                %trim both beginning and end
                trimInTime = (handles.trimInVal_screen./VidInfo.Rate) - (1/VidInfo.Rate);
                trimOutTime = ((handles.trimOutVal_screen./VidInfo.Rate) - (1/VidInfo.Rate)) - trimInTime;

                if handles.CurrenCompressionScreen == 0;
                    %remuxing
                    command = ['"' ffmpegfolder '" -ss ' num2str(trimInTime) ...
                        ' -i "' partIn '" -c copy -t ' num2str(trimOutTime) ' "' partOut '"'];
                else;
                    command = ['"' ffmpegfolder '" -ss ' num2str(trimInTime) ' -i "' partIn ...
                        '" -c:v libx264 -preset superfast -g 24 -keyint_min 24 -b:v ' ...
                        num2str(handles.CurrenCompressionScreen) 'M -pix_fmt yuv420p -threads 0 ' ...
                        '-t ' num2str(trimOutTime) ' "' partOut '"'];
                end;
            end;
        end;
        [status, cmdout] = system(command);
        guidata(handles.hf_w1_welcome, handles);

    else;
        if ispc == 1;
            errorwindow = errordlg('Permission denied, cannot access this OneDrive/Dropbox folder. Please move your file into a local folder', 'Error');
            jFrame = get(handle(errorwindow), 'javaframe');
            jicon = javax.swing.ImageIcon([MDIR '\SP2VideoManager\SpartaManager_IconSoftware.png']);
            jFrame.setFigureIcon(jicon);
            clc;
            return;
        elseif ismac == 1;
            errordlg('Permission denied, cannot access this OneDrive/Dropbox folder. Please move your file into a local folder', 'Error');
            return;
        end;
    end;
end;

set(handles.txtProgress_screen, 'String', '', 'tooltipstring', '', 'Visible', 'off');
drawnow;

t=toc
