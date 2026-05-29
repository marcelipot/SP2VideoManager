function advancedSettingConvert_screen(varargin);



handles = guidata(gcf);
handles2 = advancedSettingConvertUI_screen;

if isempty(handles2) == 1;
    return;
end;

%---Get new data
VidInfo = handles2.VidInfo;
filetosave = handles2.filetosave;
handles.VidInfoScreen = VidInfo;
handles.filetosave = filetosave;

%---Update display
frame = VidInfo.ActiveFrame;

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
        [frame, ~] = imagesbuiltinImageInterpolation2D(frame, map_x, map_y, 'nearest',0); 
%     elseif strcmpi(class(VidInfo.FishEye.param), 'fisheyeParameters');
%         %fisheye model
%         [frame, ~] = imagesbuiltinImageInterpolation2D(frame, map_x, VidInfo.FishEye.map_y, 'bilinear', 0);
%     end;
    
%% to be reviewed in the future
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
            %no need to change the rati
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
else
%     framebis = [];
%     framebis(:,:,1) = double(frame(:,:,1)./255);
%     framebis(:,:,2) = double(frame(:,:,2)./255);
%     framebis(:,:,3) = double(frame(:,:,3)./255);
%     frame = framebis;
end;
%%

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

VidInfo.xlimValCurrent = get(handles.mainVideoScreen_screen, 'xlim');
VidInfo.ylimValCurrent = get(handles.mainVideoScreen_screen, 'ylim');
if isfield(handles, 'loadVideoimdisplayedScreen') == 1;
    %field exist
    if isvalid(handles.loadVideoimdisplayedScreen) == 1;
        %exist and valid
        cla(handles.mainVideoScreen_screen, 'reset');
        axes(handles.mainVideoScreen_screen);
        handles2.loadVideoimdisplayedScreen = imshow(frame);

%         set(handles.loadVideoimdisplayedScreen, 'cdata', frame);
    else;
        %not valid: need to create it again
        cla(handles.mainVideoScreen_screen, 'reset');
        axes(handles.mainVideoScreen_screen);
        handles.loadVideoimdisplayedScreen = imshow(frame);
    end;
else;
    %create field
    cla(handles.mainVideoScreen_screen, 'reset');
    axes(handles.mainVideoScreen_screen);
    handles.loadVideoimdisplayedScreen = imshow(frame);
end;
[tb,btns] = axtoolbar(handles.mainVideoScreen_screen, {'zoomin','zoomout','pan'});
% xlim(handles.mainVideoScreen_screen, VidInfo.xlimValCurrent);
% ylim(handles.mainVideoScreen_screen, VidInfo.ylimValCurrent);

if isempty(VidInfo.exportRate) == 0;
    if VidInfo.exportRate ~= VidInfo.Rate;
        isNewRate = 1;
    else;
        isNewRate = 0;
    end;
else;
    isNewRate = 0;
end;

if isNewRate == 1 | isempty(VidInfo.FishEye) == 0 | VidInfo.ImageEnhance.Contract ~= 0 | VidInfo.ImageEnhance.Brightness ~= 0;
    if strcmpi(handles.listDropCompressionScreen{end,1}, 'Remux') == 1;
        %remove remux
        handles.listDropCompressionScreen = handles.listDropCompressionScreen(1:end-1,1);
        if get(handles.popCompression_screen, 'value') > length(handles.listDropCompressionScreen);
            set(handles.popCompression_screen, 'value', 1, 'String', handles.listDropCompressionScreen);
        else;
            set(handles.popCompression_screen, 'String', handles.listDropCompressionScreen);
        end;
    end;
else;
    if strcmpi(handles.listDropCompressionScreen{end,1}, 'Remux') == 0;
        %Add remux
        handles.listDropCompressionScreen{end+1,1} = 'Remux';
        if get(handles.popCompression_screen, 'value') > length(handles.listDropCompressionScreen);
            set(handles.popCompression_screen, 'value', 1, 'String', handles.listDropCompressionScreen);
        else;
            set(handles.popCompression_screen, 'String', handles.listDropCompressionScreen);
        end;
    end;
end;
guidata(handles.hf_w1_welcome, handles);



