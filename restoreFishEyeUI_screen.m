function restoreFishEyeUI_screen(varargin);



handles2 = guidata(gcf);

%---------------------------load video-------------------------------------
VidInfo = handles2.VidInfo;
%--------------------------------------------------------------------------


%--------------------------Reset variable----------------------------------
VidInfo.FishEye = [];
VidInfo.ActiveFrameIni = [];
VidInfo.ActiveFrameOpt = [];
%--------------------------------------------------------------------------


%-----------------------------Reset the ui---------------------------------
set(handles2.apply2_qual, 'enable', 'off');
set(handles2.multiThreadRadio_qual, 'enable', 'off', 'value', 0);
set(handles2.fisheyeType1Radio_qual, 'enable', 'off', 'value', 0);
set(handles2.fisheyeType2Radio_qual, 'enable', 'off', 'value', 0);
set(handles2.fisheyeType3Radio_qual, 'enable', 'off', 'value', 0);
set(handles2.fisheyeType4Radio_qual, 'enable', 'off', 'value', 0);
set(handles2.validImageDrop_qual, 'enable', 'off', 'value', 1);
set(handles2.selectPtDLT_qual, 'enable', 'off', 'value', 1);
set(handles2.selectDLTcoorX_EDIT_qual, 'enable', 'off', 'string', '');
set(handles2.selectDLTcoorY_EDIT_qual, 'enable', 'off', 'string', '');
set(handles2.erasePtDLT_qual, 'enable', 'off');
set(handles2.applyOptimisation1_qual, 'enable', 'off', 'value', 0);
set(handles2.applyOptimisation2_qual, 'enable', 'off', 'value', 0);
set(handles2.applyTopDown_qual, 'enable', 'off', 'value', 0);
set(handles2.apply2_qual, 'enable', 'off');
set(handles2.restore2_qual, 'enable', 'off');

set(handles2.loadFishEye_qual, 'enable', 'on');
set(handles2.defineFishEye_qual, 'enable', 'on');
%--------------------------------------------------------------------------


%--------------------------Display current frame---------------------------
frame = read(VidInfo.VidObj, VidInfo.FrameEC);
VidInfo.ActiveFrame = frame;

%---Apply fish eye
if isempty(VidInfo.FishEye) == 0;
    if isempty(strfind(VidInfo.FishEye.fileFishEyeName, 'v1')) == 0 | isempty(strfind(VidInfo.FishEye.fileFishEyeName, 'v2')) == 0;
        %pinhole model
        [frame, ~] = imagesbuiltinImageInterpolation2D(frame, VidInfo.FishEye.map_x, VidInfo.FishEye.map_y, 'bilinear',0); 
    else;
        %fisheye model
        [frame, ~] = imagesbuiltinImageInterpolation2D(frame, VidInfo.FishEye.map_x, VidInfo.FishEye.map_y, 'bilinear', 0);
    end;

    [rows, cols, ~] = size(frame);
    if strcmpi(VidInfo.FishEye.keepValid, 'Full');
        %Keep the entire image: just remove the rows and cols to make it 16/9
        if roundn(cols./rows,-3) < roundn(16/9,-3);
            %they are too many rows... need to remove some to have 16/9 ratio
            nbrowsTOT = (cols.*9)./16;
            rowsFrom = floor((rows-nbrowsTOT)./2) + 1;
            rowsTo = rows-floor((rows-nbrowsTOT)./2) - 1;
            frame = frame(rowsFrom:rowsTo,:,:);

        elseif roundn(cols./rows,-3) > roundn(16/9,-3);
            %they are too many cols... need to add black rows to have 16/9 ratio
            nbrowsTOT = (cols.*9)./16;
            missingRows = floor((rows-nbrowsTOT)./2);

            frame2a1 = zeros(missingRows,cols);
            frame2a2 = [frame2a1; frame(:,:,1); frame2a1];
            frame2b1 = zeros(missingRows,cols);
            frame2b2 = [frame2b1; frame(:,:,2); frame2b1];
            frame2c1 = zeros(missingRows,cols);
            frame2c2 = [frame2c1; frame(:,:,3); frame2c1];

            frame(:,:,1) = frame2a2;
            frame(:,:,2) = frame2b2;
            frame(:,:,3) = frame2c2;
        else;
            %no need to change the ratio
            %already 16/9
        end;
        frame = imresize(frame, [2160 3840]);

    elseif strcmpi(VidInfo.FishEye.keepValid, 'Valid');
        %Crop the image to 16/9

        midFrameRows = (rows./2) - 2160./2;
        midFrameCols = (cols./2) - 3840./2;
        posRec = [midFrameCols midFrameRows 3840-1 2160-1];

        frame = imcrop(frame, posRec);
    end;
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
%         cla(handles2.mainVideo_qual);
%         set(handles2.qualVideoimdisplayed, 'cdata', frame);
        axes(handles2.mainVideo_qual);
        handles2.qualVideoimdisplayed = imshow(frame);
%         xlim(handles2.mainVideo_qual, VidInfo.xlimValCurrent);
%         ylim(handles2.mainVideo_qual, VidInfo.ylimValCurrent);
    else;
        %not valid: need to create it again

        cla(handles2.mainVideo_qual, 'reset');
        axes(handles2.mainVideo_qual);
        handles2.qualVideoimdisplayed = imshow(frame);
%         axes(handles2.mainVideo_qual);
%         handles2.qualVideoimdisplayed = imshow(frame);
%         xlim(handles2.mainVideo_qual, VidInfo.xlimValCurrent);
%         ylim(handles2.mainVideo_qual, VidInfo.ylimValCurrent);
    end;
else;
    %create field
    cla(handles2.mainVideo_qual, 'reset');
    axes(handles2.mainVideo_qual);
    handles2.qualVideoimdisplayed = imshow(frame);
%     xlim(handles2.mainVideo_qual, VidInfo.xlimValCurrent);
%     ylim(handles2.mainVideo_qual, VidInfo.ylimValCurrent);
end;
[tb,btns] = axtoolbar(handles2.mainVideo_qual, {'zoomin','zoomout','pan'});
handles2.tb = tb;
handles2.btns = btns;
%--------------------------------------------------------------------------


%------------------------------------Save----------------------------------
handles2.VidInfo = VidInfo;
guidata(handles2.hf_w2_advancedImage, handles2);
%--------------------------------------------------------------------------

