function applyFishEye_stitching(varargin);



handles2 = guidata(gcf);
set(handles2.mainInfos_qual, 'String', 'Applying image correction ...');
drawnow;

VidInfo = handles2.VidInfo;
frame = VidInfo.ActiveFrame;


%---Apply fish eye
if isempty(VidInfo.FishEye) == 0;
    if strcmpi(class(VidInfo.FishEye.param), 'cameraParameters');
        %pinhole model
        [map_x, map_y] = initUndistortPinHoleMap(VidInfo.FishEye.param, [2160 3840], VidInfo.FishEye.keepValid);
        frameINI = frame;
        [frame, ~] = imagesbuiltinImageInterpolation2D(frame, map_x, map_y, 'nearest',0); 

        VidInfo.FishEye.map_x = map_x;
        VidInfo.FishEye.map_y = map_y;
    elseif strcmpi(class(VidInfo.FishEye.param), 'fisheyeParameters');
        %fisheye model
        [map_x, map_y] = initUndistortFishEyeMap(VidInfo.FishEye.param, VidInfo.FishEye.keepValid);
        frameINI = frame;
        [frame, ~] = imagesbuiltinImageInterpolation2D(frame, map_x, map_y, 'nearest', 0);

        VidInfo.FishEye.map_x = map_x;
        VidInfo.FishEye.map_y = map_y;
    end;
    map_x1 = map_x;
    map_y1 = map_y;
    
    [rows, cols, ~] = size(frame);
    if strcmpi(VidInfo.FishEye.keepValid, 'Full');
        %Keep the entire image: just remove the rows and cols to make it 16/9
        if roundn(cols./rows,-3) < roundn(16/9,-3);
            %they are too many rows... need to remove some to have 16/9 ratio
            nbrowsTOT = (cols.*9)./16;
            rowsFrom = floor((rows-nbrowsTOT)./2) + 1;
            rowsTo = rows-floor((rows-nbrowsTOT)./2) - 1;
            frameProcessed = frame(rowsFrom:rowsTo,:,:);
            frame = imresize(frameProcessed, [2160 3840], 'nearest');

        elseif roundn(cols./rows,-3) > roundn(16/9,-3);
            %they are too many cols... need to add black rows to have 16/9 ratio
            nbrowsTOT = (cols.*9)./16;
            missingRows = floor((rows-nbrowsTOT)./2); 
            frame2a1 = zeros(missingRows,cols);
%                         frame2a2 = [frame2a1; frame(:,:,1); frame2a1];
            frame2a2 = cat(1,frame2a1,frame(:,:,1),frame2a1);
%                         frame2b1 = zeros(missingRows,cols);
%                         frame2b2 = [frame2b1; frame(:,:,2); frame2b1];
            frame2b2 = cat(1,frame2a1,frame(:,:,2),frame2a1);
%                         frame2c1 = zeros(missingRows,cols);
%                         frame2c2 = [frame2c1; frame(:,:,3); frame2c1];
            frame2c2 = cat(1,frame2a1,frame(:,:,3),frame2a1);

%                         frameProcessed = cat(3,frame2a2,frame2b2,frame2c2);
            frameProcessed = cat(3,frame2a2,frame2b2,frame2c2);
%                         frame(:,:,1) = frame2a2;
%                         frame(:,:,2) = frame2b2;
%                         frame(:,:,3) = frame2c2;
            frame = imresize(frameProcessed, [2160 3840], 'nearest');
        else;
            %no need to change the ratio
            %already 16/9
        end;

    elseif strcmpi(VidInfo.FishEye.keepValid, 'Valid');
        %Crop the image to 16/9
        [checkH, checkW, ~] = size(frame);
        if checkH > 2160 & checkW > 3840;
            midFrameRows = (rows./2) - 2160./2;
            midFrameCols = (cols./2) - 3840./2;
            posRec = [midFrameCols midFrameRows 3840 2160];

            frame = imcrop(frame, posRec);    
        end;
    end;

    VidInfo.xlimValCurrent = [1 cols];
    VidInfo.ylimValCurrent = [1 rows];
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
%         frame = imadjust(frame, [(VidInfo.ImageEnhance.Brightness./10) 0]);
    else;
        olhi = tan((1-contrastamt)*pi/4)*0.5 + 0.5;
        frame = imadjust(frame, [1-olhi olhi], [0 1], 1);
%         frame = imadjust(frame, [0 (VidInfo.ImageEnhance.Brightness./10)]);
    end;
end;


%---update the axes
if isfield(handles2, 'qualVideoimdisplayed') == 1;
    %field exist
    if isvalid(handles2.qualVideoimdisplayed) == 1;
        %exist and valid
        cla(handles2.mainVideo_qual, 'reset');
        axes(handles2.mainVideo_qual);
        handles2.qualVideoimdisplayed = imshow(frame);
    else;
        %not valid: need to create it again
        cla(handles2.mainVideo_qual, 'reset');
        axes(handles2.mainVideo_qual);
        handles2.qualVideoimdisplayed = imshow(frame);
    end;
else;
    %create field
    cla(handles2.mainVideo_qual, 'reset');
    axes(handles2.mainVideo_qual);
    handles2.qualVideoimdisplayed = imshow(frame);
end;
[tb,btns] = axtoolbar(handles2.mainVideo_qual, {'zoomin','zoomout','pan'});


% VidInfo.ActiveFrame = frame;
handles2.filetosave.map_x = VidInfo.FishEye.map_x;
handles2.filetosave.map_y = VidInfo.FishEye.map_y;
if get(handles2.validImageDrop_qual, 'Value') == 1;
    handles2.filetosave.keepValid = 'Full';
else;
    handles2.filetosave.keepValid = 'crop';
end

set(handles2.mainInfos_qual, 'String', '');
handles2.VidInfo = VidInfo;
guidata(handles2.hf_w2_advancedImage, handles2);
