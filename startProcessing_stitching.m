function [] = startProcessing_stitching(varargin);



handles = guidata(gcf);

if isempty(handles.pathLeftfile_stitching) == 1 | isempty(handles.pathRightfile_stitching) == 1;
    return;
end;

if ispc == 1;
    MDIR = getenv('USERPROFILE');
elseif ismac == 1;
    MDIR = '/Applications';
end;
VidInfo = handles.VidInfo;
savedOutputStichingNormal = handles.savedOutputStichingNormal;
savedOutputStichingTop = handles.savedOutputStichingTop;

if isempty(VidInfo) == 1 | isempty(savedOutputStichingNormal) == 1;
    %---Estimate stitching first

    %---Load current frames
    imgLeft = read(handles.VidInfoLeftStitching.VidObj, handles.VidInfoLeftStitching.FrameEC);
    imgRight = read(handles.VidInfoRightStitching.VidObj, handles.VidInfoRightStitching.FrameEC);
    %---

    
    %---Image matching (auto: sift / manual)
    if isempty(ptStitching_valid) == 1; %Auto
        %---Get features and pair images
        grayL = im2gray(imgLeft);
        grayR = im2gray(imgRight);
    
        pointsL = detectSIFTFeatures(grayL, 'NumLayersInOctave', 3);
        pointsR = detectSIFTFeatures(grayR, 'NumLayersInOctave', 3);
    
        pointsL = selectStrongest(pointsL, 8000); %only keep 50 strongest features
        pointsR = selectStrongest(pointsR, 8000); %only keep 50 strongest features
    
        [featL, validPtsL] = extractFeatures(grayL, pointsL); %get descriptors
        [featR, validPtsR] = extractFeatures(grayR, pointsR); %get descriptors
    
        indexPairs = matchFeatures(featL, featR, 'MaxRatio', 0.7, 'Unique', true); %create pairs
        matchedPtsL = validPtsL(indexPairs(:,1));
        matchedPtsR = validPtsR(indexPairs(:,2));
    
        ptsL_stitching = matchedPtsL.Location;
        ptsR_stitching = matchedPtsR.Location;
    
    %     figure;imshow(imgRight);
    %     hold on;
    %     plot(ptsR(:,1), ptsR(:,2), 'r+');
    
    else; %manual
        ptsL_stitching = ptStitching_valid(:,1:2);
        ptsR_stitching = ptStitching_valid(:,3:4);
    
    %     figure;imshow(imgRight);
    %     hold on;
    %     plot(ptsR(:,1), ptsR(:,2), 'r+');
    
    end;
    %---


    %---Calculate 2 stitching options
    [savedOutputStichingNormal, savedOutputStichingTop] = estimateStitching_stitching(imgLeft, imgRight, ...
        ptsL_stitching, ptsR_stitching, ptDLT_validLeft, ptDLT_validRight);
    
    handles.savedOutputStichingNormal = savedOutputStichingNormal;
    handles.savedOutputStichingTop = savedOutputStichingTop;
    guidata(handles.hf_w1_welcome, handles);
    %---
    

    %---Create VidInfo
    if isempty(VidInfo) == 1;
        VidInfo.Rate = VidInfoLeft.Rate;
        VidInfo.isexportRateDefault = 1;
        VidInfo.FishEye = [];
        VidInfo.multithreadOption = 1;
        VidInfo.keepValid = 'Full';
        VidInfo.VidObjLeft = VidInfoLeft.VidObj;
        VidInfo.VidObjRight = VidInfoRight.VidObj;
        VidInfo.DurationLeft = VidInfoLeft.Duration;
        VidInfo.DurationRight = VidInfoRight.Duration;
        VidInfo.FrameECLeft = VidInfoLeft.FrameEC;
        VidInfo.FrameECRight = VidInfoRight.FrameEC;
        VidInfo.isexportRateDefault = 1;
        VidInfo.ImageEnhance.Contract = 0;
        VidInfo.ImageEnhance.Brightness = 0;
        VidInfo.exportRate = VidInfo.Rate;
        VidInfo.isexportRateDefault = 1;
        VidInfo.viewAngle = 'NormalView';
    end;
else;
    %---Stitching was estimate when previewing
    savedOutputStichingNormal = handles.savedOutputStichingNormal;
    savedOutputStichingTop = handles.savedOutputStichingTop;
    VidInfo = handles.VidInfo;
end;


trimInLeft = handles.trimInValLeft_stitching;
trimInRight = handles.trimOutValLeft_stitching;
trimOutLeft = handles.trimInValRight_stitching;
trimOutRight = handles.trimOutValRight_stitching;

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

%force video output to 4K
VidInfo.Height = 2160;
VidInfo.Width = 3840;
frameGrab = zeros(VidInfo.Height,VidInfo.Width,3);
frameUndist = zeros(VidInfo.Height,VidInfo.Width,3);
frameProcessed = zeros(VidInfo.Height,VidInfo.Width,3);
frame = zeros(VidInfo.Height,VidInfo.Width,3);

% if isMatlab == 1;
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
    checkSpecialChar;
    
    %FFMPEG folder
    if ismac == 1
        ffmpegfolder = '/opt/homebrew/bin/ffmpeg';
    elseif ispc == 1;
        ffmpegfolder = [MDIR '\SP2VideoManager\ffmpeg\bin\ffmpeg'];
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

    %List of targetted frames for left camera
    if isempty(trimInLeft) == 1 & isempty(trimOutLeft) == 1;
        frameDataTempLeft = 0 : 1./VidInfo.Rate : VidInfo.DurationLeft;
        frameINILeft = 1;
        frameENDLeft = length(frameDataTempLeft);

    elseif isempty(trimInLeft) == 1 & isempty(trimOutLeft) == 0;
        %Trim at the end
        trimOutTime = (trimOutLeft./VidInfo.Rate) - (1/VidInfo.Rate); %use the actual rate as frame were determined on the original video
        frameDataTempLeft = 0 : 1./VidInfo.Rate : trimOutTime;

        frameINILeft = 1;
        frameENDLeft = trimOutLeft;

    elseif isempty(trimInLeft) == 0 & isempty(trimOutLeft) == 1;
        %trim at the beginning
        trimInTime = (trimInLeft./VidInfo.Rate) - (1/VidInfo.Rate);  %use the actual rate as frame were determined on the original video
        frameDataTempLeft = trimInTime : 1./VidInfo.Rate : VidInfo.DurationLeft;

        frameINILeft = trimInLeft;
        frameENDLeft = frameINILeft + length(frameDataTempLeft) - 1;

    else;
        %Trim at the beginning and end
        trimInTime = (trimInLeft./VidInfo.Rate) - (1/VidInfo.Rate);
        trimOutTime = (trimOutLeft./VidInfo.Rate) - (1/VidInfo.Rate);
        frameDataTempLeft = trimInTime : 1./VidInfo.Rate : trimOutTime;

        frameINILeft = trimInLeft;
        frameENDLeft = trimOutLeft;

    end;
    frameDataTempLeft = [[frameINILeft:frameENDLeft]' frameDataTempLeft' zeros(length(frameDataTempLeft),1)];

    %List of targetted frames for right camera
    if isempty(trimInRight) == 1 & isempty(trimOutRight) == 1;
        frameDataTempRight = 0 : 1./VidInfo.Rate : VidInfo.DurationRight;
        frameINIRight = 1;
        frameENDRight = length(frameDataTempRight);

    elseif isempty(trimInRight) == 1 & isempty(trimOutRight) == 0;
        %Trim at the end
        trimOutTime = (trimOutRight./VidInfo.Rate) - (1/VidInfo.Rate); %use the actual rate as frame were determined on the original video
        frameDataTempRight = 0 : 1./VidInfo.Rate : trimOutTime;

        frameINIRight = 1;
        frameENDRight = trimOutRight;

    elseif isempty(trimInRight) == 0 & isempty(trimOutRight) == 1;
        %trim at the beginning
        trimInTime = (trimInRight./VidInfo.Rate) - (1/VidInfo.Rate);  %use the actual rate as frame were determined on the original video
        frameDataTempRight = trimInTime : 1./VidInfo.Rate : VidInfo.DurationRight;

        frameINIRight = trimInRight;
        frameENDRight = frameINIRight + length(frameDataTempRight) - 1;

    else;
        %Trim at the beginning and end
        trimInTime = (trimInRight./VidInfo.Rate) - (1/VidInfo.Rate);
        trimOutTime = (trimOutRight./VidInfo.Rate) - (1/VidInfo.Rate);
        frameDataTempRight = trimInTime : 1./VidInfo.Rate : trimOutTime;

        frameINIRight = trimInRight;
        frameENDRight = trimOutRight;

    end;
    frameDataTempRight = [[frameINIRight:frameENDRight]' frameDataTempRight' zeros(length(frameDataTempRight),1)];

    if length(frameDataTempRight) > length(frameDataTempLeft);
        diffTime = length(frameDataTempRight) - length(frameDataTempLeft);
        frameDataTempRight = frameDataTempRight(1:end-diffTime, :);
    elseif length(frameDataTempRight) < length(frameDataTempLeft);
        diffTime = length(frameDataTempLeft) - length(frameDataTempRight);
        frameDataTempLeft = frameDataTempLeft(1:end-diffTime,:);
    end;


    %get the list of frames to use for the new video
    timeEC = frameDataTempLeft(1,2);
    for imEC = 1:length(frameDataTempLeft(:,1))-1;
        diffTime = abs(frameDataTempLeft(:,2)-timeEC);
        [minVal, minLoc] = min(diffTime);
        if frameDataTempLeft(minLoc,3) == 0;
            frameDataTempLeft(minLoc,3) = 1;
        end;
        timeEC = timeEC + (1./tempRate);
    end;

    timeEC = frameDataTempRight(1,2);
    for imEC = 1:length(frameDataTempRight(:,1))-1;
        diffTime = abs(frameDataTempRight(:,2)-timeEC);
        [minVal, minLoc] = min(diffTime);
        if frameDataTempRight(minLoc,3) == 0;
            frameDataTempRight(minLoc,3) = 1;
        end;
        timeEC = timeEC + (1./tempRate);
    end;



    %Main processing... parallel processing
    nthreads = 5;
    maxFrameCount = length(frameDataTempLeft(:,1))-2;

    %Create frame list for each sub-video (parallel processing)
    frameListP1 = 1 : (maxFrameCount./5);
    frameListP2 = frameListP1(end) + 1 : (2.*(maxFrameCount./5));
    frameListP3 = frameListP2(end) + 1 : (3.*(maxFrameCount./5));
    frameListP4 = frameListP3(end) + 1 : (4.*(maxFrameCount./5));
    frameListP5 = frameListP4(end) + 1 : maxFrameCount; 


    %Export parameters for parallel processing
    fileSettings = [tempfolder 'tempVideoSettings.mat'];
    save(fileSettings, 'VidInfo', ...
        'frameListP1', 'frameListP2', 'frameListP3', 'frameListP4', 'frameListP5', ...
        'isMatlab', 'tempfolder', 'frameDataTempLeft', 'frameDataTempRight', 'targetRate', 'tempRate', ...
        'savedOutputStichingNormal', 'savedOutputStichingTop');


    %Temporary video filenames
    fileTemp1 = [tempfolder 'tempVid1'];
    fileTemp2 = [tempfolder 'tempVid2'];
    fileTemp3 = [tempfolder 'tempVid3'];
    fileTemp4 = [tempfolder 'tempVid4'];
    fileTemp5 = [tempfolder 'tempVid5'];

%     if VidInfo.multithreadOption == 1;
%         %Multithread
%         %Trigger the process
%         if ispc == 1;
%             command1 = [rootfolder 'bin\export4Kparts1_screen.exe'];
%             command2 = [rootfolder 'bin\export4Kparts2_screen.exe'];
%             command3 = [rootfolder 'bin\export4Kparts3_screen.exe'];
%             command4 = [rootfolder 'bin\export4Kparts4_screen.exe'];
%             command5 = [rootfolder 'bin\export4Kparts5_screen.exe'];
% 
%             command = ['start /B ' command1 ...
%                 ' & start /B ' command2 ...
%                 ' & start /B ' command3 ...
%                 ' & start /B ' command4 ...
%                 ' & start /B ' command5];
%             [status, out] = system(command);
% 
%         elseif ismac == 1;
%             command1 = [rootfolder 'bin/export4Kparts1_screen'];
%             command2 = [rootfolder 'bin/export4Kparts2_screen'];
%             command3 = [rootfolder 'bin/export4Kparts3_screen'];
%             command4 = [rootfolder 'bin/export4Kparts4_screen'];
%             command5 = [rootfolder 'bin/export4Kparts5_screen'];
%             command = ['./' command1 ...
%                 ' & ./' command2 ...
%                 ' & ./' command3 ...
%                 ' & ./' command4 ...
%                 ' & ./' command5];
%         end;
% 
%         proceed = 1;
%         while proceed == 1; %resume when all flags are found
%             if isfile([tempfolder 'outputVid1.mat']) == 1 & ...
%                     isfile([tempfolder 'outputVid2.mat']) == 1 & ...
%                     isfile([tempfolder 'outputVid3.mat']) == 1 & ...
%                     isfile([tempfolder 'outputVid4.mat']) == 1 & ...
%                     isfile([tempfolder 'outputVid5.mat']) == 1;
%                 try;
%                     load([tempfolder 'outputVid1.mat']);
%                     load([tempfolder 'outputVid2.mat']);
%                     load([tempfolder 'outputVid3.mat']);
%                     load([tempfolder 'outputVid4.mat']);
%                     load([tempfolder 'outputVid5.mat']);
%                     
%                     if finishVid1 == 1 & finishVid2 == 1 & finishVid3 == 1 & finishVid4 == 1 & finishVid5 == 1;
%                         proceed = 0;
%                     else;
%                         frameCount = iterVid1 + iterVid2 + iterVid3 + iterVid4 + iterVid5;
%                         set(handles.txtProgress_screen, 'String', ['Processing images ...   ' num2str(frameCount) '  /  ' num2str(maxFrameCount)], 'Visible', 'on');
%                         drawnow;
%                     end;
%                 end;
%             end;
%         end;
% 
%     else;
        %Sequence single thread
        export4Kparts1single_stitching;
        export4Kparts2single_stitching;
        export4Kparts3single_stitching;
        export4Kparts4single_stitching;
        export4Kparts5single_stitching;
%     end;

    %get output filename
    fileEC1 = handles.pathLeftfile_stitching;    
    [videoinputfolder, name1, ext] = fileparts(fileEC1);
    fileEC2 = handles.pathRightfile_stitching;    
    [videoinputfolder, name2, ext] = fileparts(fileEC2);

    proceed = 1;
    charEC = 0;
    while proceed == 1;
        matchingChar = strfind(name2, name1(1:end-charEC)); 
        if isempty(matchingChar) == 0;
            proceed = 0;
            succeed = 1;
        else;
            if charEC+1 >= length(name1);
                proceed = 0;
                succeed = 0;
            else;
                charEC = charEC + 1;
            end;
        end;
    end;
    if succeed == 0;
        proceed = 1;
        charEC = 1;
        matchingChar = strfind(name2, name1(charEC:end)); 
        if isempty(matchingChar) == 0;
            proceed = 0;
            succeed = 1;
        else;
            if charEC+1 >= length(name1);
                proceed = 0;
                succeed = 0;
            else;
                charEC = charEC + 1;
            end;
        end;
    end;

    if succeed == 0;
        fileECNew = [name1 ext];
    else;
        fileECNew = name1(1:end-charEC);
        if strcmpi(fileECNew(end), '_') | strcmpi(fileECNew(end), '-') | strcmpi(fileECNew(end), ' ');
            fileECNew = fileECNew(1:end-1);
        end;
        if strcmpi(fileECNew(1), '_') | strcmpi(fileECNew(1), '-') | strcmpi(fileECNew(1), ' ');
            fileECNew = fileECNew(2:end);
        end;
        fileECNew = [fileECNew ext];
    end;
    videooutputfolder = videoinputfolder;

    lidot = strfind(fileECNew, '.');
    lidot = lidot(end);
    if ismac == 1;
        fileOut = [fileECNew(1:lidot-1) '_stitch.MP4'];
    elseif ispc == 1;
        fileOut = [fileECNew(1:lidot-1) '_xtitch.MP4'];
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
        vidFile1 = [MDIR '\SP2VideoManager\Temp\tempVid1'];
        vidFile2 = [MDIR '\SP2VideoManager\Temp\tempVid2'];
        vidFile3 = [MDIR '\SP2VideoManager\Temp\tempVid3'];
        vidFile4 = [MDIR '\SP2VideoManager\Temp\tempVid4'];
        vidFile5 = [MDIR '\SP2VideoManager\Temp\tempVid5'];
    
        command1 = ['"' ffmpegfolder '" -i "' vidFile1 '.mp4"' ' -c copy "' vidFile1 '.ts"'];
        command2 = ['"' ffmpegfolder '" -i "' vidFile2 '.mp4"' ' -c copy "' vidFile2 '.ts"'];
        command3 = ['"' ffmpegfolder '" -i "' vidFile3 '.mp4"' ' -c copy "' vidFile3 '.ts"'];
        command4 = ['"' ffmpegfolder '" -i "' vidFile4 '.mp4"' ' -c copy "' vidFile4 '.ts"'];
        command5 = ['"' ffmpegfolder '" -i "' vidFile5 '.mp4"' ' -c copy "' vidFile5 '.ts"'];
        command = [command1 ' & ' command2 ' & ' command3 ' & ' command4 ' & ' command5];
        [status, out] = system(command);
    
        %concatenate the files together
        command = ['"' ffmpegfolder '" -i ' '"concat:"' vidFile1 '.ts"' '|"' ...
            vidFile2 '.ts"' '|"' ...
            vidFile3 '.ts"' '|"' ...
            vidFile4 '.ts"' '|"' ...
            vidFile5 '.ts"' ...
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
 
    
% else;
%     %----------------process with FFMPEG-----------------
% 
%     if ispc == 1;
%         MDIR = getenv('USERPROFILE');
%     elseif ismac == 1;
%         MDIR = '/Applications';
%     end;
%     checkSpecialChar;
% 
%     if VidInfo.Rate == 50 | VidInfo.Rate == 25;
%         %all good
%     else;
%         if ispc == 1;
%             warningwindow = warndlg(['This video has a native framerate of ' num2str(VidInfo.Rate) ' and might not be compatible with SP2'], 'Warning');
%             jFrame = get(handle(warningwindow), 'javaframe');
%             jicon = javax.swing.ImageIcon([MDIR '\SP2VideoManager\SpartaManager_IconSoftware.png']);
%             jFrame.setFigureIcon(jicon);
%             clc;
%             waitfor(warningwindow);
%         elseif ismac == 1;
%             warningwindow = warndlg(['This video has a native framerate of ' num2str(VidInfo.Rate) ' and might not be compatible with SP2'], 'Warning');
%             waitfor(warningwindow);
%         end;
%     end;
%     
%     
%     
%     
%     if ismac == 1
%         ffmpegfolder = [MDIR '/SP2VideoManager/ffmpeg/bin/ffmpeg'];
%     
%     elseif ispc == 1;
%         ffmpegfolder = [MDIR '\SP2VideoManager\ffmpeg\bin\ffmpeg'];
%     end;
%      
%     fileEC1 = handles.pathLeftfile_stitching;    
%     [videoinputfolder, name1, ext] = fileparts(fileEC1);
%     fileEC2 = handles.pathRightfile_stitching;    
%     [videoinputfolder, name2, ext] = fileparts(fileEC2);
% 
%     proceed = 1;
%     charEC = 0;
%     while proceed == 1;
%         matchingChar = strfind(name2, name1(1:end-charEC)); 
%         if isempty(matchingChar) == 0;
%             proceed = 0;
%             succeed = 1;
%         else;
%             if charEC+1 >= length(name1);
%                 proceed = 0;
%                 succeed = 0;
%             else;
%                 charEC = charEC + 1;
%             end;
%         end;
%     end;
%     if succeed == 0;
%         proceed = 1;
%         charEC = 1;
%         matchingChar = strfind(name2, name1(charEC:end)); 
%         if isempty(matchingChar) == 0;
%             proceed = 0;
%             succeed = 1;
%         else;
%             if charEC+1 >= length(name1);
%                 proceed = 0;
%                 succeed = 0;
%             else;
%                 charEC = charEC + 1;
%             end;
%         end;
%     end;
% 
%     if succeed == 0;
%         fileECNew = [name1 ext];
%     else;
%         fileECNew = name1(1:end-charEC);
%         if strcmpi(fileECNew(end), '_') | strcmpi(fileECNew(end), '-') | strcmpi(fileECNew(end), ' ');
%             fileECNew = fileECNew(1:end-1);
%         end;
%         if strcmpi(fileECNew(1), '_') | strcmpi(fileECNew(1), '-') | strcmpi(fileECNew(1), ' ');
%             fileECNew = fileECNew(2:end);
%         end;
%         fileECNew = [fileECNew ext];
%     end;
%     videooutputfolder = videoinputfolder;
%     
%     lidot = strfind(fileECNew, '.');
%     lidot = lidot(end);
%     if ismac == 1;
%         fileOut = [fileECNew(1:lidot-1) '_stitch.MP4'];
%     elseif ispc == 1;
%         fileOut = [fileECNew(1:lidot-1) '_stitch.MP4'];
%     end;
%     
%     fileoutExist = 0;
%     listdir = dir(videooutputfolder);
%     for filelist = 1:length(listdir);
%         fileCheck = listdir(filelist);
%         NameEC = fileCheck.name;
%         if strcmpi(NameEC, fileOut) == 1;
%             fileoutExist = 1;
%         end;
%     end;
%     if ismac == 1;
%         if fileoutExist == 1;
%             command = ['rm "' videooutputfolder '/' fileOut '"'];
%             [status, cmdout] = system(command);
%         end;
%     elseif ispc == 1;
%         if fileoutExist == 1;
%             command = ['del /Q "' videooutputfolder '\' fileOut '"'];
%             [status, cmdout] = system(command);
%         end;
%     end;
%     
%     liOneDrive = strfind(lower(path), 'onedrive');
%     liDropbox = strfind(lower(path), 'dropbox');
%     if ismac == 1;
%         if specialChar_MDIR == 1;
%             testFileInput = ['"' MDIR '/SP2VideoManager/frame720.jpg"'];
%         else;
%             testFileInput = [MDIR '/SP2VideoManager/frame720.jpg'];
%         end;
%     elseif ispc == 1;
%         if specialChar_MDIR == 1;
%             testFileInput = ['"' MDIR '\SP2VideoManager\frame720.jpg"'];
%         else;
%             testFileInput = [MDIR '\SP2VideoManager\frame720.jpg'];
%         end;
%     end;
%     if ismac == 1;
%         if specialChar_outputfolder == 1;
%             testFileOutput = ['"' videooutputfolder '/frame720.jpg"'];
%         else;
%             testFileOutput = [videooutputfolder '/frame720.jpg'];
%         end;
%     elseif ispc == 1;
%         if specialChar_outputfolder == 1;
%             testFileOutput = ['"' videooutputfolder '\frame720.jpg"'];
%         else;
%             testFileOutput = [videooutputfolder '\frame720.jpg'];
%         end;
%     end;
%     
%     if isempty(liOneDrive) == 0;
%         %test OneDrive
%         if ispc == 1;
%             command = ['del /f "' testFileOutput '"'];
%         else;
%             command = ['rm "' testFileInput '" "' testFileOutput '"'];
%         end;
%         [status, cmdout] = system(command);
%     
%         if ispc == 1;
%             command = ['copy "' testFileInput '" "' testFileOutput '"'];
%         else;
%             command = ['cp "' testFileInput '" "' testFileOutput '"'];
%         end;
%         [statusOnline, cmdout] = system(command);
%     
%         if statusOnline == 0;
%             if ispc == 1;
%                 command = ['del /f "' testFileOutput '"'];
%             else;
%                 command = ['rm "' testFileInput '" "' testFileOutput '"'];
%             end;
%             [status, cmdout] = system(command);
%         end;
%     else;
%         statusOnline = 0;
%     end;
%     
%     if isempty(liDropbox) == 0;
%         %test DropBox
%         if ispc == 1;
%             command = ['del /f "' testFileOutput '"'];
%         else;
%             command = ['rm "' testFileInput '" "' testFileOutput '"'];
%         end;
%         [status, cmdout] = system(command);
%     
%         if ispc == 1;
%             command = ['copy "' testFileInput '" "' testFileOutput '"'];
%         else;
%             command = ['cp "' testFileInput '" "' testFileOutput '"'];
%         end;
%         [statusOnline, cmdout] = system(command);
%     
%         if statusOnline == 0;
%             if ispc == 1;
%                 command = ['del /f "' testFileOutput '"'];
%             else;
%                 command = ['rm "' testFileInput '" "' testFileOutput '"'];
%             end;
%             [status, cmdout] = system(command);
%         end;
%     else;
%         statusOnline = 0;
%     end;
%     
%     
%     if ismac == 1;
%         tempfolder = [MDIR '/SP2VideoManager/Temp/'];
%         
%         if isdir([MDIR '/SP2VideoManager/Temp']) == 0;
%             command = ['mkdir ' tempfolder];
%             [status, cmdout] = system(command);
%         end;
%         command = ['rm "' tempfolder '"' '*'];
%         [status, cmdout] = system(command);
%     
%         tempfolder = [MDIR '/SP2VideoManager/Temp/'];
%     elseif ispc == 1;
%         tempfolder = [MDIR '\SP2VideoManager\Temp\'];
%         if isdir([MDIR '\SP2VideoManager\Temp']) == 0;
%             command = ['mkdir "' tempfolder '"'];
%             [status, cmdout] = system(command);
%         end;
%         
%         command = ['del /Q "' tempfolder  '"' '*'];
%         [status, cmdout] = system(command);
%     
%         tempfolder = [MDIR '\SP2VideoManager\Temp\'];
%     end;
%     
%     
%     if statusOnline == 0;
%         set(handles.txtProgress_screen, 'String', 'Preparing video ...', 'Visible', 'on');
%         drawnow;
%     
%         if ismac == 1;
%         
%             partIn = [videoinputfolder '/' fileECNew];
%             partOut = [videooutputfolder '/' fileOut];
%             
% %             command = ['"' ffmpegfolder '" -i "' partIn '"' ...
% %             ' -map 0:v:0 -c copy -f null -'];
% %             [status, cmdout] = system(command);
% % 
% %             lifps = strfind(cmdout, 'fps');
% %             cmdoutfps = cmdout(lifps(1)-7:lifps(1)-2);
% %             index = strfind(cmdoutfps, '.');
% %             cmdoutfps = cmdoutfps(index-2:index+2);
%             % framerate = roundn(str2num(cmdoutfps),-2);
%             framerate = VidInfo.Rate;
%     
%             txtEC = ['Exporting video ...  ' partOut];
%             set(handles.txtProgress_screen, 'String', txtEC, 'Visible', 'on', 'tooltipstring', txtEC);
%             posExtent = get(handles.txtProgress_screen, 'Extent');
%             posReal = get(handles.txtProgress_screen, 'Position');
%             if posExtent(3) >= posReal(3);
%                 fileStr = [txtEC(1:50) ' ... ' txtEC(end-50:end)];
%                 set(handles.txtProgress_screen, 'String', fileStr);
%             end;
%             drawnow;
%             
%             if isempty(handles.trimInVal_screen) == 1 & isempty(handles.trimOutVal_screen) == 1;
%                 if handles.CurrenCompressionScreen == 0;
%                     %remuxing
%                     command = ['"' ffmpegfolder '" -i "' partIn '" -c copy "' partOut '"'];
%                 else;
%                     command = ['"' ffmpegfolder '" -i "' partIn ...
%                         '" -c:v libx264 -preset superfast -g 24 -keyint_min 24 -b:v ' ...
%                         num2str(handles.CurrenCompressionScreen) 'M -pix_fmt yuv420p -threads 0 "' ...
%                         partOut '"'];
%                 end;
%                         
%             elseif isempty(handles.trimInVal_screen) == 1 & isempty(handles.trimOutVal_screen) == 0;
%                 %Trim at the end
%                 trimOutTime = (handles.trimOutVal_screen./VidInfo.Rate) - (1/VidInfo.Rate);
%                 
%                 if handles.CurrenCompressionScreen == 0;
%                     %remuxing
%                     command = ['"' ffmpegfolder '" -i "' partIn '"' ...
%                         ' -c copy -t ' num2str(trimOutTime) ' "' partOut '"'];
%                 else;
%                     command = ['"' ffmpegfolder "' -i "'  partIn ...
%                         '" -c:v libx264 -preset superfast -g 24 -keyint_min 24 -b:v ' ...
%                         num2str(handles.CurrenCompressionScreen) 'M -pix_fmt yuv420p -threads 0 ' ...
%                         '-t ' num2str(trimOutTime) ' "' partOut '"'];
%                 end;
% 
%             elseif isempty(handles.trimInVal_screen) == 0 & isempty(handles.trimOutVal_screen) == 1;
%                 %trim at the beginning
%                 trimInTime = (handles.trimInVal_screen./VidInfo.Rate) - (1/VidInfo.Rate);
%                 
%                 if handles.CurrenCompressionScreen == 0;
%                     %remuxing
%                     command = ['"' ffmpegfolder '" -ss ' num2str(trimInTime) ...
%                         ' -i "' partIn '" -c copy "' partOut '"'];
%                 else;
%                     command = ['"' ffmpegfolder '" -ss ' num2str(trimInTime) ' -i "' partIn ...
%                         '" -c:v libx264 -preset superfast -g 24 -keyint_min 24 -b:v ' ...
%                         num2str(handles.CurrenCompressionScreen) 'M -pix_fmt yuv420p -threads 0 "' ...
%                         partOut '"'];
%                 end;
%             else;
%                 %trim both beginning and end
%                 trimInTime = (handles.trimInVal_screen./VidInfo.Rate) - (1/VidInfo.Rate);
%                 trimOutTime = ((handles.trimOutVal_screen./VidInfo.Rate) - (1/VidInfo.Rate)) - trimInTime;
% 
%                 if handles.CurrenCompressionScreen == 0;
%                     %remuxing
%                     command = ['"' ffmpegfolder '" -ss ' num2str(trimInTime) ...
%                         ' -i "' partIn '" -c copy -t ' num2str(trimOutTime) ' "' partOut '"'];
%                 else;
%                     command = ['"' ffmpegfolder '" -ss ' num2str(trimInTime) ' -i "' partIn '"' ...
%                         ' -c:v libx264 -preset superfast -g 24 -keyint_min 24 -b:v ' ...
%                         num2str(handles.CurrenCompressionScreen) 'M -pix_fmt yuv420p -threads 0 ' ...
%                         '-t ' num2str(trimOutTime) ' "' partOut '"'];
%                 end;
%             end;
%     
%         elseif ispc == 1;
%             partIn = [videoinputfolder '\' fileECNew];
%             partOut = [videooutputfolder '\' fileOut];
%             
% %             command = ['"' ffmpegfolder '" -i "' partIn '"' ...
% %             ' -map 0:v:0 -c copy -f null -'];
% %             [status, cmdout] = system(command);
% %     
% %             lifps = strfind(cmdout, 'fps');
% %             cmdoutfps = cmdout(lifps(1)-7:lifps(1)-2);
% %             index = strfind(cmdoutfps, '.');
% %             cmdoutfps = cmdoutfps(index-2:index+2);
%             % framerate = roundn(str2num(cmdoutfps),-2);
%             framerate = roundn(VidInfo.Rate,-2);
%             
%             txtEC = ['Exporting video ...  ' partOut];
%             set(handles.txtProgress_screen, 'String', txtEC, 'Visible', 'on', 'tooltipstring', txtEC);
%             posExtent = get(handles.txtProgress_screen, 'Extent');
%             posReal = get(handles.txtProgress_screen, 'Position');
%             if posExtent(3) >= posReal(3);
%                 fileStr = [txtEC(1:50) ' ... ' txtEC(end-50:end)];
%                 set(handles.txtProgress_screen, 'String', fileStr);
%             end;
%             drawnow;
% 
%             if isempty(handles.trimInVal_screen) == 1 & isempty(handles.trimOutVal_screen) == 1;
%                 %no triming
%                 if handles.CurrenCompressionScreen == 0;
%                     %remuxing
%                     command = ['"' ffmpegfolder '" -i "' partIn '" -c copy "' partOut '"'];
%                 else;
%                     command = ['"' ffmpegfolder '" -i "' partIn ...
%                         '" -c:v libx264 -preset superfast -g 24 -keyint_min 24 -b:v ' ...
%                         num2str(handles.CurrenCompressionScreen) 'M -pix_fmt yuv420p -threads 0 "' ...
%                         partOut '"'];
%                 end;
% 
%             elseif isempty(handles.trimInVal_screen) == 1 & isempty(handles.trimOutVal_screen) == 0;
%                 %Trim at the end
%                 trimOutTime = (handles.trimOutVal_screen./VidInfo.Rate) - (1/VidInfo.Rate);
%                 
%                 if handles.CurrenCompressionScreen == 0;
%                     %remuxing
%                     command = ['"' ffmpegfolder '" -i "' partIn ...
%                         '" -c copy -t ' num2str(trimOutTime) ' "' partOut '"'];
%                 else;
%                     command = ['"' ffmpegfolder '" -i "'  partIn ...
%                         '" -c:v libx264 -preset superfast -g 24 -keyint_min 24 -b:v ' ...
%                         num2str(handles.CurrenCompressionScreen) 'M -pix_fmt yuv420p -threads 0 ' ...
%                         '-t ' num2str(trimOutTime) ' "' partOut '"'];
%                 end;
%                 
%             elseif isempty(handles.trimInVal_screen) == 0 & isempty(handles.trimOutVal_screen) == 1;
%                 %trim at the beginning
%                 trimInTime = (handles.trimInVal_screen./VidInfo.Rate) - (1/VidInfo.Rate);
%                 
%                 if handles.CurrenCompressionScreen == 0;
%                     %remuxing
%                     command = ['"' ffmpegfolder '" -ss ' num2str(trimInTime) ...
%                         ' -i "' partIn '" -c copy "' partOut '"'];
%                 else;
%                     command = ['"' ffmpegfolder '" -ss ' num2str(trimInTime) ' -i "' partIn ...
%                         '" -c:v libx264 -preset superfast -g 24 -keyint_min 24 -b:v ' ...
%                         num2str(handles.CurrenCompressionScreen) 'M -pix_fmt yuv420p -threads 0 "' ...
%                         partOut '"'];
%                 end;
%             else;
%                 %trim both beginning and end
%                 trimInTime = (handles.trimInVal_screen./VidInfo.Rate) - (1/VidInfo.Rate);
%                 trimOutTime = ((handles.trimOutVal_screen./VidInfo.Rate) - (1/VidInfo.Rate)) - trimInTime;
% 
%                 if handles.CurrenCompressionScreen == 0;
%                     %remuxing
%                     command = ['"' ffmpegfolder '" -ss ' num2str(trimInTime) ...
%                         ' -i "' partIn '" -c copy -t ' num2str(trimOutTime) ' "' partOut '"'];
%                 else;
%                     command = ['"' ffmpegfolder '" -ss ' num2str(trimInTime) ' -i "' partIn ...
%                         '" -c:v libx264 -preset superfast -g 24 -keyint_min 24 -b:v ' ...
%                         num2str(handles.CurrenCompressionScreen) 'M -pix_fmt yuv420p -threads 0 ' ...
%                         '-t ' num2str(trimOutTime) ' "' partOut '"'];
%                 end;
%             end;
%         end;
%         [status, cmdout] = system(command);
%         guidata(handles.hf_w1_welcome, handles);
% 
%     else;
%         if ispc == 1;
%             errorwindow = errordlg('Permission denied, cannot access this OneDrive/Dropbox folder. Please move your file into a local folder', 'Error');
%             jFrame = get(handle(errorwindow), 'javaframe');
%             jicon = javax.swing.ImageIcon([MDIR '\SP2VideoManager\SpartaManager_IconSoftware.png']);
%             jFrame.setFigureIcon(jicon);
%             clc;
%             return;
%         elseif ismac == 1;
%             errordlg('Permission denied, cannot access this OneDrive/Dropbox folder. Please move your file into a local folder', 'Error');
%             return;
%         end;
%     end;
% end;

set(handles.txtProgress_stitching, 'String', '', 'tooltipstring', '', 'Visible', 'off');
drawnow;


