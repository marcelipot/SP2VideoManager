
if ismac == 1;
    sepChar = '/';
    inputFile = ['/Applications/SP2VideoManager/Temp/tempVideoSettings.mat'];
elseif ispc == 1;
    sepChar = '\';
    MDIR = getenv('USERPROFILE');
    inputFile = [MDIR sepChar 'SP2VideoManager' sepChar 'Temp' sepChar 'tempVideoSettings.mat'];
end;
load(inputFile);

fileTemp = [tempfolder 'tempVid5.mp4'];
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

vid5 = VideoWriter(fileTemp, profile);
vid5.Quality = 85; %cannot take higher
vid5.FrameRate = targetRate;
open(vid5);

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
    
    finishVid5 = 0;
    iterVid5 = 1;
    frameListPEC = frameListP5;
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
                writeVideo(vid5, frame1);
                writeVideo(vid5, frame2);
            else;
                writeVideo(vid5, imgPanorama);
            end;

            imEC
            if mod(iterVid5,10) == 0;
                %Display image count every 10 iterations
                set(handles.txtProgress_stitching, 'String', ['Processing images ...   ' num2str(imEC) '  /  ' num2str(maxFrameCount)], 'Visible', 'on');
                drawnow;
            end;
            iterVid5 = iterVid5 + 1;
        end;
    end;
% else;
% 
% end;

close(vid5);
clear vid5;
if ismac == 1;
    finishVid5 = 1;
    save('/Applications/SP2VideoManager/Temp/outputVid5.mat', 'finishVid5', 'iterVid5');
elseif ispc == 1;
    MDIR = getenv('USERPROFILE');
    finishVid5 = 1;
    save([MDIR '\SP2VideoManager\Temp\outputVid5.mat'], 'finishVid5', 'iterVid5');
end;




