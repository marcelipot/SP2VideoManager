
if ismac == 1;
    sepChar = '/';
    inputFile = ['/Applications/SP2VideoManager/Temp/tempVideoSettings.mat'];
elseif ispc == 1;
    sepChar = '\';
    MDIR = getenv('USERPROFILE');
    inputFile = [MDIR sepChar 'SP2VideoManager' sepChar 'Temp' sepChar 'tempVideoSettings.mat'];
end;
load(inputFile);


% if ispc == 1;
%     command = ['del /Q /S ' '"' inputFile '"'];
%     [status, cmdout] = system(command);
% elseif ismac == 1;
%     command = ['rm ' '"' inputFile '"'];
%     [status, cmdout] = system(command);
% end;

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

% if strcmpi(VidInfo.FishEye.keepValid, 'Full');
%     viewOption = 1;    
% elseif strcmpi(VidInfo.FishEye.keepValid, 'Valid');
%     viewOption = 2;
% end;

frameGrab = zeros(VidInfo.Height,VidInfo.Width,3);
frameUndist = zeros(VidInfo.Height,VidInfo.Width,3);
frameProcessed = zeros(VidInfo.Height,VidInfo.Width,3);
frame = zeros(VidInfo.Height,VidInfo.Width,3);

if isMatlab == 1;
    if ispc == 1;
        MDIR = getenv('USERPROFILE');
    elseif ismac == 1;
        MDIR = '/Applications';
    end;
    
    finishVid5 = 0;
    iterVid5 = 1;
    frameListPEC = frameListP5;
    for imEC = frameListPEC(1):frameListPEC(end);
        if frameDataTemp(imEC,3) == 1;
            FrameEC = frameDataTemp(imEC,1);
            frameGrab = read(VidInfo.VidObj, FrameEC);

            %---Apply fish eye
            if isempty(VidInfo.FishEye) == 0;
                if isempty(VidInfo.FishEye.map_xOpt) == 0;
                    %---Use the optimsed maps
                    map_x = VidInfo.FishEye.map_xOpt;
                    map_y = VidInfo.FishEye.map_yOpt;
                else;
                    %--- Use the non-optimised maps
                    map_x = VidInfo.FishEye.map_xIni;
                    map_y = VidInfo.FishEye.map_yIni;
                end;
            %     if strcmpi(class(VidInfo.FishEye.param), 'cameraParameters');
            %         %pinhole model
                    [frame, ~] = imagesbuiltinImageInterpolation2D(frameGrab, map_x, map_y, 'nearest',0); 
            %     elseif strcmpi(class(VidInfo.FishEye.param), 'fisheyeParameters');
            %         %fisheye model
            %         [frame, ~] = imagesbuiltinImageInterpolation2D(frame, VidInfo.FishEye.map_x, VidInfo.FishEye.map_y, 'nearest', 0);
            %     end;

%                 [rows, cols, ~] = size(frame);
%                 if viewOption == 1;
%                     %Keep the entire image: just remove the rows and cols to make it 16/9
%                     if roundn(cols./rows,-3) < roundn(16/9,-3);
%                         %they are too many rows... need to remove some to have 16/9 ratio
%                         nbrowsTOT = (cols.*9)./16;
%                         rowsFrom = floor((rows-nbrowsTOT)./2) + 1;
%                         rowsTo = rows-floor((rows-nbrowsTOT)./2) - 1;
%                         frameProcessed = frame(rowsFrom:rowsTo,:,:);
%                         frame = imresize(frameProcessed, [2160 3840], 'nearest');
% 
%                     elseif roundn(cols./rows,-3) > roundn(16/9,-3);
%                         %they are too many cols... need to add black rows to have 16/9 ratio
%                         nbrowsTOT = (cols.*9)./16;
%                         missingRows = floor((rows-nbrowsTOT)./2); 
%                         frame2a1 = zeros(missingRows,cols);
% %                         frame2a2 = [frame2a1; frame(:,:,1); frame2a1];
%                         frame2a2 = cat(1,frame2a1,frame(:,:,1),frame2a1);
% %                         frame2b1 = zeros(missingRows,cols);
% %                         frame2b2 = [frame2b1; frame(:,:,2); frame2b1];
%                         frame2b2 = cat(1,frame2a1,frame(:,:,2),frame2a1);
% %                         frame2c1 = zeros(missingRows,cols);
% %                         frame2c2 = [frame2c1; frame(:,:,3); frame2c1];
%                         frame2c2 = cat(1,frame2a1,frame(:,:,3),frame2a1);
%     
% %                         frameProcessed = cat(3,frame2a2,frame2b2,frame2c2);
%                         frameProcessed = cat(3,frame2a2,frame2b2,frame2c2);
% %                         frame(:,:,1) = frame2a2;
% %                         frame(:,:,2) = frame2b2;
% %                         frame(:,:,3) = frame2c2;
%                         frame = imresize(frameProcessed, [2160 3840], 'nearest');
%                     else;
%                         %no need to change the ratio
%                         %already 16/9
%                     end;
% 
%                 elseif viewOption == 2;
%                     %Crop the image to 16/9
%                     [checkH, checkW, ~] = size(frame);
%                     if checkH > 2160 & checkW > 3840;
%                         midFrameRows = (rows./2) - 2160./2;
%                         midFrameCols = (cols./2) - 3840./2;
%                         posRec = [midFrameCols midFrameRows 3840 2160];
% 
%                         frame = imcrop(frame, posRec);    
%                     end;
%                 end;
            end;

            %---Apply enhancement
            if VidInfo.ImageEnhance.Contract ~= 0;
                contrastamt = 1 + VidInfo.ImageEnhance.Contract./10;
                HSV = rgb2hsv(frame);
                HSV(:, :, 2) = HSV(:, :, 2) * contrastamt;
                HSV(HSV > 1) = 1;
                frame = hsv2rgb(HSV);
            end;
            
            if VidInfo.ImageEnhance.Brightness ~= 0;
                contrastamt = VidInfo.ImageEnhance.Brightness./10;
                if VidInfo.ImageEnhance.Brightness < 0;
                    olhi = tan((contrastamt+1)*pi/4)*0.5 + 0.5;
                    frame = imadjust(frame, [0 1], [1-olhi olhi], 1);
                else;
                    olhi = tan((1-contrastamt)*pi/4)*0.5 + 0.5;
                    frame = imadjust(frame, [1-olhi olhi], [0 1], 1);
                end;
            end;

            if tempRate < targetRate;
                %duplicate the image but to be modified
                frame1 = frame;
                frame2 = frame;
                writeVideo(vid5, frame1);
                writeVideo(vid5, frame2);
            else;
                writeVideo(vid5, frame);
            end;

            imEC
            if mod(iterVid5,10) == 0;
                %Display image count every 10 iterations
                set(outputTXT, 'String', ['Processing images ...   ' num2str(imEC) '  /  ' num2str(maxFrameCount)], 'Visible', 'on');
                drawnow;
            end;
            iterVid5 = iterVid5 + 1;
        end;
    end;
else;

end;

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




