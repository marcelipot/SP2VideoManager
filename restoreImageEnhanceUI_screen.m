function restoreImageEnhanceUI_screen(varargin);


handles2 = guidata(gcf);

VidInfo = handles2.VidInfo;
frame = VidInfo.ActiveFrame;

if isempty(VidInfo.FishEye) == 1;
    optimisationState = 1; %update tools for map not existing
else;
    if isempty(VidInfo.FishEye.map_xOpt) == 0;
        optimisationState = 4; %update tools for map being already optimised
    else;
        if isempty(VidInfo.FishEye.map_xIni) == 0;
            optimisationState = 3; %update tools for map existing but not optimised
        else;
            optimisationState = 2; %update tools for map not existing
        end;
    end;
end;


%---Apply fish eye
if optimisationState == 3 | optimisationState == 4;
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
%         [frame, ~] = imagesbuiltinImageInterpolation2D(frame, VidInfo.FishEye.map_x, VidInfo.FishEye.map_y, 'nearest', 0);
%     end;
    
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
end;


%---Apply enhancement
VidInfo.ImageEnhance.Contract = 0;
VidInfo.ImageEnhance.Brightness = 0;
set(handles2.dropdownContrast_qual, 'Value', 10);
set(handles2.dropdownBrightness_qual, 'Value', 10);



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


for ptDLT = 1:50; 
    axes(handles2.mainVideo_qual); hold on;
    p = nsidedpoly(10, 'Center', [5 5], 'Radius', 10);
    circle = plot(p, 'FaceColor', [1 0 0], 'EdgeColor', [1 0 0], 'Visible', 'off');
    eval(['handles2.markerDLTP' num2str(ptDLT) ' = circle;']);
    clear circle;
end;

if isempty(VidInfo.FishEye) == 1;
    optimisationState = 1; %update tools for map not existing
else;
    if isempty(VidInfo.FishEye.map_xOpt) == 0;
        optimisationState = 4; %update tools for map being already optimised
    else;
        if isempty(VidInfo.FishEye.map_xIni) == 0;
            optimisationState = 3; %update tools for map existing but not optimised
        else;
            optimisationState = 2; %update tools for map not existing
        end;
    end;
end;
%---Update points on the image if there is any
if optimisationState == 3 | optimisationState == 4;
    %---Update control points
    axes(handles2.mainVideo_qual); hold on;
    if optimisationState == 3;
        ptDLTAll = VidInfo.FishEye.ptDLTAll;
        ptDLTValid = [];         %point for optimisation
        if isempty(ptDLTAll) == 0;
            for liEC = 1:length(ptDLTAll(:,1));
                ptEC = ptDLTAll(liEC,:);
                indexNaN = find(isnan(ptEC) == 1);
                if isempty(indexNaN) == 1;
                    %full set of points
                    ptDLTValid = [ptDLTValid; ptEC];
                end;
            end;
        end;
    elseif optimisationState == 4;
        ptDLTAll = VidInfo.FishEye.ptDLTAllOpt;
        ptDLTValid = [];         %point for optimisation
        if isempty(ptDLTAll) == 0;
            for liEC = 1:length(ptDLTAll(:,1));
                ptEC = ptDLTAll(liEC,:);
                indexNaN = find(isnan(ptEC) == 1);
                if isempty(indexNaN) == 1;
                    %full set of points
                    ptDLTValid = [ptDLTValid; ptEC];
                end;
            end;
        end;
    end;

    for ptDLT = 1:50; 
        if isempty(ptDLTValid) == 0;
            if ptDLT <= length(ptDLTValid(:,1));
                uCircle = ptDLTValid(ptDLT,1);
                vCircle = ptDLTValid(ptDLT,2);
                if isnan(uCircle) == 1;
                    p = nsidedpoly(10, 'Center', [5 5], 'Radius', 10);
                    colorEC = [1 0 0];
                    visibleEC = 'off';
                else;
                    p = nsidedpoly(10, 'Center', [uCircle vCircle], 'Radius', 10);
                    if ptEC == ptDLT;
                        %active point... green
                        colorEC = [0 1 0];
                    else;
                        %inactive point... red
                        colorEC = [1 0 0];
                    end;
                    visibleEC = 'on';
                end;
            else;
                p = nsidedpoly(10, 'Center', [5 5], 'Radius', 10);
                colorEC = [1 0 0];
                visibleEC = 'off';
            end;
            circle = plot(p, 'FaceColor', colorEC, 'EdgeColor', colorEC, 'Visible', visibleEC);
            eval(['handles2.markerDLTP' num2str(ptDLT) ' = circle;']);
            clear circle;
        end;
    end;
end;


% VidInfo.ActiveFrame = frame;
handles2.VidInfo = VidInfo;
guidata(handles2.hf_w2_advancedImage, handles2);