
if ismac == 1;
    sepChar = '/';
    inputFile = ['/Applications/SP2VideoManager/Temp/tempVideoSettings.mat'];
elseif ispc == 1;
    sepChar = '\';
    MDIR = getenv('USERPROFILE');
    inputFile = [MDIR sepChar 'SP2VideoManager' sepChar 'Temp' sepChar 'tempVideoSettings.mat'];
end;
load(inputFile);

fileTemp = [tempfolder 'tempVid1.mp4'];
if ispc == 1;
    command = ['del /Q /S ' '"' fileTemp '"'];
    [status, cmdout] = system(command);
elseif ismac == 1;
    command = ['rm ' '"' fileTemp '"'];
    [status, cmdout] = system(command);
end;
compression = 'H.264';
profile = 'MPEG-4';
container = '.mp4';

vid1 = VideoWriter(fileTemp, profile);
vid1.Quality = 85; %cannot take higher
vid1.FrameRate = targetRate;
open(vid1);

if strcmpi(VidInfo.keepValid, 'Full');
    viewOption = 1;    
elseif strcmpi(VidInfo.keepValid, 'Valid');
    viewOption = 2;
end;

frameGrab = zeros(VidInfo.Height,VidInfo.Width,3);
frameUndist = zeros(VidInfo.Height,VidInfo.Width,3);
frameProcessed = zeros(VidInfo.Height,VidInfo.Width,3);
frame = zeros(VidInfo.Height,VidInfo.Width,3);

% if isMatlab == 1;
    if ispc == 1;
        MDIR = getenv('USERPROFILE');
    elseif ismac == 1;
        MDIR = '/Applications';
    end;

    finishVid1 = 0;
    iterVid1 = 1;
    frameListPEC = frameListP1;
    for imEC = frameListPEC(1):frameListPEC(end);
        if frameDataTempLeft(imEC,3) == 1;
            FrameEC = frameDataTempLeft(imEC,1);
            imgLeft = read(VidInfo.VidObjLeft, FrameEC);
            FrameEC = frameDataTempRight(imEC,1);
            imgRight = read(VidInfo.VidObjRight, FrameEC);

            %---Create stitched view
            imgPanorama = createStitchImg_stitching(imgLeft, imgRight, savedOutputStichingNormal, savedOutputStichingTop, VidInfo.viewAngle);

            %---Apply enhancement
            if VidInfo.ImageEnhance.Contract ~= 0;
                contrastamt = 1 + VidInfo.ImageEnhance.Contract./10;
                HSV = rgb2hsv(imgPanorama);
                HSV(:, :, 2) = HSV(:, :, 2) * contrastamt;
                HSV(HSV > 1) = 1;
                imgPanorama = hsv2rgb(HSV);
            end;
            
            if VidInfo.ImageEnhance.Brightness ~= 0;
                contrastamt = VidInfo.ImageEnhance.Brightness./10;
                if VidInfo.ImageEnhance.Brightness < 0;
                    olhi = tan((contrastamt+1)*pi/4)*0.5 + 0.5;
                    imgPanorama = imadjust(imgPanorama, [0 1], [1-olhi olhi], 1);
                else;
                    olhi = tan((1-contrastamt)*pi/4)*0.5 + 0.5;
                    imgPanorama = imadjust(imgPanorama, [1-olhi olhi], [0 1], 1);
                end;
            end;

            if tempRate < targetRate;
                %duplicate the image but to be modified
                frame1 = imgPanorama;
                frame2 = imgPanorama;
                writeVideo(vid1, frame1);
                writeVideo(vid1, frame2);
            else;
                writeVideo(vid1, imgPanorama);
            end;
        end;

        imEC
        if mod(iterVid1,10) == 0;
            %Display image count every 10 iterations
            set(handles.txtProgress_stitching, 'String', ['Processing images ...   ' num2str(imEC) '  /  ' num2str(maxFrameCount)], 'Visible', 'on');
            drawnow;
        end;
        iterVid1 = iterVid1 + 1;
    end;
% else;
% 
% end;

close(vid1);
clear vid1;
if ismac == 1;
    finishVid1 = 1;
    save('/Applications/SP2VideoManager/Temp/outputVid1.mat', 'finishVid1', 'iterVid1');
elseif ispc == 1;
    MDIR = getenv('USERPROFILE');
    finishVid1 = 1;
    save([MDIR '\SP2VideoManager\Temp\outputVid1.mat'], 'finishVid1', 'iterVid1');
end;





